package com.tutor.request;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;

import java.time.LocalDateTime;
import java.util.UUID;

/**
 * Request object corresponds to schema of Request table. All data must be first marshalling to Request
 * object before being written to DynamoDB. Request data coming from DynamoDB is read into Request object.
 * Regarding table name: set equal to requestTable-{stage_name} if deploying to non prod stage.
 */
@DynamoDBTable(tableName = "requestTable-adam-dev")
public class Request {
  private UUID requesterId;
  private UUID helperId;
  private UUID requestId;
  private Subject subject;
  private LocalDateTime dateRequested;
  private LocalDateTime sessionTime;
  private Platform platform;
  private Integer costInPoints;
  private Urgency urgency;
  private Status status;

  public Request(RequestBuilder builder) {
    this.requesterId = builder.requesterId;
    this.helperId = builder.helperId;
    this.subject = builder.subject;
    this.sessionTime = builder.sessionTime;
    this.costInPoints = builder.costInPoints;
    this.platform = builder.platform;
    this.requestId = UUID.randomUUID();
    this.dateRequested = LocalDateTime.now();
    this.urgency = builder.urgency;
    this.status = builder.status;
  }

  /**
   * Used for creating object to serve as DynamoDB key.
   * @param requestId
   */
  public Request(UUID requestId) {
    this.requestId = requestId;
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

  @DynamoDBAttribute(attributeName = "helperId")
  public UUID getHelperId() {
    return helperId;
  }

  public void setHelperId(UUID helperId) {
    this.helperId = helperId;
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

  @DynamoDBAttribute(attributeName = "urgency")
  public Urgency getUrgency() {
    return urgency;
  }

  public void setUrgency(Urgency urgency) {
    this.urgency = urgency;
  }

  @DynamoDBAttribute(attributeName = "status")
  public Status getStatus() {
    return status;
  }

  public void setStatus(Status status) {
    this.status = status;
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
        + ", \"helperId\" : "
        + "\""
        + helperId
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
        + ", \"urgency\" : "
        + "\""
        + urgency
        + "\""
        + ", \"status\" : "
        + "\""
        + status
        + "\""
        + '}';
  }
}
