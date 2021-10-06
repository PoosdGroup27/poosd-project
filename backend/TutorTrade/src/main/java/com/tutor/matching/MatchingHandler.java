package com.tutor.matching;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.tutor.request.Request;
import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class MatchingHandler implements RequestHandler<Map<Object, Object>, String> {

  private static final ObjectMapper MAPPER = new ObjectMapper();
  private static final String STAGE =
      System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);
  private static final String KNN_BUCKET = String.format("request-normalized-data-%s", STAGE);
  private static final String KNN_MODEL = "knn-request-model.json";
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    String requestId;
    HashMap<?, ?> params = (HashMap<?, ?>) event.get("params");
    requestId = (String) params.get("requestId");

    Request newRequest;
    Request key = new Request(UUID.fromString(requestId));
    DynamoDBQueryExpression<Request> queryExpression =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);
    newRequest = DYNAMO_DB_MAPPER.query(Request.class, queryExpression).get(0);

    // get normalized, serialized request data from S3
    AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
    List<RequestKnnData> data;

    S3Object object = s3Client.getObject(KNN_BUCKET, KNN_MODEL);
    S3ObjectInputStream input = object.getObjectContent();
    try {
      CollectionType requestArray =
          MAPPER.getTypeFactory().constructCollectionType(List.class, RequestKnnData.class);
      data = MAPPER.readValue(input, requestArray);
    } catch (IOException e) {
      e.printStackTrace();
      return null;
    }

    int k = Integer.parseInt((String) params.get("numMatches"));

    // calculate k nearest neighbors to new request
    RequestKnn knn = new RequestKnn(data, newRequest);
    ArrayList<UUID> neighborsResult = knn.getNearestNeighbors(k);

    String resultString =
        neighborsResult.stream().map(UUID::toString).collect(Collectors.joining(", "));
    return String.format("[%s]", resultString);
  }
}
