package com.tutor.request;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import java.time.LocalDateTime;
import java.util.UUID;

public class Request {
  private UUID requesterId;
  private UUID requestId;
  private Subject subject;
  private LocalDateTime dateRequested;
  private LocalDateTime sessionTime;
  private Platform platform;
  private Integer costInPoints;

  public Request(RequestBuilder builder) {
    this.requesterId = builder.requesterId;
    this.subject = builder.subject;
    this.sessionTime = builder.sessionTime;
    this.costInPoints = builder.costInPoints;
    this.platform = builder.platform;
    this.requestId = UUID.randomUUID();
    this.dateRequested = LocalDateTime.now();
  }

  /** Default constructor for use by DynanmoDB mapper. Not for use by programmer. */
  public Request() {}

  @DynamoDBAttribute(attributeName = "requesterId")
  public UUID getRequesterId() {
    return requesterId;
  }

  public void setRequesterId(UUID requesterId) {
    this.requesterId = requesterId;
  }

  @DynamoDBHashKey(attributeName = "requestId")
  public UUID getRequestId() {
    return requestId;
  }

  public void setRequestId(UUID requestId) {
    this.requestId = requestId;
  }

  @DynamoDBAttribute(attributeName = "subject")
  public Subject getSubject() {
    return subject;
  }

  public void setSubject(Subject subject) {
    this.subject = subject;
  }

  @DynamoDBAttribute(attributeName = "dateRequested")
  public LocalDateTime getDateRequested() {
    return dateRequested;
  }

  public void setDateRequested(LocalDateTime dateRequested) {
    this.dateRequested = dateRequested;
  }

  @DynamoDBAttribute(attributeName = "sessionTime")
  public LocalDateTime getSessionTime() {
    return sessionTime;
  }

  public void setSessionTime(LocalDateTime sessionTime) {
    this.sessionTime = sessionTime;
  }

  @DynamoDBAttribute(attributeName = "platform")
  public Platform getPlatform() {
    return platform;
  }

  public void setPlatform(Platform platform) {
    this.platform = platform;
  }

  @DynamoDBAttribute(attributeName = "costInPoints")
  public Integer getCostInPoints() {
    return costInPoints;
  }

  public void setCostInPoints(Integer costInPoints) {
    this.costInPoints = costInPoints;
  }

  @Override
  public String toString() {
    return "\"request\" : {"
        + "\"requesterId\" : "
        + "\""
        + requesterId
        + "\""
        + ", \"requestId\" : "
        + "\""
        + requestId
        + "\""
        + ", \"subject\" : "
        + "\""
        + subject
        + "\""
        + ", \"dateRequested\" : "
        + "\""
        + dateRequested
        + "\""
        + ", \"sessionTime\" : "
        + "\""
        + sessionTime
        + "\""
        + ", \"platform\" : "
        + "\""
        + platform
        + "\""
        + ", \"costInPoints\" : "
        + "\""
        + costInPoints
        + "\""
        + '}';
  }
}
