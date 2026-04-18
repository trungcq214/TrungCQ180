package serverlet.admin;

import java.io.IOException;
import java.util.List;
import java.util.Map;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name="AdminReportServlet", urlPatterns={"/adminReport"})
public class AdminReportServlet extends HttpServlet {

    private boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        return user != null && user.getRole() == 2;
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        dao.ReportDAO reportDAO = new dao.ReportDAO();

        // --- Summary stats (all-time) ---
        double totalTicketRevenue = reportDAO.getTotalTicketRevenue();
        double totalSnackRevenue  = reportDAO.getTotalSnackRevenue();
        double totalRevenue       = totalTicketRevenue + totalSnackRevenue;

        request.setAttribute("totalTicketRevenue", totalTicketRevenue);
        request.setAttribute("totalSnackRevenue",  totalSnackRevenue);
        request.setAttribute("totalRevenue",        totalRevenue);
        request.setAttribute("ticketsSold",         reportDAO.getTicketsSold());
        request.setAttribute("snacksSold",          reportDAO.getSnacksSold());

        // --- Chart data: available years & selected year ---
        List<Integer> availableYears = reportDAO.getAvailableYears();
        int currentYear = java.util.Calendar.getInstance().get(java.util.Calendar.YEAR);
        int selectedYear = currentYear;

        String yearParam = request.getParameter("year");
        if (yearParam != null && !yearParam.isEmpty()) {
            try {
                selectedYear = Integer.parseInt(yearParam);
            } catch (NumberFormatException ignored) {}
        } else if (!availableYears.isEmpty()) {
            selectedYear = availableYears.get(0); // most recent year with data
        }

        Map<Integer, Double> monthlyTicket = reportDAO.getMonthlyTicketRevenue(selectedYear);
        Map<Integer, Double> monthlySnack  = reportDAO.getMonthlySnackRevenue(selectedYear);

        // Build comma-separated JS arrays for the chart
        StringBuilder labels     = new StringBuilder();
        StringBuilder dataTicket = new StringBuilder();
        StringBuilder dataSnack  = new StringBuilder();
        String[] monthNames = {"T1","T2","T3","T4","T5","T6","T7","T8","T9","T10","T11","T12"};
        for (int m = 1; m <= 12; m++) {
            if (m > 1) { labels.append(","); dataTicket.append(","); dataSnack.append(","); }
            labels.append("'").append(monthNames[m - 1]).append("'");
            dataTicket.append(monthlyTicket.getOrDefault(m, 0.0).longValue());
            dataSnack.append(monthlySnack.getOrDefault(m, 0.0).longValue());
        }

        request.setAttribute("availableYears",   availableYears);
        request.setAttribute("selectedYear",     selectedYear);
        request.setAttribute("chartLabels",      labels.toString());
        request.setAttribute("chartDataTicket",  dataTicket.toString());
        request.setAttribute("chartDataSnack",   dataSnack.toString());

        request.getRequestDispatcher("admin-report.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
