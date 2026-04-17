package dao;

import dal.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import models.Schedule;

public class ScheduleDAO extends DBContext {

    public List<Schedule> getSchedulesByMovieId(int movieId) {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, m.Title AS MovieTitle, r.Name AS RoomName, t.Name AS TheaterName " +
                     "FROM Schedule s " +
                     "JOIN Movie m ON s.MovieId = m.MovieId " +
                     "JOIN Room r ON s.RoomId = r.RoomId " +
                     "JOIN Theater t ON r.TheaterId = t.TheaterId " +
                     "WHERE s.MovieId = ? AND CAST(s.StartTime AS DATE) >= CAST(GETDATE() AS DATE) " +
                     "ORDER BY t.Name, s.StartTime";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, movieId);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    Schedule s = new Schedule(
                        rs.getInt("ScheduleId"),
                        rs.getInt("MovieId"),
                        rs.getInt("RoomId"),
                        rs.getTimestamp("StartTime"),
                        rs.getTimestamp("EndTime"),
                        rs.getDouble("Price")
                    );
                    s.setMovieTitle(rs.getString("MovieTitle"));
                    s.setRoomName(rs.getString("RoomName"));
                    s.setTheaterName(rs.getString("TheaterName"));
                    list.add(s);
                }
            }
        } catch (SQLException e) {
            System.out.println("getSchedulesByMovieId error: " + e.getMessage());
        }
        return list;
    }

    public List<Schedule> getAllDetailedSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, m.Title AS MovieTitle, r.Name AS RoomName, t.Name AS TheaterName " +
                     "FROM Schedule s " +
                     "JOIN Movie m ON s.MovieId = m.MovieId " +
                     "JOIN Room r ON s.RoomId = r.RoomId " +
                     "JOIN Theater t ON r.TheaterId = t.TheaterId " +
                     "ORDER BY s.StartTime DESC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Schedule s = new Schedule(
                    rs.getInt("ScheduleId"),
                    rs.getInt("MovieId"),
                    rs.getInt("RoomId"),
                    rs.getTimestamp("StartTime"),
                    rs.getTimestamp("EndTime"),
                    rs.getDouble("Price")
                );
                s.setMovieTitle(rs.getString("MovieTitle"));
                s.setRoomName(rs.getString("RoomName"));
                s.setTheaterName(rs.getString("TheaterName"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("getAllDetailedSchedules error: " + e.getMessage());
        }
        return list;
    }

    public List<Schedule> getUpcomingDetailedSchedules() {
        List<Schedule> list = new ArrayList<>();
        String sql = "SELECT s.*, m.Title AS MovieTitle, r.Name AS RoomName, t.Name AS TheaterName " +
                     "FROM Schedule s " +
                     "JOIN Movie m ON s.MovieId = m.MovieId " +
                     "JOIN Room r ON s.RoomId = r.RoomId " +
                     "JOIN Theater t ON r.TheaterId = t.TheaterId " +
                     "WHERE CAST(s.StartTime AS DATE) >= CAST(GETDATE() AS DATE) " +
                     "ORDER BY s.StartTime ASC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                Schedule s = new Schedule(
                    rs.getInt("ScheduleId"),
                    rs.getInt("MovieId"),
                    rs.getInt("RoomId"),
                    rs.getTimestamp("StartTime"),
                    rs.getTimestamp("EndTime"),
                    rs.getDouble("Price")
                );
                s.setMovieTitle(rs.getString("MovieTitle"));
                s.setRoomName(rs.getString("RoomName"));
                s.setTheaterName(rs.getString("TheaterName"));
                list.add(s);
            }
        } catch (SQLException e) {
            System.out.println("getUpcomingDetailedSchedules error: " + e.getMessage());
        }
        return list;
    }

    public boolean insertSchedule(Schedule schedule) {
        String sql = "INSERT INTO Schedule (MovieId, RoomId, StartTime, EndTime, Price) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, schedule.getMovieId());
            st.setInt(2, schedule.getRoomId());
            st.setTimestamp(3, schedule.getStartTime());
            st.setTimestamp(4, schedule.getEndTime());
            st.setDouble(5, schedule.getPrice());
            int rows = st.executeUpdate();
            return rows > 0;
        } catch (SQLException e) {
            System.out.println("insertSchedule error: " + e.getMessage());
        }
        return false;
    }

    public boolean deleteSchedule(int scheduleId) {
        String sql = "DELETE FROM Schedule WHERE ScheduleId = ?";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, scheduleId);
            int rows = st.executeUpdate();
            if (rows > 0) {
                resetIdentity("Schedule", "ScheduleId");
                return true;
            }
        } catch (SQLException e) {
            System.out.println("deleteSchedule error: " + e.getMessage());
        }
        return false;
    }
}
