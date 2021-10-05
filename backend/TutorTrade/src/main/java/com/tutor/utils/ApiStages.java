package com.tutor.utils;

public enum ApiStages {
  JESSE_DEV("https://bpbzrj9x3b.execute-api.us-east-1.amazonaws.com/jesse-dev"),
  ADAM_DEV("https://mlxlapjbhh.execute-api.us-east-1.amazonaws.com/adam-dev"),
  PROD("https://75j9h7est2.execute-api.us-east-1.amazonaws.com/prod"),
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
