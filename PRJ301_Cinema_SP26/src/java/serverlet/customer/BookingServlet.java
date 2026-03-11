package serverlet.customer;

import dao.MovieDAO;
import dao.ScheduleDAO;
import dao.SeatDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Movie;
import models.Schedule;
import models.Seat;
import models.User;

@WebServlet(name="BookingServlet", urlPatterns={"/booking"})
public class BookingServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String sidStr = request.getParameter("scheduleId");
        if (sidStr == null || sidStr.isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(sidStr);
            ScheduleDAO sDao = new ScheduleDAO();
            
            // We need a method to get a single Schedule by ID from DB, let's reuse getAllDetailedSchedules and filter for now (or write a specific one in DAO)
            List<Schedule> allSchedules = sDao.getAllDetailedSchedules();
            Schedule selectedSchedule = null;
            for (Schedule s : allSchedules) {
                if (s.getScheduleId() == scheduleId) {
                    selectedSchedule = s;
                    break;
                }
            }
            
            if (selectedSchedule == null) {
                response.sendRedirect("home");
                return;
            }

            MovieDAO mDao = new MovieDAO();
            Movie movie = mDao.getMovieById(selectedSchedule.getMovieId());

            SeatDAO seatDao = new SeatDAO();
            List<Seat> allSeats = seatDao.getSeatsByRoomId(selectedSchedule.getRoomId());
            List<Integer> bookedSeatIds = seatDao.getBookedSeatIdsByScheduleId(scheduleId);

            request.setAttribute("movie", movie);
            request.setAttribute("schedule", selectedSchedule);
            request.setAttribute("seats", allSeats);
            request.setAttribute("bookedSeatIds", bookedSeatIds);

            request.getRequestDispatcher("booking.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        // Will handle actual booking submission here later
    }
}
