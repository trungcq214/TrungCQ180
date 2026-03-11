package serverlet.staff;

import dao.SnackDAO;
import models.Snack;
import models.User;

import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet(name="StaffSnackServlet", urlPatterns={"/staffSnacks"})
public class StaffSnackServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null || (user.getRole() != 1 && user.getRole() != 2)) {
            response.sendRedirect("login");
            return;
        }

        SnackDAO sDao = new SnackDAO();
        List<Snack> snacks = sDao.getAllSnacks();
        request.setAttribute("snacks", snacks);
        
        request.getRequestDispatcher("staff-snacks.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        if (user == null || (user.getRole() != 1 && user.getRole() != 2)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        if ("sell".equals(action)) {
            try {
                int snackId = Integer.parseInt(request.getParameter("snackId"));
                int qty = Integer.parseInt(request.getParameter("quantity"));
                
                if (qty > 0) {
                    String customerEmail = request.getParameter("customerEmail");
                    Integer customerId = null;
                    if (customerEmail != null && !customerEmail.trim().isEmpty()) {
                        dao.UserDAO uDao = new dao.UserDAO();
                        User customer = uDao.getUserByEmail(customerEmail.trim());
                        if (customer != null) {
                            customerId = customer.getUserId();
                        } else {
                            session.setAttribute("toastMsg", "Customer email not found, processing as Walk-in.");
                            session.setAttribute("toastType", "error");
                        }
                    }

                    SnackDAO sDao = new SnackDAO();
                    boolean success = sDao.sellSnack(snackId, qty, user.getUserId(), customerId);
                    if (success) {
                        if (session.getAttribute("toastType") == null) {
                            session.setAttribute("toastMsg", "Sold " + qty + " item(s) successfully!");
                            session.setAttribute("toastType", "success");
                        }
                    } else {
                        session.setAttribute("toastMsg", "Failed to sell item! Check stock.");
                        session.setAttribute("toastType", "error");
                    }
                }
            } catch (Exception e) {
                session.setAttribute("toastMsg", "Invalid input.");
                session.setAttribute("toastType", "error");
            }
        }
        
        response.sendRedirect("staffSnacks");
    }
}
