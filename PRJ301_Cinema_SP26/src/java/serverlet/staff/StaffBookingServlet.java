package serverlet.staff;

import dao.ScheduleDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Schedule;
import models.User;

@WebServlet(name="StaffBookingServlet", urlPatterns={"/staffBooking"})
public class StaffBookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null || (user.getRole() != 1 && user.getRole() != 2)) {
            response.sendRedirect("login");
            return;
        }

        // Fetch all upcoming schedules so staff can select one to book
        ScheduleDAO sDao = new ScheduleDAO();
        List<Schedule> upcomingSchedules = sDao.getUpcomingDetailedSchedules(); 
        
        // Note: For a real POS, we'd probably filter by "today's schedules only" 
        // and add a search/filter bar. For now, we show all detailed schedules.

        request.setAttribute("schedules", upcomingSchedules);
        request.getRequestDispatcher("staff-booking.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
