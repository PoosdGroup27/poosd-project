package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.UserUtils;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.ArrayList;

import static org.junit.jupiter.api.Assertions.*;

class UserHandlerTest {
  ArrayList<String> createdUsers = new ArrayList<>();

  @AfterEach
  void tearDown() {
    for (String userId : createdUsers) {
      ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", userId));
    }
  }

  @Test
  void GIVENvalidUserWHENpostRequestANDgetRequestTHENallFieldsCorrect() throws IOException {
    boolean isTest;
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
