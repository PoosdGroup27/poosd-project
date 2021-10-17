package com.tutor.utils;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tutor.request.Request;
import com.tutor.user.User;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.time.LocalDateTime;
import java.util.List;
import java.util.Locale;
import java.util.Random;
import java.util.UUID;

/** Utility class for operations on user objects. */
public class UserUtils {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final String stage = "TEST";
  // System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);

  /**
   * Method finds user in DB and returns the corresponding user as a Java object.
   *
   * @param userId UUID representing a valid and existing user
   * @return User corresponding to userId, if user is found, null otherwise.
   */
  public static User getUserObjectById(String userId) {
    User key = new User(UUID.fromString(userId));
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
  public static String postRandomUser(boolean isTest) throws IOException {
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
    
    String response =
        ApiUtils.post(ApiUtils.ApiStages.valueOf(finalStage).toString(), "/user/create", json);

    return response;
  }

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
}