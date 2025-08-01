# Sweet-Home Hotel Booking API Testing Guide

This guide provides step-by-step instructions to test the complete hotel booking workflow on Windows.

## Prerequisites

1. Start all services in the following order:
   - Eureka Server (Port: 8761)
   - API Gateway (Port: 8080)
   - Booking Service (Port: 8081)
   - Payment Service (Port: 8083)

2. Verify all services are registered in Eureka Dashboard: http://localhost:8761

## Windows Testing Setup

### Option 1: Using PowerShell (Recommended)
Open PowerShell as Administrator and run the commands below.

### Option 2: Using Command Prompt
Open Command Prompt as Administrator and run the commands below.

### Option 3: Using Git Bash
If you have Git installed, you can use Git Bash which supports Unix-style curl commands.

## API Testing Workflow

### Step 1: Create a Booking

**Endpoint:** `POST /booking`
**Port:** 8081 (Direct) or 8080 (via API Gateway)

#### PowerShell:
```powershell
curl -X POST http://localhost:8081/booking `
  -H "Content-Type: application/json" `
  -d '{
    "fromDate": "2024-01-15",
    "toDate": "2024-01-17",
    "aadharNumber": "123456789012",
    "numOfRooms": 2
  }'
```

#### Command Prompt:
```cmd
curl -X POST http://localhost:8081/booking ^
  -H "Content-Type: application/json" ^
  -d "{\"fromDate\": \"2024-01-15\", \"toDate\": \"2024-01-17\", \"aadharNumber\": \"123456789012\", \"numOfRooms\": 2}"
```

#### Git Bash:
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

#### PowerShell:
```powershell
curl -X POST http://localhost:8081/booking/1/transaction `
  -H "Content-Type: application/json" `
  -d '{
    "paymentMode": "UPI",
    "bookingId": 1,
    "upiId": "user@upi",
    "cardNumber": null
  }'
```

#### Command Prompt:
```cmd
curl -X POST http://localhost:8081/booking/1/transaction ^
  -H "Content-Type: application/json" ^
  -d "{\"paymentMode\": \"UPI\", \"bookingId\": 1, \"upiId\": \"user@upi\", \"cardNumber\": null}"
```

#### Git Bash:
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

#### PowerShell:
```powershell
curl -X POST http://localhost:8081/booking/1/transaction `
  -H "Content-Type: application/json" `
  -d '{
    "paymentMode": "CARD",
    "bookingId": 1,
    "upiId": null,
    "cardNumber": "1234567890123456"
  }'
```

#### Command Prompt:
```cmd
curl -X POST http://localhost:8081/booking/1/transaction ^
  -H "Content-Type: application/json" ^
  -d "{\"paymentMode\": \"CARD\", \"bookingId\": 1, \"upiId\": null, \"cardNumber\": \"1234567890123456\"}"
```

#### Git Bash:
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

#### PowerShell:
```powershell
curl -X GET http://localhost:8083/transaction/1
```

#### Command Prompt:
```cmd
curl -X GET http://localhost:8083/transaction/1
```

#### Git Bash:
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

#### PowerShell:
```powershell
curl -X GET http://localhost:8081/booking/1
```

#### Command Prompt:
```cmd
curl -X GET http://localhost:8081/booking/1
```

#### Git Bash:
```bash
curl -X GET http://localhost:8081/booking/1
```

## Error Testing

### Invalid Payment Mode

#### PowerShell:
```powershell
curl -X POST http://localhost:8081/booking/1/transaction `
  -H "Content-Type: application/json" `
  -d '{
    "paymentMode": "INVALID",
    "bookingId": 1,
    "upiId": "user@upi",
    "cardNumber": null
  }'
```

#### Command Prompt:
```cmd
curl -X POST http://localhost:8081/booking/1/transaction ^
  -H "Content-Type: application/json" ^
  -d "{\"paymentMode\": \"INVALID\", \"bookingId\": 1, \"upiId\": \"user@upi\", \"cardNumber\": null}"
```

#### Git Bash:
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

#### PowerShell:
```powershell
curl -X POST http://localhost:8081/booking/999/transaction `
  -H "Content-Type: application/json" `
  -d '{
    "paymentMode": "UPI",
    "bookingId": 999,
    "upiId": "user@upi",
    "cardNumber": null
  }'
```

