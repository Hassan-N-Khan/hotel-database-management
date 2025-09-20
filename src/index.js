const express = require("express");
const app = express();
const cors = require("cors");
const pool = require("./db");
const format = require("pg-format");
const bodyParser = require('body-parser');

app.set('view engine', 'html');
app.engine('html', require('ejs').renderFile);

//middleware
app.use(cors());
app.use(express.json()); //req.body
app.use(bodyParser.urlencoded({ extended: true }));

//ROUTES//
app.get('/', (req, res) => {
  res.render('homepage')
});

app.get('/rooms', (req, res) => {
  res.render('customerSearch')
});

// search for rooms
app.post("/rooms", async (req, res) => {
  try {
    const start_date = req.body["start_date"]; // for booking/renting
    const end_date = req.body["end_date"]; // for booking/renting
    const capacity = req.body["capacity"];
    const area = req.body["area"]; // city from hotel table
    const chain = req.body["chain"];
    const category = req.body["category"]; //stars from hotel table
    const total_rooms = req.body["total_rooms"]; //total rooms from hotel table
    const price = req.body["price"];
    //console.log(start_date, end_date, capacity, area, chain, category, total_rooms, price);
    const searchRoom = await pool.query(
      `
      SELECT *
      FROM room
      INNER JOIN hotel ON room.hotel = hotel.hotel_id
      INNER JOIN hotel_chain ON hotel.chain = hotel_chain.name
      WHERE room.capacity >= $1
      AND hotel_chain.city = $2
      AND hotel_chain.name = $3
      AND hotel.category = $4
      AND hotel.number_rooms >= $5
      AND room.price <= $6
      `,
      [capacity, area, chain, category, total_rooms, price]
    );

    //res.json(searchRoom.rows[0]);
    res.render("rooms", { rooms: searchRoom.rows });
  } catch (err) {
    console.error(err.message);
  }
});

function dateDiffInDays(dateStr1, dateStr2) {
  const date1 = new Date(dateStr1);
  const date2 = new Date(dateStr2);

  // Calculate the difference in milliseconds
  const diffInMs = Math.abs(date2 - date1);

  // Convert the difference to days
  const diffInDays = diffInMs / (1000 * 60 * 60 * 24);

  return diffInDays;
}

// create a booking by room id
// values from search -> chain, hotel_id, room_id, start_date, end_date, price, room_no
// values from form -> customer info
// values calcualted -> total_price, status
app.post("/booking", async (req, res) => {
  try {
    const reference_id = 1;
    const start_date = req.body["start_date"];
    const end_date = req.body["end_date"];
    const chain = req.body["chain"];
    const hotel = req.body["hotel"];
    const room_number = req.body["room_number"];
    const room_id = req.body["room_id"];
    const customer = req.body["customer"];
    const total_price =
      req.body["total_price"] * dateDiffInDays(end_date, start_date);
    const status = "Booked";

    const booking_values = [
      [
        reference_id,
        chain,
        hotel,
        room_id,
        room_number,
        customer,
        start_date,
        end_date,
        total_price,
        status,
      ],
    ];

    const newBooking = await pool.query(
      format(
        "INSERT INTO booking \
        (reference_id, chain, hotel, room_id, room, customer, start_date, end_date, total_price, status) \
         VALUES %L RETURNING *",
        booking_values
      )
    );
    res.json(newBooking.rows[0]);
  } catch (err) {
    console.error(err.message);
  }
});

