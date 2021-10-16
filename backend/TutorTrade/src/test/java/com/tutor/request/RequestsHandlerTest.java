package com.tutor.request;

import org.junit.jupiter.api.AfterEach;
import org.junit.jupiter.api.BeforeEach;
import org.junit.jupiter.api.Test;

import static org.junit.jupiter.api.Assertions.*;

class RequestsHandlerTest {

    @BeforeEach
    void setUp() {
    }

    @AfterEach
    void tearDown() {
    }

    @Test
    void WHENthisShouldPassTHENpass() {
        assertEquals(2, 2);
    }

    @Test
    void WHENthisShouldFailTHENfails() {
        assertEquals(2+2, 5);
    }


}