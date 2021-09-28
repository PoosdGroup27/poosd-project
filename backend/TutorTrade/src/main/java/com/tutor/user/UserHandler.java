package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.net.HttpURLConnection;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 * Handle all incoming requests to UserService through user API. API request is routed to User
 * Lambda. Requests are then further routed to correct method based on information found in context
 * input.
 */
public class UserHandler implements RequestHandler<Map<Object, Object>, String> {

  private static final Logger LOG = LogManager.getLogger(UserHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");
    String path = (String) contextMap.get("resource-path");

    // grab the last element in API path
    String[] splitPath = path.split("/");
    String method = splitPath[splitPath.length - 1];

    HashMap<?, ?> bodyJson;
    HashMap<?, ?> params;
    HashMap<?, ?> pathParameters;

    if (httpMethod.equals("POST") && method.equals("create")) {
      bodyJson = (HashMap<?, ?>) event.get("body-json");
      return createUser(bodyJson);
    } else if (httpMethod.equals("GET")) {
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      return getUserById((String) pathParameters.get("id"));
    } else if (httpMethod.equals("PATCH")) {
      bodyJson = (HashMap<?, ?>) event.get("body-json");
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      return updateUser(bodyJson, (String) pathParameters.get("id"));
    } else if (httpMethod.equals("DELETE")) {
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      return deleteUser((String) pathParameters.get("id"));
    }

    return getResponseAsString(
        HttpURLConnection.HTTP_BAD_METHOD,
        String.format("Requested method was not found. Full request path was: %s", path));
  }

  private String createUser(HashMap<?, ?> body) {
    String name = (String) body.get("name");
    String school = (String) body.get("school");

    User user = new UserBuilder().withName(name).withSchool(school).build();

    MAPPER.save(user);

    return getResponseAsString(HttpURLConnection.HTTP_OK, user.toString());
  }

  private String getUserById(String userId) {
    User key = new User(UUID.fromString(userId));
    DynamoDBQueryExpression<User> queryExpression =
        new DynamoDBQueryExpression<User>().withHashKeyValues(key);

    List<User> userById = MAPPER.query(User.class, queryExpression);

    if (userById.size() == 0) {
      return getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "User not found.");
    } else if (userById.size() > 1) {
      return getResponseAsString(
          HttpURLConnection.HTTP_CONFLICT,
          String.format("Found %d users with id: %s. 1 expected.", userById.size(), userId));
    }

    // found only 1 user with ID, as desired
    return getResponseAsString(HttpURLConnection.HTTP_OK, userById.get(0).toString());
  }

  private User getUserObjectById(String userId) {
    User key = new User(UUID.fromString(userId));
    DynamoDBQueryExpression<User> queryExpression =
        new DynamoDBQueryExpression<User>().withHashKeyValues(key);

    List<User> userById = MAPPER.query(User.class, queryExpression);

    if (userById.size() != 1) {
      return null;
    }
    return userById.get(0);
  }

  private String updateUser(HashMap<?, ?> body, String userId) {
    User userToUpdate = getUserObjectById(userId);

    if (userToUpdate == null) {
      return getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "User not found.");
    }

    Date date = (Date) body.get("date");
    if (date != null) {
      userToUpdate.setDateCreated(date);
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

    MAPPER.save(
        userToUpdate,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());

    return getResponseAsString(HttpURLConnection.HTTP_OK, userToUpdate.toString());
  }

  private String deleteUser(String userId) {
    HashMap<String, Boolean> inactiveStatus = new HashMap<>();
    inactiveStatus.put("isActive", false);
    return updateUser(inactiveStatus, userId);
  }

  private String getResponseAsString(int statusCode, String body) {
    APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
    response.setStatusCode(statusCode);
    response.setBody(body);

    ObjectMapper mapper = new ObjectMapper();

    try {
      return mapper.writeValueAsString(response);
    } catch (JsonProcessingException e) {
      e.printStackTrace();
      return "Status Code: 400. Response was malformed." + response;
    }
  }
}
