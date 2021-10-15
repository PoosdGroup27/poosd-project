package com.tutor.user;

import com.amazonaws.services.dynamodbv2.datamodeling.*;
import com.tutor.request.Request;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.UUID;

/**
 * User object corresponds to schema of User table. All data must be first marshalling to User
 * object before being written to DynamoDB. User data coming from DynamoDB is read into User object.
 * Regarding table name: set equal to userTable-{stage_name} if deploying to none prod stage
 */
@DynamoDBTable(tableName = "userTable-adam-dev")
public class User {
  private String name;

  private String school;
  private LocalDateTime dateCreated;
  private boolean isActive;
  private int points;
  private ArrayList<UUID> sessionIds;
  private UUID userId;
  private static final int STARTING_POINTS = 100;

  /**
   * Constructor is a wrapper for builder and should not be called directly, unless creating user
   * object to serve as DynamoDB key (i.e. user with only an id).
   *
   * @param builder Builder class allows user to set fields of object as chained method calls.
   */
  public User(UserBuilder builder) {
    this.name = builder.name;
    this.school = builder.school;
    this.points = STARTING_POINTS;
    this.userId = UUID.randomUUID();
    this.dateCreated = LocalDateTime.now();
    this.isActive = true;

    // users shouldn't have session IDs at creation time
    this.sessionIds = new ArrayList<>();
  }

  /**
   * Used for creating object to serve as DynamoDB key (i.e. user with only an id).
   *
   * @param userId UUID uniquely identifying user
   */
  public User(UUID userId) {
    this.userId = userId;
  }

  /** Default constructor for use by DynamoDB mapper. Should not be used directly. */
  public User() {}

  @DynamoDBAttribute(attributeName = "name")
  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }

  @DynamoDBAttribute(attributeName = "school")
  public String getSchool() {
    return school;
  }

  public void setSchool(String school) {
    this.school = school;
  }

  @DynamoDBTypeConverted(converter = Request.LocalDateTimeConverter.class)
  @DynamoDBAttribute(attributeName = "dateCreated")
  public LocalDateTime getDateCreated() {
    return dateCreated;
  }

  public void setDateCreated(LocalDateTime dateCreated) {
    this.dateCreated = dateCreated;
  }

  public void setDateCreated(String dateCreated) {
    this.dateCreated = LocalDateTime.parse(dateCreated);
  }

  @DynamoDBAttribute(attributeName = "isActive")
  public boolean getIsActive() {
    return isActive;
  }

  public void setIsActive(boolean active) {
    isActive = active;
  }

  @DynamoDBAttribute(attributeName = "points")
  public int getPoints() {
    return points;
  }

  public void setPoints(int points) {
    this.points = points;
  }

  @DynamoDBAttribute(attributeName = "sessionIds")
  public ArrayList<UUID> getSessionIds() {
    return sessionIds;
  }

  public void setSessionIds(ArrayList<UUID> sessionIds) {
    this.sessionIds = sessionIds;
  }

  @DynamoDBHashKey(attributeName = "userID")
  public UUID getUserId() {
    return userId;
  }

  public void setUserId(UUID userId) {
    this.userId = userId;
  }

  @Override
  public String toString() {
    return "{"
        + "\"name\": "
        + String.format("\"%s\"", name)
        + ", \"school\": "
        + String.format("\"%s\"", school)
        + ", \"dateCreated\": "
        + String.format("\"%s\"", dateCreated)
        + ", \"isActive\": "
        + String.format("\"%b\"", isActive)
        + ", \"points\": "
        + String.format("\"%d\"", points)
        + ", \"sessionIds\": "
        + String.format("\"%s\"", sessionIds.toString())
        + ", \"userId\": "
        + String.format("\"%s\"", userId.toString())
        + '}';
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
