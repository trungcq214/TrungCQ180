<%@page contentType="text/html" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cinema - Register</title>
        <style>
            body { font-family: Arial; padding: 20px; }
            .login-box { max-width: 400px; margin: auto; padding: 20px; border: 1px solid #ccc; border-radius: 5px; background: #f9f9f9; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; }
            .form-group input { width: 100%; padding: 8px; box-sizing: border-box; }
            .btn { width: 100%; padding: 10px; background: #28a745; color: white; border: none; cursor: pointer; font-size: 16px; border-radius: 3px; }
            .btn:hover { background: #218838; }
            .error { color: red; margin-bottom: 10px; font-weight: bold; }
            .links { text-align: center; margin-top: 15px; }
        </style>
    </head>
    <body>
        <div class="login-box">
            <h2 style="text-align: center;">Register Account</h2>
            
            <% if(request.getAttribute("error") != null) { %>
                <div class="error"><%= request.getAttribute("error") %></div>
            <% } %>

            <form action="register" method="POST">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" name="username" required>
                </div>
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullname" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" required>
                </div>
                <div class="form-group">
                    <label>Confirm Password</label>
                    <input type="password" name="confirm" required>
                </div>
                <button type="submit" class="btn">Register</button>
            </form>
            
            <div class="links">
                Already have an account? <a href="login">Login here</a>
            </div>
        </div>
    </body>
</html>
