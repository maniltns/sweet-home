package com.sweethome.bookingservice.dto;

public class ErrorResponse {
    private String message;
    private Integer statusCode;

    // Default constructor
    public ErrorResponse() {
    }

    // Constructor with all fields
    public ErrorResponse(String message, Integer statusCode) {
        this.message = message;
        this.statusCode = statusCode;
    }

    // Getters and Setters
    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public Integer getStatusCode() {
        return statusCode;
    }

    public void setStatusCode(Integer statusCode) {
        this.statusCode = statusCode;
    }
} 