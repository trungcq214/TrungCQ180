package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Seat;

public class SeatDAO extends DBContext {

    public List<Seat> getSeatsByRoomId(int roomId) {
        List<Seat> list = new ArrayList<>();
        String sql = "SELECT * FROM Seat WHERE RoomId = ? ORDER BY SeatName";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, roomId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Seat(
                        rs.getInt("SeatId"),
                        rs.getInt("RoomId"),
                        rs.getString("SeatName"),
                        rs.getString("Type")
                    ));
                }
            }
            
            // Auto-generate missing seats up to 30 (A1-A10, B1-B10, C1-C10)
            if (list.size() < 30) {
                String[] rows = {"A", "B", "C"};
                List<String> expectedNames = new ArrayList<>();
                for (String r : rows) {
                    for (int i = 1; i <= 10; i++) {
                        expectedNames.add(r + i);
                    }
                }
                
                List<String> existingNames = new ArrayList<>();
                for(Seat s : list) {
                    existingNames.add(s.getSeatName());
                }
                
                String insertSql = "INSERT INTO Seat (RoomId, SeatName, Type) VALUES (?, ?, 'Normal')";
                try (PreparedStatement pInsert = conn.prepareStatement(insertSql)) {
                    for(String name : expectedNames) {
                        if(!existingNames.contains(name)) {
                            pInsert.setInt(1, roomId);
                            pInsert.setString(2, name);
                            pInsert.executeUpdate();
                        }
                    }
                }
                
                // Re-fetch to get the IDs of the newly inserted seats
                list.clear();
                try (ResultSet rs = st.executeQuery()) {
                    while (rs.next()) {
                        list.add(new Seat(
                            rs.getInt("SeatId"),
                            rs.getInt("RoomId"),
                            rs.getString("SeatName"),
                            rs.getString("Type")
                        ));
                    }
                }
            }
        } catch (SQLException e) {
            System.out.println("getSeatsByRoomId error: " + e.getMessage());
        }
        return list;
    }

    public List<Integer> getBookedSeatIdsByScheduleId(int scheduleId) {
        List<Integer> bookedSeats = new ArrayList<>();
        String sql = "SELECT SeatId FROM Ticket WHERE ScheduleId = ? AND Status = 'Paid'";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, scheduleId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    bookedSeats.add(rs.getInt("SeatId"));
                }
            }
        } catch (SQLException e) {
            System.out.println("getBookedSeatIdsByScheduleId error: " + e.getMessage());
        }
        return bookedSeats;
    }

    public boolean insertSeat(Seat seat) {
        String sql = "INSERT INTO Seat (RoomId, SeatName, Type) VALUES (?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, seat.getRoomId());
            st.setString(2, seat.getSeatName());
            st.setString(3, seat.getType());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertSeat error: " + e.getMessage());
        }
        return false;
    }

    public boolean updateSeat(Seat seat) {
        String sql = "UPDATE Seat SET SeatName = ?, Type = ? WHERE SeatId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setString(1, seat.getSeatName());
            st.setString(2, seat.getType());
            st.setInt(3, seat.getSeatId());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("updateSeat error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteSeat(int seatId) {
        String sql = "DELETE FROM Seat WHERE SeatId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, seatId);
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("deleteSeat error: " + e.getMessage());
        }
        return false;
    }
}
