package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Snack;
import models.SnackOrder;

public class SnackDAO extends DBContext {

    public List<Snack> getAllSnacks() {
        List<Snack> list = new ArrayList<>();
        String sql = "SELECT * FROM Snack";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Snack(
                    rs.getInt("SnackId"),
                    rs.getString("Name"),
                    rs.getDouble("Price"),
                    rs.getInt("StockQuantity"),
                    rs.getString("ImageUrl")
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllSnacks error: " + e.getMessage());
        }
        return list;
    }

    public boolean insertSnack(Snack snack) {
        String sql = "INSERT INTO Snack (Name, Price, StockQuantity, ImageUrl) VALUES (?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, snack.getName());
            st.setDouble(2, snack.getPrice());
            st.setInt(3, snack.getStockQuantity());
            st.setString(4, snack.getImageUrl());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertSnack error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateSnack(Snack snack) {
        String sql = "UPDATE Snack SET Name = ?, Price = ?, StockQuantity = ?, ImageUrl = ? WHERE SnackId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, snack.getName());
            st.setDouble(2, snack.getPrice());
            st.setInt(3, snack.getStockQuantity());
            st.setString(4, snack.getImageUrl());
            st.setInt(5, snack.getSnackId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateSnack error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteSnack(int snackId) {
        String sql = "DELETE FROM Snack WHERE SnackId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, snackId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteSnack error: " + e.getMessage());
        }
        return false;
    }

    public boolean sellSnack(int snackId, int quantity, int staffId, Integer customerId) {
        // Simple non-transactional flow: 1) Get Price 2) Update Stock 3) Insert Order
        try (Connection conn = getConnection()) {
            double price = 0;
            String getPriceSql = "SELECT Price, StockQuantity FROM Snack WHERE SnackId = ?";
            try (PreparedStatement stPrice = conn.prepareStatement(getPriceSql)) {
                stPrice.setInt(1, snackId);
                try (ResultSet rs = stPrice.executeQuery()) {
                    if (rs.next()) {
                        price = rs.getDouble("Price");
                        int stock = rs.getInt("StockQuantity");
                        if (stock < quantity) {
                            return false; // Not enough stock
                        }
                    } else {
                        return false; // Snack not found
                    }
                }
            }

            double totalPrice = price * quantity;

            String updateStockSql = "UPDATE Snack SET StockQuantity = StockQuantity - ? WHERE SnackId = ?";
            try (PreparedStatement stU = conn.prepareStatement(updateStockSql)) {
                stU.setInt(1, quantity);
                stU.setInt(2, snackId);
                stU.executeUpdate();
            }

            String insertOrderSql = "INSERT INTO SnackOrder (StaffId, SnackId, Quantity, TotalPrice, CustomerId) VALUES (?, ?, ?, ?, ?)";
            try (PreparedStatement stI = conn.prepareStatement(insertOrderSql)) {
                stI.setInt(1, staffId);
                stI.setInt(2, snackId);
                stI.setInt(3, quantity);
                stI.setDouble(4, totalPrice);
                if (customerId != null) {
                    stI.setInt(5, customerId);
                } else {
                    stI.setNull(5, java.sql.Types.INTEGER);
                }
                stI.executeUpdate();
            }

            return true;
        } catch (SQLException e) {
            System.out.println("sellSnack error: " + e.getMessage());
        }
        return false;
    }

    public List<SnackOrder> getSnackOrdersByCustomerId(int customerId) {
        List<SnackOrder> list = new ArrayList<>();
        String sql = "SELECT o.*, s.Name AS SnackName " +
                     "FROM SnackOrder o " +
                     "JOIN Snack s ON o.SnackId = s.SnackId " +
                     "WHERE o.CustomerId = ? " +
                     "ORDER BY o.OrderTime DESC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, customerId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    SnackOrder order = new SnackOrder(
                        rs.getInt("OrderId"),
                        (Integer) rs.getObject("CustomerId"),
                        (Integer) rs.getObject("StaffId"),
                        rs.getInt("SnackId"),
                        rs.getInt("Quantity"),
                        rs.getDouble("TotalPrice"),
                        rs.getTimestamp("OrderTime")
                    );
                    order.setSnackName(rs.getString("SnackName"));
                    list.add(order);
                }
            }
        } catch (SQLException e) {
            System.out.println("getSnackOrdersByCustomerId error: " + e.getMessage());
        }
        return list;
    }

    public List<SnackOrder> getAllSnackOrders() {
        List<SnackOrder> list = new ArrayList<>();
        String sql = "SELECT o.*, s.Name AS SnackName " +
                     "FROM SnackOrder o " +
                     "JOIN Snack s ON o.SnackId = s.SnackId " +
                     "ORDER BY o.OrderTime DESC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                SnackOrder order = new SnackOrder(
                    rs.getInt("OrderId"),
                    (Integer) rs.getObject("CustomerId"),
                    (Integer) rs.getObject("StaffId"),
                    rs.getInt("SnackId"),
                    rs.getInt("Quantity"),
                    rs.getDouble("TotalPrice"),
                    rs.getTimestamp("OrderTime")
                );
                order.setSnackName(rs.getString("SnackName"));
                list.add(order);
            }
        } catch (SQLException e) {
            System.out.println("getAllSnackOrders error: " + e.getMessage());
        }
        return list;
    }
}
