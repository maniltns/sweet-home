package com.sweethome.bookingservice.controller;

import com.sweethome.bookingservice.dto.BookingRequest;
import com.sweethome.bookingservice.dto.ErrorResponse;
import com.sweethome.bookingservice.dto.PaymentRequest;
import com.sweethome.bookingservice.entity.BookingInfoEntity;
import com.sweethome.bookingservice.service.BookingService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/booking")
public class BookingController {

    @Autowired
    private BookingService bookingService;

    @PostMapping
    public ResponseEntity<BookingInfoEntity> createBooking(@RequestBody BookingRequest bookingRequest) {
        BookingInfoEntity bookingInfo = new BookingInfoEntity();
        bookingInfo.setFromDate(bookingRequest.getFromDate());
        bookingInfo.setToDate(bookingRequest.getToDate());
        bookingInfo.setAadharNumber(bookingRequest.getAadharNumber());
        bookingInfo.setNumOfRooms(bookingRequest.getNumOfRooms());

        BookingInfoEntity savedBooking = bookingService.createBooking(bookingInfo);
        return ResponseEntity.status(HttpStatus.CREATED).body(savedBooking);
    }

    @PostMapping("/{bookingId}/transaction")
    public ResponseEntity<?> processPayment(@PathVariable Integer bookingId, @RequestBody PaymentRequest paymentRequest) {
        try {
            BookingInfoEntity updatedBooking = bookingService.processPayment(bookingId, paymentRequest);
            return ResponseEntity.ok(updatedBooking);
        } catch (RuntimeException e) {
            ErrorResponse errorResponse = new ErrorResponse();
            errorResponse.setMessage(e.getMessage());
            
            if ("Invalid mode of payment".equals(e.getMessage())) {
                errorResponse.setStatusCode(400);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
            } else if ("Invalid Booking Id".equals(e.getMessage())) {
                errorResponse.setStatusCode(400);
                return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(errorResponse);
            } else {
                errorResponse.setStatusCode(500);
                return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR).body(errorResponse);
            }
        }
    }

    @GetMapping("/{bookingId}")
    public ResponseEntity<BookingInfoEntity> getBookingById(@PathVariable Integer bookingId) {
        return bookingService.getBookingById(bookingId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
} 