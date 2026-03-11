package serverlet.staff;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="StaffServlet", urlPatterns={"/staff"})
public class StaffServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.setAttribute("message", "Welcome to Staff Dashboard. Selling features are in development.");
        request.getRequestDispatcher("staff.jsp").forward(request, response);
    } 
}
