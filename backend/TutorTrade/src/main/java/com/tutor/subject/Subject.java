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
  AGRICULTURE("🌾 Agriculture"),
  ASTRONOMY("🪐 Astronomy"),
  CHEMISTRY("🧪 Chemistry"),
  GEOGRAPHY("📍 Geography"),
  BIOLOGY("🧬 Biology"),
  FORENSICS("🔎 Forensic Science"),
  MATERIALS("🧱 Materials"),
  PHYSICS("⚛️ Physics"),
  BIOMED("☣️ Biomedical Sciences"),
  ENVIRONMENTAL("🌍 Environmental Sciences"),
  SPORTS("🏈 Sports Science"),
  MATHEMATICS("➗ Mathematics"),
  ARCHITECTURE("🏛 Architecture"),
  CONSTRUCTION("🏗 Construction"),
  ACCOUNTING("🧾 Accounting"),
  BUSINESS("📊 Business"),
  FINANCE("💵 Finance"),
  MARKETING("📈 Marketing"),
  RETAIL("🛍 Retail"),
  HR("🙋 Human Resources"),
  CS("💻 Computer Science"),
  IT("💾 IT"),
  ART("🎨 Art"),
  MUSIC("🎵 Music"),
  GRAPHICS("⿴ Graphic Design"),
  THEATRE("🎭 Theatre"),
  EDUCATION("👩‍🏫 Education"),
  CIVILENG("🚉 Civil Engineering"),
  PSYCH("🧠 Psychology"),
  NURSING("👩🏻‍⚕️ Nursing"),
  PHYSIOLOGY("💪 Physiology"),
  PHILOSOPHY("🤔 Philosophy"),
  LANGUAGES("🔤 Languages"),
  ARCHAEOLOGY("🦖 Archaeology"),
  LIT("📚 Literature"),
  HISTORY("🕰 History"),
  RELIGION("🙏 Religion"),
  LAW("📖 Law"),
  JOURNALISM("✍️ Journalism"),
  POLITICS("🗳 Politics"),
  HOSPITALITY("🏨 Hospitality"),
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
