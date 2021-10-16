package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.request.Request;
import com.tutor.utils.ApiResponse;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.RequestUtils;
import com.tutor.utils.UserUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class UserHandlerTest {
  private static final AmazonDynamoDB DYNAMO_DB =
      AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
  private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
  private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
  ArrayList<String> createdUsers = new ArrayList<>();
  private static boolean isTest;

  @AfterEach
  void tearDown() {
    for (String userId : createdUsers) {
      ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", userId));
    }
  }

  @Test
  void GIVENvalidUserWHENpostRequestANDgetRequestTHENallFieldsCorrect() throws IOException {
    User user = UserUtils.getUserFromAPIResponse(UserUtils.postRandomUser(isTest = true));

    // get user we just posted
    User userAfterGet =
        UserUtils.getUserFromAPIResponse(
            ApiUtils.get(
                ApiUtils.ApiStages.TEST.toString(),
                String.format("/user/%s", user.getUserId().toString())));

    createdUsers.add(user.getUserId().toString());

    assertEquals(user, userAfterGet);
  }
}
