package serverlet.admin;

import dao.UserDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.User;

@WebServlet(name="AdminStaffServlet", urlPatterns={"/adminStaff"})
public class AdminStaffServlet extends HttpServlet {

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

        UserDAO dao = new UserDAO();
        List<User> staffList = dao.getAllStaff();
        request.setAttribute("staffList", staffList);
        request.getRequestDispatcher("admin-staff.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        UserDAO dao = new UserDAO();

        try {
            if ("add".equals(action)) {
                String username = request.getParameter("username");
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");

                if (dao.checkUsernameExists(username)) {
                    request.getSession().setAttribute("error", "Username already exists!");
                } else {
                    User staff = new User(0, username, email, password, fullName, 1, true, null);
                    dao.insertStaff(staff);
                    request.getSession().setAttribute("message", "Staff account created successfully!");
                }

            } else if ("edit".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                String username = request.getParameter("username"); // read-only context
                String email = request.getParameter("email");
                String password = request.getParameter("password");
                String fullName = request.getParameter("fullName");
                boolean isActive = request.getParameter("isActive") != null;

                User staff = new User(userId, username, email, password, fullName, 1, isActive, null);
                dao.updateStaff(staff);
                request.getSession().setAttribute("message", "Staff account updated successfully!");

            } else if ("delete".equals(action)) {
                int userId = Integer.parseInt(request.getParameter("userId"));
                dao.deleteStaff(userId);
                request.getSession().setAttribute("message", "Staff account deactivated successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminStaff");
    }
}
