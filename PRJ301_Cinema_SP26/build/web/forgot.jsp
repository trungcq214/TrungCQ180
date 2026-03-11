<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cinema - Forgot Password</title>
        <style>
            body { font-family: Arial; padding: 20px; }
            .login-box { max-width: 400px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; background: #f9f9f9; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; }
            .form-group input { width: 100%; padding: 8px; box-sizing: border-box; }
            .btn { width: 100%; padding: 10px; background: #dc3545; color: white; border: none; cursor: pointer; font-size: 16px; border-radius: 3px; }
            .btn:hover { background: #c82333; }
            .error { color: red; margin-bottom: 10px; font-weight: bold; text-align: center; }
            .success { color: green; margin-bottom: 15px; font-weight: bold; text-align: center; padding: 10px; border: 1px solid green; background: #e8f5e9; }
            .links { text-align: center; margin-top: 15px; }
        </style>
    </head>
    <body>
        <div class="login-box">
            <h2 style="text-align: center;">Recover Password</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>

            <% if(request.getAttribute("recoveredPassword") != null) { %>
                <div class="success">
                    Your password is: <strong><%= request.getAttribute("recoveredPassword") %></strong>
                </div>
            <% } else { %>
                <p style="text-align: center; font-size: 0.9em; color: #555;">Enter your exact username to view your password.</p>
                <form action="forgot" method="POST">
                    <div class="form-group">
                        <label>Username</label>
                        <input type="text" name="username" required>
                    </div>
                    <button type="submit" class="btn">Get Password</button>
                </form>
            <% } %>
            
            <div class="links">
                Remembered it? <a href="login">Login here</a>
            </div>
        </div>
    </body>
</html>
