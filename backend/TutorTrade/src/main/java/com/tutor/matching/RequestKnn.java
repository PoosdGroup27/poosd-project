package com.tutor.matching;

import com.tutor.request.Request;
import java.util.*;

/**
 * RequestKnn retrieves the data store containing all completed request objects from s3, compares
 * each point to a new request which we'd like to match, and returns the k tutors who fulfilled the
 * requests most similar to the to-be-matched request.
 */
public class RequestKnn {
  private final List<RequestKnnData> normalizedData;
  private final Request newRequest;
  private final Map<String, Double> distances = new HashMap<>();

  public RequestKnn(List<RequestKnnData> data, Request newRequest) {
    this.normalizedData = data;
    this.newRequest = newRequest;
  }

  /**
   * Implementation of the k nearest neighbors algorithm on tutor request data.
   *
   * @param k The number of matches to return
   * @return A list of the k tutors who completed requests most similar to the request we're
   *     matching
   */
  public ArrayList<String> getNearestNeighbors(int k) {
    RequestKnnData newRequest = new RequestKnnData(this.newRequest);
    for (RequestKnnData dataPoint : this.normalizedData) {
      String helperId = dataPoint.getHelperId();
      distances.put(helperId, getScaledEuclideanDistance(dataPoint, newRequest));
    }

    List<Map.Entry<String, Double>> distancesToNewRequest = new LinkedList<>(distances.entrySet());
    distancesToNewRequest.sort(Map.Entry.comparingByValue());

    ArrayList<String> results = new ArrayList<>();
    for (int i = 0; i < k && i < normalizedData.size(); i++) {
      results.add(distancesToNewRequest.get(i).getKey());
    }
    return results;
  }

  /**
   * Method calculates distance between two request points and scales the values so that subjects
   * are the most important factor of a request followed by platform and then points.
   */
  private double getScaledEuclideanDistance(
      RequestKnnData requestDataStorePoint, RequestKnnData newRequestData) {
    double sumOfSquaredDifference = 0.0;
    sumOfSquaredDifference += requestDataStorePoint.getCost() / 10 - newRequestData.getCost() / 10;
    sumOfSquaredDifference +=
        requestDataStorePoint.getPlatform() * 100 - newRequestData.getPlatform() + 100;
    sumOfSquaredDifference +=
        requestDataStorePoint.getSubject() * 1000 - newRequestData.getSubject() * 1000;
    return Math.sqrt(sumOfSquaredDifference);
  }
}
