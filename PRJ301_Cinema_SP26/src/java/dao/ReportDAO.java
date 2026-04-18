package dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
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

    /** Monthly ticket revenue for a given year. Key = month (1-12), Value = revenue. */
    public Map<Integer, Double> getMonthlyTicketRevenue(int year) {
        Map<Integer, Double> result = new LinkedHashMap<>();
        for (int m = 1; m <= 12; m++) result.put(m, 0.0);

        String sql =
            "SELECT MONTH(t.BookingTime) AS Mo, SUM(sch.Price) AS Rev " +
            "FROM Ticket t " +
            "JOIN Schedule sch ON t.ScheduleId = sch.ScheduleId " +
            "WHERE t.Status = 'Paid' AND YEAR(t.BookingTime) = ? " +
            "GROUP BY MONTH(t.BookingTime)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, year);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getInt("Mo"), rs.getDouble("Rev"));
                }
            }
        } catch (SQLException e) {
            System.out.println("getMonthlyTicketRevenue error: " + e.getMessage());
        }
        return result;
    }

    /** Monthly snack revenue for a given year. Key = month (1-12), Value = revenue. */
    public Map<Integer, Double> getMonthlySnackRevenue(int year) {
        Map<Integer, Double> result = new LinkedHashMap<>();
        for (int m = 1; m <= 12; m++) result.put(m, 0.0);

        String sql =
            "SELECT MONTH(OrderTime) AS Mo, SUM(TotalPrice) AS Rev " +
            "FROM SnackOrder " +
            "WHERE YEAR(OrderTime) = ? " +
            "GROUP BY MONTH(OrderTime)";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql)) {
            st.setInt(1, year);
            try (ResultSet rs = st.executeQuery()) {
                while (rs.next()) {
                    result.put(rs.getInt("Mo"), rs.getDouble("Rev"));
                }
            }
        } catch (SQLException e) {
            System.out.println("getMonthlySnackRevenue error: " + e.getMessage());
        }
        return result;
    }

    /** Returns sorted list of all years that have ticket or snack revenue data. */
    public List<Integer> getAvailableYears() {
        List<Integer> years = new ArrayList<>();
        String sql =
            "SELECT DISTINCT yr FROM (" +
            "  SELECT YEAR(BookingTime) AS yr FROM Ticket WHERE Status = 'Paid' " +
            "  UNION " +
            "  SELECT YEAR(OrderTime) AS yr FROM SnackOrder" +
            ") t ORDER BY yr DESC";
        try (Connection conn = getConnection();
             PreparedStatement st = conn.prepareStatement(sql);
             ResultSet rs = st.executeQuery()) {
            while (rs.next()) {
                years.add(rs.getInt("yr"));
            }
        } catch (SQLException e) {
            System.out.println("getAvailableYears error: " + e.getMessage());
        }
        // Fallback: if no data, include current year
        if (years.isEmpty()) {
            years.add(java.util.Calendar.getInstance().get(java.util.Calendar.YEAR));
        }
        return years;
    }
}
