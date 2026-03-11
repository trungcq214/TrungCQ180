package models;

public class Theater {
    private int theaterId;
    private String name;
    private String address;
    private boolean isActive;

    public Theater() {
    }

    public Theater(int theaterId, String name, String address, boolean isActive) {
        this.theaterId = theaterId;
        this.name = name;
        this.address = address;
        this.isActive = isActive;
    }

    public int getTheaterId() { return theaterId; }
    public void setTheaterId(int theaterId) { this.theaterId = theaterId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public boolean isIsActive() { return isActive; }
    public void setIsActive(boolean isActive) { this.isActive = isActive; }
}
