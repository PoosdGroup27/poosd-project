package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import java.util.HashMap;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 * Handle all incoming requests to UserService through user API. API request is routed to User
 * Lambda. Requests are then further routed to correct method based on information found in context
 * input.
 */
public class UserHandler
    implements RequestHandler<Map<Object, Object>, String> {

  private static final Logger LOG = LogManager.getLogger(UserHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    APIGatewayV2HTTPResponse errorResponse = new APIGatewayV2HTTPResponse();
    JsonNode body;

    HashMap<String, String> bodyJson = (HashMap<String, String>) event.get("body-json");
    HashMap<String, String> contextMap = (HashMap<String, String>) event.get("context");

    String path = contextMap.get("resource-path");

    // grab the last element in API path
    String [] splitPath = path.split("/");
    String method = splitPath[splitPath.length - 1];

    // route requests
    switch (method) {
      case "create":
        try {
          return createUser(bodyJson);
        } catch (JsonProcessingException e) {
          e.printStackTrace();
        }
        break;
      default:
        errorResponse.setStatusCode(400);
        errorResponse.setBody(
                String.format("Request path is malformed or method not known. Path: %s", path));
    }

    ObjectMapper mapper = new ObjectMapper();
    try {
      return mapper.writeValueAsString(errorResponse);
    } catch (JsonProcessingException e) {
      e.printStackTrace();
      return "An error occurred; see stack trace.";
    }
  }

  private String createUser(HashMap<String, String> body) throws JsonProcessingException {
    String name = body.get("name");
    String school = body.get("school");

    User user = new UserBuilder().withName(name).withSchool(school).build();

    MAPPER.save(user);

    APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
    response.setIsBase64Encoded(true);
    response.setStatusCode(200);
    response.setBody(user.getName() + " " + user.getSchool());

    ObjectMapper mapper = new ObjectMapper();
    return mapper.writeValueAsString(response);
  }
}