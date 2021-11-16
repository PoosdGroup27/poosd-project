package com.tutor.utils;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.amazonaws.services.kms.model.NotFoundException;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tutor.subject.Subject;
import com.tutor.user.User;
import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

/** Utility class for operations on user objects. */
public class UserUtils {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final String stage = "TEST";

  /**
   * Utility enum for tracking what we want to do when calling modifyUsersSessions().
   */
  public enum ModifyUserSessions {
    ADD,
    DELETE
  }

  /**
   * Method finds user in DB and returns the corresponding user as a Java object.
   *
   * @param userId UUID representing a valid and existing user
   * @return User corresponding to userId, if user is found, null otherwise.
   */
  public static User getUserObjectById(String userId) {
    User key = new User(userId);
    DynamoDBQueryExpression<User> queryExpression =
        new DynamoDBQueryExpression<User>().withHashKeyValues(key);

    List<User> userById = MAPPER.query(User.class, queryExpression);

    if (userById.size() != 1) {
      return null;
    }
    return userById.get(0);
  }

  /**
   * Method generates a user with random but valid values and posts it to the /user/create endpoint
   * of whichever stage is defined in environmental variables.
   */
  public static String postRandomUser(boolean isTest) {
    Random rand = new Random();

    String name = String.format("RandomUser%s", rand.nextInt());
    String school = String.format("RandomSchool%s", rand.nextInt());

    int numBound = 10;
    String phoneNumber =
        String.format(
            "%d%d%d-%d%d%d-%d%d%d%d",
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound),
            rand.nextInt(numBound));

    String json =
        "{"
            + "\"name\" : "
            + "\""
            + name
            + "\""
            + ", \"school\" : "
            + "\""
            + school
            + "\""
            + ", \"phoneNumber\" : "
            + "\""
            + phoneNumber
            + "\""
            + "}";

    String finalStage = isTest ? "TEST" : stage;

    return ApiUtils.post(ApiUtils.ApiStages.valueOf(finalStage).toString(), "/user/create", json);
  }

  /**
   * Modifies a user's session via a patch, either removes or adds the given session depending on
   * the flag.
   */
  public static void modifyUsersSessions(
      String stageUri, String userId, UUID sessionId, ModifyUserSessions modifyFlag)
      throws JsonProcessingException {
    User user = UserUtils.getUserObjectById(userId);

    if (user == null) {
      throw new NotFoundException("Requesting User does not exist");
    }

    if (modifyFlag == ModifyUserSessions.ADD) {
      user.addSessionId(sessionId);
    } else if (modifyFlag == ModifyUserSessions.DELETE) {
      user.deleteSessionId(sessionId);
    } else {
      throw new UnsupportedOperationException("Invalid ModifyUserSessions enum value");
    }

    ObjectMapper mapper = new ObjectMapper();

    ApiUtils.patch(stageUri, "/user/" + user.getUserId(), mapper.writeValueAsString(user));
  }

  /**
   * Takes response of api requests to user endpoint and converts it to user POJO. This is
   * mainly to allow us to correctly parse the time -- it is fully expanded out by DynamoDB, and we
   * want to turn it back to a LocalDateTime object.
   *
   * @param APIResponseJson The JSON string returned by requests to user API
   * @return User object which is equivalent to JSON
   * @throws IOException Throws exception if JSON parsing fails
   */
  public static User getUserFromAPIResponse(String APIResponseJson) throws IOException {
    ObjectMapper mapper = new ObjectMapper();
    ObjectNode userTree = (ObjectNode) mapper.readTree(APIResponseJson).get("body");
    JsonNode dateRequest = userTree.get("dateCreated");
    LocalDateTime date =
        LocalDateTime.of(
            dateRequest.get("year").asInt(),
            dateRequest.get("monthValue").asInt(),
            dateRequest.get("dayOfMonth").asInt(),
            dateRequest.get("hour").asInt(),
            dateRequest.get("minute").asInt(),
            dateRequest.get("second").asInt(),
            dateRequest.get("nano").asInt());

    userTree.put("dateCreated", String.valueOf(date));
    return mapper.treeToValue(userTree, User.class);
  }

  /** Converts a list of strings to a list of subjects. */
  public static ArrayList<Subject> convertListOfStringsToListOfSubjects(
      ArrayList<String> subjectsListOfStrings) {
    if (subjectsListOfStrings == null) {
      return null;
    }

    return subjectsListOfStrings.stream()
        .filter(Subject.subjectNameMap.keySet()::contains)
        .map(Subject::fromSubjectName)
        .collect(Collectors.toCollection(ArrayList<Subject>::new));
  }
}
