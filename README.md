# Sweet-Home Hotel Booking Microservices

A microservices-based hotel room booking application built with Spring Boot and Spring Cloud.

## Architecture Overview

The application is divided into four microservices:

1. **Eureka Server** (Port: 8761) - Service discovery and registration
2. **API Gateway** (Port: 8080) - Route requests to appropriate microservices
3. **Booking Service** (Port: 8081) - Handle room bookings and user information
4. **Payment Service** (Port: 8083) - Process payments and transactions

## Technology Stack

- **Spring Boot** - Application framework
- **Spring Cloud Netflix Eureka** - Service discovery
- **Spring Cloud Gateway** - API Gateway
- **Spring Data JPA** - Database operations
- **H2 Database** - In-memory database for development
- **Maven** - Build tool

## Project Structure

```
sweet-home/
├── eureka-server/          # Service discovery server
├── api-gateway/            # API Gateway service
├── booking-service/        # Booking microservice
├── payment-service/        # Payment microservice
└── README.md
```

## Getting Started

### Prerequisites
- Java 11 or higher
- Maven 3.6 or higher

### Running the Application

1. **Start Eureka Server:**
   ```bash
   cd eureka-server
   mvn spring-boot:run
   ```
   Access Eureka Dashboard: http://localhost:8761

2. **Start API Gateway:**
   ```bash
   cd api-gateway
   mvn spring-boot:run
   ```

3. **Start Booking Service:**
   ```bash
   cd booking-service
   mvn spring-boot:run
   ```

4. **Start Payment Service:**
   ```bash
   cd payment-service
   mvn spring-boot:run
   ```

## API Documentation

### Booking Service APIs

#### 1. Create Booking
- **URL:** `POST /booking`
- **Port:** 8081
- **Request Body:**
  ```json
  {
    "fromDate": "2024-01-15",
    "toDate": "2024-01-17",
    "aadharNumber": "123456789012",
    "numOfRooms": 2
  }
  ```

#### 2. Process Payment
- **URL:** `POST /booking/{bookingId}/transaction`
- **Port:** 8081
- **Request Body:**
  ```json
  {
    "paymentMode": "UPI",
    "bookingId": 1,
    "upiId": "user@upi",
    "cardNumber": null
  }
  ```

### Payment Service APIs

#### 1. Create Transaction
- **URL:** `POST /transaction`
- **Port:** 8083
- **Request Body:**
  ```json
  {
    "paymentMode": "UPI",
    "bookingId": 1,
    "upiId": "user@upi",
    "cardNumber": null
  }
  ```

#### 2. Get Transaction Details
- **URL:** `GET /transaction/{transactionId}`
- **Port:** 8083

## Database Schema

### Booking Service Database
- **Table:** `booking`
- **Fields:** bookingId, fromDate, toDate, aadharNumber, numOfRooms, roomNumbers, roomPrice, transactionId, bookedOn

### Payment Service Database
- **Table:** `transaction`
- **Fields:** transactionId, paymentMode, bookingId, upiId, cardNumber

## Features

- ✅ Service Discovery with Eureka
- ✅ API Gateway for request routing
- ✅ Room booking with random room allocation
- ✅ Payment processing (UPI/Card)
- ✅ Transaction management
- ✅ Microservices communication via REST
- ✅ Database persistence
- ✅ Error handling and validation

## Workflow

1. User sends booking request to API Gateway
2. API Gateway routes to Booking Service
3. Booking Service validates and stores booking details
4. User provides payment details
5. Booking Service calls Payment Service
6. Payment Service processes payment and returns transaction ID
7. Booking Service confirms booking and prints confirmation message
