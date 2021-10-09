package com.tutor.utils;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBQueryExpression;
import com.tutor.request.Platform;
import com.tutor.request.Request;
import com.tutor.request.Subject;
import com.tutor.request.Urgency;
import com.tutor.utils.ApiUtils;

import java.io.IOException;
import java.net.HttpURLConnection;
import java.util.*;

public class RequestUtils {

    private static final List<Platform> PLATFORMS =
            Collections.unmodifiableList(Arrays.asList(Platform.values()));
    private static final List<Subject> SUBJECTS =
            Collections.unmodifiableList(Arrays.asList(Subject.values()));
    private static final List<Urgency> URGENCIES =
            Collections.unmodifiableList(Arrays.asList(Urgency.values()));
    private static final Random RANDOM = new Random();
    private static final String stage = System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);
    private static final AmazonDynamoDB DYNAMO_DB =
            AmazonDynamoDBClientBuilder.standard().withRegion(Regions.US_EAST_1).build();
    private static final DynamoDBMapper DYNAMO_DB_MAPPER = new DynamoDBMapper(DYNAMO_DB);

    /**
     * Method generates a request with random but valid values and posts it to the /request/create
     * endpoint of whichever stage is defined in environmental variables.
     */
    public static void postRandomRequest() throws IOException {
        String requesterId = UUID.randomUUID().toString();
        String subject = SUBJECTS.get(RANDOM.nextInt(SUBJECTS.size() - 1)).toString();
        int costInPoints = RANDOM.nextInt();
        String urgency = URGENCIES.get(RANDOM.nextInt(URGENCIES.size())).toString();
        String platform = PLATFORMS.get(RANDOM.nextInt(PLATFORMS.size())).toString();
        String status = "PENDING";

        String json = "{"
                + "\"requesterId\" : "
                + "\""
                + requesterId
                + "\""
                + ", \"subject\" : "
                + "\""
                + subject
                + "\""
                + ", \"platform\" : "
                + "\""
                + platform
                + "\""
                + ", \"costInPoints\" : "
                + "\""
                + costInPoints
                + "\""
                + ", \"urgency\" : "
                + "\""
                + urgency
                + "\""
                + ", \"status\" : "
                + "\""
                + status
                + "\""
                + "}";

        System.out.println(ApiUtils.post(ApiUtils.ApiStages.valueOf(stage).toString(), "/request/create", json));
    }

    public static String getRequestById(String requestId) {
        Request key = new Request(UUID.fromString(requestId));
        DynamoDBQueryExpression<Request> queryExpression =
                new DynamoDBQueryExpression<Request>().withHashKeyValues(key);

        List<Request> requestById = DYNAMO_DB_MAPPER.query(Request.class, queryExpression);

        if (requestById.size() == 0) {
            return ApiUtils.getResponseAsString(HttpURLConnection.HTTP_NOT_FOUND, "Request not found.");
        } else if (requestById.size() > 1) {
            return ApiUtils.getResponseAsString(
                    HttpURLConnection.HTTP_CONFLICT,
                    String.format(
                            "Found %d requests with id: %s. 1 expected.", requestById.size(), requestId));
        }

        // found only 1 request with ID, as desired
        return ApiUtils.getResponseAsString(HttpURLConnection.HTTP_OK, requestById.get(0).toString());
    }

    public static Request getRequestObjectById(String requestId) {
        Request key = new Request(UUID.fromString(requestId));
        DynamoDBQueryExpression<Request> queryExpression =
                new DynamoDBQueryExpression<Request>().withHashKeyValues(key);

        List<Request> requestById = DYNAMO_DB_MAPPER.query(Request.class, queryExpression);

        if (requestById.size() != 1) {
            return null;
        }

        return requestById.get(0);
    }

}
