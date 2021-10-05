package com.tutor.matching;

import com.tutor.request.Request;

import java.util.*;

public class RequestKnn {
  private final List<RequestKnnDataNormalized> normalizedData;
  private final Request newRequest;
  private HashMap<UUID, Double> distances;

  public RequestKnn(List<RequestKnnDataNormalized> data, Request newRequest) {
    this.normalizedData = data;
    this.newRequest = newRequest;
  }

  public ArrayList<UUID> getNearestNeighbors(int k) {
    RequestKnnDataNormalized newRequest = new RequestKnnDataNormalized(this.newRequest);
    for (RequestKnnDataNormalized dataPoint : this.normalizedData) {
      UUID helperId = dataPoint.getHelperId();
      distances.put(helperId, getEuclideanDistance(dataPoint, newRequest));
    }

    List<Map.Entry<UUID, Double>> distancesToNewRequest = new LinkedList<>(distances.entrySet());
    distancesToNewRequest.sort(Map.Entry.comparingByValue());

    ArrayList<UUID> results = new ArrayList<>();
    for (int i = 0; i < k; i++) {
      results.add(distancesToNewRequest.get(i).getKey());
    }
    return results;
  }

  private double getEuclideanDistance(
      RequestKnnDataNormalized requestDataStorePoint, RequestKnnDataNormalized newRequestData) {
    double sumOfSquaredDifference = 0.0;
    sumOfSquaredDifference +=
        requestDataStorePoint.getNormalizedCost() - newRequestData.getNormalizedCost();
    sumOfSquaredDifference +=
        requestDataStorePoint.getNormalizedPlatform() - newRequestData.getNormalizedPlatform();
    sumOfSquaredDifference +=
        requestDataStorePoint.getNormalizedSubject() - newRequestData.getNormalizedSubject();
    return Math.sqrt(sumOfSquaredDifference);
  }
}
