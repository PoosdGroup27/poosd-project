package com.tutor;

import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBAttribute;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBHashKey;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBTable;

@DynamoDBTable(tableName = "usersTable")
public class User {
   private String name;
   private String school;
   private Date dateCreated;
   private boolean isActive;
   private int points;
   private ArrayList<UUID> sessionIDs;
   private UUID userID;

   private final int STARTING_POINTS = 100;

   public User(UserBuilder builder) {
      this.name = builder.name;
      this.school = builder.school;

      this.points = STARTING_POINTS;
      this.userID = UUID.randomUUID();
      this.dateCreated = new Date();
      this.isActive = true;
      
      // users shouldn't have session IDs at creation time
      this.sessionIDs = new ArrayList<>();
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
   public ArrayList<UUID> getSessionIDs() {
      return sessionIDs;
   }

   @DynamoDBHashKey(attributeName = "userID")
   public UUID getUserID() {
      return userID;
   }
}