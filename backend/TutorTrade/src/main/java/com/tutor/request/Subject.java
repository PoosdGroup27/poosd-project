package com.tutor.request;

import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

/**
 * Enum of different subjects users can be tutored for. Format of underlying string is <emoji>
 * <name>
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
  AVIATION("✈️ Aviation"),
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
   * Returns a list with all the subject names and emojis
   *
   * @return List of subjects
   */
  public static List<String> getListOfSubjects() {
    return Arrays.stream(Subject.values()).map(Subject::toString).collect(Collectors.toList());
  }
}
