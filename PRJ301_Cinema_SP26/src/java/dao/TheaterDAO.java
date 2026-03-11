package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Theater;

public class TheaterDAO extends DBContext {

    public List<Theater> getAllActiveTheaters() {
        List<Theater> list = new ArrayList<>();
        String sql = "SELECT * FROM Theater WHERE IsActive = 1";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Theater(
                    rs.getInt("TheaterId"),
                    rs.getString("Name"),
                    rs.getString("Address"),
                    rs.getBoolean("IsActive")
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllActiveTheaters error: " + e.getMessage());
        }
        return list;
    }

    public List<Theater> getAllTheaters() {
        List<Theater> list = new ArrayList<>();
        String sql = "SELECT * FROM Theater";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Theater(
                    rs.getInt("TheaterId"),
                    rs.getString("Name"),
                    rs.getString("Address"),
                    rs.getBoolean("IsActive")
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllTheaters error: " + e.getMessage());
        }
        return list;
    }

    public boolean insertTheater(Theater theater) {
        String sql = "INSERT INTO Theater (Name, Address, IsActive) VALUES (?, ?, 1)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, theater.getName());
            st.setString(2, theater.getAddress());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertTheater error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateTheater(Theater theater) {
        String sql = "UPDATE Theater SET Name = ?, Address = ? WHERE TheaterId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, theater.getName());
            st.setString(2, theater.getAddress());
            st.setInt(3, theater.getTheaterId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateTheater error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteTheater(int theaterId) {
        // Soft delete by setting IsActive = 0
        String sql = "UPDATE Theater SET IsActive = 0 WHERE TheaterId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, theaterId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteTheater error: " + e.getMessage());
        }
        return false;
    }

    public Theater getTheaterById(int theaterId) {
        String sql = "SELECT * FROM Theater WHERE TheaterId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, theaterId);
            try (ResultSet rs = st.executeQuery()) {
                if (rs.next()) {
                    return new Theater(
                        rs.getInt("TheaterId"),
                        rs.getString("Name"),
                        rs.getString("Address"),
                        rs.getBoolean("IsActive")
                    );
                }
            }
        } catch (SQLException e) {
            System.out.println("getTheaterById error: " + e.getMessage());
        }
        return null;
    }
}
