package serverlet.system;

import dao.UserDAO;
import java.io.IOException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet(name="ForgotServlet", urlPatterns={"/forgot"})
public class ForgotServlet extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        String username = request.getParameter("username");

        UserDAO dao = new UserDAO();
        String password = dao.getPasswordByUsername(username);

        if (password != null) {
            request.setAttribute("recoveredPassword", password);
        } else {
            request.setAttribute("error", "Username not found!");
        }
        
        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    }
}
