package com.tutor.request;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.tutor.subject.Subject;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.RequestUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

/** Handles any HTTP requests to the API's /request/ path. */
public class RequestsHandler implements RequestHandler<Map<Object, Object>, ApiResponse<?>> {
  private static final Logger LOG = LogManager.getLogger(RequestsHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public ApiResponse<?> handleRequest(Map<Object, Object> event, Context context) {
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
      Request request =
          RequestUtils.getRequestObjectById(((String) pathParameters.get("requestId")));
      return ApiResponse.<Request>builder()
          .statusCode(HttpURLConnection.HTTP_OK)
          .body(request)
          .build();
    } else if (httpMethod.equals("POST") && method.equals("create")) {
      bodyJson = (HashMap<?, ?>) event.get("body-json");
      try {
        return createRequest(bodyJson);
      } catch (RequestBuilderException e) {
        e.printStackTrace();
        return ApiUtils.returnErrorResponse(e);
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

    return ApiResponse.<String>builder()
        .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
        .body("Request not found.")
        .build();
  }

  private ApiResponse<Request> createRequest(HashMap<?, ?> body) throws RequestBuilderException {
    String requesterId = (String) body.get("requesterId");
    String subject = (String) body.get("subject");
    String costInPoints = (String) body.get("costInPoints");
    String urgency = (String) body.get("urgency");
    String platform = (String) body.get("platform");
    String status = "PENDING";
    String description = (String) body.get("description");

    Request request =
        new RequestBuilder()
            .withRequesterId(requesterId)
            .withSubject(subject)
            .withCost(Integer.parseInt(costInPoints))
            .withUrgency(urgency)
            .withPlatform(platform)
            .withStatus(status)
            .withDescription(description)
            .build();

    DYNAMO_DB_MAPPER.save(request);

    return ApiResponse.<Request>builder()
            .statusCode(HttpURLConnection.HTTP_OK)
            .body(request)
            .build();
  }

  private ApiResponse<?> updateRequest(HashMap<?, ?> body, String requestId) {
    Request requestToUpdate = RequestUtils.getRequestObjectById(requestId);
    if (requestToUpdate == null) {
      return ApiResponse.<String>builder()
          .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
          .body("Request not found.")
          .build();
    }

    // The only fields that make sense to change are:
    // helperId, subject, sessionTime, platform, cost, urgency, status, and description.
    String helperIdString = (String) body.get("helperId");
    if (helperIdString != null) {
      try {
        requestToUpdate.setHelperId(UUID.fromString(helperIdString));
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String subjectString = (String) body.get("subject");
    if (subjectString != null) {
      try {
        requestToUpdate.setSubject(Subject.valueOf(subjectString));
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String sessionTimeString = (String) body.get("sessionTime");
    if (sessionTimeString != null) {
      try {
        requestToUpdate.setSessionTime(sessionTimeString);
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String platformString = (String) body.get("platform");
    if (platformString != null) {
      try {
        requestToUpdate.setPlatform(Platform.valueOf(platformString));
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String costInPointsString = (String) body.get("costInPoints");
    if (costInPointsString != null) {
      try {
        requestToUpdate.setCostInPoints(Integer.parseInt(costInPointsString));
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String urgencyString = (String) body.get("urgency");
    if (urgencyString != null) {
      try {
        requestToUpdate.setUrgency(Urgency.valueOf(urgencyString));
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String statusString = (String) body.get("status");
    if (statusString != null) {
      try {
        requestToUpdate.setStatus(Status.valueOf(statusString));
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String description = (String) body.get("description");
    if (description != null) {
      try {
        requestToUpdate.setDescription(description);
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    DYNAMO_DB_MAPPER.save(
        requestToUpdate,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());

    return ApiResponse.<Request>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(requestToUpdate)
        .build();
  }

  private ApiResponse<?> deleteRequest(String requestId) {
    Request requestToBeDeleted = RequestUtils.getRequestObjectById(requestId);

    if (requestToBeDeleted == null) {
      return ApiResponse.<String>builder()
          .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
          .body("Request not found.")
          .build();
    }

    DYNAMO_DB_MAPPER.delete(requestToBeDeleted);
    return ApiResponse.<Request>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(requestToBeDeleted)
        .build();
  }
}
