package com.tutor.utils;

import lombok.Builder;

/**
 * Class wraps API response to allow us to return status code information and arbitrary objects from
 * lambda handlers.
 *
 * @param <T> Data type of body. This object will be serialized and returned as API response.
 *     Typically, string for error messages, or request/user/subjects on successful API calls.
 */
@Builder
public class ApiResponse<T> {
  public int statusCode;
  public T body;
}
