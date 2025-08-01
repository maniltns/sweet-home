@echo off
echo ===============================================
echo Sweet-Home Hotel Booking API Test Script
echo ===============================================
echo.

echo Starting API tests...
echo.

echo === Test 1: Create Booking ===
echo Creating a new booking...
curl -X POST http://localhost:8081/booking -H "Content-Type: application/json" -d "{\"fromDate\": \"2024-01-15\", \"toDate\": \"2024-01-17\", \"aadharNumber\": \"123456789012\", \"numOfRooms\": 2}"
echo.
echo.

echo === Test 2: Process Payment (UPI) ===
echo Processing UPI payment...
curl -X POST http://localhost:8081/booking/1/transaction -H "Content-Type: application/json" -d "{\"paymentMode\": \"UPI\", \"bookingId\": 1, \"upiId\": \"user@upi\", \"cardNumber\": null}"
echo.
echo.

echo === Test 3: Get Transaction Details ===
echo Retrieving transaction details...
curl -X GET http://localhost:8083/transaction/1
echo.
echo.

echo === Test 4: Get Booking Details ===
echo Retrieving booking details...
curl -X GET http://localhost:8081/booking/1
echo.
echo.

echo === Test 5: Error Testing - Invalid Payment Mode ===
echo Testing invalid payment mode...
curl -X POST http://localhost:8081/booking/1/transaction -H "Content-Type: application/json" -d "{\"paymentMode\": \"INVALID\", \"bookingId\": 1, \"upiId\": \"user@upi\", \"cardNumber\": null}"
echo.
echo.

echo === Test 6: Error Testing - Invalid Booking ID ===
echo Testing invalid booking ID...
curl -X POST http://localhost:8081/booking/999/transaction -H "Content-Type: application/json" -d "{\"paymentMode\": \"UPI\", \"bookingId\": 999, \"upiId\": \"user@upi\", \"cardNumber\": null}"
echo.
echo.

echo === Test 7: Process Payment (CARD) ===
echo Processing CARD payment...
curl -X POST http://localhost:8081/booking/1/transaction -H "Content-Type: application/json" -d "{\"paymentMode\": \"CARD\", \"bookingId\": 1, \"upiId\": null, \"cardNumber\": \"1234567890123456\"}"
echo.
echo.

echo === Test 8: API Gateway Testing ===
echo Creating booking via API Gateway...
curl -X POST http://localhost:8080/booking -H "Content-Type: application/json" -d "{\"fromDate\": \"2024-01-20\", \"toDate\": \"2024-01-22\", \"aadharNumber\": \"987654321098\", \"numOfRooms\": 1}"
echo.
echo.

echo ===============================================
echo API Testing Completed!
echo ===============================================
echo.

echo Next Steps:
echo 1. Check Eureka Dashboard: http://localhost:8761
echo 2. Check Booking Service H2 Console: http://localhost:8081/h2-console
echo 3. Check Payment Service H2 Console: http://localhost:8083/h2-console
echo 4. Review console output for confirmation messages
echo.

pause 