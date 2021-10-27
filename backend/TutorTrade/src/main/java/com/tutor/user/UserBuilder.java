package com.tutor.user;

import com.tutor.subject.Subject;

import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

/**
 * Builder method for User class. Allows for chained set methods and validation during construction
 * (i.e. new UserBuilder.withName("name").withSchool("school").build())
 */
public class UserBuilder {
  public String name;
  public String school;
  public Date dateCreated;
  public boolean isActive;
  public int points;
  public ArrayList<UUID> sessionIds;
  public String phoneNumber;
  public ArrayList<Subject> subjects;
  public int cumulativeSessionsCompleted;
  public double rating;

  private static void validateUser(User user) throws UserBuilderException {
    ArrayList<String> nullValues = new ArrayList<>();

    if (user.getName() == null) {
      nullValues.add("name");
    }
    if (user.getSchool() == null) {
      nullValues.add("school");
    }
    if (user.getPhoneNumber() == null) {
      nullValues.add("phoneNumber");
    }
    if (user.getSubjects() == null) {
      nullValues.add("subjects");
    }

    if (!nullValues.isEmpty()) {
      throw new UserBuilderException("No values provided for these fields: " + nullValues);
    }
  }

  public UserBuilder withName(String name) {
    this.name = name;
    return this;
  }

  public UserBuilder withSchool(String school) {
    this.school = school;
    return this;
  }

  public UserBuilder withPhoneNumber(String phoneNumber) {
    this.phoneNumber = phoneNumber;
    return this;
  }

  public UserBuilder withSubjects(ArrayList<Subject> subjects) {
    this.subjects = subjects;
    return this;
  }

  /**
   * Validates that User contains non-empty name and school.
   *
   * @return Valid User object
   * @throws UserBuilderException Occurs when validation fails
   */
  public User build() throws UserBuilderException {
    User user = new User(this);
    validateUser(user);
    return user;
  }
}
