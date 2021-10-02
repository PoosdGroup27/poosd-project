package com.tutor.matching;

import com.tutor.request.Request;
import java.util.*;
import org.apache.commons.math3.stat.StatUtils;


public class RequestKnn {
  private final HashMap<UUID, double[]> normalizedData;
  private final Request newRequest;
  private HashMap<UUID, Double> distances;

  public RequestKnn(HashMap<UUID, double[]> data, Request newRequest) {
    this.normalizedData = data;
    this.newRequest = newRequest;
  }

  /**
   * Get array of values for use in data matrix. Values must all be created the exact same way in
   * the exact same order. IMPORTANT: if this section is modified from order of cost, platform,
   * subject or scaling factor is changed for platform or subject from 3 or 7 respectively, you must
   * recreate dataset using createFreshNormalizedData()
   *
   * @param request Request object to be converted for use in data matrix
   * @return double array of normalized request data
   */
  private static HashMap<UUID, double[]> getNormalizedArrayFromRequest(Request request) {
    // verifyUnchangedEnumSchemas()
    // verifyUnchangedMultipliers()

    double[] requestData =
        new double[] {
          (double) request.getCostInPoints(),
          ((double) request.getPlatform().ordinal()) * 3,
          ((double) request.getSubject().ordinal()) * 7
        };

    HashMap<UUID, double[]> normalizedRequest = new HashMap<>();
    normalizedRequest.put(request.getRequesterId(), StatUtils.normalize(requestData));
    return normalizedRequest;
  }

  public ArrayList<UUID> getNearestNeighbors(int k) {
    HashMap<UUID, double[]> normalizedNewRequest = getNormalizedArrayFromRequest(this.newRequest);
    double[] newRequestData = normalizedNewRequest.get(this.newRequest.getRequesterId());
    for (UUID id : this.normalizedData.keySet()) {
      double[] data = this.normalizedData.get(id);
      assert data.length == newRequestData.length;
      distances.put(id, getEuclideanDistance(data, newRequestData));
    }

    List<Map.Entry<UUID, Double>> distancesToNewRequest =
        new LinkedList<>(distances.entrySet());
    distancesToNewRequest.sort(Map.Entry.comparingByValue());

    ArrayList<UUID> results = new ArrayList<>();
    for (int i = 0; i < k; i++) {
      results.add(distancesToNewRequest.get(i).getKey());
    }
    return results;
  }

  private double getEuclideanDistance(double[] data, double[] newRequestData) {
    double sumOfSquaredDifference = 0.0;
    for (int i = 0; i < data.length; i++) {
      sumOfSquaredDifference += Math.pow((data[i] - newRequestData[i]), 2);
    }
    return Math.sqrt(sumOfSquaredDifference);
  }
}
