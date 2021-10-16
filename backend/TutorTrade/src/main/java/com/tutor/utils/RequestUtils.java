package com.tutor.utils;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.node.ObjectNode;
import com.tutor.request.Platform;
import com.tutor.request.Request;
import com.tutor.subject.Subject;
import com.tutor.request.Urgency;
import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;

/** Utility class for operations on request objects. */
public class RequestUtils {
  private static final List<Platform> PLATFORMS =
          List.of(Platform.values());
  private static final List<Subject> SUBJECTS =
          List.of(Subject.values());
  private static final List<Urgency> URGENCIES =
          List.of(Urgency.values());
  private static final Random RANDOM = new Random();
  private static final String stage =
        System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);

  /**
   * Method generates a request with random but valid values and posts it to the /request/create
   * endpoint of whichever stage is defined in environmental variables.
   */
  public static String postRandomRequest(Boolean test) throws IOException {
    String requesterId = UUID.randomUUID().toString();
    String subject = SUBJECTS.get(RANDOM.nextInt(SUBJECTS.size() - 1)).toString();
    int costInPoints = RANDOM.nextInt(1000);
    String urgency = URGENCIES.get(RANDOM.nextInt(URGENCIES.size())).toString();
    String platform = PLATFORMS.get(RANDOM.nextInt(PLATFORMS.size())).toString();
    String status = "PENDING";
    String description = "TEST";

    String json =
        "{"
            + "\"requesterId\" : "
            + "\""
            + requesterId
            + "\""
            + ", \"subject\" : "
            + "\""
            + subject
            + "\""
            + ", \"platform\" : "
            + "\""
            + platform
            + "\""
            + ", \"costInPoints\" : "
            + "\""
            + costInPoints
            + "\""
            + ", \"urgency\" : "
            + "\""
            + urgency
            + "\""
            + ", \"status\" : "
            + "\""
            + status
            + "\""
            + ", \"description\" : "
            + "\""
            + description
            + "\""
            + "}";

    String finalStage =
        test
            ? ApiUtils.ApiStages.valueOf("TEST").toString()
            : ApiUtils.ApiStages.valueOf(stage).toString();

    return ApiUtils.post(finalStage, "/request/create", json);
  }

  /**
   * Method generates a request with defined request values and posts it to the /request/create
   * endpoint of whichever stage is defined in environmental variables, or to the test stage is test
   * boolean is true.
   */
  public static String postCustomRequest(Request request, Boolean test) throws IOException {
    String requesterId = request.getRequesterId().toString();
    String subject = request.getSubject().toString();
    int costInPoints = request.getCostInPoints();
    String urgency = request.getUrgency().toString();
    String platform = request.getPlatform().toString();
    String status = request.getStatus().toString();
    String description = request.getDescription();

    String json =
        "{"
            + "\"requesterId\" : "
            + "\""
            + requesterId
            + "\""
            + ", \"subject\" : "
            + "\""
            + subject
            + "\""
            + ", \"platform\" : "
            + "\""
            + platform
            + "\""
            + ", \"costInPoints\" : "
            + "\""
            + costInPoints
            + "\""
            + ", \"urgency\" : "
            + "\""
            + urgency
            + "\""
            + ", \"status\" : "
            + "\""
            + status
            + "\""
            + ", \"description\" : "
            + "\""
            + description
            + "\""
            + "}";

    String finalStage =
        test
            ? ApiUtils.ApiStages.valueOf("TEST").toString()
            : ApiUtils.ApiStages.valueOf(stage).toString();

    return ApiUtils.post(finalStage, "/request/create", json);
  }

  /**
   * Method finds request in DB and returns the corresponding request as a Java object.
   *
   * @param requestId UUID representing a valid and existing request
   * @return Request corresponding to requestId, if request is found, null otherwise.
   */
  public static Request getRequestObjectById(String requestId) {
    Request key = new Request(UUID.fromString(requestId));
    DynamoDBQueryExpression<Request> queryExpression =
        new DynamoDBQueryExpression<Request>().withHashKeyValues(key);

    List<Request> requestById = DYNAMO_DB_MAPPER.query(Request.class, queryExpression);

    if (requestById.size() != 1) {
      return null;
    }

    return requestById.get(0);
  }

  public static Request getRequestFromAPIResponse(String APIResponseJson) throws IOException {
    ObjectMapper mapper = new ObjectMapper();
    ObjectNode requestTree = (ObjectNode) mapper.readTree(APIResponseJson).get("body");
    JsonNode dateRequest = requestTree.get("dateRequested");
    LocalDateTime date =
        LocalDateTime.of(
            dateRequest.get("year").asInt(),
            dateRequest.get("monthValue").asInt(),
            dateRequest.get("dayOfMonth").asInt(),
            dateRequest.get("hour").asInt(),
            dateRequest.get("minute").asInt(),
            dateRequest.get("second").asInt(),
            dateRequest.get("nano").asInt());

    requestTree.put("dateRequested", String.valueOf(date));
    return mapper.treeToValue(requestTree, Request.class);
  }
}
