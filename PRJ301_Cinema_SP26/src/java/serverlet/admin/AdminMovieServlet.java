package serverlet.admin;

import dao.MovieDAO;
import java.io.IOException;
import java.sql.Date;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Movie;
import models.User;

@WebServlet(name="AdminMovieServlet", urlPatterns={"/adminMovies"})
public class AdminMovieServlet extends HttpServlet {

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

        MovieDAO dao = new MovieDAO();
        List<Movie> movies = dao.getAllMovies();
        request.setAttribute("movies", movies);
        request.getRequestDispatcher("admin-movie.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        MovieDAO dao = new MovieDAO();

        try {
            if ("add".equals(action)) {
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                int duration = Integer.parseInt(request.getParameter("duration"));
                Date releaseDate = Date.valueOf(request.getParameter("releaseDate"));
                String posterUrl = request.getParameter("posterUrl");

                Movie m = new Movie(0, title, description, duration, releaseDate, posterUrl);
                dao.insertMovie(m);
                request.getSession().setAttribute("message", "Movie added successfully!");

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("movieId"));
                String title = request.getParameter("title");
                String description = request.getParameter("description");
                int duration = Integer.parseInt(request.getParameter("duration"));
                Date releaseDate = Date.valueOf(request.getParameter("releaseDate"));
                String posterUrl = request.getParameter("posterUrl");

                Movie m = new Movie(id, title, description, duration, releaseDate, posterUrl);
                dao.updateMovie(m);
                request.getSession().setAttribute("message", "Movie updated successfully!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("movieId"));
                dao.deleteMovie(id);
                request.getSession().setAttribute("message", "Movie deleted successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminMovies");
    }
}
