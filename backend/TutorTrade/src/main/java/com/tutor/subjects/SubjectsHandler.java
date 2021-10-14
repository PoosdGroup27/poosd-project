package com.tutor.subjects;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.sun.tools.javac.util.DefinedBy;
import com.tutor.request.Subject;
import com.tutor.utils.ApiUtils;
import java.net.HttpURLConnection;
import java.util.*;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Handle requests to the Subjects endpoint. Currently only supports get requests. */
public class SubjectsHandler implements RequestHandler<Map<Object, Object>, String> {

  private static final Logger LOG = LogManager.getLogger(SubjectsHandler.class);

  @Override
  public String handleRequest(Map<Object, Object> event, Context context) {
    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");

    if (httpMethod.equals("GET")) {
      try {
        return getListOfSubjects();
      } catch (JsonProcessingException e) {
        return ApiUtils.returnErrorString(e);
      }
    }

    return ApiUtils.getResponseAsString(
        HttpURLConnection.HTTP_BAD_METHOD, "Requested method was not found.");
  }

  /**
   * Returns a list of available subjects of the Subjects enum
   *
   * @return JSONified string with all available subjects
   */
  private String getListOfSubjects() throws JsonProcessingException {
    return ApiUtils.getResponseAsString(HttpURLConnection.HTTP_OK, Subject.getListOfSubjectsAsString());
  }
}
