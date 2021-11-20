package com.tutor.matching;

import com.amazonaws.services.s3.AmazonS3;
import com.amazonaws.services.s3.AmazonS3ClientBuilder;
import com.amazonaws.services.s3.model.S3Object;
import com.amazonaws.services.s3.model.S3ObjectInputStream;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import com.fasterxml.jackson.databind.type.CollectionType;
import com.tutor.request.Request;
import com.tutor.utils.ApiUtils;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Locale;
import java.util.UUID;

public class MatchingUtils {
    private static final String STAGE =
            System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);
    private static final String KNN_BUCKET =
            String.format("request-normalized-data-%s", System.getenv("STAGE"));
    private static final ObjectMapper OBJECT_MAPPER = new ObjectMapper();
    private static final AmazonS3 s3Client = AmazonS3ClientBuilder.defaultClient();
    private static final String KNN_MODEL = MatchingConstants.KNN_MODEL;

    /**
     * Update our s3 request data store with request information once a request has been completed.
     * TODO: This method has side effects and modifying the dynamo table will trigger a new stream.
     * This works for now but is not ideal.
     *
     * @param request The request we're adding to the data store.
     */
    public static void updateRequestDataStore(Request request) {
        List<RequestKnnData> data;
        try {
            data = getRequestDate();
        } catch (IOException e) {
            throw new RuntimeException("Unable to retrieve data.");
        }
        data.add(new RequestKnnData(request));
        try {
            String jsonArray = OBJECT_MAPPER.writeValueAsString(data);
            s3Client.putObject(KNN_BUCKET, KNN_MODEL, jsonArray);
        } catch (JsonProcessingException e) {
            e.printStackTrace();
            throw new RuntimeException("Unable to parse JSON from S3.");
        }
    }

    public static List<RequestKnnData> getRequestDate() throws IOException {
        // get normalized, serialized request data from S3
        List<RequestKnnData> data;
        if (!s3Client.doesObjectExist(KNN_BUCKET, KNN_MODEL)) {
            data = new ArrayList<>();
        } else {
            S3Object object = s3Client.getObject(KNN_BUCKET, KNN_MODEL);
            S3ObjectInputStream input = object.getObjectContent();
                CollectionType requestArray =
                        OBJECT_MAPPER
                                .getTypeFactory()
                                .constructCollectionType(List.class, RequestKnnData.class);
                data = OBJECT_MAPPER.readValue(input, requestArray);
        }
        return data;
    }
}
