# Sweet-Home Project Structure

This document provides a comprehensive overview of the project structure and the purpose of each component.

## Root Directory Structure

```
sweet-home/
├── README.md                    # Main project documentation
├── test-api.md                  # API testing guide with curl commands
├── PROJECT_STRUCTURE.md         # This file - project structure documentation
├── start-services.bat           # Windows script to start all services
├── start-services.sh            # Linux/Mac script to start all services
├── eureka-server/               # Service discovery server
├── api-gateway/                 # API Gateway service
├── booking-service/             # Booking microservice
└── payment-service/             # Payment microservice
```

## Eureka Server (Port: 8761)

**Purpose:** Service discovery and registration for all microservices

```
eureka-server/
├── pom.xml                      # Maven dependencies (Spring Cloud Eureka Server)
├── src/main/java/com/sweethome/eurekaserver/
│   └── EurekaServerApplication.java  # Main class with @EnableEurekaServer
└── src/main/resources/
    └── application.yml          # Configuration (port 8761, standalone mode)
```

**Key Features:**
- Standalone Eureka server configuration
- Service registry for all microservices
- Web dashboard at http://localhost:8761

## API Gateway (Port: 8080)

**Purpose:** Route external requests to appropriate microservices

```
api-gateway/
├── pom.xml                      # Maven dependencies (Spring Cloud Gateway, Eureka Client)
├── src/main/java/com/sweethome/apigateway/
│   └── ApiGatewayApplication.java  # Main class with @EnableDiscoveryClient
└── src/main/resources/
    └── application.yml          # Configuration (port 8080, routing rules)
```

**Key Features:**
- Routes `/booking/**` to booking-service
- Routes `/transaction/**` to payment-service
- Load balancing with Eureka service discovery
- Single entry point for all external requests

## Booking Service (Port: 8081)

**Purpose:** Handle room bookings, generate room numbers, calculate prices, and process payments

```
booking-service/
├── pom.xml                      # Maven dependencies (Spring Web, Data JPA, Eureka Client, H2)
├── src/main/java/com/sweethome/bookingservice/
│   ├── BookingServiceApplication.java  # Main class with RestTemplate bean
│   ├── entity/
│   │   └── BookingInfoEntity.java      # JPA entity for booking table
│   ├── dto/
│   │   ├── BookingRequest.java         # DTO for booking requests
│   │   ├── PaymentRequest.java         # DTO for payment requests
│   │   └── ErrorResponse.java          # DTO for error responses
│   ├── repository/
│   │   └── BookingRepository.java      # JPA repository interface
│   ├── service/
│   │   └── BookingService.java         # Business logic (room generation, pricing)
│   └── controller/
│       └── BookingController.java      # REST endpoints
└── src/main/resources/
    └── application.yml          # Configuration (port 8081, H2 database, Eureka client)
```

**Key Features:**
- Creates bookings with random room numbers (1-100)
- Calculates room price: 1000 × numOfRooms × number of days
- Communicates with Payment Service via RestTemplate
- Handles payment processing and booking confirmation
- Error handling for invalid payment modes and booking IDs

**Database Schema (booking table):**
- bookingId (Primary Key, Auto-generated)
- fromDate, toDate (Date)
- aadharNumber (String)
- numOfRooms (Integer)
- roomNumbers (String - comma-separated)
- roomPrice (Integer, NOT NULL)
- transactionId (Integer, Default: 0)
- bookedOn (Date)

## Payment Service (Port: 8083)

**Purpose:** Process payments and manage transactions

```
payment-service/
├── pom.xml                      # Maven dependencies (Spring Web, Data JPA, Eureka Client, H2)
├── src/main/java/com/sweethome/paymentservice/
│   ├── PaymentServiceApplication.java  # Main class with @EnableDiscoveryClient
│   ├── entity/
│   │   └── TransactionDetailsEntity.java  # JPA entity for transaction table
│   ├── dto/
│   │   └── PaymentRequest.java         # DTO for payment requests
│   ├── repository/
│   │   └── TransactionRepository.java  # JPA repository interface
│   ├── service/
│   │   └── PaymentService.java         # Business logic for transactions
│   └── controller/
│       └── PaymentController.java      # REST endpoints
└── src/main/resources/
    └── application.yml          # Configuration (port 8083, H2 database, Eureka client)
```

**Key Features:**
- Processes UPI and Card payments
- Generates unique transaction IDs
- Stores transaction details in database
- Returns transaction ID to Booking Service

**Database Schema (transaction table):**
- transactionId (Primary Key, Auto-generated)
- paymentMode (String - "UPI" or "CARD")
- bookingId (Integer, NOT NULL)
- upiId (String, NULL for card payments)
- cardNumber (String, NULL for UPI payments)

## API Endpoints

### Booking Service Endpoints
- `POST /booking` - Create a new booking
- `POST /booking/{bookingId}/transaction` - Process payment for booking
- `GET /booking/{bookingId}` - Get booking details

### Payment Service Endpoints
- `POST /transaction` - Create a new transaction
- `GET /transaction/{transactionId}` - Get transaction details

### API Gateway Routes
- `http://localhost:8080/booking/**` → Booking Service
- `http://localhost:8080/transaction/**` → Payment Service

## Technology Stack

- **Spring Boot 2.7.14** - Application framework
- **Spring Cloud 2021.0.8** - Microservices framework
- **Spring Cloud Netflix Eureka** - Service discovery
- **Spring Cloud Gateway** - API Gateway
- **Spring Data JPA** - Database operations
- **H2 Database** - In-memory database
- **Maven** - Build tool
- **Java 11** - Programming language

## Communication Flow

1. **User** → **API Gateway** (Port 8080)
2. **API Gateway** → **Booking Service** (Port 8081)
3. **Booking Service** → **Payment Service** (Port 8083) via RestTemplate
4. **Payment Service** → **Booking Service** (returns transaction ID)
5. **Booking Service** → **API Gateway** → **User** (confirmation)

## Database Access

### Booking Service H2 Console
- URL: http://localhost:8081/h2-console
- JDBC URL: `jdbc:h2:mem:bookingdb`
- Username: `sa`
- Password: `password`

### Payment Service H2 Console
- URL: http://localhost:8083/h2-console
- JDBC URL: `jdbc:h2:mem:paymentdb`
- Username: `sa`
- Password: `password`

## Key Business Logic

### Room Price Calculation
```java
roomPrice = 1000 × numOfRooms × number of days
```

### Random Room Number Generation
- Generates numbers between 1 and 100
- Returns comma-separated string of room numbers
- Example: "45,23" for 2 rooms

### Payment Processing
- Supports UPI and Card payment modes
- Validates payment mode (must be "UPI" or "CARD")
- Generates unique transaction ID
- Updates booking with transaction ID
- Prints confirmation message to console

## Error Handling

- **Invalid Payment Mode**: Returns 400 with "Invalid mode of payment"
- **Invalid Booking ID**: Returns 400 with "Invalid Booking Id"
- **Service Communication**: Handles service discovery and load balancing
- **Database Operations**: JPA handles database errors gracefully

## Testing

- Comprehensive API testing guide in `test-api.md`
- Curl commands for all endpoints
- Expected responses and error scenarios
- Complete workflow testing instructions 