// see all bookings
app.get("/booking", async (req, res) => {
  try {
    const allBooking = await pool.query("SELECT * FROM booking");
    res.json(allBooking.rows);
  } catch (err) {
    console.error(err.message);
  }
});
// form to get payment info from customer
// booking to rent by reference id
app.post("/renting", async (req, res) => {
  try {
    const { reference_id, date, operator, card_number, expiry_date, CVV } =
      req.body;

    const bookingResult = await pool.query(
      "SELECT * FROM booking WHERE reference_id=$1",
      [reference_id]
    );
    const end_date = bookingResult.rows[0].end_date;
    const customer = bookingResult.rows[0].customer;
    const chain = bookingResult.rows[0].chain;
    const hotel = bookingResult.rows[0].hotel;
    const room_id = bookingResult.rows[0].room_id;
    const room = bookingResult.rows[0].room;
    const total_price = bookingResult.rows[0].total_price;
    const status = "Rented";

    const newRenting = await pool.query(
      "INSERT INTO renting (reference_id, date, end_date, customer, chain, hotel, room_id, room, total_price, status, operator, card_number, expiry_date, CVV) VALUES ($1, $2, $3, $4, $5, $6, $7, $8, $9, $10, $11, $12, $13, $14) RETURNING *",
      [
        reference_id,
        date,
        end_date,
        customer,
        chain,
        hotel,
        room_id,
        room,
        total_price,
        status,
        operator,
        card_number,
        expiry_date,
        CVV,
      ]
    );

    const moveToArchive = await pool.query(
      "INSERT INTO archives (reference_number, chain, hotel, room, customer_ssn, type, total_price) VALUES ($1, $2, $3, $4, $5, $6, $7) RETURNING *",
      [reference_id, chain, hotel, room, customer, "booking", total_price]
    );
    const removeFromBooking = await pool.query(
      "DELETE FROM booking WHERE reference_id = $1",
      [reference_id]
    );

    res.json(newRenting.rows[0]);
  } catch (err) {
    console.error(err.message);
    res.status(500).send("Server Error");
  }
});

// renting search then rent
app.get('/admin', async (req, res) => {
  try {
  // get all customers
  const allCustomers = await pool.query("SELECT * FROM customers");
    
  // get all employees
  const allEmployees = await pool.query("SELECT * FROM employees");

  // get all hotels
  const allHotels = await pool.query("SELECT * FROM hotel");

  // get all rooms
  const allRooms = await pool.query("SELECT * FROM room");

  res.render("crudAdmin", {allCustomers: allCustomers.rows, employees: allEmployees.rows, hotels:allHotels.rows, rooms: allRooms.rows});
  }catch (err) {
    console.error(err.message);
  }
});

// crud for customers //
// insert
app.get('/customers', (req, res) => {
  // Render the create customer form HTML
  res.render('createCustomer');
});

app.post("/customers", async (req, res) => {
  try {
    const SSN = req.body["SSN"];
    const first_name = req.body["first_name"];
    const middle_initial = req.body["middle_initial"];
    const last_name = req.body["last_name"];
    const street_name = req.body["street_name"];
    const street_number = req.body["street_number"];
    const city = req.body["city"];
    const postal_code = req.body["postal_code"];
    const country = req.body["country"];
    const registration_date = req.body["registration_date"];

    const customer_values = [
      [
        SSN,
        first_name,
        middle_initial,
        last_name,
        street_name,
        street_number,
        city,
        postal_code,
        country,
        registration_date,
      ],
    ];

    const newCustomer = await pool.query(
      format(
        "INSERT INTO customers \
        (SSN, first_name, middle_initial, last_name, street_name, \
         street_number, city, postal_code, country, registration_date) \
         VALUES %L RETURNING *",
        customer_values
      )
    );

    res.json(newCustomer.rows[0]);
    //res.send({redirect: '/admin'});
  } catch (err) {
    console.error(err.message);
  }
});

// update
app.get('/customers/:id', async (req, res) => {
  // Retrieve the customer details from the database
  id = req.params.id;
  const getCustomer = await pool.query("SELECT * FROM customers WHERE ssn = $1", [id]);

  // Render the update customer form HTML with the values pre-filled
  res.render("updateCustomer", { thisCustomer: getCustomer.rows });
});

