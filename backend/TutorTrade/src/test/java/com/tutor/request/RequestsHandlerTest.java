package com.tutor.request;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.subject.Subject;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.RequestUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.*;

class RequestsHandlerTest {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  ArrayList<String> createdRequests = new ArrayList<>();
  Boolean isTest;

  @BeforeEach
  void setUp() {}

  @AfterEach
  void tearDown() {
    for (String requestId : createdRequests) {
      ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/request/%s", requestId));
    }
  }

  @Test
  void GIVENvalidRequestWHENpostRequestANDgetRequestTHENallFieldsCorrect()
      throws IOException {
    Request request =
        RequestUtils.getRequestFromAPIResponse(RequestUtils.postRandomRequest(isTest = true));

    // get request we just posted
    Request requestAfterGet =
        RequestUtils.getRequestFromAPIResponse(
            ApiUtils.get(
                ApiUtils.ApiStages.TEST.toString(),
                String.format("/request/%s", request.getRequestId().toString())));

    createdRequests.add(request.getRequestId().toString());

    assertEquals(request, requestAfterGet);
  }

  @Test
  void WHENpostRequestANDchangeFieldTHENchangePersistent()
      throws IOException {
    Request request =
        RequestUtils.getRequestFromAPIResponse(RequestUtils.postRandomRequest(isTest = true));
    createdRequests.add(request.getRequestId().toString());

    // get request we just posted
    Request requestAfterGet =
        RequestUtils.getRequestFromAPIResponse(
            ApiUtils.get(
                ApiUtils.ApiStages.TEST.toString(),
                String.format("/request/%s", request.getRequestId().toString())));

    assertEquals(request, requestAfterGet);

    Integer newCost = 1000;
    String newDescription = "This is a new test description";

    request.setCostInPoints(newCost);
    request.setDescription(newDescription);

    Map<String, String> changedFields = new HashMap<>();
    changedFields.put("costInPoints", newCost.toString());
    changedFields.put("description", newDescription);

    Request requestAfterPatch =
        RequestUtils.getRequestFromAPIResponse(
            ApiUtils.patch(
                ApiUtils.ApiStages.TEST.toString(),
                String.format("/request/%s", request.getRequestId().toString()),
                OBJECT_MAPPER.writeValueAsString(changedFields)));

    assertEquals(request, requestAfterPatch);

    Request requestAfterPatchAndGet =
        RequestUtils.getRequestFromAPIResponse(
            ApiUtils.get(
                ApiUtils.ApiStages.TEST.toString(),
                String.format("/request/%s", request.getRequestId().toString())));

    assertEquals(request, requestAfterPatchAndGet);
  }
}
