package com.sweethome.paymentservice.controller;

import com.sweethome.paymentservice.dto.PaymentRequest;
import com.sweethome.paymentservice.entity.TransactionDetailsEntity;
import com.sweethome.paymentservice.service.PaymentService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

@RestController
@RequestMapping("/transaction")
public class PaymentController {

    @Autowired
    private PaymentService paymentService;

    @PostMapping
    public ResponseEntity<Integer> createTransaction(@RequestBody PaymentRequest paymentRequest) {
        Integer transactionId = paymentService.processTransaction(paymentRequest);
        return ResponseEntity.status(HttpStatus.CREATED).body(transactionId);
    }

    @GetMapping("/{transactionId}")
    public ResponseEntity<TransactionDetailsEntity> getTransactionById(@PathVariable Integer transactionId) {
        return paymentService.getTransactionById(transactionId)
                .map(ResponseEntity::ok)
                .orElse(ResponseEntity.notFound().build());
    }
} 