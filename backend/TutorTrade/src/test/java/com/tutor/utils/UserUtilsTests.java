package com.tutor.utils;

import com.tutor.subject.Subject;
import org.junit.jupiter.api.Test;

import java.util.ArrayList;
import java.util.List;

import static org.junit.jupiter.api.Assertions.*;

public class UserUtilsTests {

  @Test
  public void convertListOfStringsToListOfSubjectsTest() {
    ArrayList<String> subjectNames = new ArrayList<>();
    subjectNames.add("🏛 Architecture");
    subjectNames.add("🏗 Construction");
    subjectNames.add("💻 Computer Science");
    subjectNames.add("⚠️ Doesn't exist");

    List<Subject> subjects = UserUtils.convertListOfStringsToListOfSubjects(subjectNames);

    assertEquals(3, subjects.size());
    assertTrue(subjects.contains(Subject.ARCHITECTURE));
    assertTrue(subjects.contains(Subject.CONSTRUCTION));
    assertTrue(subjects.contains(Subject.CS));
  }
}
