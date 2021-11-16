package com.tutor.chat;

import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.utils.JsonUtils;
import lombok.Builder;
import lombok.Data;

import java.io.IOException;
import java.util.*;

@Builder
@Data
public class Chat {
  private UUID id;
  private String tuteeId;
  private String tutorId;

  // list will contain all chat messages between the two users. Index 0 is the oldest message,
  // and index n - 1 is the newest message. The map entries for the list are organized where the key
  // is the user id (either the tutee or tutor), and the value is a string from a pre-set set of
  // chat messages
  private List<Map.Entry<String, String>> messages;
  public static HashSet<String> presetMessages;

  private static final JsonUtils JSON_UTILS = new JsonUtils();
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

  static {
    String filename = "presetMessages.json";
    String jsonKey = "presetMessages";

    try {
      String json = JSON_UTILS.getJsonFromFileAsString(filename);
      Map<String, List<String>> jsonMap =
          OBJECT_MAPPER.readValue(json, new TypeReference<HashMap<String, List<String>>>() {});

      presetMessages = new HashSet<>(jsonMap.get(jsonKey));
    } catch (IOException e) {
      e.printStackTrace();
      System.out.printf("%s is malformed%n", filename);
      throw new RuntimeException(e);
    }
  }

  /**
   * Appends a message to the running list of messages between the tutor and tutee
   *
   * @param userId
   * @param incomingMessage
   */
  private void appendMessage(String userId, String incomingMessage) {
    if (!Chat.presetMessages.contains(incomingMessage)) {
      throw new IllegalArgumentException(
          String.format("Message %s not available for chat.", incomingMessage));
    }

    if (!userId.equals(tuteeId) && !userId.equals(tutorId)) {
      throw new IllegalArgumentException(
          String.format("User %s is not a member of this chat.", userId));
    }

    messages.add(new AbstractMap.SimpleEntry<>(userId, incomingMessage));
  }
}
