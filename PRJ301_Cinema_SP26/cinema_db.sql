IF DB_ID(N'CinemaDB') IS NULL
BEGIN
  CREATE DATABASE CinemaDB;
END
GO

USE CinemaDB;
GO

/* =========================
   1. Users
   ========================= */
CREATE TABLE [User] (
    UserId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_User PRIMARY KEY,
    Username NVARCHAR(50) NOT NULL CONSTRAINT UQ_User_Username UNIQUE,
    Email NVARCHAR(255) NULL,
    Password NVARCHAR(100) NOT NULL,
    FullName NVARCHAR(120) NULL,
    Role TINYINT NOT NULL, -- 0=Customer, 1=Staff, 2=Admin
    IsActive BIT NOT NULL CONSTRAINT DF_User_IsActive DEFAULT(1),
    CreatedAt DATETIME2(0) NOT NULL CONSTRAINT DF_User_CreatedAt DEFAULT(SYSDATETIME())
);
GO

/* =========================
   2. Theaters (Cụm rạp)
   ========================= */
CREATE TABLE Theater (
    TheaterId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Theater PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Address NVARCHAR(255) NOT NULL,
    IsActive BIT NOT NULL CONSTRAINT DF_Theater_IsActive DEFAULT(1)
);
GO

/* =========================
   3. Rooms (Phòng chiếu)
   ========================= */
CREATE TABLE Room (
    RoomId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Room PRIMARY KEY,
    TheaterId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    Capacity INT NOT NULL,
    CONSTRAINT FK_Room_Theater FOREIGN KEY (TheaterId) REFERENCES Theater(TheaterId)
);
GO

/* =========================
   4. Movies (Phim)
   ========================= */
CREATE TABLE Movie (
    MovieId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Movie PRIMARY KEY,
    Title NVARCHAR(255) NOT NULL,
    Description NVARCHAR(MAX) NULL,
    Duration INT NOT NULL, -- in minutes
    ReleaseDate DATE NULL,
    PosterUrl NVARCHAR(255) NULL
);
GO

/* =========================
   5. Schedules (Suất chiếu)
   ========================= */
CREATE TABLE Schedule (
    ScheduleId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Schedule PRIMARY KEY,
    MovieId INT NOT NULL,
    RoomId INT NOT NULL,
    StartTime DATETIME2(0) NOT NULL,
    EndTime DATETIME2(0) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    CONSTRAINT FK_Schedule_Movie FOREIGN KEY (MovieId) REFERENCES Movie(MovieId),
    CONSTRAINT FK_Schedule_Room FOREIGN KEY (RoomId) REFERENCES Room(RoomId)
);
GO

/* =========================
   6. Seats (Ghế trong phòng)
   ========================= */
CREATE TABLE Seat (
    SeatId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Seat PRIMARY KEY,
    RoomId INT NOT NULL,
    SeatName NVARCHAR(10) NOT NULL, -- e.g., A1, B2
    Type NVARCHAR(20) NOT NULL CONSTRAINT DF_Seat_Type DEFAULT('Normal'), -- Normal, VIP, Couple
    CONSTRAINT FK_Seat_Room FOREIGN KEY (RoomId) REFERENCES Room(RoomId)
);
GO

/* =========================
   7. Tickets (Vé đã mua)
   ========================= */
CREATE TABLE Ticket (
    TicketId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Ticket PRIMARY KEY,
    ScheduleId INT NOT NULL,
    SeatId INT NOT NULL,
    CustomerId INT NULL,
    StaffId INT NULL,
    BookingTime DATETIME2(0) NOT NULL CONSTRAINT DF_Ticket_Config DEFAULT(SYSDATETIME()),
    Status NVARCHAR(20) NOT NULL CONSTRAINT DF_Ticket_Status DEFAULT('Paid'), -- Paid, Cancelled
    CONSTRAINT FK_Ticket_Schedule FOREIGN KEY (ScheduleId) REFERENCES Schedule(ScheduleId),
    CONSTRAINT FK_Ticket_Seat FOREIGN KEY (SeatId) REFERENCES Seat(SeatId),
    CONSTRAINT FK_Ticket_Customer FOREIGN KEY (CustomerId) REFERENCES [User](UserId),
    CONSTRAINT FK_Ticket_Staff FOREIGN KEY (StaffId) REFERENCES [User](UserId)
);
GO

