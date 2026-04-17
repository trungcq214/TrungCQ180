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
        String email = request.getParameter("email");

        if (username == null || username.trim().isEmpty()) {
            request.setAttribute("error", "Username là bắt buộc!");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }
        if (email == null || email.trim().isEmpty()) {
            request.setAttribute("error", "Email là bắt buộc!");
            request.getRequestDispatcher("forgot.jsp").forward(request, response);
            return;
        }

        UserDAO dao = new UserDAO();
        models.User user = dao.getUserByUsernameAndEmail(username.trim(), email.trim());

        if (user != null) {
            request.setAttribute("recoveredPassword", user.getPassword());
        } else {
            request.setAttribute("error", "Username hoặc Email không đúng. Vui lòng kiểm tra lại!");
        }
        
        request.getRequestDispatcher("forgot.jsp").forward(request, response);
    }
}
