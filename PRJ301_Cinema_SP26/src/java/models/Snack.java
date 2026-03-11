package models;

public class Snack {
    private int snackId;
    private String name;
    private double price;
    private int stockQuantity;
    private String imageUrl;

    public Snack() {
    }

    public Snack(int snackId, String name, double price, int stockQuantity, String imageUrl) {
        this.snackId = snackId;
        this.name = name;
        this.price = price;
        this.stockQuantity = stockQuantity;
        this.imageUrl = imageUrl;
    }

    public int getSnackId() { return snackId; }
    public void setSnackId(int snackId) { this.snackId = snackId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }
    public int getStockQuantity() { return stockQuantity; }
    public void setStockQuantity(int stockQuantity) { this.stockQuantity = stockQuantity; }
    public String getImageUrl() { return imageUrl; }
    public void setImageUrl(String imageUrl) { this.imageUrl = imageUrl; }
}
