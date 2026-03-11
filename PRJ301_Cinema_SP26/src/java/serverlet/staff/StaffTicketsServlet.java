package serverlet.staff;

import dao.TicketDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Ticket;
import models.User;

@WebServlet(name="StaffTicketsServlet", urlPatterns={"/staffTickets"})
public class StaffTicketsServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null || (user.getRole() != 1 && user.getRole() != 2)) {
            response.sendRedirect("login");
            return;
        }

        TicketDAO tDao = new TicketDAO();
        List<Ticket> allTickets = tDao.getAllDetailedTickets();
        request.setAttribute("tickets", allTickets);

        dao.SnackDAO sDao = new dao.SnackDAO();
        List<models.SnackOrder> allSnackOrders = sDao.getAllSnackOrders();
        request.setAttribute("snackOrders", allSnackOrders);
        
        request.getRequestDispatcher("staff-tickets.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
