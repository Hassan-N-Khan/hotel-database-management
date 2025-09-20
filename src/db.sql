CREATE TABLE hotel_chain(
    name VARCHAR(20) NOT NULL,
    street_name VARCHAR(20) NOT NULL,
    street_number INTEGER NOT NULL,
    city VARCHAR(20) NOT NULL,
    country VARCHAR(20) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
    number_hotels INTEGER NOT NULL,
    email VARCHAR(40) NOT NULL,
    PRIMARY KEY(name)
);

CREATE TABLE hotel(
    chain VARCHAR(20) NOT NULL,
    hotel_id INTEGER NOT NULL,
    category INTEGER NOT NULL,
    number_rooms INTEGER NOT NULL,
    street_name VARCHAR(20),
    street_number INTEGER NOT NULL,
    city VARCHAR(20) NOT NULL,
    country VARCHAR(20) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
    email VARCHAR(40) NOT NULL,
    manager BIGINT NOT NULL,
    PRIMARY KEY(hotel_id),
    FOREIGN KEY(chain) REFERENCES hotel_chain(name),
	CHECK (category in (1,2,3,4,5))
);

CREATE TABLE employees(
    SSN BIGINT NOT NULL,
    chain VARCHAR(20) NOT NULL,
    hotel INTEGER NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    middle_initial VARCHAR(4),
    last_name VARCHAR(20) NOT NULL,
    street_name VARCHAR(20) NOT NULL,
    street_number INTEGER NOT NULL,
    city VARCHAR(20) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
    country VARCHAR(20) NOT NULL,
    PRIMARY KEY(SSN),
    FOREIGN KEY(chain) REFERENCES hotel_chain(name),
    FOREIGN KEY(hotel) REFERENCES hotel(hotel_id)
);

CREATE TABLE manager(
    manager BIGINT NOT NULL,
    hotel INTEGER NOT NULL,
    PRIMARY KEY(manager),
    FOREIGN KEY(manager) REFERENCES employees(SSN),
    FOREIGN KEY(hotel) REFERENCES hotel(hotel_id)
);

CREATE TABLE customers(
    SSN BIGINT NOT NULL,
    first_name VARCHAR(20) NOT NULL,
    middle_initial VARCHAR(4),
    last_name VARCHAR(20) NOT NULL,
    street_name VARCHAR(20) NOT NULL,
    street_number INTEGER NOT NULL,
    city VARCHAR(20) NOT NULL,
    postal_code VARCHAR(6) NOT NULL,
    country VARCHAR(20) NOT NULL,
    registration_date DATE NOT NULL,
    PRIMARY KEY(SSN)
);

CREATE TABLE room(
    room_id BIGINT NOT NULL,
    chain VARCHAR(20) NOT NULL,
    hotel INTEGER NOT NULL,
    room_no INTEGER NOT NULL,
    price DECIMAL(5,2) NOT NULL,
    amenities VARCHAR(20) NOT NULL,
    capacity INTEGER NOT NULL,
    view VARCHAR(20) NOT NULL,
    extendable BOOLEAN NOT NULL,
    damage VARCHAR(20) NOT NULL,
    PRIMARY KEY(room_id),
    FOREIGN KEY(chain) REFERENCES hotel_chain(name),
    FOREIGN KEY(hotel) REFERENCES hotel(hotel_id),
	CHECK (view in ('City View','Mountain View','Sea View','None'))
);

CREATE INDEX room_index ON room(room_id);

CREATE TABLE booking(
    reference_id BIGINT NOT NULL,
    chain VARCHAR(20) NOT NULL,
    hotel INTEGER NOT NULL,
    room_id BIGINT NOT NULL,
    room INTEGER NOT NULL,
    customer BIGINT NOT NULL,
    start_date DATE NOT NULL,
    end_date DATE NOT NULL,
    total_price DECIMAL(8,2) NOT NULL,
    status VARCHAR(20) NOT NULL,
    PRIMARY KEY(reference_id),
    FOREIGN KEY(chain) REFERENCES hotel_chain(name),
    FOREIGN KEY(hotel) REFERENCES hotel(hotel_id),
    FOREIGN KEY(room_id) REFERENCES room(room_id),
    FOREIGN KEY(customer) REFERENCES customers(SSN)
);

CREATE INDEX booking_index ON booking(reference_id);

CREATE TABLE renting(
  reference_id BIGINT NOT NULL,
  date DATE NOT NULL,
  end_date DATE NOT NULL,
  customer BIGINT NOT NULL,
  chain VARCHAR(20) NOT NULL,
  hotel BIGINT NOT NULL,
  room_id BIGINT NOT NULL,
  room INTEGER NOT NULL,
  total_price DECIMAL(7,2) NOT NULL,
  status VARCHAR(20) NOT NULL,
  operator BIGINT NOT NULL,
  card_number BIGINT NOT NULL,
  expiry_date SMALLINT NOT NULL,
  CVV SMALLINT NOT NULL,
  PRIMARY KEY(reference_id),
  FOREIGN KEY(customer) REFERENCES customers(SSN),
  FOREIGN KEY(chain) REFERENCES hotel_chain(name),
  FOREIGN KEY(hotel) REFERENCES hotel(hotel_id),
  FOREIGN KEY(room_id) REFERENCES room(room_id),
  FOREIGN KEY(operator) REFERENCES employees(SSN)
);

CREATE INDEX renting_index ON renting(reference_id);

CREATE TABLE positions(
  role VARCHAR(20) NOT NULL,
  employee BIGINT NOT NULL,
  PRIMARY KEY(employee,role),
  FOREIGN KEY(employee) REFERENCES employees(SSN)
);

CREATE TABLE phone_number_chain(
  chain_name VARCHAR(20) NOT NULL,
  phone BIGINT NOT NULL,
  PRIMARY KEY(chain_name, phone),
  FOREIGN KEY(chain_name) REFERENCES hotel_chain(name)
);

CREATE TABLE phone_number_hotel(
  hotel_id BIGINT NOT NULL,
  chain VARCHAR(20) NOT NULL,
  phone BIGINT NOT NULL,
  PRIMARY KEY(chain, hotel_id, phone),
  FOREIGN KEY(hotel_id) REFERENCES hotel(hotel_id),
  FOREIGN KEY(chain) REFERENCES hotel_chain(name)
);

