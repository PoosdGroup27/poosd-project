package com.tutor.request;

import com.amazonaws.services.dynamodbv2.datamodeling.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.subject.Subject;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

/**
 * Request object corresponds to schema of Request table. All data must be first marshaled to
 * Request object before being written to DynamoDB. Request data coming from DynamoDB is read into
 * Request object. Regarding table name: set equal to requestTable-{stage_name} if deploying to non
 * prod stage.
 */
@DynamoDBTable(tableName = "requestTable-prod")
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
  private String description;
  private List<UUID> orderedMatches;

  /**
   * Constructs a Request object from a well-formed RequestBuilder.
   *
   * @param builder Takes in a RequestBuilder object.
   */
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
    this.description = builder.description;
    this.orderedMatches = new ArrayList<>();
  }

  /**
   * Used for creating object to serve as DynamoDB key.
   *
   * @param requestId Generated on creation UUID unique to request.
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

  @DynamoDBTypeConvertedEnum
  @DynamoDBAttribute(attributeName = "subject")
  public Subject getSubject() {
    return subject;
  }

  public void setSubject(Subject subject) {
    this.subject = subject;
  }

  @DynamoDBTypeConverted(converter = LocalDateTimeConverter.class)
  @DynamoDBAttribute(attributeName = "dateRequested")
  public LocalDateTime getDateRequested() {
    return dateRequested;
  }

  public void setDateRequested(LocalDateTime dateRequested) {
    this.dateRequested = dateRequested;
  }

  public void setDateRequested(String dateRequested) {
    this.dateRequested = LocalDateTime.parse(dateRequested);
  }

  @DynamoDBTypeConverted(converter = LocalDateTimeConverter.class)
  @DynamoDBAttribute(attributeName = "sessionTime")
  public LocalDateTime getSessionTime() {
    return sessionTime;
  }

  public void setSessionTime(LocalDateTime sessionTime) {
    this.sessionTime = sessionTime;
  }

  public void setSessionTime(String sessionTime) {
    this.sessionTime = LocalDateTime.parse(sessionTime);
  }

  @DynamoDBTypeConvertedEnum
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

  @DynamoDBTypeConvertedEnum
  @DynamoDBAttribute(attributeName = "urgency")
  public Urgency getUrgency() {
    return urgency;
  }

  public void setUrgency(Urgency urgency) {
    this.urgency = urgency;
  }

  @DynamoDBTypeConvertedEnum
  @DynamoDBAttribute(attributeName = "status")
  public Status getStatus() {
    return status;
  }

  public void setStatus(Status status) {
    this.status = status;
  }

  @DynamoDBAttribute(attributeName = "description")
  public String getDescription() {
    return description;
  }

  public void setDescription(String description) {
    this.description = description;
  }

  @DynamoDBAttribute(attributeName = "orderedMatches")
  public List<UUID> getOrderedMatches() {
    return orderedMatches;
  }

  public void setOrderedMatches(List<UUID> orderedMatches) {
    this.orderedMatches = orderedMatches;
  }

  @Override
  public String toString() {
    ObjectMapper mapper = new ObjectMapper();
    try {
      return mapper.writeValueAsString(this);
    } catch (JsonProcessingException e) {
      e.printStackTrace();
    }

    return "ERROR";
  }

  /**
   * This is necessary in order for the DynamoDB mapper to save LocalDateTime objects.
   * https://stackoverflow.com/questions/28077435/dynamodbmapper-for-java-time-localdatetime
   */
  public static class LocalDateTimeConverter
      implements DynamoDBTypeConverter<String, LocalDateTime> {

    @Override
    public String convert(final LocalDateTime time) {
      return time.toString();
    }

    @Override
    public LocalDateTime unconvert(final String stringValue) {
      return LocalDateTime.parse(stringValue);
    }
  }
}
