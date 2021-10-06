package com.tutor.matching;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
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
import com.tutor.request.Request;

import java.io.IOException;
import java.util.*;

/**
 * Class recives DynamoDB events containing request object, checks that the changes represents an
 * update from a non-completed status to completed, and adds completed requests' data to the request
 * data store using for the matching algorithm.
 */
public class UpdateNormalizedRequestData implements RequestHandler<DynamodbEvent, Void> {
  private static final String STAGE =
      System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);
  private static final String KNN_BUCKET =
      String.format("request-normalized-data-%s", System.getenv("STAGE"));
  private static final ObjectMapper MAPPER = new ObjectMapper();
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final String KNN_MODEL = "knn-request-model.json";

  @Override
  public Void handleRequest(DynamodbEvent dynamodbEvent, Context context) {
    for (DynamodbEvent.DynamodbStreamRecord record : dynamodbEvent.getRecords()) {

      if (record == null) {
        continue;
      }

      Map<String, AttributeValue> oldRequestRecord = record.getDynamodb().getOldImage();
      Map<String, AttributeValue> requestRecord = record.getDynamodb().getNewImage();

      // if record hasn't been just completed, we don't want to add it to our records
      if (oldRequestRecord.get("status").getS().equals("COMPLETED")
          || !requestRecord.get("status").getS().equals("COMPLETED")) {
        System.out.printf(
            "Aborted. Old: %s\n New: %s \n",
            oldRequestRecord.get("status").getS(), requestRecord.get("status").getS());
        return null;
      }

      String requestId = requestRecord.get("requestId").getS();
      Request newRequest;
      Request key = new Request(UUID.fromString(requestId));
      DynamoDBQueryExpression<Request> queryExpression =
          new DynamoDBQueryExpression<Request>().withHashKeyValues(key);
      newRequest = DYNAMO_DB_MAPPER.query(Request.class, queryExpression).get(0);

      // get normalized, serialized request data from S3
      AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
      List<RequestKnnData> data;

      if (!s3Client.doesObjectExist(KNN_BUCKET, KNN_MODEL)) {
        data = new ArrayList<>();
        System.out.println("Item does not exist.");
      } else {
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
      }

      data.add(new RequestKnnData(newRequest));

      try {
        String jsonArray = MAPPER.writeValueAsString(data);
        s3Client.putObject(KNN_BUCKET, KNN_MODEL, jsonArray);
      } catch (JsonProcessingException e) {
        e.printStackTrace();
        return null;
      }
    }
    return null;
  }
}
