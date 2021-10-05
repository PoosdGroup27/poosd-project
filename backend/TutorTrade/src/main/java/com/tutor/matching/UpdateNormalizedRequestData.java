package com.tutor.matching;

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
import com.tutor.utils.ApiStages;
import com.tutor.utils.ApiUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;

public class UpdateNormalizedRequestData implements RequestHandler<DynamodbEvent, Void> {
  private static final String stage = System.getenv("STAGE");
  private static final ObjectMapper MAPPER = new ObjectMapper();

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
          || !requestRecord.get("status").getS().equals("COMPLETED")) return null;

      String requestId = requestRecord.get("requestId").getS();
      Request newRequest;

      // get json from get request api - easier than parsing DynamoDb stream event object
      // convert to request object for processing
      try {
        String requestJson =
            ApiUtils.get(
                ApiStages.valueOf(stage).toString(), String.format("/request/%s", requestId));
        System.out.println(requestJson);
        newRequest = MAPPER.readValue(requestJson, Request.class);
        System.out.println(newRequest);
      } catch (IOException e) {
        e.printStackTrace();
        return null;
      }

      // get normalized, serialized request data from S3
      AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
      List<RequestKnnDataNormalized> data;

      if (!s3Client.doesObjectExist("request-normalized-data", "knn-request-model")) {
        data = new ArrayList<>();
      } else {
        S3Object object = s3Client.getObject("request-normalized-data", "knn-request-model");
        S3ObjectInputStream input = object.getObjectContent();
        try {
          CollectionType requestArray =
              MAPPER
                  .getTypeFactory()
                  .constructCollectionType(List.class, RequestKnnDataNormalized.class);
          data = MAPPER.readValue(input, requestArray);
        } catch (IOException e) {
          e.printStackTrace();
          return null;
        }
      }

      data.add(new RequestKnnDataNormalized(newRequest));

      try {
        String jsonArray = MAPPER.writeValueAsString(data);
        s3Client.putObject("request-normalized-data","knn-request-model", jsonArray);
      } catch (JsonProcessingException e) {
        e.printStackTrace();
        return null;
      }

    }
    return null;
  }
}
