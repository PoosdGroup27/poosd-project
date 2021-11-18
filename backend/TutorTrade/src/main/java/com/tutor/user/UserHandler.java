package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.kms.model.NotFoundException;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.subject.Subject;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.UserUtils;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.time.LocalDateTime;
import java.util.*;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Handle all incoming requests to UserService through user API. API request is routed to User
 * Lambda. Requests are then further routed to correct method based on information found in context
 * input.
 */
public class UserHandler implements RequestStreamHandler {

  private static final Logger LOG = LogManager.getLogger(UserHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

  static {
    // Serialization will exclude null fields
    OBJECT_MAPPER.setSerializationInclusion(JsonInclude.Include.NON_NULL);
  }

  @Override
  public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context)
      throws IOException {
    Map<Object, Object> event =
        OBJECT_MAPPER.readValue(inputStream, new TypeReference<Map<Object, Object>>() {});

    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");

    HashMap<?, ?> bodyJson;
    HashMap<?, ?> params;
    HashMap<?, ?> pathParameters;

    switch (httpMethod) {
      case "PUT":
        bodyJson = (HashMap<?, ?>) event.get("body-json");
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        String path = (String) contextMap.get("resource-path");

        // adding a rating to an existing user
        if (path.contains("addReview")) {
          String userId = (String) pathParameters.get("userId");

          bodyJson = (HashMap<?, ?>) event.get("body-json");
          Integer rating = (Integer) bodyJson.get("rating");
          String subject = (String) bodyJson.get("subject");
          String reviewEvaluation = (String) bodyJson.get("reviewEvaluation");

          OBJECT_MAPPER.writeValue(
              outputStream, addReview(userId, rating, subject, reviewEvaluation));
          return;
        }

        // creating a new user
        OBJECT_MAPPER.writeValue(
            outputStream, createUser(bodyJson, (String) pathParameters.get("id")));
        return;
      case "GET":
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        User user = UserUtils.getUserObjectById(((String) pathParameters.get("id")));
        ApiResponse<User> response =
            ApiResponse.<User>builder().statusCode(HttpURLConnection.HTTP_OK).body(user).build();
        OBJECT_MAPPER.writeValue(outputStream, response);
        return;
      case "PATCH":
        bodyJson = (HashMap<?, ?>) event.get("body-json");
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        OBJECT_MAPPER.writeValue(
            outputStream, updateUser(bodyJson, (String) pathParameters.get("id")));
        return;
      case "DELETE":
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        OBJECT_MAPPER.writeValue(outputStream, deleteUser((String) pathParameters.get("id")));
        return;
      default:
        OBJECT_MAPPER.writeValue(outputStream, "Unsupported method requested.");
    }

    ApiResponse<String> response =
        ApiResponse.<String>builder()
            .statusCode(HttpURLConnection.HTTP_BAD_METHOD)
            .body(
                String.format(
                    "Requested method was not found. HTTP method requested was: %s", httpMethod))
            .build();

    OBJECT_MAPPER.writeValue(outputStream, response);
  }

  private ApiResponse<?> createUser(HashMap<?, ?> body, String userId) {
    String name = (String) body.get("name");
    String school = (String) body.get("school");
    String phoneNumber = (String) body.get("phoneNumber");
    ArrayList<String> subjectsLearnStringList = (ArrayList<String>) body.get("subjectsLearn");
    ArrayList<String> subjectsTeachStringList = (ArrayList<String>) body.get("subjectsTeach");
    String major = (String) body.get("major");

    ArrayList<Subject> subjectsLearnSubjectList =
        UserUtils.convertListOfStringsToListOfSubjects(subjectsLearnStringList);
    ArrayList<Subject> subjectsTeachSubjectList =
        UserUtils.convertListOfStringsToListOfSubjects(subjectsTeachStringList);

    User user =
        new UserBuilder()
            .withId(userId)
            .withName(name)
            .withSchool(school)
            .withPhoneNumber(phoneNumber)
            .withSubjectsLearn(subjectsLearnSubjectList)
            .withSubjectsTeach(subjectsTeachSubjectList)
            .withMajor(major)
            .build();

    MAPPER.save(user);

    return ApiResponse.<User>builder().statusCode(HttpURLConnection.HTTP_OK).body(user).build();
  }

