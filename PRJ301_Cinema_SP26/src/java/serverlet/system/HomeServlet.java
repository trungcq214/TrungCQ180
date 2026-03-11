package serverlet.system;

import dao.MovieDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import models.Movie;

@WebServlet(name="HomeServlet", urlPatterns={"/home"})
public class HomeServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        MovieDAO dao = new MovieDAO();
        List<Movie> movies = dao.getAllMovies();
        
        request.setAttribute("movies", movies);
        request.getRequestDispatcher("home.jsp").forward(request, response);
    } 
}
