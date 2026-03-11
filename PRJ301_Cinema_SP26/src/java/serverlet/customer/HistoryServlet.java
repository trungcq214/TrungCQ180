package serverlet.customer;

import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.List;
import dao.TicketDAO;
import models.Ticket;
import models.User;

@WebServlet(name="HistoryServlet", urlPatterns={"/history"})
public class HistoryServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        TicketDAO tDao = new TicketDAO();
        List<Ticket> tickets = tDao.getTicketsByCustomerId(user.getUserId());
        request.setAttribute("tickets", tickets);

        dao.SnackDAO sDao = new dao.SnackDAO();
        List<models.SnackOrder> snackOrders = sDao.getSnackOrdersByCustomerId(user.getUserId());
        request.setAttribute("snackOrders", snackOrders);
        
        request.getRequestDispatcher("history.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
