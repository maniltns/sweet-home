# Sweet-Home Hotel Booking API Testing Guide

This guide provides step-by-step instructions to test the complete hotel booking workflow.

## Prerequisites

1. Start all services in the following order:
   - Eureka Server (Port: 8761)
   - API Gateway (Port: 8080)
   - Booking Service (Port: 8081)
   - Payment Service (Port: 8083)

2. Verify all services are registered in Eureka Dashboard: http://localhost:8761

## API Testing Workflow

### Step 1: Create a Booking

**Endpoint:** `POST /booking`
**Port:** 8081 (Direct) or 8080 (via API Gateway)

```bash
curl -X POST http://localhost:8081/booking \
  -H "Content-Type: application/json" \
  -d '{
    "fromDate": "2024-01-15",
    "toDate": "2024-01-17",
    "aadharNumber": "123456789012",
    "numOfRooms": 2
  }'
```

**Expected Response:**
```json
{
  "bookingId": 1,
  "fromDate": "2024-01-15",
  "toDate": "2024-01-17",
  "aadharNumber": "123456789012",
  "numOfRooms": 2,
  "roomNumbers": "45,23",
  "roomPrice": 4000,
  "transactionId": 0,
  "bookedOn": "2024-01-10"
}
```

**Notes:**
- `transactionId` is 0 initially (no payment made yet)
- `roomNumbers` are randomly generated between 1-100
- `roomPrice` = 1000 × numOfRooms × number of days

### Step 2: Process Payment (UPI)

**Endpoint:** `POST /booking/{bookingId}/transaction`
**Port:** 8081 (Direct) or 8080 (via API Gateway)

```bash
curl -X POST http://localhost:8081/booking/1/transaction \
  -H "Content-Type: application/json" \
  -d '{
    "paymentMode": "UPI",
    "bookingId": 1,
    "upiId": "user@upi",
    "cardNumber": null
  }'
```

**Expected Response:**
```json
{
  "bookingId": 1,
  "fromDate": "2024-01-15",
  "toDate": "2024-01-17",
  "aadharNumber": "123456789012",
  "numOfRooms": 2,
  "roomNumbers": "45,23",
  "roomPrice": 4000,
  "transactionId": 1,
  "bookedOn": "2024-01-10"
}
```

**Notes:**
- `transactionId` now contains the actual transaction ID from payment service
- Check console for confirmation message

### Step 3: Process Payment (Card)

```bash
curl -X POST http://localhost:8081/booking/1/transaction \
  -H "Content-Type: application/json" \
  -d '{
    "paymentMode": "CARD",
    "bookingId": 1,
    "upiId": null,
    "cardNumber": "1234567890123456"
  }'
```

### Step 4: Get Transaction Details

**Endpoint:** `GET /transaction/{transactionId}`
**Port:** 8083 (Direct) or 8080 (via API Gateway)

```bash
curl -X GET http://localhost:8083/transaction/1
```

**Expected Response:**
```json
{
  "transactionId": 1,
  "paymentMode": "UPI",
  "bookingId": 1,
  "upiId": "user@upi",
  "cardNumber": null
}
```

### Step 5: Get Booking Details

**Endpoint:** `GET /booking/{bookingId}`
**Port:** 8081 (Direct) or 8080 (via API Gateway)

```bash
curl -X GET http://localhost:8081/booking/1
```

## Error Testing

### Invalid Payment Mode

```bash
curl -X POST http://localhost:8081/booking/1/transaction \
  -H "Content-Type: application/json" \
  -d '{
    "paymentMode": "INVALID",
    "bookingId": 1,
    "upiId": "user@upi",
    "cardNumber": null
  }'
```

**Expected Response:**
```json
{
  "message": "Invalid mode of payment",
  "statusCode": 400
}
```

### Invalid Booking ID

```bash
curl -X POST http://localhost:8081/booking/999/transaction \
  -H "Content-Type: application/json" \
  -d '{
    "paymentMode": "UPI",
    "bookingId": 999,
    "upiId": "user@upi",
    "cardNumber": null
  }'
```

**Expected Response:**
```json
{
  "message": "Invalid Booking Id",
  "statusCode": 400
}
```

## Testing via API Gateway

All the above endpoints can also be accessed via the API Gateway at port 8080:

- Booking endpoints: `http://localhost:8080/booking/*`
- Payment endpoints: `http://localhost:8080/transaction/*`

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

## Complete Workflow Test

1. Create a booking
2. Note the booking ID and room details
3. Process payment with UPI or Card
4. Verify transaction ID is updated in booking
5. Check confirmation message in console
6. Retrieve transaction details
7. Verify all data in H2 console

## Troubleshooting

1. **Service not found errors:** Ensure all services are running and registered with Eureka
2. **Connection refused:** Check if services are running on correct ports
3. **Database errors:** H2 databases are in-memory and reset on service restart
4. **Date format:** Use ISO date format (YYYY-MM-DD) for dates 