-- Create the database
CREATE DATABASE RealEstateTrackerDB;

-- Select the database for use
USE RealEstateTrackerDB;

-- Create the Agents table
CREATE TABLE Agents (
    AgentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    CommissionRate DECIMAL(5 , 4 ) NOT NULL DEFAULT 0.02
);

-- Create the Properties table
CREATE TABLE Properties (
    PropertyID INT AUTO_INCREMENT PRIMARY KEY,
    Address VARCHAR(255) NOT NULL,
    Type VARCHAR(50) NOT NULL,
    Price DECIMAL(15 , 2 ) NOT NULL,
    Status ENUM('Available', 'Pending', 'Sold') NOT NULL DEFAULT 'Available',
    Description TEXT,
    Bedrooms INT,
    Bathrooms DECIMAL(2 , 1 ),
    Area DECIMAL(10 , 2 ),
    AgentID INT,
    FOREIGN KEY (AgentID)
        REFERENCES Agents (AgentID)
        ON DELETE SET NULL ON UPDATE CASCADE
);

-- Create the Buyers table
CREATE TABLE Buyers (
    BuyerID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(255) NOT NULL,
    Email VARCHAR(255) UNIQUE NOT NULL,
    Phone VARCHAR(20),
    PreferredType VARCHAR(50),
    MinPrice DECIMAL(15 , 2 ),
    MaxPrice DECIMAL(15 , 2 )
);

-- Create the Bookings table
CREATE TABLE Bookings (
    BookingID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT NOT NULL,
    BuyerID INT NOT NULL,
    AgentID INT NOT NULL,
    BookingDate DATE NOT NULL,
    BookingTime TIME NOT NULL,
    Status ENUM('Scheduled', 'Completed', 'Cancelled') NOT NULL DEFAULT 'Scheduled',
    FOREIGN KEY (PropertyID)
        REFERENCES Properties (PropertyID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (BuyerID)
        REFERENCES Buyers (BuyerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (AgentID)
        REFERENCES Agents (AgentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Create the Sales table
CREATE TABLE Sales (
    SaleID INT AUTO_INCREMENT PRIMARY KEY,
    PropertyID INT UNIQUE NOT NULL,
    BuyerID INT NOT NULL,
    AgentID INT NOT NULL,
    SaleDate DATE NOT NULL,
    FinalPrice DECIMAL(15 , 2 ) NOT NULL,
    CommissionAmount DECIMAL(15 , 2 ),
    FOREIGN KEY (PropertyID)
        REFERENCES Properties (PropertyID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (BuyerID)
        REFERENCES Buyers (BuyerID)
        ON DELETE RESTRICT ON UPDATE CASCADE,
    FOREIGN KEY (AgentID)
        REFERENCES Agents (AgentID)
        ON DELETE RESTRICT ON UPDATE CASCADE
);

-- Create the Buyer_Interests associative table
CREATE TABLE Buyer_Interests (
    BuyerID INT NOT NULL,
    PropertyID INT NOT NULL,
    DateExpressed DATE NOT NULL,
    PRIMARY KEY (BuyerID , PropertyID),
    FOREIGN KEY (BuyerID)
        REFERENCES Buyers (BuyerID)
        ON DELETE CASCADE ON UPDATE CASCADE,
    FOREIGN KEY (PropertyID)
        REFERENCES Properties (PropertyID)
        ON DELETE CASCADE ON UPDATE CASCADE
);

-- Insert data into Agents
INSERT INTO Agents (Name, Email, Phone, CommissionRate) VALUES
('Alice Smith', 'alice.s@example.com', '111-222-3333', 0.025),
('Bob Johnson', 'bob.j@example.com', '444-555-6666', 0.030),
('Charlie Brown', 'charlie.b@example.com', '777-888-9999', 0.020);

-- Insert data into Properties
INSERT INTO Properties (Address, Type, Price, Status, Description, Bedrooms, Bathrooms, Area, AgentID) VALUES
('123 Main St, Anytown', 'House', 500000.00, 'Available', 'Spacious family home.', 4, 2.5, 2500.00, 1),
('456 Oak Ave, Anytown', 'Condo', 300000.00, 'Pending', 'Modern condo with city views.', 2, 2.0, 1200.00, 2),
('789 Pine Ln, Otherville', 'Land', 150000.00, 'Available', 'Vacant lot for development.', 0, 0.0, 10000.00, 1),
('101 Elm St, Anytown', 'House', 750000.00, 'Sold', 'Luxury estate with large yard.', 5, 3.5, 3500.00, 2);

-- Insert data into Buyers
INSERT INTO Buyers (Name, Email, Phone, PreferredType, MinPrice, MaxPrice) VALUES
('David Lee', 'david.l@example.com', '123-456-7890', 'House', 450000.00, 600000.00),
('Emily White', 'emily.w@example.com', '987-654-3210', 'Condo', 250000.00, 350000.00);

-- Insert data into Bookings
INSERT INTO Bookings (PropertyID, BuyerID, AgentID, BookingDate, BookingTime, Status) VALUES
(1, 1, 1, '2025-05-20', '10:00:00', 'Completed'),
(2, 2, 2, '2025-05-22', '14:30:00', 'Scheduled');

-- Insert data into Sales
INSERT INTO Sales (PropertyID, BuyerID, AgentID, SaleDate, FinalPrice, CommissionAmount) VALUES
(4, 1, 2, '2025-05-15', 740000.00, 740000.00 * 0.030);-- Commission calculated manually for now

DELIMITER $$
CREATE PROCEDURE AddNewProperty (
    IN p_Address VARCHAR(255),
    IN p_Type VARCHAR(50),
    IN p_Price DECIMAL(15, 2),
    IN p_Description TEXT,
    IN p_Bedrooms INT,
    IN p_Bathrooms DECIMAL(2, 1),
    IN p_Area DECIMAL(10, 2),
    IN p_AgentID INT
)
BEGIN
    INSERT INTO Properties (Address, Type, Price, Status, Description, Bedrooms, Bathrooms, Area, AgentID)
    VALUES (p_Address, p_Type, p_Price, 'Available', p_Description, p_Bedrooms, p_Bathrooms, p_Area, p_AgentID);
    SELECT 'Property added successfully.' AS Message;
END $$
DELIMITER ;

DELIMITER //
CREATE PROCEDURE ScheduleBooking (
    IN p_PropertyID INT,
    IN p_BuyerID INT,
    IN p_AgentID INT,
    IN p_BookingDate DATE,
    IN p_BookingTime TIME
)
BEGIN
    -- Optional: Add checks here (e.g., if property is available, if agent is free)
    INSERT INTO Bookings (PropertyID, BuyerID, AgentID, BookingDate, BookingTime, Status)
    VALUES (p_PropertyID, p_BuyerID, p_AgentID, p_BookingDate, p_BookingTime, 'Scheduled');
    SELECT 'Booking scheduled successfully.' AS Message;
END //
DELIMITER ;



