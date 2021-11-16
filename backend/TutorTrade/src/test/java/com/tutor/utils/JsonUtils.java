package com.tutor.utils;

import java.io.File;
import java.io.IOException;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;
import java.util.List;
import java.util.Objects;

public class JsonUtils {
  public String getJsonFromFileAsString(String filename) throws IOException {
    File file =
        new File(
            Objects.requireNonNull(this.getClass().getClassLoader().getResource(filename))
                .getFile());
    List<String> requestJson = Files.readAllLines(file.toPath(), StandardCharsets.UTF_8);

    StringBuilder json = new StringBuilder();
    requestJson.forEach(json::append);

    return json.toString();
  }
}
