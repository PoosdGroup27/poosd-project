package com.tutor.utils;

import com.tutor.request.Platform;
import com.tutor.request.Subject;
import com.tutor.request.Urgency;

import java.io.IOException;
import java.util.*;

/**
 * Used for the creation and POSTing of random requests. Requests are sent to
 * API and request table of whichever stage is defined in environmental
 * variables. e.g. jesse-dev
 */
public class PopulateRequests {
    private static final List<Platform> PLATFORMS =
            Collections.unmodifiableList(Arrays.asList(Platform.values()));
    private static final List<Subject> SUBJECTS =
            Collections.unmodifiableList(Arrays.asList(Subject.values()));
    private static final List<Urgency> URGENCIES =
            Collections.unmodifiableList(Arrays.asList(Urgency.values()));
    private static final Random RANDOM = new Random();
    private static final String stage = System.getenv("STAGE").replace('-', '_').toUpperCase(Locale.ENGLISH);


    private static void postRandomRequest() throws IOException {
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

        System.out.println(ApiUtils.post(ApiStages.valueOf(stage).toString(), "/request/create", json));
    }
}
