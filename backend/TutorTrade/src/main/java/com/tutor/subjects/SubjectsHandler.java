package com.tutor.subjects;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.tutor.request.Subject;
import com.tutor.utils.ApiUtils;
import java.net.HttpURLConnection;
import java.util.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Handle requests to the Subjects endpoint. Currently only supports get requests. */
public class SubjectsHandler implements RequestHandler<Map<Object, Object>, String> {

  private static final Logger LOG = LogManager.getLogger(SubjectsHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");

    if (httpMethod.equals("GET")) {
      return getListOfSubjects();
    }

    return ApiUtils.getResponseAsString(
        HttpURLConnection.HTTP_BAD_METHOD, "Requested method was not found.");
  }

  /**
   * Returns a list of available subjects of the Subjects enum
   *
   * @return JSONified string with all available subjects
   */
  private String getListOfSubjects() {
    StringBuilder subjectsBuilder = new StringBuilder("");

    subjectsBuilder.append("{");

    for (int i = 0; i < Subject.values().length; i++) {
      Subject subject = Subject.values()[i];

      subjectsBuilder.append(String.format("\"%s\": {", subject.name()));
      subjectsBuilder.append(String.format("\"subjectName\": \"%s\", ", subject.getSubjectName()));
      subjectsBuilder.append(String.format("\"emoji\": \"%s\"", subject.getEmoji()));
      subjectsBuilder.append("}");

      // include comma for next subject for all subjects except last one
      if (i != Subject.values().length - 1) {
        subjectsBuilder.append(", ");
      }
    }

    subjectsBuilder.append("}");

    return ApiUtils.getResponseAsString(HttpURLConnection.HTTP_OK, subjectsBuilder.toString());
  }
}
