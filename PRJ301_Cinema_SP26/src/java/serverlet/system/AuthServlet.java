package serverlet.system;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name="AuthServlet", urlPatterns={"/login", "/logout"})
public class AuthServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String path = request.getServletPath();
        if ("/logout".equals(path)) {
            HttpSession session = request.getSession();
            session.invalidate();
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        request.getRequestDispatcher("login.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String u = request.getParameter("username");
        String p = request.getParameter("password");
        
        UserDAO dao = new UserDAO();
        User user = dao.login(u, p);
        
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("account", user);
            
            if (user.getRole() == 2) {
                response.sendRedirect("admin");
            } else if (user.getRole() == 1) {
                response.sendRedirect("staff");
            } else {
                response.sendRedirect("home");
            }
        } else {
            request.setAttribute("error", "Invalid username or password!");
            request.getRequestDispatcher("login.jsp").forward(request, response);
        }
    }
}
