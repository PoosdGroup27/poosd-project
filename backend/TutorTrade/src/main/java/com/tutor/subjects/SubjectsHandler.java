package com.tutor.subjects;

import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.tutor.request.Subject;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

/** Handle requests to the Subjects endpoint. Currently only supports get requests. */
public class SubjectsHandler implements RequestHandler<Map<Object, Object>, List<String>> {
  private static final Logger LOG = LogManager.getLogger(SubjectsHandler.class);

  @Override
  public List<String> handleRequest(Map<Object, Object> event, Context context) {
    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");

    if (httpMethod.equals("GET")) {
      return Subject.getListOfSubjects();
    }
    return null;
  }
}
