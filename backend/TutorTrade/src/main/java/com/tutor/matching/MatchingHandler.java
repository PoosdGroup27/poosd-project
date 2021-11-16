package com.tutor.matching;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.lambda.runtime.events.DynamodbEvent;
import com.amazonaws.services.lambda.runtime.events.models.dynamodb.AttributeValue;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.tutor.request.MatchStatus;
import com.tutor.request.Request;
import com.tutor.request.Status;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.RequestUtils;
import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.*;

/**
 * Class gets requests to find matches for a given requestId and returns a list of userIds for users
 * who are well suited to fulfill that request.
 */
public class MatchingHandler implements RequestHandler<DynamodbEvent, ApiResponse<?>> {
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  private static final String STAGE =
      System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);
  private static final String KNN_BUCKET =
      String.format("request-normalized-data-%s", System.getenv("STAGE"));
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
  private static final String KNN_MODEL = MatchingConstants.KNN_MODEL;

  @Override
  public ApiResponse<?> handleRequest(DynamodbEvent dynamodbEvent, Context context) {
    // get normalized, serialized request data from S3
    List<RequestKnnData> data;
    if (!s3Client.doesObjectExist(KNN_BUCKET, KNN_MODEL)) {
      data = new ArrayList<>();
    } else {
      S3Object object = s3Client.getObject(KNN_BUCKET, KNN_MODEL);
      S3ObjectInputStream input = object.getObjectContent();
      try {
        CollectionType requestArray =
            OBJECT_MAPPER
                .getTypeFactory()
                .constructCollectionType(List.class, RequestKnnData.class);
        data = OBJECT_MAPPER.readValue(input, requestArray);
      } catch (IOException e) {
        return ApiUtils.returnErrorResponse(e);
      }
    }

    // sanity check to make sure we're not stuck in a recursive record processing loop, since
    // we modify the same dynamodb table here as is processed by this lambda.
    // We will never create more than 15 matches during testing
    assert dynamodbEvent.getRecords().size() < 15;

    for (DynamodbEvent.DynamodbStreamRecord record : dynamodbEvent.getRecords()) {
      Map<String, AttributeValue> oldRequestRecord = record.getDynamodb().getOldImage();
      Map<String, AttributeValue> newRequestRecord = record.getDynamodb().getNewImage();
      String requestId = newRequestRecord.get("requestId").getS();
      Request newRequest = RequestUtils.getRequestObjectById(requestId);

      if (newRequest == null) {
        return ApiResponse.<String>builder()
            .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
            .body(String.format("Request %s from Dynamo stream not found. Strange...", requestId))
            .build();
      }

      if (newRequestRecord.get("status").getS().equals("PENDING")) {
        getMatches(data, newRequest);
        System.out.println("Matching completed.");
      } else if (!oldRequestRecord.isEmpty()
          && (!oldRequestRecord.get("status").getS().equals("COMPLETED")
              && newRequestRecord.get("status").getS().equals("COMPLETED"))) {
        System.out.println("Update completed.");
      } else {
        System.out.println("Returning without action.");
        return ApiResponse.<String>builder()
            .statusCode(HttpURLConnection.HTTP_NOT_FOUND)
            .body(
                String.format(
                    "Request %s is neither pending nor completed. No action needed.", requestId))
            .build();
      }
    }

    return ApiResponse.<String>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body("Matching successful")
        .build();
  }

  /**
   * Get matches for a given request and update DynamoDB to reflect matches + matched status. TODO:
   * This method has side effects and modifying the dynamo table will trigger a new stream. This
   * works for now but is not ideal.
   *
   * @param data All our existing request data. In the future we may need to check that this is
   *     small enough to bring into memory.
   * @param request The request we're getting matches for.
   */
  private void getMatches(List<RequestKnnData> data, Request request) {
    int k = MatchingConstants.NUM_MATCHES;

    // calculate k nearest neighbors to new request
    RequestKnn knn = new RequestKnn(data, request);
    List<String> resultList = knn.getNearestNeighbors(k);

    HashMap<String, MatchStatus> result = new HashMap<>();
    resultList.forEach(x -> result.put(x, MatchStatus.UNANSWERED));

    // update request with matches and matched status
    request.setOrderedMatches(result);
    request.setStatus(Status.MATCHED);
    DYNAMO_DB_MAPPER.save(
        request,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());
  }

  /**
   * Update our s3 request data store with request information once a request has been completed.
   * TODO: This method has side effects and modifying the dynamo table will trigger a new stream.
   * This works for now but is not ideal.
   *
   * @param data All our existing request data. In the future we may need to check that this is
   *     small enough to bring into memory.
   * @param request The request we're adding to the data store.
   * @return [requestId]
   */
  private List<UUID> updateRequestDataStore(List<RequestKnnData> data, Request request) {
    data.add(new RequestKnnData(request));
    try {
      String jsonArray = OBJECT_MAPPER.writeValueAsString(data);
      s3Client.putObject(KNN_BUCKET, KNN_MODEL, jsonArray);
    } catch (JsonProcessingException e) {
      e.printStackTrace();
      return null;
    }
    List<UUID> result = new ArrayList<>();
    result.add(request.getRequestId());
    return result;
  }
}