  private ApiResponse<?> addReview(
      String userId, Integer rating, String subject, String reviewEvaluation) {
    User user = UserUtils.getUserObjectById(userId);

    // validate fields
    List<String> missingBodyValues = new ArrayList<String>();
    if (user == null) {
      missingBodyValues.add(String.format("User %s does not exist", userId));
    }

    if (rating == null || rating < 1 || rating > 5) {
      missingBodyValues.add("Integer rating not specified or invalid (must be between 1 and 5).");
    }

    if (reviewEvaluation == null) {
      missingBodyValues.add("reviewEvaluation string not specified.");
    }

    if (subject == null) {
      missingBodyValues.add("Subject for review not specified.");
    }

    if (!missingBodyValues.isEmpty()) {
      return ApiUtils.returnErrorResponse(
          new IllegalArgumentException(
              "The following elements of the JSON body either do not exist or have issues: "
                  + missingBodyValues));
    }

    user.addNewRating(rating);
    user.addReviewEvaluation(subject + ": " + reviewEvaluation);

    MAPPER.save(
        user,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());

    return ApiResponse.<User>builder().statusCode(HttpURLConnection.HTTP_OK).body(user).build();
  }

  private ApiResponse<?> updateUser(HashMap<?, ?> body, String userId) {
    User userToUpdate = UserUtils.getUserObjectById(userId);

    if (userToUpdate == null) {
      return ApiResponse.<String>builder()
          .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
          .body("User not found.")
          .build();
    }

    String date = (String) body.get("date");
    if (date != null) {
      LocalDateTime dateTime = LocalDateTime.parse(date);
      userToUpdate.setDateCreated(dateTime);
    }

    String name = (String) body.get("name");
    if (name != null) {
      userToUpdate.setName(name);
    }

    String school = (String) body.get("school");
    if (school != null) {
      userToUpdate.setSchool(school);
    }

    Integer points = (Integer) body.get("points");
    if (points != null) {
      userToUpdate.setPoints(points);
    }

    Boolean active = (Boolean) body.get("isActive");
    if (active != null) {
      userToUpdate.setIsActive(active);
    }

    ArrayList<?> sessionIds = (ArrayList<?>) body.get("sessionIds");
    if (sessionIds != null) {
      ArrayList<UUID> newSessionIds = new ArrayList<>();
      for (Object sessionId : sessionIds) {
        newSessionIds.add(UUID.fromString((String) sessionId));
      }
      userToUpdate.setSessionIds(newSessionIds);
    }

    String phoneNumber = (String) body.get("phoneNumber");
    if (phoneNumber != null) {
      userToUpdate.setPhoneNumber(phoneNumber);
    }

    ArrayList<String> subjectsLearn = (ArrayList<String>) body.get("subjectsLearn");
    if (subjectsLearn != null) {
      userToUpdate.setSubjectsLearn(UserUtils.convertListOfStringsToListOfSubjects(subjectsLearn));
    }

    ArrayList<String> subjectsTeach = (ArrayList<String>) body.get("subjectsTeach");
    if (subjectsTeach != null) {
      userToUpdate.setSubjectsTeach(UserUtils.convertListOfStringsToListOfSubjects(subjectsTeach));
    }

    String major = (String) body.get("major");
    if (major != null) {
      userToUpdate.setMajor(major);
    }

    Integer cumulativeSessionsCompleted = (Integer) body.get("cumulativeSessionsCompleted");
    if (cumulativeSessionsCompleted != null) {
      userToUpdate.setCumulativeSessionsCompleted(cumulativeSessionsCompleted);
    }

    Double rating = (Double) body.get("rating");
    if (rating != null) {
      userToUpdate.setRating(rating);
    }

    Integer newRating = (Integer) body.get("newRating");
    if (newRating != null) {
      userToUpdate.addNewRating(newRating);
    }

    ArrayList<String> reviewEvaluations = (ArrayList<String>) body.get("reviewEvaluations");
    if (reviewEvaluations != null) {
      userToUpdate.setReviewEvaluations(reviewEvaluations);
    }

    MAPPER.save(
        userToUpdate,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());

    return ApiResponse.<User>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(userToUpdate)
        .build();
  }

  private ApiResponse<?> deleteUser(String userId) {
    HashMap<String, Boolean> inactiveStatus = new HashMap<>();
    inactiveStatus.put("isActive", false);
    return updateUser(inactiveStatus, userId);
  }
}
