package com.tutor.chat;

import com.amazonaws.services.dynamodbv2.datamodeling.*;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.utils.JsonUtils;
import lombok.AllArgsConstructor;
import lombok.Builder;

import java.io.IOException;
import java.util.*;

@AllArgsConstructor
@Builder
@DynamoDBTable(tableName = "chatTable-adam-dev")
public class Chat {
  private UUID id;
  private String tuteeId;
  private String tutorId;

  // list will contain all chat messages between the two users. Index 0 is the oldest message,
  // and index n - 1 is the newest message. The map entries for the list are organized where the key
  // is the user id (either the tutee or tutor), and the value is a string from a pre-set set of
  // chat messages
  private List<Map.Entry<String, String>> messages = new ArrayList<>();
  public static HashSet<String> presetMessages;

  private static final JsonUtils JSON_UTILS = new JsonUtils();
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();

  public Chat() {}

  public Chat(UUID chatId) {
    id = chatId;
  }

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
   * @param userId Id of user who message belongs to
   * @param incomingMessage Message user would like to send
   */
  public void appendMessage(String userId, String incomingMessage) {
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

  @DynamoDBHashKey(attributeName = "chatId")
  public UUID getId() {
    return id;
  }

  public void setId(UUID id) {
    this.id = id;
  }

  @DynamoDBAttribute(attributeName = "tuteeId")
  public String getTuteeId() {
    return tuteeId;
  }

  public void setTuteeId(String tuteeId) {
    this.tuteeId = tuteeId;
  }

  @DynamoDBAttribute(attributeName = "tutorId")
  public String getTutorId() {
    return tutorId;
  }

  public void setTutorId(String tutorId) {
    this.tutorId = tutorId;
  }

  @DynamoDBTypeConverted(converter = MessagesConverter.class)
  @DynamoDBAttribute(attributeName = "messages")
  public List<Map.Entry<String, String>> getMessages() {
    return messages;
  }

  public void setMessages(List<Map.Entry<String, String>> messages) {
    this.messages = messages;
  }

  /** Convert messages list to strings and back when storing in DynamoDB. */
  public static class MessagesConverter
      implements DynamoDBTypeConverter<List<Map<String, String>>, List<Map.Entry<String, String>>> {
    @Override
    public List<Map<String, String>> convert(List<Map.Entry<String, String>> object) {
      List<Map<String, String>> outputList = new ArrayList<>();

      object.forEach(
          x -> {
            HashMap<String, String> outputMap = new HashMap<>();
            outputMap.put(x.getKey(), x.getValue());
            outputList.add(outputMap);
          });

      return outputList;
    }

    @Override
    public List<Map.Entry<String, String>> unconvert(List<Map<String, String>> object) {
      List<Map.Entry<String, String>> outputList = new ArrayList<>();

      object.forEach(
          x -> x.keySet().forEach(y -> outputList.add(new AbstractMap.SimpleEntry<>(y, x.get(y)))));

      return outputList;
    }
  }
}
