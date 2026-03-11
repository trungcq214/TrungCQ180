package serverlet.admin;

import dao.SnackDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Snack;
import models.User;

@WebServlet(name="AdminSnackServlet", urlPatterns={"/adminSnacks"})
public class AdminSnackServlet extends HttpServlet {

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

        SnackDAO dao = new SnackDAO();
        List<Snack> snacks = dao.getAllSnacks();
        request.setAttribute("snacks", snacks);
        request.getRequestDispatcher("admin-snack.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        SnackDAO dao = new SnackDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
                String imageUrl = request.getParameter("imageUrl");

                Snack s = new Snack(0, name, price, stockQuantity, imageUrl);
                dao.insertSnack(s);
                request.getSession().setAttribute("message", "Snack added successfully!");

            } else if ("edit".equals(action)) {
                int id = Integer.parseInt(request.getParameter("snackId"));
                String name = request.getParameter("name");
                double price = Double.parseDouble(request.getParameter("price"));
                int stockQuantity = Integer.parseInt(request.getParameter("stockQuantity"));
                String imageUrl = request.getParameter("imageUrl");

                Snack s = new Snack(id, name, price, stockQuantity, imageUrl);
                dao.updateSnack(s);
                request.getSession().setAttribute("message", "Snack updated successfully!");

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("snackId"));
                dao.deleteSnack(id);
                request.getSession().setAttribute("message", "Snack deleted successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminSnacks");
    }
}
