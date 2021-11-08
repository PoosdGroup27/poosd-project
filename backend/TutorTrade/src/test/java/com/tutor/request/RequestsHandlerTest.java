package com.tutor.request;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.JsonUtils;
import com.tutor.utils.RequestUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

class RequestsHandlerTest {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final DynamoDBMapperConfig DYNAMO_DB_MAPPER_CONFIG =
      new DynamoDBMapperConfig.Builder()
          .withTableNameOverride(
              DynamoDBMapperConfig.TableNameOverride.withTableNameReplacement("requestTable-test"))
          .build();
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  private static final JsonUtils JSON_UTILS = new JsonUtils();
  ArrayList<String> createdRequests = new ArrayList<>();

  @BeforeEach
  void setUp() {}

  @AfterEach
  void tearDown() {
    for (String requestId : createdRequests) {
      ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/request/%s", requestId));
    }
  }

  @Test
  void postTestGivenValidRequest() throws IOException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields =
        OBJECT_MAPPER.readValue(requestBody, new TypeReference<HashMap<String, String>>() {});

    // WHEN: post request to request API
    String requestPostResponseString =
        ApiUtils.post(ApiUtils.ApiStages.TEST.toString(), "/request", requestBody);

    // THEN: request response is not null
    assertNotNull(requestPostResponseString);

    // THEN: request response is a valid request object
    Request request = RequestUtils.getRequestFromAPIResponse(requestPostResponseString);
    assertNotNull(request);

    // THEN: fields of request object match those from validPostRequest.json
    assertEquals(request.getRequesterId().toString(), requestBodyFields.get("requesterId"));
    assertEquals(request.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(request.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(request.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(request.getPlatform().toString(), requestBodyFields.get("platform"));

    // WHEN: query dynamodb directly so as not to rely on correctness of GET method
    Request key = new Request(request.getRequestId());
    DynamoDBQueryExpression<Request> queryExpression =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);

    List<Request> requestById =
        DYNAMO_DB_MAPPER.query(Request.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, requestById.size());
    Request requestInDB = requestById.get(0);

    // THEN: all fields correct
    assertEquals(requestInDB.getRequesterId().toString(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(requestInDB.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(requestInDB.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB.getPlatform().toString(), requestBodyFields.get("platform"));

    // cleanup
    createdRequests.add(request.getRequestId().toString());
  }

  @Test
  void patchTestGivenValidChange() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields =
        OBJECT_MAPPER.readValue(requestBody, new TypeReference<HashMap<String, String>>() {});

    // GIVEN: valid request in DynamoDB. Put directly so as not to rely on POST method correctness
    Request request =
        new RequestBuilder()
            .withRequesterId(requestBodyFields.get("requesterId"))
            .withSubject(requestBodyFields.get("subject"))
            .withCost(Integer.parseInt(requestBodyFields.get("costInPoints")))
            .withUrgency(requestBodyFields.get("urgency"))
            .withPlatform(requestBodyFields.get("platform"))
            .withDescription(requestBodyFields.get("description"))
            .withStatus(Status.PENDING.toString())
            .build();
    DYNAMO_DB_MAPPER.save(request, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: query dynamodb directly so as not to rely on correctness of GET method
    Request key = new Request(request.getRequestId());
    DynamoDBQueryExpression<Request> queryExpression =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);
    List<Request> requestById =
        DYNAMO_DB_MAPPER.query(Request.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, requestById.size());
    Request requestInDB = requestById.get(0);

    // THEN: all fields correct
    assertEquals(requestInDB.getRequesterId().toString(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(requestInDB.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(requestInDB.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB.getPlatform().toString(), requestBodyFields.get("platform"));

    // WHEN: patch request
    Map<String, String> changes = new HashMap<>();
    changes.put("subject", "🧬 Biology");
    changes.put("costInPoints", "5000");
    String body = OBJECT_MAPPER.writeValueAsString(changes);
    String response =
        ApiUtils.patch(
            ApiUtils.ApiStages.TEST.toString(),
            String.format("/request/%s", request.getRequestId()),
            body);

    // THEN: response is not null
    assertNotNull(response);

    // THEN: fields in DynamoDB reflect changes. Query directly so as not to rely on correctness of
    // GET method
    Request key2 = new Request(request.getRequestId());
    DynamoDBQueryExpression<Request> queryExpression2 =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);
    List<Request> requestById2 =
        DYNAMO_DB_MAPPER.query(Request.class, queryExpression2, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, requestById2.size());
    Request requestInDB2 = requestById2.get(0);

    assertEquals(requestInDB2.getRequesterId().toString(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB2.getSubject().getSubjectName(), changes.get("subject"));
    assertEquals(requestInDB2.getCostInPoints().toString(), changes.get("costInPoints"));
    assertEquals(requestInDB2.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB2.getPlatform().toString(), requestBodyFields.get("platform"));

    // cleanup
    createdRequests.add(request.getRequestId().toString());
  }

  @Test
  void deleteTestGivenValidRequest() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields =
        OBJECT_MAPPER.readValue(requestBody, new TypeReference<HashMap<String, String>>() {});

    // GIVEN: valid request in DynamoDB. Put directly so as not to rely on POST method correctness
    Request request =
        new RequestBuilder()
            .withRequesterId(requestBodyFields.get("requesterId"))
            .withSubject(requestBodyFields.get("subject"))
            .withCost(Integer.parseInt(requestBodyFields.get("costInPoints")))
            .withUrgency(requestBodyFields.get("urgency"))
            .withPlatform(requestBodyFields.get("platform"))
            .withDescription(requestBodyFields.get("description"))
            .withStatus(Status.PENDING.toString())
            .build();
    DYNAMO_DB_MAPPER.save(request, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: delete request
    String response =
        ApiUtils.delete(
            ApiUtils.ApiStages.TEST.toString(),
            String.format("/request/%s", request.getRequestId()));

    // THEN: response is not null
    assertNotNull(response);

    // THEN: delete removes request from DB. Query directly so as not to rely on correctness of GET
    // method
    Request key = new Request(request.getRequestId());
    DynamoDBQueryExpression<Request> queryExpression =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);
    List<Request> requestById =
        DYNAMO_DB_MAPPER.query(Request.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(0, requestById.size());
  }

  @Test
  void getTestGivenValidRequest() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields =
        OBJECT_MAPPER.readValue(requestBody, new TypeReference<HashMap<String, String>>() {});

    // GIVEN: valid request in DynamoDB. Put directly so as not to rely on POST method correctness
    Request request =
        new RequestBuilder()
            .withRequesterId(requestBodyFields.get("requesterId"))
            .withSubject(requestBodyFields.get("subject"))
            .withCost(Integer.parseInt(requestBodyFields.get("costInPoints")))
            .withUrgency(requestBodyFields.get("urgency"))
            .withPlatform(requestBodyFields.get("platform"))
            .withDescription(requestBodyFields.get("description"))
            .withStatus(Status.PENDING.toString())
            .build();
    DYNAMO_DB_MAPPER.save(request, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: get request
    String response =
        ApiUtils.get(
            ApiUtils.ApiStages.TEST.toString(),
            String.format("/request/%s", request.getRequestId()));

    // THEN: response is not null
    assertNotNull(response);

    // THEN: object we receive is identical to object we put
    Request requestFromGet = RequestUtils.getRequestFromAPIResponse(response);
    assertEquals(request, requestFromGet);
  }
}
