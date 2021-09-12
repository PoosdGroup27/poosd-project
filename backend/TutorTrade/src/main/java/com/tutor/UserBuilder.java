package com.tutor;
import java.util.ArrayList;
import java.util.Date;
import java.util.UUID;

public class UserBuilder {
   public String name;
   public String school;
   public Date dateCreated;
   public boolean isActive;
   public int points;
   public ArrayList<UUID> sessionIDs;

   public UserBuilder withName(String name) {
      this.name = name;
      return this;
   }

   public UserBuilder withSchool(String school) {
      this.school = school;
      return this;
   }

   public User build() throws UserBuilderException {
      User user = new User(this);
      validateUser(user);
      return user;
   }

   private static void validateUser(User user) throws UserBuilderException {
      ArrayList<String> nullValues = new ArrayList<>();

      if (user.getName() == null) {
         nullValues.add("name");
      }
      if (user.getSchool() == null) {
         nullValues.add("school");
      }

      if (!nullValues.isEmpty()) {
         throw new UserBuilderException("No values provided for these fields: " + nullValues);
      }
   }
}