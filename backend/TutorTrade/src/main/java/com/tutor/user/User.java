package com.tutor.user;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

/**
 * User object corresponds to schema of User table. All data must be
 * first marshalling to User object before being written to DynamoDB.
 * User data coming from DynamoDB is read into User object.
 */
@DynamoDBTable(tableName = "usersTable")
public class User {
  private final String name;
  private final String school;
  private final Date dateCreated;
  private final boolean isActive;
  private final int points;
  private final ArrayList<UUID> sessionIds;
  private final UUID userId;
  private static final int STARTING_POINTS = 100;

  /**
   * Constructor is a wrapper for builder and should
   * not be called directly.
   *
   * @param builder Builder class allows user to
   *                set fields of object as chained
   *                method calls.
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

  @DynamoDBAttribute(attributeName = "name")
  public String getName() {
    return name;
  }

  @DynamoDBAttribute(attributeName = "school")
  public String getSchool() {
    return school;
  }

  @DynamoDBAttribute(attributeName = "dateCreated")
  public Date getDateCreated() {
    return dateCreated;
  }

  @DynamoDBAttribute(attributeName = "isActive")
  public boolean getIsActive() {
    return isActive;
  }

  @DynamoDBAttribute(attributeName = "points")
  public int getPoints() {
    return points;
  }

  @DynamoDBAttribute(attributeName = "sessionID")
  public ArrayList<UUID> getSessionIds() {
    return sessionIds;
  }

  @DynamoDBHashKey(attributeName = "userID")
  public UUID getUserId() {
    return userId;
  }
}
