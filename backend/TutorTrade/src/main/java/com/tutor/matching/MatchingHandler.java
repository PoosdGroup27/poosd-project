package com.tutor.matching;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.tutor.request.Request;
import com.tutor.utils.ApiStages;
import com.tutor.utils.ApiUtils;

import java.io.IOException;
import java.util.*;
import java.util.stream.Collectors;

public class MatchingHandler implements RequestHandler<Map<Object, Object>, String> {

  private static final ObjectMapper MAPPER = new ObjectMapper();
  private static final String stage =
      System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ROOT);

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    String requestId;
    int k;
    HashMap<?, ?> params = (HashMap<?, ?>) event.get("params");
    HashMap<?, ?> pathParameters = (HashMap<?, ?>) params.get("path");
    requestId = (String) params.get("requestId");
    k = Integer.parseInt((String) params.get("numMatches"));

    Request newRequest;
    try {
      String jsonRequest =
          ApiUtils.get(
              ApiStages.valueOf(stage).toString(), String.format("/request/%s", requestId));
      final ObjectMapper objMapper = new ObjectMapper();
      newRequest = objMapper.readValue(jsonRequest, Request.class);
    } catch (IOException e) {
      e.printStackTrace();
      System.out.printf("Unable to deserialize request: %s\n", requestId);
      return null;
    }

    // get normalized, serialized request data from S3
    AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
    List<RequestKnnDataNormalized> data;

    S3Object object = s3Client.getObject("request-normalized-data", "knn-request-model");
    S3ObjectInputStream input = object.getObjectContent();
    try {
      CollectionType requestArray =
          MAPPER
              .getTypeFactory()
              .constructCollectionType(
                  List.class, RequestKnnDataNormalized.class);
      data = MAPPER.readValue(input, requestArray);
    } catch (IOException e) {
      e.printStackTrace();
      return null;
    }

    // calculate k nearest neighbors to new request
    RequestKnn knn = new RequestKnn(data, newRequest);
    ArrayList<UUID> neighborsResult = knn.getNearestNeighbors(k);

    String resultString =
        neighborsResult.stream().map(UUID::toString).collect(Collectors.joining(", "));
    return String.format("[%s]", resultString);
  }
}
