package models;

import java.sql.Timestamp;

public class SnackOrder {
    private int orderId;
    private Integer customerId;
    private Integer staffId;
    private int snackId;
    private int quantity;
    private double totalPrice;
    private Timestamp orderTime;
    
    // Display field
    private String snackName;

    public SnackOrder() {
    }

    public SnackOrder(int orderId, Integer customerId, Integer staffId, int snackId, int quantity, double totalPrice, Timestamp orderTime) {
        this.orderId = orderId;
        this.customerId = customerId;
        this.staffId = staffId;
        this.snackId = snackId;
        this.quantity = quantity;
        this.totalPrice = totalPrice;
        this.orderTime = orderTime;
    }

    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public Integer getCustomerId() { return customerId; }
    public void setCustomerId(Integer customerId) { this.customerId = customerId; }
    public Integer getStaffId() { return staffId; }
    public void setStaffId(Integer staffId) { this.staffId = staffId; }
    public int getSnackId() { return snackId; }
    public void setSnackId(int snackId) { this.snackId = snackId; }
    public int getQuantity() { return quantity; }
    public void setQuantity(int quantity) { this.quantity = quantity; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public Timestamp getOrderTime() { return orderTime; }
    public void setOrderTime(Timestamp orderTime) { this.orderTime = orderTime; }

    public String getSnackName() { return snackName; }
    public void setSnackName(String snackName) { this.snackName = snackName; }
}
