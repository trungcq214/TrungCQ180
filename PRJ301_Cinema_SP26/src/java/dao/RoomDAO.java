package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Room;

public class RoomDAO extends DBContext {

    public List<Room> getRoomsByTheaterId(int theaterId) {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room WHERE TheaterId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, theaterId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Room(
                        rs.getInt("RoomId"),
                        rs.getInt("TheaterId"),
                        rs.getString("Name"),
                        30 // Force capacity to 30 to match generated seats
                    ));
                }
            }
        } catch (SQLException e) {
            System.out.println("getRoomsByTheaterId error: " + e.getMessage());
        }
        return list;
    }

    public boolean insertRoom(Room room) {
        String sql = "INSERT INTO Room (TheaterId, Name, Capacity) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, room.getTheaterId());
            st.setString(2, room.getName());
            st.setInt(3, room.getCapacity());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertRoom error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateRoom(Room room) {
        String sql = "UPDATE Room SET Name = ?, Capacity = ? WHERE RoomId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, room.getName());
            st.setInt(2, room.getCapacity());
            st.setInt(3, room.getRoomId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateRoom error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteRoom(int roomId) {
        String sql = "DELETE FROM Room WHERE RoomId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, roomId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteRoom error: " + e.getMessage());
        }
        return false;
    }

    public List<Room> getAllRooms() {
        List<Room> list = new ArrayList<>();
        String sql = "SELECT * FROM Room";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                list.add(new Room(
                    rs.getInt("RoomId"),
                    rs.getInt("TheaterId"),
                    rs.getString("Name"),
                    30 // Force capacity to 30
                ));
            }
        } catch (SQLException e) {
            System.out.println("getAllRooms error: " + e.getMessage());
        }
        return list;
    }
}
