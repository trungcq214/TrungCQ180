package models;

public class Room {
    private int roomId;
    private int theaterId;
    private String name;
    private int capacity;

    public Room() {
    }

    public Room(int roomId, int theaterId, String name, int capacity) {
        this.roomId = roomId;
        this.theaterId = theaterId;
        this.name = name;
        this.capacity = capacity;
    }

    public int getRoomId() { return roomId; }
    public void setRoomId(int roomId) { this.roomId = roomId; }
    public int getTheaterId() { return theaterId; }
    public void setTheaterId(int theaterId) { this.theaterId = theaterId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public int getCapacity() { return capacity; }
    public void setCapacity(int capacity) { this.capacity = capacity; }
}