CREATE TABLE archives(
  reference_number BIGINT NOT NULL,
  chain VARCHAR(20) NOT NULL,
  hotel BIGINT NOT NULL,
  room INTEGER NOT NULL,
  customer_ssn BIGINT NOT NULL,
  type VARCHAR(20) NOT NULL,
  total_price DECIMAL(7,2) NOT NULL,
  PRIMARY KEY(reference_number),
  CHECK (type in ('booking','renting'))
);
CREATE INDEX archives_index ON archives(reference_number);


INSERT INTO hotel_chain (name, street_name, street_number, city, country, postal_code, number_hotels, email)
VALUES 
('Marriott', 'Main St', 123, 'New York', 'USA', '10001', 50, 'marriott@example.com'),
('Hilton', 'Park Ave', 456, 'Los Angeles', 'USA', '90001', 35, 'hilton@example.com'),
('Hyatt', 'Broadway', 789, 'Chicago', 'USA', '60601', 25, 'hyatt@example.com'),
('InterContinental', 'Oxford St', 101, 'London', 'UK', 'W1D2EH', 20, 'intercon@example.com'),
('Accor', 'Champs-Élysées', 22, 'Paris', 'France', '75008', 30, 'accor@example.com');

--Marriott hotels
INSERT INTO hotel (chain, hotel_id, category, number_rooms, street_name, street_number, city, country, postal_code, email, manager)
VALUES 
('Marriott', 95827154, 4, 200, 'Main St', 123, 'New York', 'USA', '10001', 'marriott_ny@example.com', 88647418),
('Marriott', 08446973, 3, 150, 'Broadway', 456, 'Los Angeles', 'USA', '90001', 'marriott_la@example.com', 96299438),
('Marriott', 36040509, 5, 300, 'Rodeo Dr', 789, 'Chicago', 'USA', '60601', 'marriott_chicago@example.com', 76994757),
('Marriott', 10751872, 4, 250, 'Sunset Blvd', 234, 'Miami', 'USA', '33131', 'marriott_miami@example.com', 39428873),
('Marriott', 06763842, 3, 100, 'Michigan Ave', 678, 'San Francisco', 'USA', '94105', 'marriott_sf@example.com', 13415974),
('Marriott', 33402978, 4, 220, 'Pico Blvd', 101, 'London', 'UK', 'W1D2EH', 'marriott_london@example.com', 52789598),
('Marriott', 57412031, 3, 180, 'Champs-Elysees', 22, 'Paris', 'France', '75008', 'marriott_paris@example.com', 41519931),
('Marriott', 34678491, 5, 350, 'Rue de Rivoli', 55, 'Dubai', 'UAE', '12345', 'marriott_dubai@example.com', 46746134);

--Hilton hotels
INSERT INTO hotel (chain, hotel_id, category, number_rooms, street_name, street_number, city, country, postal_code, email, manager)
VALUES 
('Hilton', 65517409, 4, 200,'Thomas St', 123, 'New York', 'USA', '10001', 'hilton_ny@example.com', 00347830),
('Hilton', 79796065, 3, 150, 'Glenlake Lane', 456, 'Los Angeles', 'USA', '90001', 'hilton_la@example.com', 26222744),
('Hilton', 61286078, 5, 300, 'Second Lane', 789, 'Chicago', 'USA', '60601', 'hilton_chicago@example.com', 51742409),
('Hilton', 87727206, 4, 250,'Elmwood Dr.', 234, 'Miami', 'USA', '33131', 'hilton_miami@example.com', 44568289),
('Hilton', 26980996, 3, 100, 'North Warren Court', 678, 'San Francisco', 'USA', '94105', 'hilton_sf@example.com', 25781332),
('Hilton', 76139352, 4, 220, 'West Creekside Ave.', 101, 'London', 'UK', 'W1D2EH', 'hilton_london@example.com', 69145679),
('Hilton', 90570691, 3, 180, 'Cherry Lane', 22, 'Paris', 'France', '75008', 'hilton_paris@example.com', 51833796),
('Hilton', 85570302, 5, 350, 'Wayne Dr.', 55, 'Dubai', 'UAE', '12345', 'hilton_dubai@example.com', 53244266);

--Hyaat Hotels 
INSERT INTO hotel (chain, hotel_id, category, number_rooms, street_name, street_number, city, country, postal_code, email, manager)
VALUES 
('Hyatt', 31051950, 5, 250, 'Thomas St', 500, 'New York', 'USA', '10001', 'hyattNY@example.com', 36040120),
('Hyatt', 23998234, 4, 150, 'Broadway', 245, 'Los Angeles', 'USA', 90001, 'hyattLA@example.com', 65388419),
('Hyatt', 34700560, 3, 100, '1st Avenue', 100, 'Seattle', 'USA', '98101', 'hyattSeattle@example.com', 40579529),
('Hyatt', 82557885, 4, 200, 'East Main Street', 123, 'Louisville', 'USA', '40202', 'hyattLouisville@example.com', 79799696),
('Hyatt', 90814450, 5, 300, 'Madison Avenue', 725, 'New York', 'USA', '10022', 'hyattNYC@example.com', 24319469),
('Hyatt', 60982967, 3, 120, 'Market Street', 625, 'San Francisco', 'USA', '94105', 'hyattSF@example.com', 02213112),
('Hyatt', 02551594, 4, 175, '5th Avenue', 660, 'New York', 'USA', '10019', 'hyattCentralPark@example.com', 12905481),
('Hyatt', 48593988, 3, 90, 'Westlake Avenue', 1100, 'Seattle', 'USA', '98109', 'hyattSeattleCenter@example.com', 11870969);

--InterContinental Hotels

INSERT INTO hotel (chain, hotel_id, category, number_rooms, street_name, street_number, city, country, postal_code, email, manager)
VALUES
('InterContinental', 04703837, 5, 200, '5th Avenue', 600, 'New York', 'USA', '10019', 'NY@intercon.com', 83120834),
('InterContinental', 83430392, 4, 150, 'Kings Road', 5, 'London', 'UK', 'SW35UZ', 'kingsroad@intercon.com', 80396709),
('InterContinental', 08768076, 3, 100, 'High Holborn', 50, 'London', 'UK', 'WC17EN', 'holborn@intercon.com', 82073795),
('InterContinental', 35131214, 5, 300, 'Park Street', 12, 'Paris', 'France', '75016', 'paris@intercon.com', 22640895),
('InterContinental', 59044366, 4, 180, 'Rue Saint-Honoré', 10, 'Paris', 'France', '75001', 'sainthonore@intercon.com', 63439143),
('InterContinental', 43376982, 3, 90, 'Rue de Rivoli', 19, 'Paris', 'France', '75001', 'rivoli@intercon.com', 99596692),
('InterContinental', 43134891, 5, 250, 'Friedrichstraße', 31, 'Berlin', 'Germany', '10117', 'berlin@intercon.com', 85326110),
('InterContinental', 10654082, 4, 160, 'Unter den Linden', 77, 'Berlin', 'Germany', '10117', 'linden@intercon.com', 30062498);

