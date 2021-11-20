package com.tutor.matches;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.kms.model.NotFoundException;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.chat.Chat;
import com.tutor.request.MatchStatus;
import com.tutor.request.Request;
import com.tutor.user.User;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.RequestUtils;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.util.*;

import com.tutor.utils.UserUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Handles requests for updating matching statuses within requests. */
public class MatchesHandler implements RequestStreamHandler {
  private static final Logger LOG = LogManager.getLogger(com.tutor.matches.MatchesHandler.class);
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

    HashMap<?, ?> bodyJson;
    HashMap<?, ?> params;
    HashMap<?, ?> pathParameters;

    if (httpMethod.equals("PUT")) {
      bodyJson = (HashMap<?, ?>) event.get("body-json");
      params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");

      String requestIdString = (String) pathParameters.get("requestId");
      String tutorId = (String) bodyJson.get("tutorId");
      String newStatus = (String) bodyJson.get("statusUpdate");

      OBJECT_MAPPER.writeValue(
          outputStream, updateRequestsMatch(requestIdString, tutorId, newStatus));
    } else {
      OBJECT_MAPPER.writeValue(
          outputStream,
          ApiUtils.returnErrorResponse(
              new UnsupportedOperationException(
                  String.format("%s method not supported for matches endpoint", httpMethod))));
    }
  }

  private ApiResponse<?> updateRequestsMatch(
      String requestIdString, String tutorId, String statusUpdate) {
    MatchStatus matchStatus;
    try {
      matchStatus = MatchStatus.valueOf(statusUpdate);
    } catch (IllegalArgumentException ex) {
      return ApiUtils.returnErrorResponse(ex);
    }

    Request requestToUpdate = RequestUtils.getRequestObjectById(requestIdString);
    if (requestToUpdate == null) {
      return ApiUtils.returnErrorResponse(
          new Exception(String.format("Request %s does not exist", requestIdString)));
    }

    if (!requestToUpdate.getOrderedMatches().containsKey(tutorId)) {
      return ApiUtils.returnErrorResponse(
          new Exception(
              String.format(
                  "Tutor %s does not exist within Request %s", tutorId, requestIdString)));
    }

    requestToUpdate.getOrderedMatches().put(tutorId, matchStatus);

    DYNAMO_DB_MAPPER.save(
        requestToUpdate,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());

    // if the status update is going to chat, create a new chat between the tutor
    // and tutee
    if (statusUpdate.equals("CHATTING")) {
      List<Map.Entry<String, String>> messages = new ArrayList<>();

      String tuteeId = requestToUpdate.getRequesterId();

      User tutor = UserUtils.getUserObjectById(tutorId);
      User tutee = UserUtils.getUserObjectById(tuteeId);

      if (tutee == null || tutor == null) {
        return ApiUtils.returnErrorResponse(
            new NotFoundException(String.format("Either tutor %s or tutee %s", tutorId, tuteeId)));
      }

      messages.add(new AbstractMap.SimpleEntry<>(tutorId, tutor.getPhoneNumber()));
      messages.add(new AbstractMap.SimpleEntry<>(tutorId, tutee.getPhoneNumber()));

      Chat chat =
          Chat.builder()
              .tutorId(tutorId)
              .tuteeId(tuteeId)
              .id(UUID.randomUUID())
              .messages(messages)
              .build();

      DYNAMO_DB_MAPPER.save(
          chat,
          DynamoDBMapperConfig.builder()
              .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
              .build());
    }

    return ApiResponse.<Request>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(requestToUpdate)
        .build();
  }
}
