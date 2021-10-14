package com.tutor.request;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;

import java.util.Arrays;
import java.util.stream.*;

/**
 * Enum of different subjects users can be tutored for. Format of underlying string is <emoji>
 * <name>
 */
public enum Subject {
  BIO("🧬 BIOLOGY"),
  CHEM("🧪 CHEMISTRY"),
  PHY("🚗 PHYSICS"),
  CS("💻 COMPUTER SCIENCE"),
  LIT("📚 LITERATURE"),
  UNSUPPORTED("🤷 UNSUPPORTED");

  private final String subjectName;

  Subject(String subjectName) {
    this.subjectName = subjectName;
  }

  @Override
  public String toString() {
    return this.subjectName;
  }

  /**
   * Returns a string of a list with all the subject names and emojis
   * @return
   * @throws JsonProcessingException
   */
  public static String getListOfSubjectsAsString() throws JsonProcessingException {
    ObjectMapper mapper = new ObjectMapper();

    return mapper
        .writerWithDefaultPrettyPrinter()
        .writeValueAsString(
            Arrays.stream(Subject.values())
                .map(val -> val.toString())
                .collect(Collectors.toList()));
  }
}
