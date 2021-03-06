package com.tutor.request;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.subject.Subject;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.JsonUtils;
import com.tutor.utils.RequestUtils;
import org.junit.jupiter.api.*;

import java.io.IOException;
import java.util.*;

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
  private static final String TEST_USER_ID = UUID.randomUUID().toString();

  @BeforeAll
  static void beforeAll() throws IOException {
    String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
    ApiUtils.put(ApiUtils.ApiStages.TEST.toString(), "/user/" + TEST_USER_ID, userBody);
  }

  @AfterAll
  static void afterAll() {
    ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), "user/" + TEST_USER_ID);
  }

  @BeforeEach
  void setUp() {}

  @AfterEach
  void tearDown() {
    for (String requestId : createdRequests) {
      ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/request/%s", requestId));
    }
  }

  private static Map<String, String> getTestRequestFromFile(String requestBody) throws IOException {
    Map<String, String> requestBodyFields =
        OBJECT_MAPPER.readValue(requestBody, new TypeReference<HashMap<String, String>>() {});

    // dynamically change the requesterId
    requestBodyFields.put("requesterId", TEST_USER_ID);

    return requestBodyFields;
  }

  // Test-Case-B01.2
  @Test
  void postTestGivenValidRequest() throws IOException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields = getTestRequestFromFile(requestBody);

    // WHEN: post request to request API
    String requestPostResponseString =
        ApiUtils.post(
            ApiUtils.ApiStages.TEST.toString(),
            "/request",
            OBJECT_MAPPER.writeValueAsString(requestBodyFields));

    // THEN: request response is not null
    assertNotNull(requestPostResponseString);

    // THEN: request response is a valid request object
    Request request = RequestUtils.getRequestFromAPIResponse(requestPostResponseString);
    assertNotNull(request);

    // THEN: fields of request object match those from validPostRequest.json
    assertEquals(request.getRequesterId(), requestBodyFields.get("requesterId"));
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
    assertEquals(requestInDB.getRequesterId(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(requestInDB.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(requestInDB.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB.getPlatform().toString(), requestBodyFields.get("platform"));

    // cleanup
    createdRequests.add(request.getRequestId().toString());
  }

  // Test-Case-B01.1
  @Test
  void postTestGivenValidRandomRequest() throws IOException {
    // GIVEN: valid random request body
    Map<String, String> requestBodyFields = createRandomRequestPostBody();

    // WHEN: post request to request API
    String requestPostResponseString =
            ApiUtils.post(
                    ApiUtils.ApiStages.TEST.toString(),
                    "/request",
                    OBJECT_MAPPER.writeValueAsString(requestBodyFields));

    // THEN: request response is not null
    assertNotNull(requestPostResponseString);

    // THEN: request response is a valid request object
    Request request = RequestUtils.getRequestFromAPIResponse(requestPostResponseString);
    assertNotNull(request);

    // THEN: fields of request object match those from validPostRequest.json
    assertEquals(request.getRequesterId(), requestBodyFields.get("requesterId"));
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
    assertEquals(requestInDB.getRequesterId(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(requestInDB.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(requestInDB.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB.getPlatform().toString(), requestBodyFields.get("platform"));

    // cleanup
    createdRequests.add(request.getRequestId().toString());
  }

  // Test-Case-B02.2
  @Test
  void patchTestGivenValidChange() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields = getTestRequestFromFile(requestBody);

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
    assertEquals(requestInDB.getRequesterId(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(requestInDB.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(requestInDB.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB.getPlatform().toString(), requestBodyFields.get("platform"));

    // WHEN: patch request
    Map<String, String> changes = new HashMap<>();
    changes.put("subject", "???? Biology");
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

    assertEquals(requestInDB2.getRequesterId(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB2.getSubject().getSubjectName(), changes.get("subject"));
    assertEquals(requestInDB2.getCostInPoints().toString(), changes.get("costInPoints"));
    assertEquals(requestInDB2.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB2.getPlatform().toString(), requestBodyFields.get("platform"));

    // cleanup
    createdRequests.add(request.getRequestId().toString());
  }


  // Test-Case-B02.1
  @Test
  void patchTestGivenValidRandomChange() throws IOException, RequestBuilderException {
    Random random = new Random();

    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields = getTestRequestFromFile(requestBody);

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
    assertEquals(requestInDB.getRequesterId(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB.getSubject().getSubjectName(), requestBodyFields.get("subject"));
    assertEquals(requestInDB.getCostInPoints().toString(), requestBodyFields.get("costInPoints"));
    assertEquals(requestInDB.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB.getPlatform().toString(), requestBodyFields.get("platform"));

    // WHEN: patch request
    Map<String, String> changes = new HashMap<>();
    changes.put("subject", Subject.values()[random.nextInt(Subject.values().length)].getSubjectName());
    changes.put("costInPoints", String.valueOf(random.nextInt()));
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

    assertEquals(requestInDB2.getRequesterId(), requestBodyFields.get("requesterId"));
    assertEquals(requestInDB2.getSubject().getSubjectName(), changes.get("subject"));
    assertEquals(requestInDB2.getCostInPoints().toString(), changes.get("costInPoints"));
    assertEquals(requestInDB2.getUrgency().toString(), requestBodyFields.get("urgency"));
    assertEquals(requestInDB2.getPlatform().toString(), requestBodyFields.get("platform"));

    // cleanup
    createdRequests.add(request.getRequestId().toString());
  }

  // Test-Case-B04.2
  @Test
  void deleteTestGivenValidRequest() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields = getTestRequestFromFile(requestBody);

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

  // Test-Case-B04.1
  @Test
  void deleteTestGivenValidRandomRequest() throws RequestBuilderException {
    // GIVEN: valid request body
    Map<String, String> requestBodyFields = createRandomRequestPostBody();

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

  // Test-Case-B03.2
  @Test
  void getTestGivenValidRequest() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    String requestBody = JSON_UTILS.getJsonFromFileAsString("validPostRequest.json");
    Map<String, String> requestBodyFields = getTestRequestFromFile(requestBody);

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

  // Test-Case-B03.1
  @Test
  void getTestGivenValidRandomRequest() throws IOException, RequestBuilderException {
    // GIVEN: valid request body
    Map<String, String> requestBodyFields = createRandomRequestPostBody();

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

  private Map<String, String> createRandomRequestPostBody() {
    Random random = new Random();

    Map<String, String> requestBodyFields = new HashMap<>();
    requestBodyFields.put("requesterId", TEST_USER_ID);
    requestBodyFields.put("subject", Subject.values()[random.nextInt(Subject.values().length)].getSubjectName());
    requestBodyFields.put("urgency", Urgency.values()[random.nextInt(Urgency.values().length)].toString());
    requestBodyFields.put("platform", Platform.values()[random.nextInt(Platform.values().length)].toString());
    requestBodyFields.put("costInPoints", String.valueOf(random.nextInt(10000)));
    requestBodyFields.put("description", "This is a test");

    return requestBodyFields;
  }
}
