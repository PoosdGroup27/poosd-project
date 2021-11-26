package com.tutor.request;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.model.AttributeAction;
import com.amazonaws.services.dynamodbv2.model.AttributeValue;
import com.amazonaws.services.dynamodbv2.model.ScanRequest;
import com.amazonaws.services.dynamodbv2.model.ScanResult;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.subject.Subject;
import com.tutor.user.User;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.RequestUtils;
import com.tutor.utils.UserUtils;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.util.*;
import java.util.jar.Attributes;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Handles any HTTP requests to the API's /request/ path. */
public class RequestsHandler implements RequestStreamHandler {
  private static final Logger LOG = LogManager.getLogger(RequestsHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  private static final String STAGE = System.getenv("STAGE");

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
    String path = (String) contextMap.get("resource-path");

    HashMap<?, ?> bodyJson;
    HashMap<?, ?> params;
    HashMap<?, ?> pathParameters;

    switch (httpMethod) {
      case "GET":
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        String[] pathArray = path.split("/");

        /**
         * TODO: this will need to be changed if we ever implement a get method with userId as path
         * parameter on any resource more than one layer deep. This works for
         * /request/{someMethod}/{userID}
         */
        String userId = (String) pathParameters.get("userId");
        if (userId != null && pathArray.length == 4) {
          // e.g. resource-path=/request/getRequestsByUserId/{userId}
          // .split("/") = ["", "request", "getRequestsByUserId", "userID"]
          if (pathArray[2].equals("getRequestsByUserId")) {
            OBJECT_MAPPER.writeValue(outputStream, getRequestsByUserId(userId));
            return;
          } else if (pathArray[2].equals("getAllMatchedRequests")) {
            OBJECT_MAPPER.writeValue(outputStream, getRequestsWithMatchOfUser(userId));
            return;
          }
        }

        // plain old GET for a Request
        Request request =
            RequestUtils.getRequestObjectById(((String) pathParameters.get("requestId")));
        ApiResponse<Request> response =
            ApiResponse.<Request>builder()
                .statusCode(HttpURLConnection.HTTP_OK)
                .body(request)
                .build();
        OBJECT_MAPPER.writeValue(outputStream, response);
        return;
      case "POST":
        bodyJson = (HashMap<?, ?>) event.get("body-json");
        try {
          OBJECT_MAPPER.writeValue(outputStream, createRequest(bodyJson));
          return;
        } catch (RequestBuilderException e) {
          e.printStackTrace();
          OBJECT_MAPPER.writeValue(outputStream, ApiUtils.returnErrorResponse(e));
          return;
        }
      case "PATCH":
        bodyJson = (HashMap<?, ?>) event.get("body-json");
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        OBJECT_MAPPER.writeValue(
            outputStream, updateRequest(bodyJson, (String) pathParameters.get("requestId")));
        return;
      case "DELETE":
        params = (HashMap<?, ?>) event.get("params");
        pathParameters = (HashMap<?, ?>) params.get("path");
        OBJECT_MAPPER.writeValue(
            outputStream, deleteRequest((String) pathParameters.get("requestId")));
        return;
      default:
        OBJECT_MAPPER.writeValue(outputStream, "Unsupported method requested.");
    }
  }

  private ApiResponse<Request> createRequest(HashMap<?, ?> body)
      throws RequestBuilderException, JsonProcessingException {
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

    UserUtils.modifyUsersSessions(
        ApiUtils.getApiStageUriFromStageEnvVariable(STAGE),
        requesterId,
        request.getRequestId(),
        UserUtils.ModifyUserSessions.ADD);

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
        requestToUpdate.setHelperId(helperIdString);
      } catch (Exception ex) {
        return ApiUtils.returnErrorResponse(ex);
      }
    }

    String subjectString = (String) body.get("subject");
    if (subjectString != null) {
      try {
        requestToUpdate.setSubject(Subject.fromSubjectName(subjectString));
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

  private ApiResponse<?> deleteRequest(String requestId) throws JsonProcessingException {
    Request requestToBeDeleted = RequestUtils.getRequestObjectById(requestId);

    if (requestToBeDeleted == null) {
      return ApiResponse.<String>builder()
          .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
          .body("Request not found.")
          .build();
    }

    UserUtils.modifyUsersSessions(
        ApiUtils.getApiStageUriFromStageEnvVariable(STAGE),
        requestToBeDeleted.getRequesterId(),
        requestToBeDeleted.getRequestId(),
        UserUtils.ModifyUserSessions.DELETE);

    DYNAMO_DB_MAPPER.delete(requestToBeDeleted);
    return ApiResponse.<Request>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(requestToBeDeleted)
        .build();
  }

  /** Returns a list of tuples of a user's session IDs along with their associated subjects. */
  private ApiResponse<?> getRequestsByUserId(String userId) {
    List<List<String>> sessionSubjectsList = new ArrayList<>();

    User user = UserUtils.getUserObjectById(userId);

    if (user == null) {
      return ApiUtils.returnErrorResponse(new Exception("User does not exist"));
    }

    for (UUID sessionId : user.getSessionIds()) {
      Request request = RequestUtils.getRequestObjectById(sessionId.toString());

      if (request != null) {
        sessionSubjectsList.add(
            Arrays.asList(sessionId.toString(), request.getSubject().getSubjectName()));
      }
    }

    return ApiResponse.<List<List<String>>>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(sessionSubjectsList)
        .build();
  }

  private Map<String, String> getRequestsWithMatchOfUser(String userId) {
    ScanRequest scan = new ScanRequest().withTableName(String.format("requestTable-%s", STAGE));

    // returns up to 1 MB of data, which should always be fine for our
    // purposes
    ScanResult result = DYNAMO_DB.scan(scan);

    // all matched requestIds : matching status for given user
    Map<String, String> resultMap = new HashMap<>();
    for (Map<String, AttributeValue> item : result.getItems()) {
      if (item.get("orderedMatches").getM().containsKey(userId) && item.get("orderedMatches").getM().get(userId).getS().equals("UNDECIDED")) {
        resultMap.put(
            item.get("requestId").getS(), item.get("orderedMatches").getM().get(userId).getS());
      }
    }

    return resultMap;
  }
}
