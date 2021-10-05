package com.tutor;

import org.apache.http.HttpEntity;
import org.apache.http.client.ClientProtocolException;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.protocol.HTTP;
import org.apache.http.util.EntityUtils;

import java.io.IOException;

public class ApiUtils {
    public static String get(String apiUri, String pathToResource) throws IOException {
        CloseableHttpClient client = HttpClients.createDefault();
        String fullPath = apiUri + pathToResource;
        HttpGet httpGet = new HttpGet(fullPath);
        HttpEntity entity;

        try (CloseableHttpResponse response = client.execute(httpGet)) {
            entity = response.getEntity();
        }
        return EntityUtils.toString(entity);
    }

    public static String post(String apiUri, String pathToResource, String body) throws IOException {
        CloseableHttpClient client = HttpClients.createDefault();
        String fullPath = apiUri + pathToResource;
        HttpPost httpPost = new HttpPost(fullPath);
        httpPost.setEntity(new StringEntity(body));
        httpPost.setHeader("Accept", "application/json");
        httpPost.setHeader("Content-type", "application/json");
        HttpEntity entity;

        try (CloseableHttpResponse response = client.execute(httpPost)) {
            entity = response.getEntity();
            return EntityUtils.toString(entity);
        } catch (IOException e) {
            e.printStackTrace();
        }
        return "Encountered error. See stack trace.";
    }
}
