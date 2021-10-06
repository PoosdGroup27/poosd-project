package com.tutor.request;

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
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/**
 * Handles any HTTP requests to the API's /request/ path.
 */
public class RequestsHandler implements RequestHandler<Map<Object, Object>, String> {
  private static final Logger LOG = LogManager.getLogger(RequestsHandler.class);
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

    if (httpMethod.equals("GET")) {
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      return getRequestById((String) pathParameters.get("requestId"));
    } else if (httpMethod.equals("POST") && method.equals("create")) {
      bodyJson = (HashMap<?, ?>) event.get("body-json");
      try {
        return createRequest(bodyJson);
      } catch (RequestBuilderException e) {
        e.printStackTrace();
        return getResponseAsString(
                HttpURLConnection.HTTP_BAD_REQUEST,
                e.getMessage());
      }
    } else if (httpMethod.equals("PATCH")) {
      bodyJson = (HashMap<?, ?>) event.get("body-json");
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      return updateRequest(bodyJson, (String) pathParameters.get("requestId"));
    } else if (httpMethod.equals("DELETE")) {
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      return deleteRequest((String) pathParameters.get("requestId"));
    }

    return getResponseAsString(
        HttpURLConnection.HTTP_BAD_METHOD,
        String.format("Requested method was not found. Full request path was: %s", path));
  }

  private String getRequestById(String requestId) {
    Request key = new Request(UUID.fromString(requestId));
    DynamoDBQueryExpression<Request> queryExpression =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);

    List<Request> requestById = MAPPER.query(Request.class, queryExpression);

    if (requestById.size() == 0) {
      return getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "Request not found.");
    } else if (requestById.size() > 1) {
      return getResponseAsString(
          HttpURLConnection.HTTP_CONFLICT,
          String.format(
              "Found %d requests with id: %s. 1 expected.", requestById.size(), requestId));
    }

    // found only 1 request with ID, as desired
    return getResponseAsString(HttpURLConnection.HTTP_OK, requestById.get(0).toString());
  }

  private String createRequest(HashMap<?, ?> body) throws RequestBuilderException {
    String requesterId = (String) body.get("requesterId");
    String subject = (String) body.get("subject");
    String costInPoints = (String) body.get("costInPoints");
    String urgency = (String) body.get("urgency");
    String platform = (String) body.get("platform");
    String status = "PENDING";

    Request request =
        new RequestBuilder()
            .withRequesterId(requesterId)
            .withSubject(subject)
            .withCost(Integer.parseInt(costInPoints))
            .withUrgency(urgency)
            .withPlatform(platform)
            .withStatus(status)
            .build();

    MAPPER.save(request);

    return getResponseAsString(HttpURLConnection.HTTP_OK, request.toString());
  }

  private Request getRequestObjectById(String requestId) {
    Request key = new Request(UUID.fromString(requestId));
    DynamoDBQueryExpression<Request> queryExpression =
            new DynamoDBQueryExpression<Request>().withHashKeyValues(key);

    List<Request> requestById = MAPPER.query(Request.class, queryExpression);

    if (requestById.size() != 1) {
      return null;
    }

    return requestById.get(0);
  }

  private String returnErrorString(Exception ex) {
    return getResponseAsString(HttpURLConnection.HTTP_BAD_REQUEST, ex.getMessage());
  }

  private String updateRequest(HashMap<?, ?> body, String requestId) {
    Request requestToUpdate = getRequestObjectById(requestId);

    if (requestToUpdate == null) {
      return getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "Request not found.");
    }

    // The only fields that make sense to change are:
    // helperId, subject, sessionTime, platform, cost, urgency, and status.

    String helperIdString = (String) body.get("helperId");
    if (helperIdString != null) {
      try {
        requestToUpdate.setHelperId(UUID.fromString(helperIdString));
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    String subjectString = (String) body.get("subject");
    if (subjectString != null) {
      try {
        requestToUpdate.setSubject(Subject.valueOf(subjectString));
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    String sessionTimeString = (String) body.get("sessionTime");
    if (sessionTimeString != null) {
      try {
        requestToUpdate.setSessionTime(sessionTimeString);
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    String platformString = (String) body.get("platform");
    if (platformString != null) {
      try {
        requestToUpdate.setPlatform(Platform.valueOf(platformString));
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    String costInPointsString = (String) body.get("costInPoints");
    if (costInPointsString != null) {
      try {
        requestToUpdate.setCostInPoints(Integer.parseInt(costInPointsString));
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    String urgencyString = (String) body.get("urgency");
    if (urgencyString != null) {
      try {
        requestToUpdate.setUrgency(Urgency.valueOf(urgencyString));
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    String statusString = (String) body.get("status");
    if (statusString != null) {
      try {
        requestToUpdate.setStatus(Status.valueOf(statusString));
      } catch (Exception ex) {
        return returnErrorString(ex);
      }
    }

    MAPPER.save(
            requestToUpdate,
            DynamoDBMapperConfig.builder()
                    .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
                    .build());

    return getResponseAsString(HttpURLConnection.HTTP_OK, requestToUpdate.toString());
  }

  private String deleteRequest(String requestId) {
    Request requestToBeDeleted = getRequestObjectById(requestId);

    if (requestToBeDeleted == null) {
      return getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "Request not found.");
    }

    MAPPER.delete(requestToBeDeleted);
    return getResponseAsString(HttpURLConnection.HTTP_OK, requestToBeDeleted.toString());
  }

  /**
   * TODO: make this a helper method.
   *
   * @param statusCode HTTP status code.
   * @param body string for the body of the response.
   * @return string response.
   */
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