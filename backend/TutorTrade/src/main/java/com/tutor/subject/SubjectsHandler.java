package com.tutor.subject;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.tutor.utils.ApiResponse;
import java.net.HttpURLConnection;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

/** Handle requests to the Subjects endpoint. Currently only supports get requests. */
public class SubjectsHandler implements RequestHandler<Map<Object, Object>, ApiResponse<?>> {
  private static final Logger LOG = LogManager.getLogger(SubjectsHandler.class);

  @Override
  public ApiResponse<?> handleRequest(Map<Object, Object> event, Context context) {
    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");

    if (httpMethod.equals("GET")) {
      return ApiResponse.<List<String>>builder()
          .statusCode(HttpURLConnection.HTTP_OK)
          .body(Subject.getListOfSubjects())
          .build();
    }
    return null;
  }
}
