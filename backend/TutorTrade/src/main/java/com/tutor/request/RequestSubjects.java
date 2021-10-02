package com.tutor.request;

public class RequestSubjects {
  public static Subject getType(String subject) {
    Subject requestSubject;
    switch (subject) {
      case "PHYSICS":
        requestSubject = Subject.PHY;
        break;
      case "COMPUTER SCIENCE":
        requestSubject = Subject.CS;
        break;
      case "ENGLISH":
        requestSubject = Subject.LIT;
        break;
      case "BIOLOGY":
        requestSubject = Subject.BIO;
        break;
      case "CHEMISTRY":
        requestSubject = Subject.CHEM;
        break;
      default:
        requestSubject = Subject.UNSUPPORTED;
    }
    return requestSubject;
  }
}
