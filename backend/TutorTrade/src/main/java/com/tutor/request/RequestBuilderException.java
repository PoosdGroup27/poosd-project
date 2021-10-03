package com.tutor.request;

/** Custom exception for request objects. */
public class RequestBuilderException extends Exception {
  /**
   * Problems with building a Request object.
   *
   * @param errorMessage Failed validation report.
   */
  public RequestBuilderException(String errorMessage) {
    super(errorMessage);
  }
}
