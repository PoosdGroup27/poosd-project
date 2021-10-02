package com.tutor.matching;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.request.Request;
import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;
import java.util.stream.Collectors;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;



public class MatchingHandler implements RequestHandler<Map<Object, Object>, String> {

  private static final Logger LOG = LogManager.getLogger(MatchingHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final String stage = System.getenv("STAGE");

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");
    String path = (String) contextMap.get("resource-path");

    // grab the last element in API path
    String[] splitPath = path.split("/");
    String method = splitPath[splitPath.length - 1];

    HashMap<?, ?> pathParameters;
    int k;

    if (httpMethod.equals("GET")) {
      HashMap<?, ?> params = (HashMap<?, ?>) event.get("params");
      pathParameters = (HashMap<?, ?>) params.get("path");
      UUID requestId = UUID.fromString(((String) params.get("requestId")));
      k = Integer.parseInt((String) params.get("numMatches"));
    }
    return "in progress";
//
//    // request information about request from Request service
//    String jsonRequest = API.GET("/request/{requestId}");
//    final ObjectMapper objMapper = new ObjectMapper();
//    Request newRequest;
//    try {
//      newRequest = objMapper.readValue(jsonRequest, Request.class);
//    } catch (IOException e) {
//      e.printStackTrace();
//    }
//    // get normalized, serialized request data from S3
//    HashMap<UUID, double[]> data = S3Client.get(s3URIToSerializedData);
//    // calculate k nearest neighbors to new request
//    RequestKnn knn = new RequestKnn(data, newRequest);
//    ArrayList<UUID> results = knn.getNearestNeighbors(k);
//
//    String resultString = results.stream().map(UUID::toString).collect(Collectors.joining(", "));
//    return String.format("[%s]", resultString);
  }
}
