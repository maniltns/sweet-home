package com.sweethome.bookingservice.dto;

import java.time.LocalDate;

public class BookingRequest {
    private LocalDate fromDate;
    private LocalDate toDate;
    private String aadharNumber;
    private Integer numOfRooms;

    // Default constructor
    public BookingRequest() {
    }

    // Constructor with all fields
    public BookingRequest(LocalDate fromDate, LocalDate toDate, String aadharNumber, Integer numOfRooms) {
        this.fromDate = fromDate;
        this.toDate = toDate;
        this.aadharNumber = aadharNumber;
        this.numOfRooms = numOfRooms;
    }

    // Getters and Setters
    public LocalDate getFromDate() {
        return fromDate;
    }

    public void setFromDate(LocalDate fromDate) {
        this.fromDate = fromDate;
    }

    public LocalDate getToDate() {
        return toDate;
    }

    public void setToDate(LocalDate toDate) {
        this.toDate = toDate;
    }

    public String getAadharNumber() {
        return aadharNumber;
    }

    public void setAadharNumber(String aadharNumber) {
        this.aadharNumber = aadharNumber;
    }

    public Integer getNumOfRooms() {
        return numOfRooms;
    }

    public void setNumOfRooms(Integer numOfRooms) {
        this.numOfRooms = numOfRooms;
    }
} 