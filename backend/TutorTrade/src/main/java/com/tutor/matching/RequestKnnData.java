package com.tutor.matching;

import com.tutor.request.Request;

import java.util.UUID;

/** Helper intermediary class for moving request data to the completed request data store. */
public class RequestKnnData {
  private UUID helperId;

  public UUID getHelperId() {
    return helperId;
  }

  public void setHelperId(UUID helperId) {
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

  public RequestKnnData(Request request) {
    this.helperId = request.getHelperId();
    this.cost = (double) request.getCostInPoints();
    this.platform = request.getPlatform().ordinal() + 1;
    this.subject = request.getSubject().ordinal() + 1;
  }

  public RequestKnnData() {}
}