--Accor Hotels
INSERT INTO hotel(chain, hotel_id, category, number_rooms, street_name, street_number, city, country, postal_code, email, manager)
VALUES
('Accor', 99297537, 4, 200, 'Rue de Rivoli', 1, 'Paris', 'France', '75001', 'hotel1@accor.com', 18117701),
('Accor', 62877537, 3, 150, 'Avenue des Ternes', 6, 'Paris', 'France', '75017', 'hotel2@accor.com', 21037994),
('Accor', 39182237, 5, 300, 'Main St', 65, 'Paris', 'France', '75016', 'hotel3@accor.com', 55441884),
('Accor', 81193855, 2, 100, 'Rue Saint-Antoine', 100, 'Paris', 'France', '75004', 'hotel4@accor.com', 99404680),
('Accor', 59764826, 4, 150, 'Kings Road', 25, 'London', 'UK', 'SW35UZ', 'hotel5@accor.com', 66986801),
('Accor', 57932618, 3, 120, 'Rue de Rivoli', 39, 'Paris', 'France', '75001', 'hotel6@accor.com', 12699662),
('Accor', 26760936, 5, 350, 'Rue Saint-Honoré', 228, 'Paris', 'France', '75001', 'hotel7@accor.com', 59094792),
('Accor', 20034961, 2, 160, 'Friedrichstraße', 148, 'Berlin', 'Germany', '10117', 'hotel8@accor.com', 31941119);


