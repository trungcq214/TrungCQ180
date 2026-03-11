package models;

public class Seat {
    private int seatId;
    private int roomId;
    private String seatName;
    private String type;

    public Seat() {
    }

    public Seat(int seatId, int roomId, String seatName, String type) {
        this.seatId = seatId;
        this.roomId = roomId;
        this.seatName = seatName;
        this.type = type;
    }

    public int getSeatId() { return seatId; }
    public void setSeatId(int seatId) { this.seatId = seatId; }
    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public String getSeatName() { return seatName; }
    public void setSeatName(String seatName) { this.seatName = seatName; }
    public String getType() { return type; }
    public void setType(String type) { this.type = type; }
}
