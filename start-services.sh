#!/bin/bash

echo "Starting Sweet-Home Hotel Booking Microservices..."
echo

echo "Starting Eureka Server on port 8761..."
cd eureka-server && mvn spring-boot:run &
EUREKA_PID=$!
sleep 10

echo "Starting API Gateway on port 8080..."
cd ../api-gateway && mvn spring-boot:run &
GATEWAY_PID=$!
sleep 10

echo "Starting Booking Service on port 8081..."
cd ../booking-service && mvn spring-boot:run &
BOOKING_PID=$!
sleep 10

echo "Starting Payment Service on port 8083..."
cd ../payment-service && mvn spring-boot:run &
PAYMENT_PID=$!
sleep 10

echo
echo "All services are starting..."
echo
echo "Eureka Dashboard: http://localhost:8761"
echo "API Gateway: http://localhost:8080"
echo "Booking Service: http://localhost:8081"
echo "Payment Service: http://localhost:8083"
echo
echo "Check test-api.md for testing instructions"
echo
echo "Press Ctrl+C to stop all services"
echo

# Wait for user to stop services
trap "echo 'Stopping all services...'; kill $EUREKA_PID $GATEWAY_PID $BOOKING_PID $PAYMENT_PID; exit" INT
wait 