package com.tutor;

public class UserBuilderException extends RuntimeException {
   /**
    * Problems with building a User object
    * @param errorMessage Failed validation report
    */
   public UserBuilderException(String errorMessage) {
      super(errorMessage);
  }
}
