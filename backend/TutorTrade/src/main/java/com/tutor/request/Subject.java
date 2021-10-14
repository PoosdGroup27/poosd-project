package com.tutor.request;

import java.util.Arrays;

/**
 * Enum of different subjects users can be tutored for. Format of underlying string is
 * <name>:<emoji>
 */
public enum Subject {
  BIO("BIOLOGY:🧬"),
  CHEM("CHEMISTRY:🧪"),
  PHY("PHYSICS:🚗"),
  CS("COMPUTER SCIENCE:💻"),
  LIT("LITERATURE:📚"),
  UNSUPPORTED("UNSUPPORTED:🤷");

  private final String subjectName;

  Subject(String subjectName) {
    this.subjectName = subjectName;
  }

  @Override
  public String toString() {
    return this.subjectName;
  }

  public String getEmoji() {
    return toString().split(":")[1];
  }

  public String getSubjectName() {
    return toString().split(":")[0];
  }
}
