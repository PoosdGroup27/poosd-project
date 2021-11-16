package com.tutor.matches;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.request.MatchStatus;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

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
      String matchToUpdate = (String) bodyJson.get("tutorId");
      String newStatus = (String) bodyJson.get("statusUpdate");

    } else {
      OBJECT_MAPPER.writeValue(
          outputStream,
          ApiUtils.returnErrorResponse(
              new UnsupportedOperationException(
                  String.format("%s method not supported for matches endpoint", httpMethod))));
    }
  }

  private ApiResponse<?> updateRequestsMatch(String requestIdString, String tutorId, String statusUpdate) {
    UUID requestId;
    try {
      requestId = UUID.fromString(requestIdString);
    } catch (IllegalArgumentException ex) {
      return ApiUtils.returnErrorResponse(ex);
    }

    MatchStatus matchStatus;
    try {
      matchStatus = MatchStatus.valueOf(statusUpdate);
    } catch (IllegalArgumentException ex) {
      return ApiUtils.returnErrorResponse(ex);
    }
  }
}
