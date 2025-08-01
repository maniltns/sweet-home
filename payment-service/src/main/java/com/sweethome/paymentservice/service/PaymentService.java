package com.sweethome.paymentservice.service;

import com.sweethome.paymentservice.dto.PaymentRequest;
import com.sweethome.paymentservice.entity.TransactionDetailsEntity;
import com.sweethome.paymentservice.repository.TransactionRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.util.Optional;

@Service
public class PaymentService {

    @Autowired
    private TransactionRepository transactionRepository;

    public Integer processTransaction(PaymentRequest paymentRequest) {
        // Create transaction entity
        TransactionDetailsEntity transaction = new TransactionDetailsEntity();
        transaction.setPaymentMode(paymentRequest.getPaymentMode());
        transaction.setBookingId(paymentRequest.getBookingId());
        transaction.setUpiId(paymentRequest.getUpiId());
        transaction.setCardNumber(paymentRequest.getCardNumber());

        // Save transaction to database
        TransactionDetailsEntity savedTransaction = transactionRepository.save(transaction);

        // Return the transaction ID (auto-generated primary key)
        return savedTransaction.getTransactionId();
    }

    public Optional<TransactionDetailsEntity> getTransactionById(Integer transactionId) {
        return transactionRepository.findById(transactionId);
    }
} 