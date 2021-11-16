package com.tutor.user;

import com.amazonaws.services.dynamodbv2.datamodeling.*;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.request.Request;
import com.tutor.subject.Subject;
import com.tutor.utils.UserUtils;

import java.lang.reflect.Array;
import java.text.DecimalFormat;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.Objects;
import java.util.UUID;
import java.util.stream.Collectors;

/**
 * User object corresponds to schema of User table. All data must be first marshalling to User
 * object before being written to DynamoDB. User data coming from DynamoDB is read into User object.
 * Regarding table name: set equal to userTable-{stage_name} if deploying to none prod stage
 */
@DynamoDBTable(tableName = "userTable-test")
public class User {
  private String name;

  private String school;
  private LocalDateTime dateCreated;
  private boolean isActive;
  private int points;
  private ArrayList<UUID> sessionIds;
  private String userId;
  private static final int STARTING_POINTS = 100;
  private String phoneNumber;
  private ArrayList<Subject> subjectsTeach;
  private ArrayList<Subject> subjectsLearn;
  private int cumulativeSessionsCompleted;
  private double rating;
  private String major;

  /**
   * Constructor is a wrapper for builder and should not be called directly, unless creating user
   * object to serve as DynamoDB key (i.e. user with only an id).
   *
   * @param builder Builder class allows user to set fields of object as chained method calls.
   */
  public User(UserBuilder builder) {
    this.name = builder.name;
    this.school = builder.school;
    this.userId = builder.userId;
    this.phoneNumber = builder.phoneNumber;
    this.points = STARTING_POINTS;
    this.dateCreated = LocalDateTime.now();
    this.isActive = true;
    this.cumulativeSessionsCompleted = 0;
    this.rating = 5;
    this.subjectsTeach =
        (builder.subjectsTeach == null) ? new ArrayList<>() : builder.subjectsTeach;
    this.subjectsLearn =
        (builder.subjectsLearn == null) ? new ArrayList<>() : builder.subjectsLearn;
    this.major = builder.major;
    // users shouldn't have session IDs at creation time
    this.sessionIds = new ArrayList<>();
  }

  /**
   * Used for creating object to serve as DynamoDB key (i.e. user with only an id).
   *
   * @param userId UUID uniquely identifying user
   */
  public User(String userId) {
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

  /** Adds a sessionId from the user's list */
  public void addSessionId(UUID sessionId) {
    sessionIds.add(sessionId);
  }

  /** Deletes a sessionId from the user's list */
  public void deleteSessionId(UUID sessionId) {
    if (sessionId != null) {
      sessionIds.remove(sessionId);
    }
  }

  @DynamoDBHashKey(attributeName = "userID")
  public String getUserId() {
    return userId;
  }

  public void setUserId(String userId) {
    this.userId = userId;
  }

  @DynamoDBAttribute(attributeName = "phoneNumber")
  public String getPhoneNumber() {
    return phoneNumber;
  }

  public void setPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
  }

  @DynamoDBTypeConverted(converter = SubjectListConverter.class)
  @DynamoDBAttribute(attributeName = "subjectsLearn")
  public ArrayList<Subject> getSubjectsLearn() {
    return subjectsLearn;
  }

  public void setSubjectsLearn(ArrayList<Subject> subjectsLearn) {
    this.subjectsLearn = subjectsLearn;
  }

  @DynamoDBTypeConverted(converter = SubjectListConverter.class)
  @DynamoDBAttribute(attributeName = "subjectsTeach")
  public ArrayList<Subject> getSubjectsTeach() {
    return subjectsTeach;
  }

  public void setSubjectsTeach(ArrayList<Subject> subjectsTeach) {
    this.subjectsTeach = subjectsTeach;
  }

  @DynamoDBAttribute(attributeName = "cumulativeSessionsCompleted")
  public int getCumulativeSessionsCompleted() {
    return cumulativeSessionsCompleted;
  }

  public void setCumulativeSessionsCompleted(int cumulativeSessionsCompleted) {
    this.cumulativeSessionsCompleted = cumulativeSessionsCompleted;
  }

  @DynamoDBAttribute(attributeName = "rating")
  public double getRating() {
    return rating;
  }

  public void setRating(double rating) {
    this.rating = rating;
  }

  @DynamoDBAttribute(attributeName = "major")
  public String getMajor() {
    return major;
  }

  public void setMajor(String major) {
    this.major = major;
  }

  /**
   * Adds a new rating to the overall rating for the user. In other words, calculates new average
   * for rating and stores inside rating field.
   *
   * @param rating rating to be added
   */
  public void addNewRating(int rating) {
    if (cumulativeSessionsCompleted == 0) {
      this.rating = rating;
    }

    DecimalFormat df = new DecimalFormat("#.#");

    double totalNumPoints = cumulativeSessionsCompleted * this.rating;
    cumulativeSessionsCompleted++;

    this.rating =
        Double.parseDouble(df.format((totalNumPoints + rating) / cumulativeSessionsCompleted));
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

  @Override
  public boolean equals(Object o) {
    if (this == o) return true;
    if (o == null || getClass() != o.getClass()) return false;
    User user = (User) o;
    return isActive == user.isActive
        && points == user.points
        && Objects.equals(name, user.name)
        && Objects.equals(school, user.school)
        && Objects.equals(dateCreated, user.dateCreated)
        && Objects.equals(sessionIds, user.sessionIds)
        && Objects.equals(userId, user.userId)
        && Objects.equals(phoneNumber, user.phoneNumber)
        && Objects.equals(subjectsLearn, user.subjectsLearn)
        && Objects.equals(subjectsTeach, user.subjectsTeach)
        && Objects.equals(major, user.major)
        && Objects.equals(cumulativeSessionsCompleted, user.cumulativeSessionsCompleted)
        && Objects.equals(rating, user.rating);
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

  /** This is necessary in order for DynamoDB mapper to save ArrayList of Subject enums */
  public static class SubjectListConverter
      implements DynamoDBTypeConverter<ArrayList<String>, ArrayList<Subject>> {

    @Override
    public ArrayList<String> convert(final ArrayList<Subject> subjects) {
      return subjects.stream()
          .map(Subject::getSubjectName)
          .collect(Collectors.toCollection(ArrayList<String>::new));
    }

    @Override
    public ArrayList<Subject> unconvert(final ArrayList<String> stringValue) {
      return (stringValue != null)
          ? UserUtils.convertListOfStringsToListOfSubjects(stringValue)
          : null;
    }
  }
}
