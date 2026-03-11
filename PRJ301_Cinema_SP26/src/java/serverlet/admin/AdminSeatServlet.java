package serverlet.admin;

import dao.RoomDAO;
import dao.SeatDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Room;
import models.Seat;
import models.User;
import dao.TheaterDAO;
import models.Theater;

@WebServlet(name="AdminSeatServlet", urlPatterns={"/adminSeats"})
public class AdminSeatServlet extends HttpServlet {

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

        String roomIdStr = request.getParameter("roomId");
        String tIdStr = request.getParameter("theaterId");
        
        if (roomIdStr == null || roomIdStr.isEmpty() || tIdStr == null || tIdStr.isEmpty()) {
            response.sendRedirect("adminTheaters");
            return;
        }

        int roomId = Integer.parseInt(roomIdStr);
        int theaterId = Integer.parseInt(tIdStr);
        
        RoomDAO rd = new RoomDAO();
        TheaterDAO td = new TheaterDAO();
        SeatDAO sd = new SeatDAO();
        
        // Ensure Room belongs to Theater
        // Since we don't have getRoomById, we loop through getRoomsByTheaterId
        List<Room> rooms = rd.getRoomsByTheaterId(theaterId);
        Room roomObj = null;
        for (Room r : rooms) {
            if(r.getRoomId() == roomId) {
                roomObj = r;
                break;
            }
        }
        
        if (roomObj == null) {
            response.sendRedirect("adminTheaters");
            return;
        }
        
        Theater theater = td.getTheaterById(theaterId);

        List<Seat> seats = sd.getSeatsByRoomId(roomId);
        
        request.setAttribute("theater", theater);
        request.setAttribute("room", roomObj);
        request.setAttribute("seats", seats);
        request.getRequestDispatcher("admin-seat.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        int roomId = Integer.parseInt(request.getParameter("roomId"));
        int theaterId = Integer.parseInt(request.getParameter("theaterId"));
        SeatDAO dao = new SeatDAO();

        try {
            if ("add".equals(action)) {
                List<Seat> currentSeats = dao.getSeatsByRoomId(roomId);
                if (currentSeats.size() >= 30) {
                    request.getSession().setAttribute("error", "Cannot add more seats. Room is at maximum capacity (30 seats).");
                } else {
                    String name = request.getParameter("name");
                    String type = request.getParameter("type");

                    Seat s = new Seat(0, roomId, name, type);
                    dao.insertSeat(s);
                    request.getSession().setAttribute("message", "Seat added successfully!");
                }

            } else if ("edit".equals(action)) {
                int seatId = Integer.parseInt(request.getParameter("seatId"));
                String name = request.getParameter("name");
                String type = request.getParameter("type");

                Seat s = new Seat(seatId, roomId, name, type);
                dao.updateSeat(s);
                request.getSession().setAttribute("message", "Seat updated successfully!");

            } else if ("delete".equals(action)) {
                int seatId = Integer.parseInt(request.getParameter("seatId"));
                dao.deleteSeat(seatId);
                request.getSession().setAttribute("message", "Seat deleted successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminSeats?theaterId=" + theaterId + "&roomId=" + roomId);
    }
}
