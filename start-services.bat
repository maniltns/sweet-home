@echo off
echo Starting Sweet-Home Hotel Booking Microservices...
echo.

echo Starting Eureka Server on port 8761...
start "Eureka Server" cmd /k "cd eureka-server && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo Starting API Gateway on port 8080...
start "API Gateway" cmd /k "cd api-gateway && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo Starting Booking Service on port 8081...
start "Booking Service" cmd /k "cd booking-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo Starting Payment Service on port 8083...
start "Payment Service" cmd /k "cd payment-service && mvn spring-boot:run"
timeout /t 10 /nobreak > nul

echo.
echo All services are starting...
echo.
echo Eureka Dashboard: http://localhost:8761
echo API Gateway: http://localhost:8080
echo Booking Service: http://localhost:8081
echo Payment Service: http://localhost:8083
echo.
echo Check test-api.md for testing instructions
echo.
pause 