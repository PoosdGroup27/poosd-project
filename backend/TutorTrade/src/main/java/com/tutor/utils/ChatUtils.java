package com.tutor.utils;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.tutor.chat.Chat;
import com.tutor.request.Request;

import java.util.List;
import java.util.UUID;

public class ChatUtils {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);

  /**
   * Retrieves a chat object via its associated UUID.
   *
   * @param chatId UUID of chat
   * @return Chat object from DynamoDB if exists, null otherwise
   */
  public static Chat getChatObjectById(String chatId) {
    Chat key = new Chat(UUID.fromString(chatId));
    DynamoDBQueryExpression<Chat> queryExpression =
        new DynamoDBQueryExpression<Chat>().withHashKeyValues(key);

    List<Chat> chats = DYNAMO_DB_MAPPER.query(Chat.class, queryExpression);

    if (chats.size() != 1) {
      return null;
    }

    return chats.get(0);
  }
}
