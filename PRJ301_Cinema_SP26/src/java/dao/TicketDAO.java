package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Ticket;

public class TicketDAO extends DBContext {

    public List<Ticket> getTicketsByScheduleId(int scheduleId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT * FROM Ticket WHERE ScheduleId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
             st.setInt(1, scheduleId);
             try(ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    list.add(new Ticket(
                        rs.getInt("TicketId"),
                        rs.getInt("ScheduleId"),
                        rs.getInt("SeatId"),
                        (Integer) rs.getObject("CustomerId"),
                        (Integer) rs.getObject("StaffId"),
                        rs.getTimestamp("BookingTime"),
                        rs.getString("Status")
                    ));
                }
             }
        } catch (SQLException e) {
            System.out.println("getTicketsByScheduleId error: " + e.getMessage());
        }
        return list;
    }

    public boolean bookTicket(Ticket t) {
        String sql = "INSERT INTO Ticket (ScheduleId, SeatId, CustomerId, StaffId, Status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
             st.setInt(1, t.getScheduleId());
             st.setInt(2, t.getSeatId());
             st.setObject(3, t.getCustomerId());
             st.setObject(4, t.getStaffId());
             st.setString(5, t.getStatus());
             
             return st.executeUpdate() > 0;
        } catch (SQLException e) {
            System.out.println("bookTicket error: " + e.getMessage());
        }
        return false;
    }

    public List<Ticket> getTicketsByCustomerId(int customerId) {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, m.Title AS MovieTitle, th.Name AS TheaterName, r.Name AS RoomName, " +
                     "s.SeatName, sch.StartTime, sch.Price " +
                     "FROM Ticket t " +
                     "JOIN Schedule sch ON t.ScheduleId = sch.ScheduleId " +
                     "JOIN Movie m ON sch.MovieId = m.MovieId " +
                     "JOIN Room r ON sch.RoomId = r.RoomId " +
                     "JOIN Theater th ON r.TheaterId = th.TheaterId " +
                     "JOIN Seat s ON t.SeatId = s.SeatId " +
                     "WHERE t.CustomerId = ? " +
                     "ORDER BY t.BookingTime DESC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
             st.setInt(1, customerId);
             try(ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Ticket t = new Ticket(
                        rs.getInt("TicketId"),
                        rs.getInt("ScheduleId"),
                        rs.getInt("SeatId"),
                        (Integer) rs.getObject("CustomerId"),
                        (Integer) rs.getObject("StaffId"),
                        rs.getTimestamp("BookingTime"),
                        rs.getString("Status")
                    );
                    t.setMovieTitle(rs.getString("MovieTitle"));
                    t.setTheaterName(rs.getString("TheaterName"));
                    t.setRoomName(rs.getString("RoomName"));
                    t.setSeatName(rs.getString("SeatName"));
                    t.setStartTime(rs.getTimestamp("StartTime"));
                    t.setPrice(rs.getDouble("Price"));
                    list.add(t);
                }
             }
        } catch (SQLException e) {
            System.out.println("getTicketsByCustomerId error: " + e.getMessage());
        }
        return list;
    }

    public List<Ticket> getAllDetailedTickets() {
        List<Ticket> list = new ArrayList<>();
        String sql = "SELECT t.*, m.Title AS MovieTitle, th.Name AS TheaterName, r.Name AS RoomName, " +
                     "s.SeatName, sch.StartTime, sch.Price " +
                     "FROM Ticket t " +
                     "JOIN Schedule sch ON t.ScheduleId = sch.ScheduleId " +
                     "JOIN Movie m ON sch.MovieId = m.MovieId " +
                     "JOIN Room r ON sch.RoomId = r.RoomId " +
                     "JOIN Theater th ON r.TheaterId = th.TheaterId " +
                     "JOIN Seat s ON t.SeatId = s.SeatId " +
                     "ORDER BY t.BookingTime DESC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Ticket t = new Ticket(
                        rs.getInt("TicketId"),
                        rs.getInt("ScheduleId"),
                        rs.getInt("SeatId"),
                        (Integer) rs.getObject("CustomerId"),
                        (Integer) rs.getObject("StaffId"),
                        rs.getTimestamp("BookingTime"),
                        rs.getString("Status")
                    );
                    t.setMovieTitle(rs.getString("MovieTitle"));
                    t.setTheaterName(rs.getString("TheaterName"));
                    t.setRoomName(rs.getString("RoomName"));
                    t.setSeatName(rs.getString("SeatName"));
                    t.setStartTime(rs.getTimestamp("StartTime"));
                    t.setPrice(rs.getDouble("Price"));
                    list.add(t);
                }
        } catch (SQLException e) {
            System.out.println("getAllDetailedTickets error: " + e.getMessage());
        }
        return list;
    }
}