-- Create filtered unique index to allow multiple cancelled/refunded tickets for the same seat, 
-- but only one 'Paid' ticket.
CREATE UNIQUE NONCLUSTERED INDEX UQ_Ticket_Seat_Paid 
ON Ticket (ScheduleId, SeatId) 
WHERE Status = 'Paid';
GO

/* =========================
   8. Snacks (Đồ ăn thức uống)
   ========================= */
CREATE TABLE Snack (
    SnackId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_Snack PRIMARY KEY,
    Name NVARCHAR(100) NOT NULL,
    Price DECIMAL(10, 2) NOT NULL,
    StockQuantity INT NOT NULL CONSTRAINT DF_Snack_Stock DEFAULT(0),
    ImageUrl NVARCHAR(255) NULL
);
GO

/* =========================
   9. Snack Orders (Đơn mua đồ ăn)
   ========================= */
CREATE TABLE SnackOrder (
    OrderId INT IDENTITY(1,1) NOT NULL CONSTRAINT PK_SnackOrder PRIMARY KEY,
    CustomerId INT NULL,
    StaffId INT NULL,
    SnackId INT NOT NULL,
    Quantity INT NOT NULL,
    TotalPrice DECIMAL(10, 2) NOT NULL,
    OrderTime DATETIME2(0) NOT NULL CONSTRAINT DF_SnackOrder_OrderTime DEFAULT(SYSDATETIME()),
    CONSTRAINT FK_SnackOrder_Customer FOREIGN KEY (CustomerId) REFERENCES [User](UserId),
    CONSTRAINT FK_SnackOrder_Staff FOREIGN KEY (StaffId) REFERENCES [User](UserId),
    CONSTRAINT FK_SnackOrder_Snack FOREIGN KEY (SnackId) REFERENCES Snack(SnackId)
);
GO

/* =========================
   Seed Data
   ========================= */
INSERT INTO [User] (Username, Password, FullName, Role) VALUES 
('admin', '123456', 'Administrator', 2),
('staff1', '123456', 'Staff Member 1', 1),
('customer1', '123456', 'John Doe', 0);
GO

INSERT INTO Theater (Name, Address) VALUES 
('CGV Landmark 81', '720A Dien Bien Phu, Binh Thanh, HCMC'),
('Galaxy Nguyen Du', '116 Nguyen Du, Q1, HCMC');
GO

INSERT INTO Room (TheaterId, Name, Capacity) VALUES 
(1, 'Room 1', 50),
(1, 'Room 2', 40),
(2, 'Room A', 60);
GO

INSERT INTO Movie (Title, Description, Duration, ReleaseDate) VALUES 
('Dune: Part Two', 'Sci-fi epic. Paul Atreides unites with Chani and the Fremen while on a warpath of revenge against the conspirators who destroyed his family.', 166, '2024-03-01'),
('Kung Fu Panda 4', 'Animated comedy. After Po is tapped to become the Spiritual Leader of the Valley of Peace, he needs to find and train a new Dragon Warrior.', 94, '2024-03-08');
GO

INSERT INTO Schedule (MovieId, RoomId, StartTime, EndTime, Price) VALUES 
(1, 1, '2024-12-01 19:00:00', '2024-12-01 21:46:00', 120000.00),
(2, 2, '2024-12-01 20:00:00', '2024-12-01 21:34:00', 90000.00);
GO

INSERT INTO Seat (RoomId, SeatName) VALUES 
(1, 'A1'), (1, 'A2'), (1, 'A3'), (1, 'A4'), (1, 'A5'),
(1, 'B1'), (1, 'B2'), (1, 'B3'), (1, 'B4'), (1, 'B5');
GO

INSERT INTO Snack (Name, Price, StockQuantity) VALUES 
('Popcorn Caramel Small', 50000, 100),
('Coca-Cola Large', 40000, 200);
GO