#### Command Prompt:
```cmd
curl -X POST http://localhost:8081/booking/999/transaction ^
  -H "Content-Type: application/json" ^
  -d "{\"paymentMode\": \"UPI\", \"bookingId\": 999, \"upiId\": \"user@upi\", \"cardNumber\": null}"
```

#### Git Bash:
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

### Example via API Gateway:

#### PowerShell:
```powershell
curl -X POST http://localhost:8080/booking `
  -H "Content-Type: application/json" `
  -d '{
    "fromDate": "2024-01-15",
    "toDate": "2024-01-17",
    "aadharNumber": "123456789012",
    "numOfRooms": 2
  }'
```

## Windows-Specific Tips

### 1. Using PowerShell (Recommended)
- Use backtick (`) for line continuation
- JSON can be formatted with proper indentation
- Better error handling and output formatting

### 2. Using Command Prompt
- Use caret (^) for line continuation
- JSON must be on a single line with escaped quotes
- Limited formatting options

### 3. Using Git Bash
- Supports Unix-style commands
- Use backslash (\) for line continuation
- Best compatibility with curl syntax

### 4. Alternative: Using Postman
If curl is not working properly, you can use Postman:
1. Download and install Postman
2. Import the following collection or create requests manually
3. Set base URL to `http://localhost:8081` or `http://localhost:8080`

### 5. Alternative: Using Windows Subsystem for Linux (WSL)
If you have WSL installed:
```bash
# Install curl if not available
sudo apt update
sudo apt install curl

# Then use Unix-style commands
curl -X POST http://localhost:8081/booking \
  -H "Content-Type: application/json" \
  -d '{
    "fromDate": "2024-01-15",
    "toDate": "2024-01-17",
    "aadharNumber": "123456789012",
    "numOfRooms": 2
  }'
```

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

### Common Windows Issues:

1. **curl not recognized:**
   - Windows 10/11: curl is built-in, use `curl.exe` if needed
   - Older Windows: Download curl from https://curl.se/windows/
   - Alternative: Use PowerShell's `Invoke-WebRequest`

2. **JSON formatting issues:**
   - Use PowerShell for better JSON handling
   - Escape quotes properly in Command Prompt
   - Use Git Bash for Unix-style commands

3. **Service not found errors:**
   - Ensure all services are running and registered with Eureka
   - Check Windows Firewall settings
   - Verify ports are not blocked

4. **Connection refused:**
   - Check if services are running on correct ports
   - Ensure no other applications are using the ports
   - Restart services if needed

5. **Database errors:**
   - H2 databases are in-memory and reset on service restart
   - Clear browser cache for H2 console

6. **Date format:**
   - Use ISO date format (YYYY-MM-DD) for dates

### PowerShell Alternative Commands:

If curl doesn't work, you can use PowerShell's `Invoke-WebRequest`:

```powershell
# Create booking
$body = @{
    fromDate = "2024-01-15"
    toDate = "2024-01-17"
    aadharNumber = "123456789012"
    numOfRooms = 2
} | ConvertTo-Json

Invoke-WebRequest -Uri "http://localhost:8081/booking" -Method POST -Body $body -ContentType "application/json"
```

## Quick Test Script

Create a PowerShell script `test-api.ps1`:

```powershell
Write-Host "Testing Sweet-Home Hotel Booking API..." -ForegroundColor Green

# Test 1: Create Booking
Write-Host "`n1. Creating booking..." -ForegroundColor Yellow
$bookingResponse = curl -X POST http://localhost:8081/booking -H "Content-Type: application/json" -d '{"fromDate": "2024-01-15", "toDate": "2024-01-17", "aadharNumber": "123456789012", "numOfRooms": 2}'
Write-Host "Booking Response: $bookingResponse" -ForegroundColor Cyan

# Test 2: Process Payment
Write-Host "`n2. Processing payment..." -ForegroundColor Yellow
$paymentResponse = curl -X POST http://localhost:8081/booking/1/transaction -H "Content-Type: application/json" -d '{"paymentMode": "UPI", "bookingId": 1, "upiId": "user@upi", "cardNumber": null}'
Write-Host "Payment Response: $paymentResponse" -ForegroundColor Cyan

Write-Host "`nAPI Testing completed!" -ForegroundColor Green
```

Run the script: `.\test-api.ps1` 