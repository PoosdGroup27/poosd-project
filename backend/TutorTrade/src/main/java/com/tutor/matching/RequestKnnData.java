package com.tutor.matching;

import com.tutor.request.Request;
import lombok.AllArgsConstructor;
import lombok.Builder;

/** Helper intermediary class for moving request data to the completed request data store. */
@AllArgsConstructor
@Builder
public class RequestKnnData {
  private String helperId;

  public String getHelperId() {
    return helperId;
  }

  public void setHelperId(String helperId) {
    this.helperId = helperId;
  }

  public double getCost() {
    return cost;
  }

  public void setCost(double cost) {
    this.cost = cost;
  }

  public double getPlatform() {
    return platform;
  }

  public void setPlatform(double platform) {
    this.platform = platform;
  }

  public double getSubject() {
    return subject;
  }

  public void setSubject(double subject) {
    this.subject = subject;
  }

  private double cost;
  private double platform;
  private double subject;

  /**
   * Constructor to extract data from request which is relevant to KNN, and shift ordinals such that
   * we never have a zero value.
   */
  public RequestKnnData(Request request) {
    this.helperId = request.getHelperId();
    this.cost = (double) request.getCostInPoints();
    this.platform = request.getPlatform().ordinal() + 1;
    this.subject = request.getSubject().ordinal() + 1;
  }

  public RequestKnnData() {}
}
