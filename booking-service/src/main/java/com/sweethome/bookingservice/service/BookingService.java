package com.sweethome.bookingservice.service;

import com.sweethome.bookingservice.dto.PaymentRequest;
import com.sweethome.bookingservice.entity.BookingInfoEntity;
import com.sweethome.bookingservice.repository.BookingRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.Random;

@Service
public class BookingService {

    @Autowired
    private BookingRepository bookingRepository;

    @Autowired
    private RestTemplate restTemplate;

    private static final int BASE_PRICE_PER_ROOM_PER_DAY = 1000;

    public BookingInfoEntity createBooking(BookingInfoEntity bookingInfo) {
        // Generate random room numbers
        List<String> roomNumbers = getRandomNumbers(bookingInfo.getNumOfRooms());
        bookingInfo.setRoomNumbers(String.join(",", roomNumbers));

        // Calculate room price
        long numberOfDays = ChronoUnit.DAYS.between(bookingInfo.getFromDate(), bookingInfo.getToDate());
        int roomPrice = BASE_PRICE_PER_ROOM_PER_DAY * bookingInfo.getNumOfRooms() * (int) numberOfDays;
        bookingInfo.setRoomPrice(roomPrice);

        // Set booked date
        bookingInfo.setBookedOn(LocalDate.now());

        // Save to database
        return bookingRepository.save(bookingInfo);
    }

    public BookingInfoEntity processPayment(Integer bookingId, PaymentRequest paymentRequest) {
        // Validate booking exists
        Optional<BookingInfoEntity> bookingOpt = bookingRepository.findById(bookingId);
        if (!bookingOpt.isPresent()) {
            throw new RuntimeException("Invalid Booking Id");
        }

        BookingInfoEntity booking = bookingOpt.get();

        // Validate payment mode
        if (!"UPI".equalsIgnoreCase(paymentRequest.getPaymentMode()) && 
            !"CARD".equalsIgnoreCase(paymentRequest.getPaymentMode())) {
            throw new RuntimeException("Invalid mode of payment");
        }

        // Call payment service
        Integer transactionId = restTemplate.postForObject(
            "http://payment-service/transaction", 
            paymentRequest, 
            Integer.class
        );

        // Update booking with transaction ID
        booking.setTransactionId(transactionId);
        booking = bookingRepository.save(booking);

        // Print confirmation message
        String message = "Booking confirmed for user with aadhaar number: " 
            + booking.getAadharNumber() 
            + "    |    " 
            + "Here are the booking details:    " + booking.toString();
        System.out.println(message);

        return booking;
    }

    public Optional<BookingInfoEntity> getBookingById(Integer bookingId) {
        return bookingRepository.findById(bookingId);
    }

    /**
     * Generates random room numbers between 1 and 100
     */
    public static List<String> getRandomNumbers(int count) {
        Random rand = new Random();
        int upperBound = 100;
        List<String> numberList = new ArrayList<>();

        for (int i = 0; i < count; i++) {
            numberList.add(String.valueOf(rand.nextInt(upperBound) + 1)); // +1 to avoid room 0
        }

        return numberList;
    }
} 