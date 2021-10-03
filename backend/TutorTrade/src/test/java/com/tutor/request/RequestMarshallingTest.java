package com.tutor.request;

import com.fasterxml.jackson.databind.ObjectMapper;

import java.io.IOException;
import java.util.UUID;

public class RequestMarshallingTest {
    public static void main(String [] args) throws RequestBuilderException, IOException {
    Request request =
        new RequestBuilder()
            .withCost(100)
            .withRequesterId(UUID.randomUUID().toString())
            .withHelperId(UUID.randomUUID().toString())
            .withPlatform(Platform.IN_PERSON)
            .withStatus("PENDING")
            .withSessionTime("8/10/2021 10:00")
            .withUrgency("IMMEDIATE")
            .withSubject("CS")
            .build();

        ObjectMapper mapper = new ObjectMapper();
        Request newRequest = mapper.readValue(request.toString(), Request.class);

        System.out.println(request.toString().equals(newRequest.toString()));
    }
}