--rooms for Marriott
INSERT INTO room (room_id, chain, hotel, room_no, price, amenities, capacity, view, extendable, damage)
VALUES
(31941119, 'Marriott', 06763842, 1001, 250.00, 'WiFi', 2, 'City View', true, 'None'),
(41601286, 'Marriott', 06763842, 1002, 275.00, 'WiFi, TV', 3, 'Sea View', true, 'None'),
(89515437, 'Marriott', 06763842, 1003, 300.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(05440864, 'Marriott', 06763842, 1004, 350.00, 'WiFi, TV, Safe', 5, 'Mountain View', false, 'None'),
(67498750, 'Marriott', 06763842, 1005, 400.00, 'WiFi, TV, Balcony', 6, 'Sea View', true, 'None'),

(32549934, 'Marriott', 08446973, 1006, 150.00, 'WiFi', 2, 'City View', true, 'None'),
(57437331, 'Marriott', 08446973, 1007, 175.00, 'WiFi, TV', 3, 'Mountain View', true, 'None'),
(07120657, 'Marriott', 08446973, 1008, 200.00, 'WiFi, TV, Safe', 4, 'Mountain View', false, 'None'),
(80734195, 'Marriott', 08446973, 1009, 225.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(73196129, 'Marriott', 08446973, 1010, 250.00, 'WiFi, TV, Safe', 6, 'City View', true, 'None'),

(81105936, 'Marriott', 10751872, 1011, 400.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(30472547, 'Marriott', 10751872, 1012, 450.00, 'WiFi, TV, Jacuzzi', 3, 'Sea View', true, 'None'),
(67938725, 'Marriott', 10751872, 1013, 500.00, 'WiFi, Jacuzzi', 4, 'Sea View', false, 'None'),
(29391678, 'Marriott', 10751872, 1014, 550.00, 'WiFi, TV, Balcony', 5, 'City View', true, 'None'),
(63474023, 'Marriott', 10751872, 1015, 600.00, 'WiFi', 6, 'Mountain View', false, 'None'),

(19219533, 'Marriott', 33402978, 2001, 200.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(75593469, 'Marriott', 33402978, 2002, 220.00, 'WiFi, TV, Jacuzzi', 3, 'City View', false, 'None'),
(98393576, 'Marriott', 33402978, 2003, 240.00, 'WiFi, TV, minibar', 4, 'Mountain View', false, 'None'),
(48457669, 'Marriott', 33402978, 2004, 260.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(64001789, 'Marriott', 33402978, 2005, 280.00, 'WiFi, TV', 6, 'City View', true, 'None'),

(40838300, 'Marriott', 34678491, 2006, 100.00, 'WiFi, TV', 1, 'City View', false, 'None'),
(27497489, 'Marriott', 34678491, 2007, 120.00, 'WiFi, TV, Balcony', 2, 'Mountain View', false, 'None'),
(96317394, 'Marriott', 34678491, 2008, 140.00, 'WiFi, TV, Safe', 3, 'Mountain View', true, 'None'),
(21252205, 'Marriott', 34678491, 2009, 160.00, 'WiFi, TV, Balcony', 4, 'City View', true, 'None'),
(67006933, 'Marriott', 34678491, 2010, 180.00, 'WiFi, TV, minibar', 5, 'Sea View', true, 'None'),

(55852970, 'Marriott', 36040509, 2011, 300.00, 'WiFi, TV, balcony', 1, 'City View', true, 'None'),
(08352468, 'Marriott', 36040509, 2012, 320.00, 'WiFi, TV, minibar', 2, 'Sea View', true, 'None'),
(84524459, 'Marriott', 36040509, 2013, 340.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(61240565, 'Marriott', 36040509, 2014, 360.00, 'WiFi, TV, Safe', 4, 'City View', true, 'None'),
(98632948, 'Marriott', 36040509, 2015, 380.00, 'WiFi, TV, balcony', 5, 'Mountain View', false, 'None'),

(68208562, 'Marriott', 57412031, 3001, 300.00, 'WiFi, TV, balcony', 2, 'City View', true, 'None'),
(51455058, 'Marriott', 57412031, 3002, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(98916888, 'Marriott', 57412031, 3003, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', true, 'None'),
(59332612, 'Marriott', 57412031, 3004, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(20375016, 'Marriott', 57412031, 3005, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None'),

(77471651, 'Marriott', 95827154, 3006, 300.00, 'WiFi, TV, minibar', 2, 'City View', true, 'None'),
(40699750, 'Marriott', 95827154, 3007, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(00836068, 'Marriott', 95827154, 3008, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(05891286, 'Marriott', 95827154, 3009, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(63720166, 'Marriott', 95827154, 3010, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None');

--rooms for InterContinental
INSERT INTO room (room_id, chain, hotel, room_no, price, amenities, capacity, view, extendable, damage)
VALUES
(09745503, 'InterContinental', 04703837, 1001, 250.00, 'WiFi', 2, 'City View', true, 'None'),
(82383414, 'InterContinental', 04703837, 1002, 275.00, 'WiFi, TV', 3, 'Sea View', true, 'None'),
(28119602, 'InterContinental', 04703837, 1003, 300.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(15165860, 'InterContinental', 04703837, 1004, 350.00, 'WiFi, TV, Safe', 5, 'Mountain View', false, 'None'),
(48802417, 'InterContinental', 04703837, 1005, 400.00, 'WiFi, TV, Balcony', 6, 'Sea View', true, 'None'),

(31771688, 'InterContinental', 08768076, 1006, 150.00, 'WiFi', 2, 'City View', true, 'None'),
(87164880, 'InterContinental', 08768076, 1007, 175.00, 'WiFi, TV', 3, 'Mountain View', true, 'None'),
(19879942, 'InterContinental', 08768076, 1008, 200.00, 'WiFi, TV, Safe', 4, 'Mountain View', false, 'None'),
(28349469, 'InterContinental', 08768076, 1009, 225.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(85385646, 'InterContinental', 08768076, 1010, 250.00, 'WiFi, TV, Safe', 6, 'City View', true, 'None'),

(46996715, 'InterContinental', 10654082, 1011, 400.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(36366552, 'InterContinental', 10654082, 1012, 450.00, 'WiFi, TV, Jacuzzi', 3, 'Sea View', true, 'None'),
(07623978, 'InterContinental', 10654082, 1013, 500.00, 'WiFi, Jacuzzi', 4, 'Sea View', false, 'None'),
(44275495, 'InterContinental', 10654082, 1014, 550.00, 'WiFi, TV, Balcony', 5, 'City View', true, 'None'),
(06025173, 'InterContinental', 10654082, 1015, 600.00, 'WiFi', 6, 'Mountain View', false, 'None'),

(98593170, 'InterContinental', 35131214, 2001, 200.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(74273776, 'InterContinental', 35131214, 2002, 220.00, 'WiFi, TV, Jacuzzi', 3, 'City View', false, 'None'),
(10437670, 'InterContinental', 35131214, 2003, 240.00, 'WiFi, TV, minibar', 4, 'Mountain View', false, 'None'),
(18307480, 'InterContinental', 35131214, 2004, 260.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(67443401, 'InterContinental', 35131214, 2005, 280.00, 'WiFi, TV', 6, 'City View', true, 'None'),

(00239384, 'InterContinental', 43134891, 2006, 100.00, 'WiFi, TV', 1, 'City View', false, 'None'),
(14460372, 'InterContinental', 43134891, 2007, 120.00, 'WiFi, TV, Balcony', 2, 'Mountain View', false, 'None'),
(16244716, 'InterContinental', 43134891, 2008, 140.00, 'WiFi, TV, Safe', 3, 'Mountain View', true, 'None'),
(92263179, 'InterContinental', 43134891, 2009, 160.00, 'WiFi, TV, Balcony', 4, 'City View', true, 'None'),
(73629605, 'InterContinental', 43134891, 2010, 180.00, 'WiFi, TV, minibar', 5, 'Sea View', true, 'None'),

(85237590, 'InterContinental', 43376982, 2011, 300.00, 'WiFi, TV, balcony', 1, 'City View', true, 'None'),
(30466129, 'InterContinental', 43376982, 2012, 320.00, 'WiFi, TV, minibar', 2, 'Sea View', true, 'None'),
(07893104, 'InterContinental', 43376982, 2013, 340.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(00292535, 'InterContinental', 43376982, 2014, 360.00, 'WiFi, TV, Safe', 4, 'City View', true, 'None'),
(43313061, 'InterContinental', 43376982, 2015, 380.00, 'WiFi, TV, balcony', 5, 'Mountain View', false, 'None'),

(40978669, 'InterContinental', 59044366, 3001, 300.00, 'WiFi, TV, balcony', 2, 'City View', true, 'None'),
(12542557, 'InterContinental', 59044366, 3002, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(27101576, 'InterContinental', 59044366, 3003, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', true, 'None'),
(18651472, 'InterContinental', 59044366, 3004, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(91693458, 'InterContinental', 59044366, 3005, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None'),

(39621453, 'InterContinental', 83430392, 3006, 300.00, 'WiFi, TV, minibar', 2, 'City View', true, 'None'),
(82480204, 'InterContinental', 83430392, 3007, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(03298424, 'InterContinental', 83430392, 3008, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(64614991, 'InterContinental', 83430392, 3009, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(39059477, 'InterContinental', 83430392, 3010, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None');

--rooms for Hyatt
INSERT INTO room (room_id, chain, hotel, room_no, price, amenities, capacity, view, extendable, damage)
VALUES
(70443001, 'Hyatt', 02551594, 1001, 250.00, 'WiFi', 2, 'City View', true, 'None'),
(14392791, 'Hyatt', 02551594, 1002, 275.00, 'WiFi, TV', 3, 'Sea View', true, 'None'),
(01495416, 'Hyatt', 02551594, 1003, 300.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(27529540, 'Hyatt', 02551594, 1004, 350.00, 'WiFi, TV, Safe', 5, 'Mountain View', false, 'None'),
(00171810, 'Hyatt', 02551594, 1005, 400.00, 'WiFi, TV, Balcony', 6, 'Sea View', true, 'None'),

(12275658, 'Hyatt', 23998234, 1006, 150.00, 'WiFi', 2, 'City View', true, 'None'),
(94754653, 'Hyatt', 23998234, 1007, 175.00, 'WiFi, TV', 3, 'Mountain View', true, 'None'),
(17734419, 'Hyatt', 23998234, 1008, 200.00, 'WiFi, TV, Safe', 4, 'Mountain View', false, 'None'),
(84548983, 'Hyatt', 23998234, 1009, 225.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(37910346, 'Hyatt', 23998234, 1010, 250.00, 'WiFi, TV, Safe', 6, 'City View', true, 'None'),

(94655484, 'Hyatt', 31051950, 1011, 400.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(70926806, 'Hyatt', 31051950, 1012, 450.00, 'WiFi, TV, Jacuzzi', 3, 'Sea View', true, 'None'),
(56607193, 'Hyatt', 31051950, 1013, 500.00, 'WiFi, Jacuzzi', 4, 'Sea View', false, 'None'),
(62056070, 'Hyatt', 31051950, 1014, 550.00, 'WiFi, TV, Balcony', 5, 'City View', true, 'None'),
(97065706, 'Hyatt', 31051950, 1015, 600.00, 'WiFi', 6, 'Mountain View', false, 'None'),

(29274070, 'Hyatt', 34700560, 2001, 200.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(16636082, 'Hyatt', 34700560, 2002, 220.00, 'WiFi, TV, Jacuzzi', 3, 'City View', false, 'None'),
(46059570, 'Hyatt', 34700560, 2003, 240.00, 'WiFi, TV, minibar', 4, 'Mountain View', false, 'None'),
(53645046, 'Hyatt', 34700560, 2004, 260.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(21021728, 'Hyatt', 34700560, 2005, 280.00, 'WiFi, TV', 6, 'City View', true, 'None'),

(78408039, 'Hyatt', 48593988, 2006, 100.00, 'WiFi, TV', 1, 'City View', false, 'None'),
(54517465, 'Hyatt', 48593988, 2007, 120.00, 'WiFi, TV, Balcony', 2, 'Mountain View', false, 'None'),
(07221691, 'Hyatt', 48593988, 2008, 140.00, 'WiFi, TV, Safe', 3, 'Mountain View', true, 'None'),
(23793246, 'Hyatt', 48593988, 2009, 160.00, 'WiFi, TV, Balcony', 4, 'City View', true, 'None'),
(09397986, 'Hyatt', 48593988, 2010, 180.00, 'WiFi, TV, minibar', 5, 'Sea View', true, 'None'),

(33196200, 'Hyatt', 60982967, 2011, 300.00, 'WiFi, TV, balcony', 1, 'City View', true, 'None'),
(90111545, 'Hyatt', 60982967, 2012, 320.00, 'WiFi, TV, minibar', 2, 'Sea View', true, 'None'),
(87604638, 'Hyatt', 60982967, 2013, 340.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(20566011, 'Hyatt', 60982967, 2014, 360.00, 'WiFi, TV, Safe', 4, 'City View', true, 'None'),
(71606405, 'Hyatt', 60982967, 2015, 380.00, 'WiFi, TV, balcony', 5, 'Mountain View', false, 'None'),

(77172782, 'Hyatt', 82557885, 3001, 300.00, 'WiFi, TV, balcony', 2, 'City View', true, 'None'),
(90406415, 'Hyatt', 82557885, 3002, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(70813556, 'Hyatt', 82557885, 3003, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', true, 'None'),
(43152203, 'Hyatt', 82557885, 3004, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(53366082, 'Hyatt', 82557885, 3005, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None'),

(49770660, 'Hyatt', 90814450, 3006, 300.00, 'WiFi, TV, minibar', 2, 'City View', true, 'None'),
(46987492, 'Hyatt', 90814450, 3007, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(88489020, 'Hyatt', 90814450, 3008, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(01943775, 'Hyatt', 90814450, 3009, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(90971726, 'Hyatt', 90814450, 3010, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None');

--rooms for Hilton
INSERT INTO room (room_id, chain, hotel, room_no, price, amenities, capacity, view, extendable, damage)
VALUES
(56924466, 'Hilton', 26980996, 1001, 250.00, 'WiFi', 2, 'City View', true, 'None'),
(54801405, 'Hilton', 26980996, 1002, 275.00, 'WiFi, TV', 3, 'Sea View', true, 'None'),
(76289823, 'Hilton', 26980996, 1003, 300.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(18319561, 'Hilton', 26980996, 1004, 350.00, 'WiFi, TV, Safe', 5, 'Mountain View', false, 'None'),
(09678517, 'Hilton', 26980996, 1005, 400.00, 'WiFi, TV, Balcony', 6, 'Sea View', true, 'None'),

(41345282, 'Hilton', 61286078, 1006, 150.00, 'WiFi', 2, 'City View', true, 'None'),
(36424379, 'Hilton', 61286078, 1007, 175.00, 'WiFi, TV', 3, 'Mountain View', true, 'None'),
(13641658, 'Hilton', 61286078, 1008, 200.00, 'WiFi, TV, Safe', 4, 'Mountain View', false, 'None'),
(55045480, 'Hilton', 61286078, 1009, 225.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(83820782, 'Hilton', 61286078, 1010, 250.00, 'WiFi, TV, Safe', 6, 'City View', true, 'None'),

(06566373, 'Hilton', 65517409, 1011, 400.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(12837633, 'Hilton', 65517409, 1012, 450.00, 'WiFi, TV, Jacuzzi', 3, 'Sea View', true, 'None'),
(55272463, 'Hilton', 65517409, 1013, 500.00, 'WiFi, Jacuzzi', 4, 'Sea View', false, 'None'),
(70750298, 'Hilton', 65517409, 1014, 550.00, 'WiFi, TV, Balcony', 5, 'City View', true, 'None'),
(41042576, 'Hilton', 65517409, 1015, 600.00, 'WiFi', 6, 'Mountain View', false, 'None'),

(14454720, 'Hilton', 76139352, 2001, 200.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(30279459, 'Hilton', 76139352, 2002, 220.00, 'WiFi, TV, Jacuzzi', 3, 'City View', false, 'None'),
(64399538, 'Hilton', 76139352, 2003, 240.00, 'WiFi, TV, minibar', 4, 'Mountain View', false, 'None'),
(54983350, 'Hilton', 76139352, 2004, 260.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(06798058, 'Hilton', 76139352, 2005, 280.00, 'WiFi, TV', 6, 'City View', true, 'None'),

(79081912, 'Hilton', 79796065, 2006, 100.00, 'WiFi, TV', 1, 'City View', false, 'None'),
(69137622, 'Hilton', 79796065, 2007, 120.00, 'WiFi, TV, Balcony', 2, 'Mountain View', false, 'None'),
(05192468, 'Hilton', 79796065, 2008, 140.00, 'WiFi, TV, Safe', 3, 'Mountain View', true, 'None'),
(04307824, 'Hilton', 79796065, 2009, 160.00, 'WiFi, TV, Balcony', 4, 'City View', true, 'None'),
(15160723, 'Hilton', 79796065, 2010, 180.00, 'WiFi, TV, minibar', 5, 'Sea View', true, 'None'),

(86716341, 'Hilton', 85570302, 2011, 300.00, 'WiFi, TV, balcony', 1, 'City View', true, 'None'),
(93718827, 'Hilton', 85570302, 2012, 320.00, 'WiFi, TV, minibar', 2, 'Sea View', true, 'None'),
(40787043, 'Hilton', 85570302, 2013, 340.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(60432024, 'Hilton', 85570302, 2014, 360.00, 'WiFi, TV, Safe', 4, 'City View', true, 'None'),
(07842749, 'Hilton', 85570302, 2015, 380.00, 'WiFi, TV, balcony', 5, 'Mountain View', false, 'None'),

(74888992, 'Hilton', 87727206, 3001, 300.00, 'WiFi, TV, balcony', 2, 'City View', true, 'None'),
(22856048, 'Hilton', 87727206, 3002, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(00119576, 'Hilton', 87727206, 3003, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', true, 'None'),
(39266382, 'Hilton', 87727206, 3004, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(97666644, 'Hilton', 87727206, 3005, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None'),

(53274436, 'Hilton', 90570691, 3006, 300.00, 'WiFi, TV, minibar', 2, 'City View', true, 'None'),
(35919772, 'Hilton', 90570691, 3007, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(79656606, 'Hilton', 90570691, 3008, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(23006352, 'Hilton', 90570691, 3009, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(35476226, 'Hilton', 90570691, 3010, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None');

--rooms for Accor
INSERT INTO room (room_id, chain, hotel, room_no, price, amenities, capacity, view, extendable, damage)
VALUES
(26637020, 'Accor', 20034961, 1001, 250.00, 'WiFi', 2, 'City View', true, 'None'),
(08080856, 'Accor', 20034961, 1002, 275.00, 'WiFi, TV', 3, 'Sea View', true, 'None'),
(19779375, 'Accor', 20034961, 1003, 300.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(76538553, 'Accor', 20034961, 1004, 350.00, 'WiFi, TV, Safe', 5, 'Mountain View', false, 'None'),
(15235330, 'Accor', 20034961, 1005, 400.00, 'WiFi, TV, Balcony', 6, 'Sea View', true, 'None'),

(55396722, 'Accor', 26760936, 1006, 150.00, 'WiFi', 2, 'City View', true, 'None'),
(83492744, 'Accor', 26760936, 1007, 175.00, 'WiFi, TV', 3, 'Mountain View', true, 'None'),
(56568914, 'Accor', 26760936, 1008, 200.00, 'WiFi, TV, Safe', 4, 'Mountain View', false, 'None'),
(19969256, 'Accor', 26760936, 1009, 225.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(73978267, 'Accor', 26760936, 1010, 250.00, 'WiFi, TV, Safe', 6, 'City View', true, 'None'),

(92335002, 'Accor', 39182237, 1011, 400.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(12735375, 'Accor', 39182237, 1012, 450.00, 'WiFi, TV, Jacuzzi', 3, 'Sea View', true, 'None'),
(40316152, 'Accor', 39182237, 1013, 500.00, 'WiFi, Jacuzzi', 4, 'Sea View', false, 'None'),
(88380339, 'Accor', 39182237, 1014, 550.00, 'WiFi, TV, Balcony', 5, 'City View', true, 'None'),
(23210047, 'Accor', 39182237, 1015, 600.00, 'WiFi', 6, 'Mountain View', false, 'None'),

(25727774, 'Accor', 57932618, 2001, 200.00, 'WiFi, TV, Balcony', 2, 'City View', true, 'None'),
(60066050, 'Accor', 57932618, 2002, 220.00, 'WiFi, TV, Jacuzzi', 3, 'City View', false, 'None'),
(98382339, 'Accor', 57932618, 2003, 240.00, 'WiFi, TV, minibar', 4, 'Mountain View', false, 'None'),
(33485111, 'Accor', 57932618, 2004, 260.00, 'WiFi, TV, Safe', 5, 'Sea View', false, 'None'),
(47419776, 'Accor', 57932618, 2005, 280.00, 'WiFi, TV', 6, 'City View', true, 'None'),

(83836288, 'Accor', 59764826, 2006, 100.00, 'WiFi, TV', 1, 'City View', false, 'None'),
(10574955, 'Accor', 59764826, 2007, 120.00, 'WiFi, TV, Balcony', 2, 'Mountain View', false, 'None'),
(54745402, 'Accor', 59764826, 2008, 140.00, 'WiFi, TV, Safe', 3, 'Mountain View', true, 'None'),
(57917276, 'Accor', 59764826, 2009, 160.00, 'WiFi, TV, Balcony', 4, 'City View', true, 'None'),
(73398769, 'Accor', 59764826, 2010, 180.00, 'WiFi, TV, minibar', 5, 'Sea View', true, 'None'),

(81514632, 'Accor', 62877537, 2011, 300.00, 'WiFi, TV, balcony', 1, 'City View', true, 'None'),
(28005022, 'Accor', 62877537, 2012, 320.00, 'WiFi, TV, minibar', 2, 'Sea View', true, 'None'),
(07361998, 'Accor', 62877537, 2013, 340.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(67392875, 'Accor', 62877537, 2014, 360.00, 'WiFi, TV, Safe', 4, 'City View', true, 'None'),
(31757412, 'Accor', 62877537, 2015, 380.00, 'WiFi, TV, balcony', 5, 'Mountain View', false, 'None'),

(32586793, 'Accor', 81193855, 3001, 300.00, 'WiFi, TV, balcony', 2, 'City View', true, 'None'),
(11991781, 'Accor', 81193855, 3002, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(02299461, 'Accor', 81193855, 3003, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', true, 'None'),
(92795373, 'Accor', 81193855, 3004, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(37433160, 'Accor', 81193855, 3005, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None'),

(76516177, 'Accor', 99297537, 3006, 300.00, 'WiFi, TV, minibar', 2, 'City View', true, 'None'),
(57753076, 'Accor', 99297537, 3007, 320.00, 'WiFi, TV, minibar', 3, 'Sea View', true, 'None'),
(54369011, 'Accor', 99297537, 3008, 340.00, 'WiFi, TV, Safe', 4, 'Sea View', false, 'None'),
(57314551, 'Accor', 99297537, 3009, 360.00, 'WiFi, TV, Safe', 5, 'City View', true, 'None'),
(78034829, 'Accor', 99297537, 3010, 380.00, 'WiFi, TV, minibar', 6, 'Mountain View', false, 'None');


--employees for Accor
INSERT INTO employees (SSN, chain, hotel, first_name, middle_initial, last_name, street_name, street_number, city, postal_code, country)
VALUES 
(31941119, 'Accor', 20034961, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(63578095, 'Accor', 20034961, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(24711970, 'Accor', 20034961, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(59094792, 'Accor', 26760936, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(67064474, 'Accor', 26760936, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(88979226, 'Accor', 26760936, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(55441884, 'Accor', 39182237, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(25874910, 'Accor', 39182237, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(21050472, 'Accor', 39182237, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(12699662, 'Accor', 57932618, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(45268117, 'Accor', 57932618, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(92112696, 'Accor', 57932618, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(66986801, 'Accor', 59764826, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(23456789, 'Accor', 59764826, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(34567890, 'Accor', 59764826, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(21037994, 'Accor', 62877537, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(30476445, 'Accor', 62877537, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(22494268, 'Accor', 62877537, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(99404680, 'Accor', 81193855, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(82463136, 'Accor', 81193855, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(22800725, 'Accor', 81193855, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(18117701, 'Accor', 99297537, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(20872858, 'Accor', 99297537, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(91689584, 'Accor', 99297537, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA');

--employees for Hilton
INSERT INTO employees (SSN, chain, hotel, first_name, middle_initial, last_name, street_name, street_number, city, postal_code, country)
VALUES 
(25781332, 'Hilton', 26980996, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(60215616, 'Hilton', 26980996, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(90086698, 'Hilton', 26980996, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(51742409, 'Hilton', 61286078, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(77496811, 'Hilton', 61286078, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(26893448, 'Hilton', 61286078, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(347830, 'Hilton', 65517409, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(09135499, 'Hilton', 65517409, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(31151115, 'Hilton', 65517409, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(69145679, 'Hilton', 76139352, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(95039874, 'Hilton', 76139352, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(79815589, 'Hilton', 76139352, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(26222744, 'Hilton', 79796065, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(51274504, 'Hilton', 79796065, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(39329305, 'Hilton', 79796065, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(53244266, 'Hilton', 85570302, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(94558981, 'Hilton', 85570302, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(55651945, 'Hilton', 85570302, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(44568289, 'Hilton', 87727206, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(05007352, 'Hilton', 87727206, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(44085416, 'Hilton', 87727206, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(51833796, 'Hilton', 90570691, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(49810597, 'Hilton', 90570691, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(69410505, 'Hilton', 90570691, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA');


--employees for Hyatt
INSERT INTO employees (SSN, chain, hotel, first_name, middle_initial, last_name, street_name, street_number, city, postal_code, country)
VALUES 
(12905481, 'Hyatt', 2551594, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(66989153, 'Hyatt', 2551594, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(42817231, 'Hyatt', 2551594, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(65388419, 'Hyatt', 23998234, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(56923773, 'Hyatt', 23998234, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(27790543, 'Hyatt', 23998234, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(36040120, 'Hyatt', 31051950, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(97299525, 'Hyatt', 31051950, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(34052854, 'Hyatt', 31051950, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(40579529, 'Hyatt', 34700560, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(28668648, 'Hyatt', 34700560, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(44915716, 'Hyatt', 34700560, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(11870969, 'Hyatt', 48593988, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(57926335, 'Hyatt', 48593988, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(13351219, 'Hyatt', 48593988, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(2213112, 'Hyatt', 60982967, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(51066728, 'Hyatt', 60982967, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(79662552, 'Hyatt', 60982967, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(79799696, 'Hyatt', 82557885, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(87905390, 'Hyatt', 82557885, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(19464398, 'Hyatt', 82557885, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(24319469, 'Hyatt', 90814450, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(00281391, 'Hyatt', 90814450, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(81487641, 'Hyatt', 90814450, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA');

--employees for InterContinental
INSERT INTO employees (SSN, chain, hotel, first_name, middle_initial, last_name, street_name, street_number, city, postal_code, country)
VALUES 
(83120834, 'InterContinental', 4703837, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(75004900, 'InterContinental', 4703837, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(49661798, 'InterContinental', 4703837, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(82073795, 'InterContinental', 8768076, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(29748912, 'InterContinental', 8768076, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(77457547, 'InterContinental', 8768076, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(30062498, 'InterContinental', 10654082, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(04268137, 'InterContinental', 10654082, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(87065067, 'InterContinental', 10654082, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(22640895, 'InterContinental', 35131214, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(96227524, 'InterContinental', 35131214, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(37211438, 'InterContinental', 35131214, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(85326110, 'InterContinental', 43134891, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(65162959, 'InterContinental', 43134891, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(66850519, 'InterContinental', 43134891, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(99596692, 'InterContinental', 43376982, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(75835238, 'InterContinental', 43376982, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(02988395, 'InterContinental', 43376982, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(63439143, 'InterContinental', 59044366, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(45198291, 'InterContinental', 59044366, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(21067048, 'InterContinental', 59044366, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(80396709, 'InterContinental', 83430392, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(70216071, 'InterContinental', 83430392, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(51794864, 'InterContinental', 83430392, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA');

--employees for Marriott
INSERT INTO employees (SSN, chain, hotel, first_name, middle_initial, last_name, street_name, street_number, city, postal_code, country)
VALUES 
(13415974, 'Marriott', 6763842, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(71644081, 'Marriott', 6763842, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(58542324, 'Marriott', 6763842, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(96299438, 'Marriott', 8446973, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(02706513, 'Marriott', 8446973, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(62202756, 'Marriott', 8446973, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(39428873, 'Marriott', 10751872, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(52797620, 'Marriott', 10751872, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(61130198, 'Marriott', 10751872, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(52789598, 'Marriott', 33402978, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(94892648, 'Marriott', 33402978, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(23761378, 'Marriott', 33402978, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(46746134, 'Marriott', 34678491, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(92321850, 'Marriott', 34678491, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(95621480, 'Marriott', 34678491, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(76994757, 'Marriott', 36040509, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(62513627, 'Marriott', 36040509, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(11391954, 'Marriott', 36040509, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(41519931, 'Marriott', 57412031, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(57365137, 'Marriott', 57412031, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(66595494, 'Marriott', 57412031, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA'),

(88647418, 'Marriott', 95827154, 'John', 'D', 'Smith', 'Main St', 123, 'New York', '12345', 'USA'),
(98602908, 'Marriott', 95827154, 'Jane', 'K', 'Doe', 'High St', 456, 'Los Angeles', '67890', 'USA'),
(40822861, 'Marriott', 95827154, 'Robert', 'L', 'Johnson', 'Market St', 789, 'Chicago', '56789', 'USA');


--Marriot Employees Roles
INSERT INTO positions (role, employee) VALUES
('Manager',13415974),
('Manager',96299438),
('Manager',39428873),
('Manager',52789598),
('Manager',46746134),
('Manager',76994757),
('Manager',41519931),
('Manager',88647418),

('Door Man',71644081),
('Door Man',02706513),
('Door Man',52797620),
('Door Man',94892648),
('Door Man',92321850),
('Door Man',62513627),
('Door Man',57365137),
('Door Man',98602908),

('Cook',58542324),
('Cook',62202756),
('Cook',61130198),
('Cook',23761378),
('Cook',95621480),
('Cook',11391954),
('Cook',66595494),
('Cook',40822861);

--InterContinental Employees Roles
INSERT INTO positions (role, employee) VALUES
('Manager',83120834),
('Manager',82073795),
('Manager',30062498),
('Manager',22640895),
('Manager',85326110),
('Manager',99596692),
('Manager',63439143),
('Manager',80396709),

('Door Man',75004900),
('Door Man',29748912),
('Door Man',04268137),
('Door Man',96227524),
('Door Man',65162959),
('Door Man',75835238),
('Door Man',45198291),
('Door Man',70216071),

('Cook',49661798),
('Cook',77457547),
('Cook',87065067),
('Cook',37211438),
('Cook',66850519),
('Cook',02988395),
('Cook',21067048),
('Cook',51794864);

--Hyatt Employees Roles
INSERT INTO positions (role, employee) VALUES
('Manager',12905481),
('Manager',65388419),
('Manager',36040120),
('Manager',40579529),
('Manager',11870969),
('Manager',2213112),
('Manager',79799696),
('Manager',24319469),

('Door Man',66989153),
('Door Man',56923773),
('Door Man',97299525),
('Door Man',28668648),
('Door Man',57926335),
('Door Man',51066728),
('Door Man',87905390),
('Door Man',00281391),

('Cook',42817231),
('Cook',27790543),
('Cook',34052854),
('Cook',44915716),
('Cook',13351219),
('Cook',79662552),
('Cook',19464398),
('Cook',81487641);

--Accor Employees Roles
INSERT INTO positions (role, employee) VALUES
('Manager',31941119),
('Manager',59094792),
('Manager',55441884),
('Manager',12699662),
('Manager',66986801),
('Manager',21037994),
('Manager',99404680),
('Manager',18117701),

('Door Man',63578095),
('Door Man',67064474),
('Door Man',25874910),
('Door Man',45268117),
('Door Man',23456789),
('Door Man',30476445),
('Door Man',82463136),
('Door Man',20872858),

('Cook',24711970),
('Cook',88979226),
('Cook',21050472),
('Cook',92112696),
('Cook',34567890),
('Cook',22494268),
('Cook',22800725),
('Cook',91689584);

--inserting phone number chain
--NOT REAL PHONE NUMBERS
INSERT INTO phone_number_chain(chain_name,phone)
VALUES
('Accor',2001823272),
('Hilton',1272027114),
('Hyatt',1929746489),
('InterContinental',1485174721),
('Marriott',1788071876);

--inserting phone number Accor
INSERT INTO phone_number_hotel(hotel_id, chain, phone)
VALUES
(20034961,'Accor',3757040371),
(26760936,'Accor',9481499970),
(39182237,'Accor',4395452311),
(57932618,'Accor',6320954970),
(59764826,'Accor',8884081529),
(62877537,'Accor',9870902376),
(81193855,'Accor',9169844380),
(99297537,'Accor',4244186858);

--inserting phone number Hilton
INSERT INTO phone_number_hotel(hotel_id, chain, phone)
VALUES
(26980996,'Hilton',5928385055),
(61286078,'Hilton',4394618996),
(65517409,'Hilton',1992181333),
(76139352,'Hilton',1837490563),
(79796065,'Hilton',5029552631),
(85570302,'Hilton',4682772440),
(87727206,'Hilton',7619486038),
(90570691,'Hilton',6965076509);

--inserting phone number Hyatt
INSERT INTO phone_number_hotel(hotel_id, chain, phone)
VALUES
(2551594,'Hyatt',8882398930),
(23998234,'Hyatt',8374616206),
(31051950,'Hyatt',8272086037),
(34700560,'Hyatt',9572830628),
(48593988,'Hyatt',3685369002),
(60982967,'Hyatt',4142713065),
(82557885,'Hyatt',1921438113),
(90814450,'Hyatt',8439297908);

--inserting phone number InterContinental
INSERT INTO phone_number_hotel(hotel_id, chain, phone)
VALUES
(4703837,'InterContinental',1538985890),
(8768076,'InterContinental',9596567646),
(10654082,'InterContinental',8601803619),
(35131214,'InterContinental',9927356282),
(43134891,'InterContinental',5032678249),
(43376982,'InterContinental',3607483175),
(59044366,'InterContinental',7988726183),
(83430392,'InterContinental',6555105279);

--inserting phone number Marriott
INSERT INTO phone_number_hotel(hotel_id, chain, phone)
VALUES
(6763842,'Marriott',8635048349),
(8446973,'Marriott',8203315460),
(10751872,'Marriott',6170376761),
(33402978,'Marriott',6137754901),
(34678491,'Marriott',9363956080),
(36040509,'Marriott',8268967219),
(57412031,'Marriott',6470798878),
(95827154,'Marriott',5999186665);

--2 triggers:
--trigger1
CREATE FUNCTION new_hotel() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO phone_number_hotel (hotel_id, chain)
  VALUES (NEW.hotel_id, NEW.chain);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER new_hotel AFTER INSERT ON hotel
FOR EACH ROW
EXECUTE FUNCTION new_hotel();

--trigger2
CREATE FUNCTION new_booking() RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO renting (customer, chain, hotel, room)
  VALUES (NEW.customer, NEW.chain, NEW.hotel, NEW.room);
  RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER new_booking AFTER INSERT ON booking
FOR EACH ROW
EXECUTE FUNCTION new_booking();

--view 1
create view available_room_no as
SELECT h.city, COUNT(r.room_id) AS num_rooms
FROM hotel h
JOIN room r ON h.hotel_id = r.hotel
GROUP BY h.city;

--view 2
create view capacity_Marriott_33402978 as
SELECT SUM(capacity) FROM room WHERE
room.chain = 'Marriott' AND room.hotel = 33402978;
