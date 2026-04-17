package serverlet.customer;

import dao.SnackDAO;
import dao.TicketDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.Objects;
import models.Ticket;
import models.User;

@WebServlet(name="RefundServlet", urlPatterns={"/refund"})
public class RefundServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String ticketIdStr = request.getParameter("ticketId");
        if (ticketIdStr == null || ticketIdStr.isEmpty()) {
            response.sendRedirect("history");
            return;
        }

        try {
            int ticketId = Integer.parseInt(ticketIdStr);
            TicketDAO tDao = new TicketDAO();
            Ticket t = tDao.getTicketById(ticketId);
            
            if (t == null) {
                session.setAttribute("error", "Vé không tồn tại!");
                response.sendRedirect("history");
                return;
            }
            
            // Allow user to cancel their own ticket, or Admin/Staff to cancel any ticket
            if (user.getRole() != 1 && user.getRole() != 2) {
                if (!Objects.equals(t.getCustomerId(), user.getUserId())) {
                    session.setAttribute("error", "Bạn không có quyền hủy vé này.");
                    response.sendRedirect("history");
                    return;
                }
            }

            if (!"Paid".equals(t.getStatus())) {
                session.setAttribute("error", "Tình trạng vé không hợp lệ để hủy.");
                response.sendRedirect("history");
                return;
            }

            // Check if start time is > 24 hours from now
            long diff = t.getStartTime().getTime() - System.currentTimeMillis();
            long hours24 = 24L * 60L * 60L * 1000L;
            if (diff < hours24) {
                session.setAttribute("error", "Chỉ được hủy vé trước 24 giờ so với giờ chiếu.");
                response.sendRedirect("history");
                return;
            }

            // Execute refund
            if (tDao.updateTicketStatus(ticketId, "Refunded")) {
                // Check if there are any remaining paid tickets for this order
                List<Ticket> scheduleTickets = tDao.getTicketsByScheduleId(t.getScheduleId());
                boolean hasRemainingPaidTickets = false;
                
                for (Ticket st : scheduleTickets) {
                    if ("Paid".equals(st.getStatus()) &&
                        Math.abs(st.getBookingTime().getTime() - t.getBookingTime().getTime()) <= 5000 &&
                        Objects.equals(st.getCustomerId(), t.getCustomerId()) &&
                        Objects.equals(st.getStaffId(), t.getStaffId())) {
                        hasRemainingPaidTickets = true;
                        break;
                    }
                }
                
                if (!hasRemainingPaidTickets) {
                    SnackDAO sDao = new SnackDAO();
                    sDao.refundSnacksByOrderTime(t.getBookingTime(), t.getCustomerId(), t.getStaffId());
                    session.setAttribute("message", "Đã hủy vé thành công! Toàn bộ vé trong đơn hàng đã bị hủy, do đó đồ ăn/uống (nếu có) cũng đã được hủy tự động.");
                } else {
                    session.setAttribute("message", "Hủy vé thành công! Bạn vẫn còn vé trong đơn hàng nên đồ ăn/uống (nếu có) được giữ lại.");
                }
            } else {
                session.setAttribute("error", "Lỗi trong quá trình hủy vé.");
            }

        } catch (NumberFormatException e) {
            session.setAttribute("error", "Mã vé không hợp lệ.");
        }
        
        response.sendRedirect("history");
    }
}
