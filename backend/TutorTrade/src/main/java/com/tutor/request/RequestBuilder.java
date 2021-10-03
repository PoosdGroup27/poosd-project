package com.tutor.request;

import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.time.format.DateTimeFormatterBuilder;
import java.time.temporal.ChronoField;
import java.util.ArrayList;
import java.util.UUID;

/**
 * Builder method for Requests class. Allows for chained set methods and validation during
 * construction.
 */
public class RequestBuilder {
  public UUID requesterId;
  public UUID helperId;
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
    if (request.getHelperId() == null) {
      nullValues.add("helperId");
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
    if (request.getUrgency() == null) {
      nullValues.add("urgency");
    }
    if (request.getStatus() == null) {
      nullValues.add("status");
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

  public RequestBuilder withHelperId(String helperId) {
    this.helperId = UUID.fromString(helperId);
    return this;
  }

  public RequestBuilder withSubject(String subject) {
    this.subject = Subject.valueOf(subject);
    return this;
  }

  public RequestBuilder withSessionTime(String sessionTime) {
    this.sessionTime = LocalDateTime.parse(sessionTime, DateTimeFormatter.ofPattern("M/d/yyyy H:mm"));
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

  public RequestBuilder withUrgency(String urgency) {
    this.urgency = Urgency.valueOf(urgency);
    return this;
  }

  public RequestBuilder withStatus(String status) {
    this.status = Status.valueOf(status);
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
