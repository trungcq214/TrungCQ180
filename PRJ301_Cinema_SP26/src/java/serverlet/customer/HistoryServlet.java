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
        List<Ticket> rawTickets = tDao.getTicketsByCustomerId(user.getUserId());
        java.util.Map<String, List<Ticket>> groupedMap = new java.util.LinkedHashMap<>();
        for (Ticket t : rawTickets) {
            String key = t.getScheduleId() + "_" + t.getBookingTime().getTime();
            groupedMap.computeIfAbsent(key, k -> new java.util.ArrayList<>()).add(t);
        }

        dao.SnackDAO sDao = new dao.SnackDAO();
        List<models.SnackOrder> snackOrders = sDao.getSnackOrdersByCustomerId(user.getUserId());
        
        List<java.util.Map<String, Object>> finalOrders = new java.util.ArrayList<>();
        
        for (List<Ticket> tList : groupedMap.values()) {
            java.util.Map<String, Object> orderDto = new java.util.HashMap<>();
            orderDto.put("tickets", tList);
            
            Ticket firstT = tList.get(0);
            long tTime = firstT.getBookingTime().getTime();
            
            List<models.SnackOrder> relatedSnacks = new java.util.ArrayList<>();
            java.util.Iterator<models.SnackOrder> it = snackOrders.iterator();
            while(it.hasNext()) {
                models.SnackOrder snack = it.next();
                if (Math.abs(snack.getOrderTime().getTime() - tTime) <= 5000) {
                    relatedSnacks.add(snack);
                    it.remove();
                }
            }
            orderDto.put("snacks", relatedSnacks);
            orderDto.put("orderTime", firstT.getBookingTime());
            finalOrders.add(orderDto);
        }
        
        // Nhóm các snack còn lại (mua riêng rẽ không kèm vé)
        while(!snackOrders.isEmpty()) {
            models.SnackOrder firstS = snackOrders.remove(0);
            List<models.SnackOrder> sList = new java.util.ArrayList<>();
            sList.add(firstS);
            
            java.util.Iterator<models.SnackOrder> it = snackOrders.iterator();
            while(it.hasNext()) {
                models.SnackOrder snack = it.next();
                if (Math.abs(snack.getOrderTime().getTime() - firstS.getOrderTime().getTime()) <= 5000) {
                    sList.add(snack);
                    it.remove();
                }
            }
            java.util.Map<String, Object> orderDto = new java.util.HashMap<>();
            orderDto.put("tickets", new java.util.ArrayList<Ticket>());
            orderDto.put("snacks", sList);
            orderDto.put("orderTime", firstS.getOrderTime());
            finalOrders.add(orderDto);
        }
        
        finalOrders.sort((o1, o2) -> {
            java.util.Date d1 = (java.util.Date) o1.get("orderTime");
            java.util.Date d2 = (java.util.Date) o2.get("orderTime");
            return d2.compareTo(d1);
        });

        request.setAttribute("finalOrders", finalOrders);
        
        request.getRequestDispatcher("history.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doGet(request, response);
    }
}
