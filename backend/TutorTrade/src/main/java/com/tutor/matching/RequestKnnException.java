package com.tutor.matching;

/** Runtimes exceptions cause AWS Lambda function execution to halt. */
public class RequestKnnException extends RuntimeException {
  /**
   * Problems with KNN algorithm.
   *
   * @param errorMessage Error encountered while preparing and executing KNN algorithm for request.
   *     matching.
   */
  public RequestKnnException(String errorMessage) {
    super(errorMessage);
  }
}
