package com.tutor.subject;

import com.fasterxml.jackson.annotation.JsonValue;
import java.util.*;

/**
 * Enum of different subjects users can be tutored for. Format of underlying string is "{emoji}
 * {name}"
 */
public enum Subject {
  MATHEMATICS("➗ Mathematics"),
  ASTRONOMY("🪐 Astronomy"),
  PHYSICS("⚛️ Physics"),
  CS("💻 Computer Science"),
  IT("💾 IT"),
  CIVILENG("🚉 Civil Engineering"),
  MATERIALS("🧱 Materials"),
  CONSTRUCTION("🏗 Construction"),
  ARCHITECTURE("🏛 Architecture"),
  ENVIRONMENTAL("🌍 Environmental Sciences"),
  AGRICULTURE("🌾 Agriculture"),
  BIOLOGY("🧬 Biology"),
  BIOMED("☣️ Biomedical Sciences"),
  CHEMISTRY("🧪 Chemistry"),
  SPORTS("🏈 Sports Science"),
  PHYSIOLOGY("💪 Physiology"),
  FORENSICS("🔎 Forensic Science"),
  NURSING("👩🏻‍⚕️ Nursing"),
  PSYCH("🧠 Psychology"),
  PHILOSOPHY("🤔 Philosophy"),
  RELIGION("🙏 Religion"),
  POLITICS("🗳 Politics"),
  LAW("📖 Law"),
  HISTORY("🕰 History"),
  GEOGRAPHY("📍 Geography"),
  ARCHAEOLOGY("🦖 Archaeology"),
  JOURNALISM("✍️ Journalism"),
  LIT("📚 Literature"),
  LANGUAGES("🔤 Languages"),
  ART("🎨 Art"),
  THEATRE("🎭 Theatre"),
  MUSIC("🎵 Music"),
  EDUCATION("👩‍🏫 Education"),
  HOSPITALITY("🏨 Hospitality"),
  MARKETING("📈 Marketing"),
  BUSINESS("📊 Business"),
  ACCOUNTING("🧾 Accounting"),
  FINANCE("💵 Finance"),
  RETAIL("🛍 Retail"),
  HR("🙋 Human Resources"),
  GRAPHICS("⿴ Graphic Design"),
  AVIATION("✈️ Aviation");

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
