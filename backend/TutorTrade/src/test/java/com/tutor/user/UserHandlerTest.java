package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.request.Request;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.JsonUtils;
import com.tutor.utils.RequestUtils;
import com.tutor.utils.UserUtils;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

import static org.junit.jupiter.api.Assertions.assertEquals;
import static org.junit.jupiter.api.Assertions.assertNotNull;

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

    private static Map<String, String> getTestUserFromFile(String userBody) throws IOException {
        return OBJECT_MAPPER.readValue(userBody, new TypeReference<HashMap<String, String>>() {});
    }

    @Test
    void postUserGivenValidFields() throws IOException {
        // GIVEN: valid user fields
        String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
        Map<String, String> userBodyFields = getTestUserFromFile(userBody);

        // WHEN: post user to user API
        String userPostResponseString = ApiUtils.post(ApiUtils.ApiStages.TEST.toString(), "/user", OBJECT_MAPPER.writeValueAsString(userBodyFields));

        // THEN: request response is not null
        assertNotNull(userPostResponseString);

        // THEN: user response is a valid user object
        User user = UserUtils.getUserFromAPIResponse(userPostResponseString);
        assertNotNull(user);

        // THEN: fields of request object match those from validPostRequest.json

        assertEquals(user.getSchool(), userBodyFields.get("school"));
        assertEquals(user.getName(), userBodyFields.get("name"));

        assertEquals(user.getIsActive(), Boolean.valueOf(userBodyFields.get("isActive")));
        assertEquals(user.getPoints(), Integer.parseInt(userBodyFields.get("points")));
        assertEquals(user.getSessionIds(), userBodyFields.get("sessionIds"));
        assertEquals(user.getUserId(), userBodyFields.get("userId"));
        assertEquals(user.getPhoneNumber(), userBodyFields.get("phoneNumber"));
        assertEquals(user.getSubjectsLearn(), userBodyFields.get("subjectsLearn"));
        assertEquals(user.getSubjectsTeach(), userBodyFields.get("subjectsTeach"));
        assertEquals(user.getCumulativeSessionsCompleted(), userBodyFields.get("cumulativeSessionsCompleted"));
        assertEquals(user.getRating(), userBodyFields.get("rating"));
        assertEquals(user.getMajor(), userBodyFields.get("major"));
        assertEquals(user.getReviewEvaluations(), userBodyFields.get("reviewEvaluations"));


    }
}
