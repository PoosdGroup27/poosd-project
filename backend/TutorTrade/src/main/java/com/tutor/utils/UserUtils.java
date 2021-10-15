package com.tutor.utils;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.tutor.user.User;
import java.net.HttpURLConnection;
import java.util.List;
import java.util.UUID;

/** Utility class for operations on user objects. */
public class UserUtils {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);

  /**
   * Method finds request in DB and returns an API response with user.
   *
   * @param userId UUID representing a valid and existing user
   * @return API response with HTTP_OK and request as body, if user is found, response with error
   *     code otherwise
   */
  public static String getUserById(String userId) {
    User key = new User(UUID.fromString(userId));
    DynamoDBQueryExpression<User> queryExpression =
        new DynamoDBQueryExpression<User>().withHashKeyValues(key);

    List<User> userById = MAPPER.query(User.class, queryExpression);

    if (userById.size() == 0) {
      return ApiUtils.getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "User not found.");
    } else if (userById.size() > 1) {
      return ApiUtils.getResponseAsString(
          HttpURLConnection.HTTP_CONFLICT,
          String.format("Found %d users with id: %s. 1 expected.", userById.size(), userId));
    }

    // found only 1 user with ID, as desired
    return ApiUtils.getResponseAsString(HttpURLConnection.HTTP_OK, userById.get(0).toString());
  }

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
}
