package com.tutor.request;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import java.util.Arrays;
import java.util.stream.Collectors;

/**
 * Enum of different subjects users can be tutored for. Format of underlying string is "{emoji}
 * {name}"
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
   * Returns a string of a list with all the subject names and emojis.
   *
   * @return String representation of all available subjects in list form.
   * @throws JsonProcessingException if ObjectMapper is unable to parse list. This should not occur
   *     and would indicate an issue with the subject constant names.
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
