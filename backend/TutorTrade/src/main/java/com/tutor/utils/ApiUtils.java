package com.tutor.utils;

import java.io.IOException;
import java.io.UnsupportedEncodingException;
import java.net.HttpURLConnection;
import org.apache.http.HttpEntity;
import org.apache.http.client.methods.CloseableHttpResponse;
import org.apache.http.client.methods.HttpGet;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.StringEntity;
import org.apache.http.impl.client.CloseableHttpClient;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;

/** Utility classes for making GET and POST requests to tutor API. */
public class ApiUtils {
  /** Mapping of stage names to API URIs for easy access. */
  public enum ApiStages {
    JESSE_DEV("https://bpbzrj9x3b.execute-api.us-east-1.amazonaws.com/jesse-dev"),
    ADAM_DEV("https://mlxlapjbhh.execute-api.us-east-1.amazonaws.com/adam-dev"),
    PROD("https://75j9h7est2.execute-api.us-east-1.amazonaws.com/prod"),
    TEST("https://od85mau9h3.execute-api.us-east-1.amazonaws.com/test/"),
    UNSUPPORTED("UNSUPPORTED");

    private final String url;

    ApiStages(String url) {
      this.url = url;
    }

    @Override
    public String toString() {
      return this.url;
    }
  }

  /**
   * Helper method for making GET requests to tutor API.
   *
   * @param apiUri API Uri defined in ApiStages enum -- differs according to the desired stage to
   *     which you'd like to post. The Uri needs to be manually updated in the ApiStages enum if any
   *     stack is redeployed or a new stack is added
   * @param pathToResource Path to desired resource, which is appended to uri. e.g. "/user"
   * @return Stringified response from API or "Encountered error. See stack trace." upon error.
   *     TODO: improve error response mechanism.
   */
  public static String get(String apiUri, String pathToResource) {
    CloseableHttpClient client = HttpClients.createDefault();
    String fullPath = apiUri + pathToResource;
    HttpGet httpGet = new HttpGet(fullPath);
    HttpEntity entity;

    try (CloseableHttpResponse response = client.execute(httpGet)) {
      entity = response.getEntity();
      return EntityUtils.toString(entity);
    } catch (IOException e) {
      e.printStackTrace();
    }
    return "Encountered error. See stack trace.";
  }

  /**
   * Helper method for making POST requests to tutor API.
   *
   * @param apiUri API Uri defined in ApiStages enum -- differs according to the desired stage to
   *     which you'd like to post. The Uri needs to be manually updated in the ApiStages enum if any
   *     stack is redeployed or a new stack is added
   * @param pathToResource Path to desired resource, which is appended to uri. e.g. "/user/create"
   * @param body Body of resource. Must be well-formed json and correct for the fields of the API
   *     you'd like to make a request to. See API documentation: TODO: add link to API documentation
   *     once created in GitHub wiki.
   * @return Stringified response from API or "Encountered error. See stack trace." upon error.
   *     TODO: improve error response mechanism.
   * @throws UnsupportedEncodingException if the body string cannot be properly encoded. This should
   *     not occur if the string is well-formed ascii json.
   */
  public static String post(String apiUri, String pathToResource, String body)
      throws UnsupportedEncodingException {
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

  public static ApiResponse<String> returnErrorResponse(Exception ex) {
    return ApiResponse.<String>builder()
            .statusCode(HttpURLConnection.HTTP_OK)
            .body(ex.toString())
            .build();
  }
}
