CREATE TABLE MusicianPopularity(
	popularity INT,
	expected_turnout INT,
	PRIMARY KEY (popularity)
);

CREATE TABLE StageSize(
	stage_size INT,
	capacity INT,
	PRIMARY KEY (stage_size)
);

CREATE TABLE Venue(
	venue_name VARCHAR2(40),
	city VARCHAR2(40),
	capacity INT,
	accessibility CHAR(80),
	PRIMARY KEY (venue_name)
);

CREATE TABLE Stage(
	venue_name VARCHAR2(40),
	stage_number int,
	stage_size int,
	PRIMARY KEY (venue_name, stage_number),
	FOREIGN KEY (stage_size) REFERENCES StageSize (stage_size) ON DELETE CASCADE,
	FOREIGN KEY (venue_name) REFERENCES Venue (venue_name) ON DELETE CASCADE
);

CREATE TABLE Musician(
	musician_id INT,
	musician_name VARCHAR2(40) NOT NULL,
	festival_year INT,
	stage_venue VARCHAR2(40),
	stage_number INT,
	popularity INT,
	PRIMARY KEY (musician_id),
	FOREIGN KEY (stage_venue, stage_number) REFERENCES Stage(venue_name, stage_number) ON DELETE CASCADE, 
	FOREIGN KEY (popularity) REFERENCES MusicianPopularity
);

CREATE TABLE MarketingPlatform(
	platform VARCHAR2(40),
	content VARCHAR2(40),
	PRIMARY KEY (platform)
);

CREATE TABLE Marketing(
	platform VARCHAR2(40),
	festival_year INT,
	releaseDate VARCHAR2(40),
	PRIMARY KEY (platform, festival_year),
	FOREIGN KEY (platform) REFERENCES MarketingPlatform
);

CREATE TABLE Advertises(
	platform VARCHAR2(40),
	festival_year INT,
	venue_name VARCHAR2(40),
	PRIMARY KEY (platform, festival_year, venue_name),
	FOREIGN KEY (platform, festival_year) REFERENCES Marketing (platform, festival_year),
	FOREIGN KEY (venue_name) REFERENCES Venue (venue_name) ON DELETE CASCADE
);

CREATE TABLE CashFlow (
    id INT,
    quantity INT,
    PRIMARY KEY (id)
);

CREATE TABLE Sponsor(
	sponsor_name VARCHAR2(40),
	festival_year int,
	contributes_to INT, -- changed - incompatible when referencing ID
	PRIMARY KEY (sponsor_name, festival_year),
	FOREIGN KEY (contributes_to) REFERENCES CashFlow (id)
);

CREATE TABLE Features(
	sponsor_name VARCHAR2(40),
	marketing_platform VARCHAR2(40),
	festival_year INT,
	PRIMARY KEY (sponsor_name, marketing_platform, festival_year),
	FOREIGN KEY (sponsor_name, festival_year) REFERENCES Sponsor (sponsor_name, festival_year),
	FOREIGN KEY (marketing_platform, festival_year) REFERENCES Marketing (platform, festival_year)
);


CREATE TABLE VenuePayment( 
    cash_flow_id INT, 
    venue_name VARCHAR2(40),
    PRIMARY KEY (cash_flow_id, venue_name),
    FOREIGN KEY (cash_flow_id) REFERENCES CashFlow, 
    FOREIGN KEY (venue_name) REFERENCES Venue ON DELETE CASCADE
);

CREATE TABLE MusicianPayment(
    id int,
    festival_year int, 
    cash_flow_id int,
    PRIMARY KEY (id, festival_year, cash_flow_id), 
    FOREIGN KEY (id) REFERENCES Musician ON DELETE CASCADE, 
    FOREIGN KEY (cash_flow_id) REFERENCES CashFlow
);

CREATE TABLE MarketingPayment ( 
    platform VARCHAR2(40), 
    festival_year int, 
    cash_flow_id int, 
    PRIMARY KEY (platform, festival_year, cash_flow_id), 
    FOREIGN KEY (platform, festival_year) REFERENCES Marketing, 
    FOREIGN KEY (cash_flow_id) REFERENCES CashFlow
);

CREATE TABLE EmployeePosition( 
    position VARCHAR2(40), 
    hourly_wage int, 
    hours_worked int, 
    PRIMARY KEY (position)
);

CREATE TABLE Employee( 
    employee_id int, 
    position VARCHAR2(40), 
    employee_name VARCHAR2(40) NOT NULL, 
    PRIMARY KEY (employee_id),
    FOREIGN KEY (position) REFERENCES EmployeePosition
);

CREATE TABLE EmployeePayment (
    employee_id int, 
    cash_flow_id int, 
    PRIMARY KEY (employee_id, cash_flow_id), 
    FOREIGN KEY (employee_id) REFERENCES Employee, 
    FOREIGN KEY (cash_flow_id) REFERENCES CashFlow
);

CREATE TABLE Staff(
    id INT, 
    station VARCHAR2(40), 
    PRIMARY KEY (id),
    FOREIGN KEY (id) REFERENCES Employee
);

CREATE TABLE SecurityStaff( 
    id int, 
    license_number int NOT NULL, 
    PRIMARY KEY (id), 
    FOREIGN KEY (id) REFERENCES Employee
);

CREATE TABLE Attendee(
    id int, 
    age int, 
    attendee_name VARCHAR2(40) NOT NULL, 
    PRIMARY KEY (id)
);

CREATE TABLE Ticket(
    ticket_number int, 
    holder int NOT NULL , 
    ticket_to VARCHAR2(40) NOT NULL,
    cash_flow_id int NOT NULL, 
    PRIMARY KEY (ticket_number), 
    FOREIGN KEY (holder) REFERENCES Attendee, 
    FOREIGN KEY (ticket_to) REFERENCES Venue ON DELETE CASCADE,
    FOREIGN KEY (cash_flow_id) REFERENCES CashFlow
);

CREATE TABLE Vendor(
    lot_number int, 
    festival_year int, 
    PRIMARY KEY (lot_number, festival_year)
);

CREATE TABLE FoodVendor(
    lot_number int, 
    festival_year int,
	health_certification int NOT NULL,
	cuisine VARCHAR2(40),
    PRIMARY KEY (lot_number, festival_year)
);

CREATE TABLE DrinkVendor(
	lot_number INT,
	festival_year INT,
	license_id INT NOT NULL,
	drinkType VARCHAR2(40),
	PRIMARY KEY (lot_number, festival_year),
	FOREIGN KEY (lot_number, festival_year) REFERENCES Vendor
);

CREATE TABLE MerchandiseVendor(
	lot_number INT,
	festival_year INT,
	type_sold VARCHAR2(40),
	PRIMARY KEY (lot_number, festival_year),
	FOREIGN KEY (lot_number, festival_year) REFERENCES Vendor
);

CREATE TABLE CustomerReceipt(
	attendee_id INT,
	vendor_lot INT,
	festival_year INT,
	PRIMARY KEY (attendee_id, vendor_lot, festival_year),
	FOREIGN KEY (attendee_id) REFERENCES Attendee,
	FOREIGN KEY (vendor_lot, festival_year) REFERENCES Vendor (lot_number, festival_year)
	);

CREATE TABLE VendorRevenue(
	vendor_lot INT,
	festival_year INT,
	cash_flow_id INT,
	PRIMARY KEY (vendor_lot, festival_year, cash_flow_id),
	FOREIGN KEY (vendor_lot, festival_year) REFERENCES Vendor (lot_number, festival_year),
	FOREIGN KEY (cash_flow_id) REFERENCES CashFlow
);
