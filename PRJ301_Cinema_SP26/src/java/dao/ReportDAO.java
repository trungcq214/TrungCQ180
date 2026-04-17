package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import dal.DBContext;

public class ReportDAO extends DBContext {

    public double getTotalTicketRevenue() {
        double total = 0;
        String sql = "SELECT SUM(sch.Price) AS TotalTicketRevenue " +
                     "FROM Ticket t " +
                     "JOIN Schedule sch ON t.ScheduleId = sch.ScheduleId " +
                     "WHERE t.Status = 'Paid'";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("TotalTicketRevenue");
            }
        } catch (SQLException e) {
            System.out.println("getTotalTicketRevenue error: " + e.getMessage());
        }
        return total;
    }

    public int getTicketsSold() {
        int count = 0;
        String sql = "SELECT COUNT(TicketId) AS TicketsSold FROM Ticket WHERE Status = 'Paid'";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("TicketsSold");
            }
        } catch (SQLException e) {
            System.out.println("getTicketsSold error: " + e.getMessage());
        }
        return count;
    }

    public double getTotalSnackRevenue() {
        double total = 0;
        String sql = "SELECT SUM(TotalPrice) AS TotalSnackRevenue FROM SnackOrder";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                total = rs.getDouble("TotalSnackRevenue");
            }
        } catch (SQLException e) {
            System.out.println("getTotalSnackRevenue error: " + e.getMessage());
        }
        return total;
    }

    public int getSnacksSold() {
        int count = 0;
        String sql = "SELECT SUM(Quantity) AS SnacksSold FROM SnackOrder";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            if (rs.next()) {
                count = rs.getInt("SnacksSold");
            }
        } catch (SQLException e) {
            System.out.println("getSnacksSold error: " + e.getMessage());
        }
        return count;
    }
}
