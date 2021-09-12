package com.tutor;

import java.io.IOException;
import java.util.Map;

import org.apache.logging.log4j.LogManager;
import org.apache.logging.log4j.Logger;

import com.amazonaws.regions.Regions;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDB;
import com.amazonaws.services.dynamodbv2.AmazonDynamoDBClientBuilder;
import com.amazonaws.services.dynamodbv2.datamodeling.DynamoDBMapper;
import com.amazonaws.services.lambda.runtime.Context;
import com.amazonaws.services.lambda.runtime.RequestHandler;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;

public class UserHandler implements RequestHandler<Map<String, Object>, ApiGatewayResponse> {

	private static final Logger LOG = LogManager.getLogger(UserHandler.class);
	private static final AmazonDynamoDB DYNAMO_DB = AmazonDynamoDBClientBuilder.standard()
			.withRegion(Regions.US_EAST_1)
			.build();
	private static final DynamoDBMapper MAPPER = new DynamoDBMapper(DYNAMO_DB);
	private static final String USER_TABLE_NAME = System.getenv("USER_TABLE_NAME");

	public static String getUserTableName() {
		return USER_TABLE_NAME;
	}

	@Override
	public ApiGatewayResponse handleRequest(Map<String, Object> input, Context context) {
		System.out.println(context);
		
		JsonNode body;
		
		try {
			body = new ObjectMapper().readTree((String) input.get("body"));
		} catch (IOException ex) {
			return ApiGatewayResponse.builder()
						.setStatusCode(400)
						.setObjectBody(new Response("Request does not contain a body for creating a user.", input))
						.build();
		}
		
		String name = body.get("name").textValue();
		String school = body.get("school").textValue();

		User user = new UserBuilder()
							.withName(name)
							.withSchool(school)
							.build();
		
		MAPPER.save(user);

		return ApiGatewayResponse.builder()
					.setStatusCode(200)
					.setObjectBody(user)
					.build();
	}
}