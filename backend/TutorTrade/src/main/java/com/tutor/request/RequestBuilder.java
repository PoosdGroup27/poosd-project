package com.tutor.request;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.FormatStyle;
import java.util.ArrayList;
import java.util.UUID;

/**
 * Builder method for Requests class. Allows for chained set methods and validation during construction
 * (i.e. new UserBuilder.withName("name).withSchool("school").build())
 */
public class RequestBuilder {
  public UUID requesterId;
  public Subject subject;
  public LocalDateTime sessionTime;
  public Platform platform;
  public int costInPoints;
  public Urgency urgency;
  public Status status;

  private static void validateRequest(Request request) throws RequestBuilderException {
    ArrayList<String> nullValues = new ArrayList<>();

    if (request.getRequesterId() == null) {
      nullValues.add("requesterId");
    }
    if (request.getSubject() == null) {
      nullValues.add("subject");
    }
    if (request.getSessionTime() == null) {
      nullValues.add("sessionTime");
    }
    if (request.getPlatform() == null) {
      nullValues.add("platform");
    }
    if (request.getCostInPoints() == null) {
      nullValues.add("cost");
    }

    if (!nullValues.isEmpty()) {
      throw new RequestBuilderException("No values provided for these fields: " + nullValues);
    } else if (request.getSubject() == Subject.UNSUPPORTED) {
      throw new RequestBuilderException("Subject is unsupported");
    }
  }

  public RequestBuilder withRequesterId(String requesterId) {
    this.requesterId = UUID.fromString(requesterId);
    return this;
  }

  public RequestBuilder withSubject(String subject) {
    this.subject = Subject.valueOf(subject);
    return this;
  }

  public RequestBuilder withSessionTime(String sessionTime) {
    DateTimeFormatter formatter = DateTimeFormatter.ofLocalizedDate(FormatStyle.LONG);
    this.sessionTime = LocalDateTime.parse(sessionTime, formatter);
    return this;
  }

  public RequestBuilder withPlatform(Platform platform) {
    this.platform = platform;
    return this;
  }

  public RequestBuilder withCost(int cost) {
    this.costInPoints = cost;
    return this;
  }

  public RequestBuilder withUrgency(Urgency urgency) {
    this.urgency = urgency;
    return this;
  }

  public RequestBuilder withStatus(Status status) {
    this.status = status;
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
