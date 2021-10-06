package com.tutor.user;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

/**
 * User object corresponds to schema of User table. All data must be first marshalling to User
 * object before being written to DynamoDB. User data coming from DynamoDB is read into User object.
 * Regarding table name: set equal to userTable-{stage_name} if deploying to none prod stage
 */
@DynamoDBTable(tableName = "userTable-prod")
public class User {
  private String name;

  private String school;
  private Date dateCreated;
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
    this.dateCreated = new Date();
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

  @DynamoDBAttribute(attributeName = "dateCreated")
  public Date getDateCreated() {
    return dateCreated;
  }

  public void setDateCreated(Date dateCreated) {
    this.dateCreated = dateCreated;
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
    return "User{"
        + "name='"
        + name
        + '\''
        + ", school='"
        + school
        + '\''
        + ", dateCreated="
        + dateCreated
        + ", isActive="
        + isActive
        + ", points="
        + points
        + ", sessionIds="
        + sessionIds
        + ", userId="
        + userId
        + '}';
  }
}
