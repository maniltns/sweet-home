# Sweet-Home Hotel Booking API Test Script for Windows
# Run this script in PowerShell to test all API endpoints

Write-Host "===============================================" -ForegroundColor Green
Write-Host "Sweet-Home Hotel Booking API Test Script" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

# Function to make API calls and display results
function Test-API {
    param(
        [string]$Method,
        [string]$Url,
        [string]$Body = "",
        [string]$Description
    )
    
    Write-Host "`n$Description" -ForegroundColor Yellow
    Write-Host "URL: $Url" -ForegroundColor Gray
    Write-Host "Method: $Method" -ForegroundColor Gray
    
    try {
        if ($Body -ne "") {
            $response = curl -X $Method $Url -H "Content-Type: application/json" -d $Body
        } else {
            $response = curl -X $Method $Url
        }
        
        Write-Host "Response:" -ForegroundColor Cyan
        Write-Host $response -ForegroundColor White
        return $response
    }
    catch {
        Write-Host "Error: $($_.Exception.Message)" -ForegroundColor Red
        return $null
    }
}

# Test 1: Create a booking
Write-Host "`n=== Test 1: Create Booking ===" -ForegroundColor Magenta
$bookingBody = '{
    "fromDate": "2024-01-15",
    "toDate": "2024-01-17",
    "aadharNumber": "123456789012",
    "numOfRooms": 2
}'

$bookingResponse = Test-API -Method "POST" -Url "http://localhost:8081/booking" -Body $bookingBody -Description "Creating a new booking"

# Extract booking ID from response (simple extraction)
if ($bookingResponse -match '"bookingId":\s*(\d+)') {
    $bookingId = $matches[1]
    Write-Host "`nExtracted Booking ID: $bookingId" -ForegroundColor Green
} else {
    $bookingId = 1
    Write-Host "`nUsing default Booking ID: $bookingId" -ForegroundColor Yellow
}

# Test 2: Process payment with UPI
Write-Host "`n=== Test 2: Process Payment (UPI) ===" -ForegroundColor Magenta
$paymentBody = "{
    `"paymentMode`": `"UPI`",
    `"bookingId`": $bookingId,
    `"upiId`": `"user@upi`",
    `"cardNumber`": null
}"

$paymentResponse = Test-API -Method "POST" -Url "http://localhost:8081/booking/$bookingId/transaction" -Body $paymentBody -Description "Processing UPI payment"

# Test 3: Get transaction details
Write-Host "`n=== Test 3: Get Transaction Details ===" -ForegroundColor Magenta
if ($paymentResponse -match '"transactionId":\s*(\d+)') {
    $transactionId = $matches[1]
    Write-Host "Extracted Transaction ID: $transactionId" -ForegroundColor Green
} else {
    $transactionId = 1
    Write-Host "Using default Transaction ID: $transactionId" -ForegroundColor Yellow
}

Test-API -Method "GET" -Url "http://localhost:8083/transaction/$transactionId" -Description "Retrieving transaction details"

# Test 4: Get booking details
Write-Host "`n=== Test 4: Get Booking Details ===" -ForegroundColor Magenta
Test-API -Method "GET" -Url "http://localhost:8081/booking/$bookingId" -Description "Retrieving booking details"

# Test 5: Error testing - Invalid payment mode
Write-Host "`n=== Test 5: Error Testing - Invalid Payment Mode ===" -ForegroundColor Magenta
$invalidPaymentBody = "{
    `"paymentMode`": `"INVALID`",
    `"bookingId`": $bookingId,
    `"upiId`": `"user@upi`",
    `"cardNumber`": null
}"

Test-API -Method "POST" -Url "http://localhost:8081/booking/$bookingId/transaction" -Body $invalidPaymentBody -Description "Testing invalid payment mode"

# Test 6: Error testing - Invalid booking ID
Write-Host "`n=== Test 6: Error Testing - Invalid Booking ID ===" -ForegroundColor Magenta
$invalidBookingBody = "{
    `"paymentMode`": `"UPI`",
    `"bookingId`": 999,
    `"upiId`": `"user@upi`",
    `"cardNumber`": null
}"

Test-API -Method "POST" -Url "http://localhost:8081/booking/999/transaction" -Body $invalidBookingBody -Description "Testing invalid booking ID"

# Test 7: Process payment with CARD
Write-Host "`n=== Test 7: Process Payment (CARD) ===" -ForegroundColor Magenta
$cardPaymentBody = "{
    `"paymentMode`": `"CARD`",
    `"bookingId`": $bookingId,
    `"upiId`": null,
    `"cardNumber`": `"1234567890123456`"
}"

Test-API -Method "POST" -Url "http://localhost:8081/booking/$bookingId/transaction" -Body $cardPaymentBody -Description "Processing CARD payment"

# Test 8: API Gateway testing
Write-Host "`n=== Test 8: API Gateway Testing ===" -ForegroundColor Magenta
$gatewayBookingBody = '{
    "fromDate": "2024-01-20",
    "toDate": "2024-01-22",
    "aadharNumber": "987654321098",
    "numOfRooms": 1
}'

Test-API -Method "POST" -Url "http://localhost:8080/booking" -Body $gatewayBookingBody -Description "Creating booking via API Gateway"

Write-Host "`n===============================================" -ForegroundColor Green
Write-Host "API Testing Completed!" -ForegroundColor Green
Write-Host "===============================================" -ForegroundColor Green

Write-Host "`nNext Steps:" -ForegroundColor Cyan
Write-Host "1. Check Eureka Dashboard: http://localhost:8761" -ForegroundColor White
Write-Host "2. Check Booking Service H2 Console: http://localhost:8081/h2-console" -ForegroundColor White
Write-Host "3. Check Payment Service H2 Console: http://localhost:8083/h2-console" -ForegroundColor White
Write-Host "4. Review console output for confirmation messages" -ForegroundColor White

Write-Host "`nPress any key to exit..." -ForegroundColor Gray
$null = $Host.UI.RawUI.ReadKey("NoEcho,IncludeKeyDown") 