package com.tutor.chat;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.kms.model.NotFoundException;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestStreamHandler;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.ChatUtils;
import com.tutor.utils.UserUtils;
import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.util.*;

public class ChatHandler implements RequestStreamHandler {
  private static final Logger LOG = LogManager.getLogger(com.tutor.matches.MatchesHandler.class);
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  private static final String STAGE = System.getenv("STAGE");

  static {
    // Serialization will exclude null fields
    OBJECT_MAPPER.setSerializationInclusion(JsonInclude.Include.NON_NULL);
  }

  @Override
  public void handleRequest(InputStream inputStream, OutputStream outputStream, Context context)
      throws IOException {
    Map<Object, Object> event =
        OBJECT_MAPPER.readValue(inputStream, new TypeReference<Map<Object, Object>>() {});

    HashMap<?, ?> contextMap = (HashMap<?, ?>) event.get("context");
    String httpMethod = (String) contextMap.get("http-method");

    HashMap<?, ?> bodyJson;
    HashMap<?, ?> params;
    HashMap<?, ?> pathParameters;

    // brackets create local scopes for each case
    switch (httpMethod) {
      case "PUT":
        {
          // updating chat with a new message from tutor or tutee

          bodyJson = (HashMap<?, ?>) event.get("body-json");
          params = (HashMap<?, ?>) event.get("params");
          pathParameters = (HashMap<?, ?>) params.get("path");

          String chatIdString = (String) pathParameters.get("chatId");
          String userId = (String) bodyJson.get("userId");
          String message = (String) bodyJson.get("message");

          OBJECT_MAPPER.writeValue(outputStream, updateChat(chatIdString, userId, message));
          return;
        }
      case "GET":
        {
          params = (HashMap<?, ?>) event.get("params");
          pathParameters = (HashMap<?, ?>) params.get("path");

          // preset messages endpoint
          if (pathParameters.isEmpty()) {
            OBJECT_MAPPER.writeValue(
                outputStream,
                ApiResponse.<HashSet<String>>builder()
                    .statusCode(HttpURLConnection.HTTP_OK)
                    .body(Chat.presetMessages)
                    .build());
            return;
          }

          // get chat messages endpoint
          String chatIdString = (String) pathParameters.get("chatId");
          Chat chat = ChatUtils.getChatObjectById(chatIdString);

          if (chat == null) {
            OBJECT_MAPPER.writeValue(
                outputStream,
                ApiUtils.returnErrorResponse(
                    new Exception(String.format("Chat %s does not exist", chatIdString))));
            return;
          }

          OBJECT_MAPPER.writeValue(
              outputStream,
              ApiResponse.<List<Map.Entry<String, String>>>builder()
                  .statusCode(HttpURLConnection.HTTP_OK)
                  .body(chat.getMessages())
                  .build());
          return;
        }
      case "POST":
        {
          // post a new chat object for a given tutor/tutee
          bodyJson = (HashMap<?, ?>) event.get("body-json");

          String tutorId = (String) bodyJson.get("tutorId");
          String tuteeId = (String) bodyJson.get("tuteeId");

          // user validation
          List<String> invalidUsers = new ArrayList<>();
          if (!isValidUser(tuteeId)) {
            invalidUsers.add(tuteeId);
          }
          if (!isValidUser(tutorId)) {
            invalidUsers.add(tutorId);
          }
          if (invalidUsers.size() > 0) {
            OBJECT_MAPPER.writeValue(
                outputStream,
                ApiUtils.returnErrorResponse(
                    new NotFoundException("The following users do not exist: " + invalidUsers)));
            return;
          }

          Chat chat =
              Chat.builder().tutorId(tutorId).tuteeId(tuteeId).id(UUID.randomUUID()).build();

          DYNAMO_DB_MAPPER.save(
              chat,
              DynamoDBMapperConfig.builder()
                  .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
                  .build());

          OBJECT_MAPPER.writeValue(
              outputStream,
              ApiResponse.<Chat>builder().statusCode(HttpURLConnection.HTTP_OK).body(chat).build());

          return;
        }
      default:
        OBJECT_MAPPER.writeValue(
            outputStream,
            ApiUtils.returnErrorResponse(
                new UnsupportedOperationException(
                    String.format("Method %s not supported by chat endpoint", httpMethod))));
    }
  }

  private ApiResponse<?> updateChat(String chatIdString, String userId, String message) {
    Chat chatToUpdate = ChatUtils.getChatObjectById(chatIdString);

    if (chatToUpdate == null) {
      return ApiUtils.returnErrorResponse(
          new Exception(String.format("Chat %s does not exist", chatIdString)));
    }

    try {
      chatToUpdate.appendMessage(userId, message);
    } catch (IllegalArgumentException ex) {
      return ApiUtils.returnErrorResponse(ex);
    }

    DYNAMO_DB_MAPPER.save(
        chatToUpdate,
        DynamoDBMapperConfig.builder()
            .withSaveBehavior(DynamoDBMapperConfig.SaveBehavior.UPDATE_SKIP_NULL_ATTRIBUTES)
            .build());

    return ApiResponse.<Chat>builder()
        .statusCode(HttpURLConnection.HTTP_OK)
        .body(chatToUpdate)
        .build();
  }

  /**
   * Determines whether a user backed by the given id exists or not
   *
   * @param userId string userid
   * @return true if exists, false otherwise
   */
  private boolean isValidUser(String userId) {
    return (UserUtils.getUserObjectById(userId) != null);
  }
}
