package com.tutor.user;

import com.tutor.subject.Subject;
import java.util.ArrayList;

/**
 * Builder method for User class. Allows for chained set methods and validation during construction
 * (i.e. new UserBuilder.withName("name").withSchool("school").build())
 */
public class UserBuilder {
  public String name;
  public String userId;
  public String school;
  public String phoneNumber;
  public ArrayList<Subject> subjectsLearn;
  public ArrayList<Subject> subjectsTeach;
  public String major;

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
    if (user.getUserId() == null) {
      nullValues.add("userId");
    }

    if (!nullValues.isEmpty()) {
      throw new UserBuilderException("No values provided for these fields: " + nullValues);
    }
  }

  public UserBuilder withId(String id) {
    this.userId = id;
    return this;
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

  public UserBuilder withSubjectsLearn(ArrayList<Subject> subjectsLearn) {
    this.subjectsLearn = subjectsLearn;
    return this;
  }

  public UserBuilder withSubjectsTeach(ArrayList<Subject> subjectsTeach) {
    this.subjectsTeach = subjectsTeach;
    return this;
  }

  public UserBuilder withMajor(String major) {
    this.major = major;
    return this;
  }

  /**
   * Validates that User contains all required fields.
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
