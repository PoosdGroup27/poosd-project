package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.tutor.subject.Subject;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.UserUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.net.HttpURLConnection;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/**
 * Handle all incoming requests to UserService through user API. API request is routed to User
 * Lambda. Requests are then further routed to correct method based on information found in context
 * input.
 */
public class UserHandler implements RequestHandler<Map<Object, Object>, ApiResponse<?>> {

  private static final Logger LOG = LogManager.getLogger(UserHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public ApiResponse<?> handleRequest(Map<Object, Object> event, Context context) {
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
        return createUser(bodyJson, (String) pathParameters.get("id"));
      case "GET":
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        User user = UserUtils.getUserObjectById(((String) pathParameters.get("id")));
        return ApiResponse.<User>builder().statusCode(HttpURLConnection.HTTP_OK).body(user).build();
      case "PATCH":
        bodyJson = (HashMap<?, ?>) event.get("body-json");
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        return updateUser(bodyJson, (String) pathParameters.get("id"));
      case "DELETE":
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        return deleteUser((String) pathParameters.get("id"));
    }

    return ApiResponse.<String>builder()
        .statusCode(HttpURLConnection.HTTP_BAD_METHOD)
        .body(String.format("Requested method was not found. HTTP method requested was: %s", httpMethod))
        .build();
  }

  private ApiResponse<?> createUser(HashMap<?, ?> body, String userId) {
    String name = (String) body.get("name");
    String school = (String) body.get("school");
    String phoneNumber = (String) body.get("phoneNumber");
    ArrayList<String> subjects = (ArrayList<String>) body.get("subjects");

    ArrayList<Subject> userSubjects = UserUtils.convertListOfStringsToListOfSubjects(subjects);

    User user =
        new UserBuilder()
            .withId(userId)
            .withName(name)
            .withSchool(school)
            .withPhoneNumber(phoneNumber)
            .withSubjects(userSubjects)
            .build();

    MAPPER.save(user);

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

    ArrayList<String> subjects = (ArrayList<String>) body.get("subjects");
    if (subjects != null) {
      userToUpdate.setSubjects(UserUtils.convertListOfStringsToListOfSubjects(subjects));
    }

    Integer cumulativeSessionsCompleted = (Integer) body.get("cumulativeSessionsCompleted");
    if (cumulativeSessionsCompleted != null) {
      userToUpdate.setCumulativeSessionsCompleted(cumulativeSessionsCompleted);
    }

    Integer rating = (Integer) body.get("rating");
    if (rating != null) {
      userToUpdate.setRating(rating);
    }

    Integer newRating = (Integer) body.get("newRating");
    if (newRating != null) {
      userToUpdate.addNewRating(newRating);
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
