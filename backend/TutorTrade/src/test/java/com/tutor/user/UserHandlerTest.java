package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.JsonUtils;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeAll;
import org.junit.jupiter.api.BeforeEach;

import java.io.IOException;
import java.util.ArrayList;
import java.util.UUID;

public class UserHandlerTest {
    private static final AmazonDynamoDB DYNAMO_DB =
            AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
    private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);
    private static final DynamoDBMapperConfig DYNAMO_DB_MAPPER_CONFIG =
            new DynamoDBMapperConfig.Builder()
                    .withTableNameOverride(
                            DynamoDBMapperConfig.TableNameOverride.withTableNameReplacement("userTable-test"))
                    .build();
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final JsonUtils JSON_UTILS = new JsonUtils();
    ArrayList<String> createdUsers = new ArrayList<>();
    private static final String TEST_USER_ID = UUID.randomUUID().toString();

    @BeforeAll
    static void beforeAll() throws IOException {
        String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
        ApiUtils.put(ApiUtils.ApiStages.TEST.toString(), "/user/" + TEST_USER_ID, userBody);
    }

    @AfterAll
    static void afterAll() {
        ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), "user/" + TEST_USER_ID);
    }

    @BeforeEach
    void setUp() {}

    @AfterEach
    void tearDown() {
        for (String requestId : createdUsers) {
            ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", requestId));
        }
    }
}
