package serverlet.customer;

import dao.MovieDAO;
import dao.ScheduleDAO;
import dao.SeatDAO;
import dao.TicketDAO;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Movie;
import models.Schedule;
import models.Seat;
import models.Ticket;
import models.User;

@WebServlet(name="PaymentServlet", urlPatterns={"/payment"})
public class PaymentServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        String seatIdsStr = request.getParameter("seatIds");

        if (scheduleIdStr == null || seatIdsStr == null || seatIdsStr.isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdStr);
            String[] seatIdArray = seatIdsStr.split(",");
            
            ScheduleDAO sDao = new ScheduleDAO();
            List<Schedule> allSchedules = sDao.getAllDetailedSchedules();
            Schedule selectedSchedule = null;
            for (Schedule s : allSchedules) {
                if (s.getScheduleId() == scheduleId) {
                    selectedSchedule = s;
                    break;
                }
            }
            if (selectedSchedule == null) {
                response.sendRedirect("home");
                return;
            }

            MovieDAO mDao = new MovieDAO();
            Movie movie = mDao.getMovieById(selectedSchedule.getMovieId());

            SeatDAO seatDao = new SeatDAO();
            List<Seat> allSeats = seatDao.getSeatsByRoomId(selectedSchedule.getRoomId());
            
            dao.SnackDAO snackDao = new dao.SnackDAO();
            List<models.Snack> availableSnacks = snackDao.getAllSnacks();
            request.setAttribute("availableSnacks", availableSnacks);
            
            List<Seat> selectedSeats = new ArrayList<>();
            for (String sId : seatIdArray) {
                int id = Integer.parseInt(sId);
                for (Seat s : allSeats) {
                    if (s.getSeatId() == id) {
                        selectedSeats.add(s);
                        break;
                    }
                }
            }

            double totalAmount = selectedSeats.size() * selectedSchedule.getPrice();

            request.setAttribute("movie", movie);
            request.setAttribute("schedule", selectedSchedule);
            request.setAttribute("selectedSeats", selectedSeats);
            request.setAttribute("totalAmount", totalAmount);
            request.setAttribute("seatIdsStr", seatIdsStr);

            request.getRequestDispatcher("payment.jsp").forward(request, response);

        } catch (NumberFormatException e) {
            response.sendRedirect("home");
        }
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("account");
        
        if (user == null) {
            response.sendRedirect("login");
            return;
        }

        String scheduleIdStr = request.getParameter("scheduleId");
        String seatIdsStr = request.getParameter("seatIds");

        if (scheduleIdStr == null || seatIdsStr == null || seatIdsStr.isEmpty()) {
            response.sendRedirect("home");
            return;
        }

        try {
            int scheduleId = Integer.parseInt(scheduleIdStr);
            String[] seatIdArray = seatIdsStr.split(",");
            
            TicketDAO tDao = new TicketDAO();
            boolean success = true;
            
            Integer customerId = user.getUserId();
            String customerEmail = request.getParameter("customerEmail");
            
            if (user.getRole() == 1 || user.getRole() == 2) {
                // Staff or Admin booking on behalf of customer
                if (customerEmail != null && !customerEmail.trim().isEmpty()) {
                    dao.UserDAO uDao = new dao.UserDAO();
                    User customer = uDao.getUserByEmail(customerEmail.trim());
                    if (customer == null) {
                        request.setAttribute("error", "Customer with email " + customerEmail + " not found!");
                        doGet(request, response);
                        return;
                    }
                    customerId = customer.getUserId();
                } else {
                    customerId = null; // Walk-in
                }
            }
            
            for (String sId : seatIdArray) {
                int seatId = Integer.parseInt(sId);
                Ticket t = new Ticket(0, scheduleId, seatId, customerId, null, null, "Paid");
                if (!tDao.bookTicket(t)) {
                    success = false;
                }
            }

            // Process Snack Orders
            dao.SnackDAO snackDao = new dao.SnackDAO();
            List<models.Snack> snacks = snackDao.getAllSnacks();
            for (models.Snack s : snacks) {
                String qStr = request.getParameter("snack_qty_" + s.getSnackId());
                if (qStr != null && !qStr.isEmpty()) {
                    int qty = Integer.parseInt(qStr);
                    if (qty > 0) {
                        snackDao.sellSnack(s.getSnackId(), qty, null, customerId);
                    }
                }
            }

            if (success) {
                session.setAttribute("bookingSuccess", "Your tickets have been successfully booked!");
                if (user.getRole() == 1 || user.getRole() == 2) {
                    response.sendRedirect("staffTickets");
                } else {
                    response.sendRedirect("history");
                }
            } else {
                request.setAttribute("error", "There was an error processing your booking. Some seats might have already been taken.");
                doGet(request, response);
            }

        } catch (Exception e) {
            request.setAttribute("error", "System error: " + e.getMessage());
            doGet(request, response);
        }
    }
}
