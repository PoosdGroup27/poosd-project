package com.tutor.request;

import com.tutor.subject.Subject;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.ArrayList;

/**
 * Builder method for Requests class. Allows for chained set methods and validation during
 * construction.
 */
public class RequestBuilder {
  public String requesterId;
  public String helperId;
  public Subject subject;
  public LocalDateTime sessionTime;
  public Platform platform;
  public int costInPoints;
  public Urgency urgency;
  public Status status;
  public String description;

  private static void validateRequest(Request request) throws RequestBuilderException {
    ArrayList<String> nullValues = new ArrayList<>();

    // May not be a good idea to throw exceptions for null values of
    // helperId and sessionTime, as these will be figured out later/sent via PATCH.

    if (request.getRequesterId() == null) {
      nullValues.add("requesterId");
    }
    if (request.getSubject() == null) {
      nullValues.add("subject");
    }
    if (request.getPlatform() == null) {
      nullValues.add("platform");
    }
    if (request.getCostInPoints() == null) {
      nullValues.add("cost");
    }
    if (request.getUrgency() == null) {
      nullValues.add("urgency");
    }
    if (request.getStatus() == null) {
      nullValues.add("status");
    }
    if (request.getDescription() == null) {
      nullValues.add("description");
    }

    if (!nullValues.isEmpty()) {
      throw new RequestBuilderException("No values provided for these fields: " + nullValues);
    }
  }

  public RequestBuilder withRequesterId(String requesterId) {
    this.requesterId = requesterId;
    return this;
  }

  public RequestBuilder withHelperId(String helperId) {
    this.helperId = helperId;
    return this;
  }

  /**
   * Set subject of request.
   *
   * @param subject String representing subject constant in Subject enum
   * @return RequestBuilder for chained calls
   * @throws RequestBuilderException Throws exception if enum constant does not exist
   */
  public RequestBuilder withSubject(String subject) throws RequestBuilderException {
    try {
      this.subject = Subject.fromSubjectName(subject);
    } catch (IllegalArgumentException e) {
      throw new RequestBuilderException(String.format("Subject %s is unsupported.", subject));
    }
    return this;
  }

  /**
   * Accepts a string representing a session of the form "M/d/yyyy H:mm".
   *
   * @param sessionTime string of the above form.
   * @return the RequestBuilder object, to be able to chain "with" methods.
   */
  public RequestBuilder withSessionTime(String sessionTime) {
    this.sessionTime =
        LocalDateTime.parse(sessionTime, DateTimeFormatter.ofPattern("M/d/yyyy H:mm"));
    return this;
  }

  public RequestBuilder withPlatform(String platform) {
    this.platform = Platform.valueOf(platform);
    return this;
  }

  public RequestBuilder withCost(int cost) {
    this.costInPoints = cost;
    return this;
  }

  public RequestBuilder withUrgency(String urgency) {
    this.urgency = Urgency.valueOf(urgency);
    return this;
  }

  public RequestBuilder withStatus(String status) {
    this.status = Status.valueOf(status);
    return this;
  }

  public RequestBuilder withDescription(String description) {
    this.description = description;
    return this;
  }

  /**
   * Validates that request contains non-empty application provided fields.
   *
   * @return Valid Request object
   * @throws RequestBuilderException Occurs when validation fails
   */
  public Request build() throws RequestBuilderException {
    Request request = new Request(this);
    validateRequest(request);
    return request;
  }
}
