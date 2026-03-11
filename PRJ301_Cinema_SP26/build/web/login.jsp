<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cinema Login</title>
        <style>
            body { font-family: Arial, sans-serif; background-color: #f4f4f4; display: flex; justify-content: center; align-items: center; height: 100vh; margin: 0; }
            .login-container { background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1); width: 100%; max-width: 400px; }
            h2 { text-align: center; color: #333; margin-bottom: 20px; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; color: #666; }
            .form-group input { width: 100%; padding: 10px; border: 1px solid #ddd; border-radius: 4px; box-sizing: border-box; }
            .btn { width: 100%; padding: 12px; background-color: #e50914; color: white; border: none; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; }
            .btn:hover { background-color: #b20710; }
            .error { color: #e50914; text-align: center; margin-bottom: 15px; }
        </style>
    </head>
    <body>
        <div class="login-container">
            <h2>Cinema System</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="login" method="POST">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <button type="submit" class="btn">Login</button>
            </form>
            
            <div style="text-align: center; margin-top: 20px;">
                <a href="forgot" style="color: #e50914; text-decoration: none; display: block; margin-bottom: 10px;">Forgot Password?</a>
                <a href="register" style="color: #666; text-decoration: none; display: block; margin-bottom: 10px;">Create an Account</a>
                <a href="home" style="color: #666; text-decoration: none; display: block;">&larr; Back to Home</a>
            </div>
        </div>
    </body>
</html>
