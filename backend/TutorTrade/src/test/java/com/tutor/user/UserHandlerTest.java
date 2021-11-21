package com.tutor.user;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapperConfig;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.fasterxml.jackson.core.type.TypeReference;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.tutor.subject.Subject;
import com.tutor.utils.ApiUtils;
import com.tutor.utils.JsonUtils;
import com.tutor.utils.UserUtils;
import org.junit.jupiter.api.AfterAll;
import org.junit.jupiter.api.Test;

import java.io.IOException;
import java.time.LocalDateTime;
import java.util.*;
import java.util.stream.Collectors;

import static org.junit.jupiter.api.Assertions.*;

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
  static ArrayList<String> createdUsers = new ArrayList<>();

  private static Map<String, Object> getTestUserFromFile(String userBody) throws IOException {
    return OBJECT_MAPPER.readValue(userBody, new TypeReference<HashMap<String, Object>>() {});
  }

  @AfterAll
  static void afterAll() {
    for (String userId : createdUsers) {
      // sets user to inactive
      ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", userId));
    }
  }

  @Test
  void postUserGivenValidFields() throws IOException {
    // GIVEN: valid user fields
    String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
    Map<String, Object> userBodyFields = getTestUserFromFile(userBody);

    // WHEN: post user to user API
    String userPostResponseString =
        ApiUtils.put(
            ApiUtils.ApiStages.TEST.toString(),
            String.format("/user/%s", userBodyFields.get("name")),
            OBJECT_MAPPER.writeValueAsString(userBodyFields));

    // THEN: request response is not null
    assertNotNull(userPostResponseString);

    // THEN: user response is a valid user object
    User user = UserUtils.getUserFromAPIResponse(userPostResponseString);
    assertNotNull(user);

    // THEN: fields of request object match those from validPostRequest.json
    assertEquals(user.getSchool(), userBodyFields.get("school"));
    assertEquals(user.getName(), userBodyFields.get("name"));
    assertTrue(user.getIsActive()); // should be true on user creation
    assertEquals(user.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
        user.getSubjectsLearn().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
        userBodyFields.get("subjectsLearn"));
    assertEquals(
        user.getSubjectsTeach().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
        userBodyFields.get("subjectsTeach"));
    assertEquals(user.getMajor(), userBodyFields.get("major"));

    // WHEN: query Dynamo db directly
    User key = new User(user.getUserId());
    DynamoDBQueryExpression<User> queryExpression =
        new DynamoDBQueryExpression<User>().withHashKeyValues(key);

    List<User> userById =
        DYNAMO_DB_MAPPER.query(User.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, userById.size());
    User userInDB = userById.get(0);

    assertEquals(userInDB.getSchool(), userBodyFields.get("school"));
    assertEquals(userInDB.getName(), userBodyFields.get("name"));
    assertTrue(userInDB.getIsActive()); // should be true on user creation
    assertEquals(userInDB.getPoints(), 100); // user given 100 points to begin with
    assertEquals(userInDB.getSessionIds(), new ArrayList<>()); // should be empty on initialization
    assertEquals(
        userInDB.getUserId(),
        userBodyFields.get(
            "name")); // we just let the userId be the user's name -- must not contain spacing
    assertEquals(userInDB.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
        userInDB.getSubjectsLearn().stream()
            .map(Subject::getSubjectName)
            .collect(Collectors.toList()),
        userBodyFields.get("subjectsLearn"));
    assertEquals(
        userInDB.getSubjectsTeach().stream()
            .map(Subject::getSubjectName)
            .collect(Collectors.toList()),
        userBodyFields.get("subjectsTeach"));
    assertEquals(userInDB.getCumulativeSessionsCompleted(), 0); // should be zero on initialization
    assertEquals(userInDB.getRating(), 5); // start out with a 5-star rating
    assertEquals(userInDB.getMajor(), userBodyFields.get("major"));
    assertEquals(
        userInDB.getReviewEvaluations(), new ArrayList<>()); // empty array list to start out

    // cleanup
    createdUsers.add(user.getUserId());
  }

  @Test
  void postUserGivenValidRandomFields() throws IOException {
    // GIVEN: valid random user fields
    Map<String, Object> userBodyFields = createRandomRequestPostBody();

    // WHEN: post user to user API
    String userPostResponseString =
        ApiUtils.put(
            ApiUtils.ApiStages.TEST.toString(),
            String.format("/user/%s", userBodyFields.get("name")),
            OBJECT_MAPPER.writeValueAsString(userBodyFields));

    // THEN: request response is not null
    assertNotNull(userPostResponseString);

    // THEN: user response is a valid user object
    User user = UserUtils.getUserFromAPIResponse(userPostResponseString);
    assertNotNull(user);

    // THEN: fields of request object match those from validPostRequest.json
    assertEquals(user.getSchool(), userBodyFields.get("school"));
    assertEquals(user.getName(), userBodyFields.get("name"));
    assertTrue(user.getIsActive()); // should be true on user creation
    assertEquals(user.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
        user.getSubjectsLearn().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
        userBodyFields.get("subjectsLearn"));
    assertEquals(
        user.getSubjectsTeach().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
        userBodyFields.get("subjectsTeach"));
    assertEquals(user.getMajor(), userBodyFields.get("major"));

    // WHEN: query Dynamo db directly
    User key = new User(user.getUserId());
    DynamoDBQueryExpression<User> queryExpression =
        new DynamoDBQueryExpression<User>().withHashKeyValues(key);

    List<User> userById =
        DYNAMO_DB_MAPPER.query(User.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, userById.size());
    User userInDB = userById.get(0);

    assertEquals(userInDB.getSchool(), userBodyFields.get("school"));
    assertEquals(userInDB.getName(), userBodyFields.get("name"));
    assertTrue(userInDB.getIsActive()); // should be true on user creation
    assertEquals(userInDB.getPoints(), 100); // user given 100 points to begin with
    assertEquals(userInDB.getSessionIds(), new ArrayList<>()); // should be empty on initialization
    assertEquals(
        userInDB.getUserId(),
        userBodyFields.get(
            "name")); // we just let the userId be the user's name -- must not contain spacing
    assertEquals(userInDB.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
        userInDB.getSubjectsLearn().stream()
            .map(Subject::getSubjectName)
            .collect(Collectors.toList()),
        userBodyFields.get("subjectsLearn"));
    assertEquals(
        userInDB.getSubjectsTeach().stream()
            .map(Subject::getSubjectName)
            .collect(Collectors.toList()),
        userBodyFields.get("subjectsTeach"));
    assertEquals(userInDB.getCumulativeSessionsCompleted(), 0); // should be zero on initialization
    assertEquals(userInDB.getRating(), 5); // start out with a 5-star rating
    assertEquals(userInDB.getMajor(), userBodyFields.get("major"));
    assertEquals(
        userInDB.getReviewEvaluations(), new ArrayList<>()); // empty array list to start out

    // cleanup
    createdUsers.add(user.getUserId());
  }

  @Test
  void patchTestGivenValidUserChange() throws IOException {
    // GIVEN valid user body
    String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
    Map<String, Object> userBodyFields = getTestUserFromFile(userBody);

    User user =
        new UserBuilder()
            .withId((String) userBodyFields.get("name"))
            .withName((String) userBodyFields.get("name"))
            .withSchool((String) userBodyFields.get("school"))
            .withPhoneNumber((String) userBodyFields.get("phoneNumber"))
            .withMajor((String) userBodyFields.get("major"))
            .withSubjectsTeach(
                convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsTeach")))
            .withSubjectsLearn(
                convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsLearn")))
            .build();
    DYNAMO_DB_MAPPER.save(user, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: query dynamodb directly so as not to rely on correctness of GET method
    User key = new User(user.getUserId());
    DynamoDBQueryExpression<User> queryExpression =
            new DynamoDBQueryExpression<User>().withHashKeyValues(key);
    List<User> userById =
            DYNAMO_DB_MAPPER.query(User.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, userById.size());
    User userInDB = userById.get(0);

    // THEN: all fields correct
    assertEquals(userInDB.getSchool(), userBodyFields.get("school"));
    assertEquals(userInDB.getName(), userBodyFields.get("name"));
    assertTrue(userInDB.getIsActive()); // should be true on user creation
    assertEquals(userInDB.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
            userInDB.getSubjectsLearn().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
            userBodyFields.get("subjectsLearn"));
    assertEquals(
            userInDB.getSubjectsTeach().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
            userBodyFields.get("subjectsTeach"));
    assertEquals(userInDB.getMajor(), userBodyFields.get("major"));

    // WHEN: patch request
    ArrayList<Subject> newSubjectsTeach = new ArrayList<>();
    newSubjectsTeach.add(Subject.ARCHITECTURE);
    newSubjectsTeach.add(Subject.FINANCE);
    ArrayList<Subject> newSubjectsLearn = new ArrayList<>();
    newSubjectsTeach.add(Subject.CONSTRUCTION);
    newSubjectsTeach.add(Subject.BIOMED);

    Map<String, Object> changes = new HashMap<>();
    changes.put("subjectsTeach", newSubjectsTeach);
    changes.put("subjectsLearn", newSubjectsLearn);
    changes.put("name", "PoosdGroup27");

    String body = OBJECT_MAPPER.writeValueAsString(changes);
    String response = ApiUtils.patch(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", user.getUserId()), body);

    // THEN: response is not null
    assertNotNull(response);

    User key2 = new User(user.getUserId());
    DynamoDBQueryExpression<User> queryExpression2 =
            new DynamoDBQueryExpression<User>().withHashKeyValues(key2);
    List<User> userById2 =
            DYNAMO_DB_MAPPER.query(User.class, queryExpression2, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, userById2.size());
    User userInDB2 = userById2.get(0);

    assertEquals(userInDB2.getSchool(), userBodyFields.get("school"));
    assertEquals(userInDB2.getName(), changes.get("name"));
    assertTrue(userInDB2.getIsActive()); // should be true on user creation
    assertEquals(userInDB2.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
            userInDB2.getSubjectsLearn(),
            changes.get("subjectsLearn"));
    assertEquals(
            userInDB2.getSubjectsTeach(),
            changes.get("subjectsTeach"));
    assertEquals(userInDB2.getMajor(), userBodyFields.get("major"));

    // cleanup
    createdUsers.add(user.getUserId());
  }

  @Test
  void patchTestGivenValidRandomUserChange() throws IOException {
    // GIVEN valid user body
    String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
    Map<String, Object> userBodyFields = getTestUserFromFile(userBody);

    User user =
            new UserBuilder()
                    .withId((String) userBodyFields.get("name"))
                    .withName((String) userBodyFields.get("name"))
                    .withSchool((String) userBodyFields.get("school"))
                    .withPhoneNumber((String) userBodyFields.get("phoneNumber"))
                    .withMajor((String) userBodyFields.get("major"))
                    .withSubjectsTeach(
                            convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsTeach")))
                    .withSubjectsLearn(
                            convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsLearn")))
                    .build();
    DYNAMO_DB_MAPPER.save(user, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: query dynamodb directly so as not to rely on correctness of GET method
    User key = new User(user.getUserId());
    DynamoDBQueryExpression<User> queryExpression =
            new DynamoDBQueryExpression<User>().withHashKeyValues(key);
    List<User> userById =
            DYNAMO_DB_MAPPER.query(User.class, queryExpression, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, userById.size());
    User userInDB = userById.get(0);

    // THEN: all fields correct
    assertEquals(userInDB.getSchool(), userBodyFields.get("school"));
    assertEquals(userInDB.getName(), userBodyFields.get("name"));
    assertTrue(userInDB.getIsActive()); // should be true on user creation
    assertEquals(userInDB.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
            userInDB.getSubjectsLearn().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
            userBodyFields.get("subjectsLearn"));
    assertEquals(
            userInDB.getSubjectsTeach().stream().map(Subject::getSubjectName).collect(Collectors.toList()),
            userBodyFields.get("subjectsTeach"));
    assertEquals(userInDB.getMajor(), userBodyFields.get("major"));

    // WHEN: patch request
    Random random = new Random();

    ArrayList<Subject> newSubjectsTeach = new ArrayList<>();
    newSubjectsTeach.add(Subject.values()[random.nextInt(Subject.values().length)]);
    newSubjectsTeach.add(Subject.values()[random.nextInt(Subject.values().length)]);

    ArrayList<Subject> newSubjectsLearn = new ArrayList<>();
    newSubjectsLearn.add(Subject.values()[random.nextInt(Subject.values().length)]);
    newSubjectsLearn.add(Subject.values()[random.nextInt(Subject.values().length)]);

    Map<String, Object> changes = new HashMap<>();
    changes.put("subjectsTeach", newSubjectsTeach);
    changes.put("subjectsLearn", newSubjectsLearn);
    changes.put("name", "TestName" + Math.abs(random.nextInt()));

    String body = OBJECT_MAPPER.writeValueAsString(changes);
    String response = ApiUtils.patch(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", user.getUserId()), body);

    // THEN: response is not null
    assertNotNull(response);

    User key2 = new User(user.getUserId());
    DynamoDBQueryExpression<User> queryExpression2 =
            new DynamoDBQueryExpression<User>().withHashKeyValues(key2);
    List<User> userById2 =
            DYNAMO_DB_MAPPER.query(User.class, queryExpression2, DYNAMO_DB_MAPPER_CONFIG);
    assertEquals(1, userById2.size());
    User userInDB2 = userById2.get(0);

    assertEquals(userInDB2.getSchool(), userBodyFields.get("school"));
    assertEquals(userInDB2.getName(), changes.get("name"));
    assertTrue(userInDB2.getIsActive()); // should be true on user creation
    assertEquals(userInDB2.getPhoneNumber(), userBodyFields.get("phoneNumber"));
    assertEquals(
            userInDB2.getSubjectsLearn(),
            changes.get("subjectsLearn"));
    assertEquals(
            userInDB2.getSubjectsTeach(),
            changes.get("subjectsTeach"));
    assertEquals(userInDB2.getMajor(), userBodyFields.get("major"));

    // cleanup
    createdUsers.add(user.getUserId());
  }

  @Test
  void deleteTestGivenValidUser() throws IOException {
    // GIVEN valid user body
    String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
    Map<String, Object> userBodyFields = getTestUserFromFile(userBody);

    User user =
            new UserBuilder()
                    .withId((String) userBodyFields.get("name"))
                    .withName((String) userBodyFields.get("name"))
                    .withSchool((String) userBodyFields.get("school"))
                    .withPhoneNumber((String) userBodyFields.get("phoneNumber"))
                    .withMajor((String) userBodyFields.get("major"))
                    .withSubjectsTeach(
                            convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsTeach")))
                    .withSubjectsLearn(
                            convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsLearn")))
                    .build();
    DYNAMO_DB_MAPPER.save(user, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: delete request
    String response = ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", user.getUserId()));

    // THEN: response is non null
    assertNotNull(response);

    // THEN: upon deletion, user isActive simply set to false
    User userFromGet = UserUtils.getUserFromAPIResponse(response);
    assertEquals(userFromGet.getIsActive(), false);
  }

  @Test
  void deleteTestGivenValidRandomUser() throws IOException {
    // GIVEN valid user body
    Map<String, Object> userBody = createRandomRequestPostBody();
    User user = OBJECT_MAPPER.convertValue(userBody, User.class);

    // need to set these two fields if not creating via UserBuilder
    user.setUserId(user.getName());
    user.setDateCreated(LocalDateTime.now());


    DYNAMO_DB_MAPPER.save(user, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: delete request
    String response = ApiUtils.delete(ApiUtils.ApiStages.TEST.toString(), String.format("/user/%s", user.getUserId()));

    // THEN: response is non null
    assertNotNull(response);

    // THEN: upon deletion, user isActive simply set to false
    User userFromGet = UserUtils.getUserFromAPIResponse(response);
    assertEquals(userFromGet.getIsActive(), false);
  }

  @Test
  void getTestGivenValidUser() throws IOException {
    // GIVEN valid user body
    String userBody = JSON_UTILS.getJsonFromFileAsString("validUserToPost.json");
    Map<String, Object> userBodyFields = getTestUserFromFile(userBody);

    User user =
            new UserBuilder()
                    .withId((String) userBodyFields.get("name"))
                    .withName((String) userBodyFields.get("name"))
                    .withSchool((String) userBodyFields.get("school"))
                    .withPhoneNumber((String) userBodyFields.get("phoneNumber"))
                    .withMajor((String) userBodyFields.get("major"))
                    .withSubjectsTeach(
                            convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsTeach")))
                    .withSubjectsLearn(
                            convertObjectSubjectListToSubjectList(userBodyFields.get("subjectsLearn")))
                    .build();
    DYNAMO_DB_MAPPER.save(user, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: get request
    String response =
            ApiUtils.get(
                    ApiUtils.ApiStages.TEST.toString(),
                    String.format("/user/%s", user.getUserId()));

    // THEN: response is not null
    assertNotNull(response);

    // THEN: object we receive is identical to one we put
    User userFromGet = UserUtils.getUserFromAPIResponse(response);
    assertEquals(userFromGet, user);
  }

  @Test
  void getTestGivenValidRandomUser() throws IOException {
    // GIVEN valid user body
    Map<String, Object> userBody = createRandomRequestPostBody();
    User user = OBJECT_MAPPER.convertValue(userBody, User.class);
    user.setUserId(user.getName());
    user.setDateCreated(LocalDateTime.now());

    DYNAMO_DB_MAPPER.save(user, DYNAMO_DB_MAPPER_CONFIG);

    // WHEN: get request
    String response =
            ApiUtils.get(
                    ApiUtils.ApiStages.TEST.toString(),
                    String.format("/user/%s", user.getUserId()));

    // THEN: response is not null
    assertNotNull(response);

    // THEN: object we receive is identical to one we put
    User userFromGet = UserUtils.getUserFromAPIResponse(response);
    assertEquals(userFromGet, user);
  }

  private static Map<String, Object> createRandomRequestPostBody() {
    Random random = new Random();

    Map<String, Object> userBodyFields = new HashMap<>();
    userBodyFields.put("name", UUID.randomUUID().toString());
    userBodyFields.put("school", "TestSchool" + random.nextInt());
    userBodyFields.put("phoneNumber", "555-555-5555");
    userBodyFields.put("major", "TestMajor" + random.nextInt());
    userBodyFields.put(
        "subjectsLearn",
        List.of(Subject.values()[random.nextInt(Subject.values().length)].getSubjectName()));
    userBodyFields.put(
        "subjectsTeach",
        List.of(Subject.values()[random.nextInt(Subject.values().length)].getSubjectName()));

    return userBodyFields;
  }

  private static ArrayList<Subject> convertObjectSubjectListToSubjectList(Object o) {
    ArrayList<String> subjectStringList = (ArrayList<String>) o;
    return (ArrayList<Subject>)
        subjectStringList.stream()
            .map(x -> Subject.fromSubjectName(x))
            .collect(Collectors.toList());
  }
}
