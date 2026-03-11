package serverlet.admin;

import java.io.IOException;
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
        double totalTicketRevenue = reportDAO.getTotalTicketRevenue();
        double totalSnackRevenue = reportDAO.getTotalSnackRevenue();
        double totalRevenue = totalTicketRevenue + totalSnackRevenue;
        
        request.setAttribute("totalTicketRevenue", totalTicketRevenue);
        request.setAttribute("totalSnackRevenue", totalSnackRevenue);
        request.setAttribute("totalRevenue", totalRevenue);
        request.setAttribute("ticketsSold", reportDAO.getTicketsSold());
        request.setAttribute("snacksSold", reportDAO.getSnacksSold());

        request.getRequestDispatcher("admin-report.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
