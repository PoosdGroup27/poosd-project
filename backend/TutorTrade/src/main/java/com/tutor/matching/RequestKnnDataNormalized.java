package com.tutor.matching;

import com.tutor.request.Request;
import java.util.UUID;

public class RequestKnnDataNormalized {
    public UUID getHelperId() {
        return helperId;
    }

    public double getNormalizedCost() {
        return normalizedCost;
    }

    public double getNormalizedPlatform() {
        return normalizedPlatform;
    }

    public double getNormalizedSubject() {
        return normalizedSubject;
    }

    private final UUID helperId;
    private final double normalizedCost;
    private final double normalizedPlatform;
    private final double normalizedSubject;

    public RequestKnnDataNormalized(Request request) {
        this.helperId = request.getHelperId();
        double[] normData = request.getNormalizedArrayData();
        this.normalizedCost = normData[0];
        this.normalizedPlatform = normData[1];
        this.normalizedSubject = normData[2];
    }
}