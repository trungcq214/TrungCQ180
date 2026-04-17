package models;

import java.sql.Timestamp;

public class Ticket {
    private int ticketId;
    private int scheduleId;
    private int seatId;
    private Integer customerId; // Can be null if bought at counter without account
    private Integer staffId;    // Can be null if bought online
    private Timestamp bookingTime;
    private String status;

    // Display fields
    private String movieTitle;
    private String theaterName;
    private String roomName;
    private String seatName;
    private Timestamp startTime;
    private double price;
    private int ticketCount; // Số vé trong cùng một giao dịch (dùng khi group)

    public Ticket() {
    }

    public Ticket(int ticketId, int scheduleId, int seatId, Integer customerId, Integer staffId, Timestamp bookingTime, String status) {
        this.ticketId = ticketId;
        this.scheduleId = scheduleId;
        this.seatId = seatId;
        this.customerId = customerId;
        this.staffId = staffId;
        this.bookingTime = bookingTime;
        this.status = status;
    }

    public int getTicketId() { return ticketId; }
    public void setTicketId(int ticketId) { this.ticketId = ticketId; }
    public int getScheduleId() { return scheduleId; }
    public void setScheduleId(int scheduleId) { this.scheduleId = scheduleId; }
    public int getSeatId() { return seatId; }
    public void setSeatId(int seatId) { this.seatId = seatId; }
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }
    public Timestamp getBookingTime() { return bookingTime; }
    public void setBookingTime(Timestamp bookingTime) { this.bookingTime = bookingTime; }
    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public String getMovieTitle() { return movieTitle; }
    public void setMovieTitle(String movieTitle) { this.movieTitle = movieTitle; }
    public String getTheaterName() { return theaterName; }
    public void setTheaterName(String theaterName) { this.theaterName = theaterName; }
    public String getRoomName() { return roomName; }
    public void setRoomName(String roomName) { this.roomName = roomName; }
    public String getSeatName() { return seatName; }
    public void setSeatName(String seatName) { this.seatName = seatName; }
    public Timestamp getStartTime() { return startTime; }
    public void setStartTime(Timestamp startTime) { this.startTime = startTime; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getTicketCount() { return ticketCount; }
    public void setTicketCount(int ticketCount) { this.ticketCount = ticketCount; }
}
