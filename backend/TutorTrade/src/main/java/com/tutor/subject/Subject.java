package com.tutor.subject;

import com.fasterxml.jackson.annotation.JsonValue;
import java.util.*;

/**
 * Enum of different subjects users can be tutored for. Format of underlying string is "{emoji}
 * {name}"
 * Note: order here does matter, as the matching service will try to match someone with a similar
 * subject tutor if one for their exact subject does not exist. Similarity is determined by order of
 * enum consants.
 */
public enum Subject {
  MATHEMATICS("โ Mathematics"),
  ASTRONOMY("๐ช Astronomy"),
  PHYSICS("โ๏ธ Physics"),
  CS("๐ป Computer Science"),
  IT("๐พ IT"),
  CIVILENG("๐ Civil Engineering"),
  MATERIALS("๐งฑ Materials"),
  CONSTRUCTION("๐ Construction"),
  ARCHITECTURE("๐ Architecture"),
  ENVIRONMENTAL("๐ Environmental Sciences"),
  AGRICULTURE("๐พ Agriculture"),
  BIOLOGY("๐งฌ Biology"),
  BIOMED("โฃ๏ธ Biomedical Sciences"),
  CHEMISTRY("๐งช Chemistry"),
  SPORTS("๐ Sports Science"),
  PHYSIOLOGY("๐ช Physiology"),
  FORENSICS("๐ Forensic Science"),
  NURSING("๐ฉ๐ปโโ๏ธ Nursing"),
  PSYCH("๐ง  Psychology"),
  PHILOSOPHY("๐ค Philosophy"),
  RELIGION("๐ Religion"),
  POLITICS("๐ณ Politics"),
  LAW("๐ Law"),
  HISTORY("๐ฐ History"),
  GEOGRAPHY("๐ Geography"),
  ARCHAEOLOGY("๐ฆ Archaeology"),
  JOURNALISM("โ๏ธ Journalism"),
  LIT("๐ Literature"),
  LANGUAGES("๐ค Languages"),
  ART("๐จ Art"),
  THEATRE("๐ญ Theatre"),
  MUSIC("๐ต Music"),
  EDUCATION("๐ฉโ๐ซ Education"),
  HOSPITALITY("๐จ Hospitality"),
  MARKETING("๐ Marketing"),
  BUSINESS("๐ Business"),
  ACCOUNTING("๐งพ Accounting"),
  FINANCE("๐ต Finance"),
  RETAIL("๐ Retail"),
  HR("๐ Human Resources"),
  GRAPHICS("โฟด Graphic Design"),
  AVIATION("โ๏ธ Aviation");

  private final String subjectName;

  Subject(String subjectName) {
    this.subjectName = subjectName;
  }

  @JsonValue
  public String getSubjectName() {
    return this.subjectName;
  }

  /** Unmodifiable inverse lookup map to find a Subject instance from a subject name. */
  public static final Map<String, Subject> subjectNameMap;

  // Initializes the subject name map at class loading time
  static {
    final Map<String, Subject> tempSubjectNameMap = new HashMap<>();
    Arrays.stream(values()).forEach(value -> tempSubjectNameMap.put(value.subjectName, value));
    subjectNameMap = Collections.unmodifiableMap(tempSubjectNameMap);
  }

  /**
   * Returns a list with all the subject names and emojis.
   *
   * @return List of subjects
   */
  public static List<String> getListOfSubjects() {
    return new ArrayList<>(subjectNameMap.keySet());
  }

  /**
   * Convert a subject name to a Subject instance.
   *
   * @param subjectName The associated subject name of the Subject instance
   * @return The corresponding Subject instance, or null if the subject name does not map to any
   *     Subject instance
   */
  public static Subject fromSubjectName(String subjectName) {
    return subjectNameMap.get(subjectName);
  }
}
