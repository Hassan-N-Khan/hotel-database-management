# Hotel Management System
CSI2132
## Requirements

-   [node & npm](https://nodejs.org/en/)
-   [express.js](https://expressjs.com/)
-   [git](https://www.robinwieruch.de/git-essential-commands/)
-   [PostgreSQL](https://www.postgresql.org/)

## Installation

-   `cd csi2132/src`
-   `npm install`
-   `node index.js`
-   navigate to `http://localhost:5000/`

## Install DB

- Run all commands within `src/db.sql` within your `dbproject` database inside PostgreSQL.

# Curl Commands
## Rooms

### Searching for Rooms

`bash
curl -X POST \
  -H "Content-type: application/json" \
  -H "Accept: application/json" \
  -d '{"start_date":"2023-04-10", "end_date":"2023-04-11", "capacity":"2", "area":"New York", "chain":"Marriott", "category":"3", "total_rooms":"5", "price":"200" }' \
  "http://localhost:5000/rooms"
`

### Booking Room

`bash
curl -X POST \
-H "Content-Type: application/json" \
-d '{
"reference_id": "1",
"chain": "Marriott",
"hotel": 95827154,
"room_id": 31941119,
"room_number": 1001,
"customer": 313348392295129,
"start_date": "2023-06-01",
"end_date": "2023-06-07",
"total_price": 950.00,
"status": "confirmed"
}' \
http://localhost:5000/booking
`

### Renting Room

`curl -H "Content-Type: application/json" -X POST -d '{
"reference_id": 1,
"date": "2022-05-01",
"operator": 98602908,
"card_number": 1234567890123456,
"expiry_date": 2504,
"CVV": 123
}' http://localhost:5000/renting`

### Creating Room

`curl -H "Content-Type: application/json" -X POST -d '{
"room_id": "313348",
"chain": "Marriott",
"hotel": "95827154",
"room_no": "105",
"price": "250.00",
"amenities": "Wifi",
"capacity": "2",
"view": "City View",
"extendable": "true",
"damage":"None"
}' http://localhost:5000/room`

### Updating Room

`curl -H 'Content-Type: application/json' -X PUT -d '{
"room_id": "313348",
"chain": "Marriott",
"hotel": "95827154",
"room_no": "105",
"price": "250.00",
"amenities": "Wifi",
"capacity": "4",
"view": "City View",
"extendable": "true",
"damage":"None"
}' \
 http://localhost:5000/room/313348`

### Deleting Room

`curl -X DELETE http://localhost:5000/room/313348`

## Customers

### Creating Customer

`curl -H "Content-Type: application/json" -X POST -d '{
"SSN": "1334832295129",
"first_name": "Grena",
"middle_initial": "B",
"last_name": "Doe",
"street_name": "Main St",
"street_number": "123",
"city": "New York",
"postal_code": "13524",
"country": "USA",
"registration_date":"2022-01-01"
}' http://localhost:5000/customers`

### Updating Customer

`curl -H 'Content-Type: application/json' -X PUT -d '{
"SSN": "313348392295129",
"first_name": "John",
"middle_initial": "A",
"last_name": "Doe",
"street_name": "Main St",
"street_number": "123",
"city": "New York",
"postal_code": "13524",
"country": "USA",
"registration_date":"2022-01-01"
}' http://localhost:5000/customers/313348392295129`

### Deleting Customer

`curl -X DELETE http://localhost:5000/customer/313348392295129`

## Employees

### Creating Employee

`curl -H "Content-Type: application/json" -X POST -d '{
"SSN": "123456789",
"chain": "Marriott",
"hotel": "95827154",
"first_name": "John",
"middle_initial": "A",
"last_name": "Doe",
"street_name": "Main St",
"street_number": "123",
"city": "New York",
"postal_code": "13524",
"country": "USA"
}' http://localhost:5000/employees`

### Updating Employee

`curl -H "Content-Type: application/json" -X PUT -d '{
"chain": "Marriott",
"hotel": "2",
"first_name": "Jane",
"middle_initial": "B",
"last_name": "Smith",
"street_name": "Elm St",
"street_number": "456",
"city": "Los Angeles",
"postal_code": "90210",
"country": "USA",
"SSN": "313348392295129"
}' http://localhost:5000/employees/313348392295129`

### Deleting Employee

`curl -X DELETE http://localhost:5000/employees/123456789`

## Hotel

### Creating Hotel

`curl -H "Content-Type: application/json" -X POST -d '{
"chain": "Marriott",
"hotel_id": 12345,
"category": 4,
"number_rooms": 200,
"street_name": "Broadway",
"street_number": 123,
"city": "New York",
"postal_code": "10019",
"country": "USA",
"email": "info@marriott.com",
"manager": "13415974",
"phone_number": "12334134"
}' http://localhost:5000/hotel`

### Updating Hotel

`curl -H "Content-Type: application/json" -X PUT -d '{
"chain": "Marriott",
"hotel_id": 12345,
"category": 4,
"number_rooms": 200,
"street_name": "Broadway",
"street_number": 123,
"city": "New York",
"postal_code": "10019",
"country": "USA",
"email": "info@marriott.com",
"manager": "13415974",
"phone_number": "12334134"
}' http://localhost:5000/hotel/12345`

### Deleting Hotel

`curl -X DELETE http://localhost:5000/hotel/12345`

## Checklist
- [x] Search for Room
- [x] CRUD for Customers, Employees, Hotels, Rooms
- [X] Customer Booking
- [X] Employee Renting
- [X] Employee Customer Payment
# hotel-database-management