app.post("/customers/:id", async (req, res) => {
  console.log("AA")
  try {
    const SSN = req.body["SSN"];
    const first_name = req.body["first_name"];
    const middle_initial = req.body["middle_initial"];
    const last_name = req.body["last_name"];
    const street_name = req.body["street_name"];
    const street_number = req.body["street_number"];
    const city = req.body["city"];
    const postal_code = req.body["postal_code"];
    const country = req.body["country"];
    const registration_date = req.body["registration_date"];

    const newCustomer = await pool.query(
      `UPDATE customers SET
       first_name = $1, middle_initial = $2, 
       last_name = $3, street_name = $4, 
       street_number = $5, city = $6, 
       postal_code = $7, country = $8,
       registration_date = $9 WHERE
       SSN = $10
      `,
      [
        first_name,
        middle_initial,
        last_name,
        street_name,
        street_number,
        city,
        postal_code,
        country,
        registration_date,
        SSN,
      ]
    );

    res.json("Customer Updated");
  } catch (err) {
    console.error(err.message);
  }
});

// delete by id
app.get("/customer/delete/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const song = await pool.query("DELETE FROM customers WHERE ssn = $1", [id]);
    res.json("Customer was deleted!");
  } catch (err) {
    console.log(err.message);
  }
});

// crud for employees //
// insert
app.post("/employees", async (req, res) => {
  try {
    const SSN = req.body["SSN"];
    const chain = req.body["chain"];
    const hotel = req.body["hotel"];
    const first_name = req.body["first_name"];
    const middle_initial = req.body["middle_initial"];
    const last_name = req.body["last_name"];
    const street_name = req.body["street_name"];
    const street_number = req.body["street_number"];
    const city = req.body["city"];
    const postal_code = req.body["postal_code"];
    const country = req.body["country"];

    const employee_values = [
      [
        SSN,
        chain,
        hotel,
        first_name,
        middle_initial,
        last_name,
        street_name,
        street_number,
        city,
        postal_code,
        country,
      ],
    ];

    const newEmployee = await pool.query(
      format(
        "INSERT INTO employees \
      (SSN, chain, hotel, first_name, middle_initial, last_name, street_name, \
       street_number, city, postal_code, country) \
       VALUES %L RETURNING *",
        employee_values
      )
    );

    res.json(newEmployee.rows[0]);
  } catch (err) {
    console.error(err.message);
  }
});

// update
app.put("/employees/:id", async (req, res) => {
  try {
    const id = req.params.id;
    const {
      chain,
      hotel,
      first_name,
      middle_initial,
      last_name,
      street_name,
      street_number,
      city,
      postal_code,
      country,
    } = req.body;
    const updatedEmployee = await pool.query(
      "UPDATE employees SET chain = $1, hotel = $2, first_name = $3, middle_initial = $4, last_name = $5, street_name = $6, street_number = $7, city = $8, postal_code = $9, country = $10 WHERE SSN = $11 RETURNING *",
      [
        chain,
        hotel,
        first_name,
        middle_initial,
        last_name,
        street_name,
        street_number,
        city,
        postal_code,
        country,
        id,
      ]
    );

    res.json("Employee Updated");
  } catch (err) {
    console.error(err.message);
  }
});

// delete by id
app.delete("/employees/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const song = await pool.query("DELETE FROM employees WHERE ssn = $1", [id]);
    res.json("Employee was deleted!");
  } catch (err) {
    console.log(err.message);
  }
});
// crud for hotels //
// insert
app.post("/hotel", async (req, res) => {
  try {
    const chain = req.body["chain"];
    const hotel_id = req.body["hotel_id"];
    const category = req.body["category"];
    const number_rooms = req.body["number_rooms"];
    const street_name = req.body["street_name"];
    const street_number = req.body["street_number"];
    const city = req.body["city"];
    const country = req.body["country"];
    const postal_code = req.body["postal_code"];
    const email = req.body["email"];
    const manager = req.body["manager"];
    const phone_number = req.body["phone_number"];

    const hotel_values = [
      [
        chain,
        hotel_id,
        category,
        number_rooms,
        street_name,
        street_number,
        city,
        country,
        postal_code,
        email,
        manager,
      ],
    ];

    const newHotel = await pool.query(
      format(
        "INSERT INTO hotel \
        (chain, hotel_id, category, number_rooms, street_name, \
         street_number, city, country, postal_code, email, manager) \
         VALUES %L RETURNING *",
        hotel_values
      )
    );

    res.json(newHotel.rows[0]);
  } catch (err) {
    console.error(err.message);
  }
});

