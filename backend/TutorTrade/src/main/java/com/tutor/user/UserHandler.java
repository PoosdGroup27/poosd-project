package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPEvent;
import com.amazonaws.services.lambda.runtime.events.APIGatewayV2HTTPResponse;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.io.IOException;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;


/**
 * Handle all incoming requests to UserService through user API. API request is routed to User
 * Lambda. Requests are then further routed to correct method based on information found in context
 * input.
 */
public class UserHandler
    implements RequestHandler<APIGatewayV2HTTPEvent, APIGatewayV2HTTPResponse> {

  private static final Logger LOG = LogManager.getLogger(UserHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public APIGatewayV2HTTPResponse handleRequest(APIGatewayV2HTTPEvent input, Context context) {
    APIGatewayV2HTTPResponse errorResponse = new APIGatewayV2HTTPResponse();
    JsonNode body;

    String path = input.getRawPath();
    // grab the last element in API path
    String method = path.split("/")[path.length() - 1];

    try {
      body = new ObjectMapper().readTree(input.getBody());
    } catch (IOException ex) {
      errorResponse.setStatusCode(400);
      errorResponse.setBody("Request does not contain a body for creating a user.");
      return errorResponse;
    }

    // route requests
    switch (method) {
      case "create":
        return createUser(body);
      default:
        errorResponse.setStatusCode(400);
        errorResponse.setBody(
                String.format("Request path is malformed or method not known. Path: %s", path));
    }

    return errorResponse;
  }

  private APIGatewayV2HTTPResponse createUser(JsonNode body) {
    String name = body.get("name").textValue();
    String school = body.get("school").textValue();

    User user = new UserBuilder().withName(name).withSchool(school).build();

    MAPPER.save(user);

    APIGatewayV2HTTPResponse response = new APIGatewayV2HTTPResponse();
    response.setIsBase64Encoded(false);
    response.setStatusCode(200);
    response.setBody(user.toString());
    return response;
  }
}
