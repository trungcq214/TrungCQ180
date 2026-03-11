package serverlet.admin;

import dao.TheaterDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Theater;
import models.User;

@WebServlet(name="AdminTheaterServlet", urlPatterns={"/adminTheaters"})
public class AdminTheaterServlet extends HttpServlet {

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

        TheaterDAO dao = new TheaterDAO();
        List<Theater> theaters = dao.getAllTheaters();
        request.setAttribute("theaters", theaters);
        request.getRequestDispatcher("admin-theater.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        TheaterDAO dao = new TheaterDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String address = request.getParameter("address");

                Theater t = new Theater(0, name, address, true);
                dao.insertTheater(t);
                request.getSession().setAttribute("message", "Theater added successfully!");

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("theaterId"));
                String name = request.getParameter("name");
                String address = request.getParameter("address");

                Theater t = new Theater(id, name, address, true);
                dao.updateTheater(t);
                request.getSession().setAttribute("message", "Theater updated successfully!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("theaterId"));
                dao.deleteTheater(id);
                request.getSession().setAttribute("message", "Theater deleted successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminTheaters");
    }
}
