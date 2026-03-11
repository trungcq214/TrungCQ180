package serverlet.customer;

import dao.MovieDAO;
import dao.ScheduleDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Movie;
import models.Schedule;

@WebServlet(name="ScheduleServlet", urlPatterns={"/schedule"})
public class ScheduleServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String idStr = request.getParameter("id");
        if (idStr == null || idStr.isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int movieId = Integer.parseInt(idStr);
            
            MovieDAO mDao = new MovieDAO();
            Movie movie = mDao.getMovieById(movieId);
            
            if (movie == null) {
                response.sendRedirect("home");
                return;
            }

            ScheduleDAO sDao = new ScheduleDAO();
            List<Schedule> schedules = sDao.getSchedulesByMovieId(movieId);

            request.setAttribute("movie", movie);
            request.setAttribute("schedules", schedules);
            request.getRequestDispatcher("schedule.jsp").forward(request, response);
            
        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
