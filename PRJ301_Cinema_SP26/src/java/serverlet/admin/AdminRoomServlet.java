package serverlet.admin;

import dao.RoomDAO;
import dao.TheaterDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import models.Room;
import models.Theater;
import models.User;

@WebServlet(name="AdminRoomServlet", urlPatterns={"/adminRooms"})
public class AdminRoomServlet extends HttpServlet {

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

        String tIdStr = request.getParameter("theaterId");
        if (tIdStr == null || tIdStr.isEmpty()) {
            response.sendRedirect("adminTheaters");
            return;
        }

        int theaterId = Integer.parseInt(tIdStr);
        TheaterDAO td = new TheaterDAO();
        Theater theater = td.getTheaterById(theaterId);
        
        if (theater == null) {
            response.sendRedirect("adminTheaters");
            return;
        }

        RoomDAO rd = new RoomDAO();
        List<Room> rooms = rd.getRoomsByTheaterId(theaterId);
        
        request.setAttribute("theater", theater);
        request.setAttribute("rooms", rooms);
        request.getRequestDispatcher("admin-room.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        if (!isAdmin(request)) {
            response.sendRedirect("login");
            return;
        }

        String action = request.getParameter("action");
        int theaterId = Integer.parseInt(request.getParameter("theaterId"));
        RoomDAO dao = new RoomDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                int capacity = 30; // Force to 30

                Room r = new Room(0, theaterId, name, capacity);
                dao.insertRoom(r);
                request.getSession().setAttribute("message", "Room added successfully!");

            } else if ("edit".equals(action)) {
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                String name = request.getParameter("name");
                int capacity = 30; // Force to 30

                Room r = new Room(roomId, theaterId, name, capacity);
                dao.updateRoom(r);
                request.getSession().setAttribute("message", "Room updated successfully!");

            } else if ("delete".equals(action)) {
                int roomId = Integer.parseInt(request.getParameter("roomId"));
                dao.deleteRoom(roomId);
                request.getSession().setAttribute("message", "Room deleted successfully!");
            }
        } catch (Exception e) {
            request.getSession().setAttribute("error", "Error processing request: " + e.getMessage());
        }

        response.sendRedirect("adminRooms?theaterId=" + theaterId);
    }
}