// update
app.put("/hotel/:id", async (req, res) => {
  try {
    const hotel_id = req.params.id;
    const chain = req.body["chain"];
    const category = req.body["category"];
    const number_rooms = req.body["number_rooms"];
    const street_name = req.body["street_name"];
    const street_number = req.body["street_number"];
    const city = req.body["city"];
    const postal_code = req.body["postal_code"];
    const country = req.body["country"];
    const email = req.body["email"];
    const manager = req.body["manager"];

    const updateHotel = await pool.query(
      "UPDATE hotel SET chain = $1, category = $2, number_rooms = $3, \
      street_name = $4, street_number = $5, city = $6, postal_code = $7, \
      country = $8, email = $9, manager = $10 WHERE hotel_id = $11 RETURNING *",
      [
        chain,
        category,
        number_rooms,
        street_name,
        street_number,
        city,
        postal_code,
        country,
        email,
        manager,
        hotel_id,
      ]
    );

    res.json("Hotel Updated");
  } catch (err) {
    console.error(err.message);
  }
});

// delete by id
app.delete("/hotel/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const song = await pool.query("DELETE FROM hotel WHERE hotel_id = $1", [
      id,
    ]);
    res.json("Hotel was deleted!");
  } catch (err) {
    console.log(err.message);
  }
});

// crud for rooms //
// insert
app.post("/room", async (req, res) => {
  try {
    const room_id = req.body["room_id"];
    const chain = req.body["chain"];
    const hotel = req.body["hotel"];
    const room_no = req.body["room_no"];
    const price = req.body["price"];
    const amenities = req.body["amenities"];
    const capacity = req.body["capacity"];
    const view = req.body["view"];
    const extendable = req.body["extendable"];
    const damage = req.body["damage"];

    const room_values = [
      [
        room_id,
        chain,
        hotel,
        room_no,
        price,
        amenities,
        capacity,
        view,
        extendable,
        damage,
      ],
    ];

    const newRoom = await pool.query(
      format(
        "INSERT INTO room \
        (room_id, chain, hotel, room_no, price, amenities, \
         capacity, view, extendable, damage) VALUES %L RETURNING *",
        room_values
      )
    );

    res.json(newRoom.rows[0]);
  } catch (err) {
    console.error(err.message);
  }
});
// update by id
app.put("/room/:id", async (req, res) => {
  try {
    const room_id = req.body["room_id"];
    const chain = req.body["chain"];
    const hotel = req.body["hotel"];
    const room_no = req.body["room_no"];
    const price = req.body["price"];
    const amenities = req.body["amenities"];
    const capacity = req.body["capacity"];
    const view = req.body["view"];
    const extendable = req.body["extendable"];
    const damage = req.body["damage"];

    const newRoom = await pool.query(
      `UPDATE room SET
       chain = $1, hotel = $2, 
       room_no = $3, price = $4,
       amenities = $5, capacity = $6,
       view = $7, extendable = $8, 
       damage = $9 WHERE 
       room_id = $10`,
      [
        chain,
        hotel,
        room_no,
        price,
        amenities,
        capacity,
        view,
        extendable,
        damage,
        room_id,
      ]
    );

    res.json("Room Updated");
  } catch (err) {
    console.error(err.message);
  }
});

// delete by id
app.delete("/room/:id", async (req, res) => {
  try {
    const { id } = req.params;
    const song = await pool.query("DELETE FROM room WHERE room_id = $1", [id]);
    res.json("Room was deleted!");
  } catch (err) {
    console.log(err.message);
  }
});

app.listen(5000, () => {
  console.log("Server Started on Port 5000");
});
