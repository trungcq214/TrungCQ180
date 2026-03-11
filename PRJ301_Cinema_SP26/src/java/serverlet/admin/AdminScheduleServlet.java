package serverlet.admin;

import dao.MovieDAO;
import dao.RoomDAO;
import dao.ScheduleDAO;
import dao.TheaterDAO;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Movie;
import models.Room;
import models.Schedule;
import models.Theater;
import models.User;

@WebServlet(name="AdminScheduleServlet", urlPatterns={"/adminSchedules"})
public class AdminScheduleServlet extends HttpServlet {

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

        ScheduleDAO sDao = new ScheduleDAO();
        MovieDAO mDao = new MovieDAO();
        TheaterDAO tDao = new TheaterDAO();
        RoomDAO rDao = new RoomDAO();

        List<Schedule> schedules = sDao.getAllDetailedSchedules();
        List<Movie> movies = mDao.getAllMovies();
        List<Theater> theaters = tDao.getAllTheaters();
        List<Room> rooms = rDao.getAllRooms();

        request.setAttribute("schedules", schedules);
        request.setAttribute("movies", movies);
        request.setAttribute("theaters", theaters);
        request.setAttribute("rooms", rooms);
        
        request.getRequestDispatcher("admin-schedule.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        ScheduleDAO dao = new ScheduleDAO();

        try {
            if ("add".equals(action)) {
                int movieId = Integer.parseInt(request.getParameter("movieId"));
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                double price = Double.parseDouble(request.getParameter("price"));
                
                // HTML5 datetime-local gives "YYYY-MM-DDTHH:MM" 
                // Timestamp needs "YYYY-MM-DD HH:MM:SS"
                String startStr = request.getParameter("startTime").replace("T", " ");
                if (startStr.length() == 16) startStr += ":00";
                Timestamp startTime = Timestamp.valueOf(startStr);

                String endStr = request.getParameter("endTime").replace("T", " ");
                if (endStr.length() == 16) endStr += ":00";
                Timestamp endTime = Timestamp.valueOf(endStr);

                Schedule s = new Schedule(0, movieId, roomId, startTime, endTime, price);
                dao.insertSchedule(s);
                request.getSession().setAttribute("message", "Showtime added successfully!");

            } else if ("delete".equals(action)) {
                int scheduleId = Integer.parseInt(request.getParameter("scheduleId"));
                dao.deleteSchedule(scheduleId);
                request.getSession().setAttribute("message", "Showtime deleted successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminSchedules");
    }
}
