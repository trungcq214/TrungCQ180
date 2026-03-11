<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Admin Dashboard - Cinema</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            .user-info { font-weight: bold; color: #555; }
            .btn-logout { background: #e74c3c; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; margin-left: 15px; }
            .btn-logout:hover { background: #c0392b; }
            
            /* Dashboard Grid */
            .grid-container { display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px; }
            .card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); text-align: center; transition: transform 0.2s; border-top: 4px solid #3498db; }
            .card:hover { transform: translateY(-5px); box-shadow: 0 6px 12px rgba(0,0,0,0.1); }
            .card h3 { margin-top: 0; color: #2c3e50; }
            .card p { color: #7f8c8d; margin-bottom: 20px; }
            .card .btn-manage { display: inline-block; padding: 8px 20px; background: #3498db; color: white; text-decoration: none; border-radius: 20px; font-size: 14px; }
            .card .btn-manage:hover { background: #2980b9; }
            
            .msg-success { color: green; margin-bottom: 20px; }
            
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2>Cinema Admin</h2>
            <a href="admin" class="active">Dashboard Summary</a>
            <a href="adminMovies">Manage Movies</a>
            <a href="adminTheaters">Theaters & Rooms</a>
            <a href="adminSchedules">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks">Snacks & Drinks</a>
            <a href="adminReport">Revenue Report</a>
        </div>
        
        <div class="content">
            <div class="header">
                <h1>Overview</h1>
                <div class="user-info">
                    Welcome, <a href="profile" style="color: #555; text-decoration: underline;" title="My Profile">Administrator</a>
                    <a href="logout" class="btn-logout">Logout</a>
                </div>
            </div>
            
            <c:if test="${not empty message}">
                <div class="msg-success">${message}</div>
            </c:if>
            
            <div class="grid-container">
                <div class="card" style="border-top-color: #9b59b6;">
                    <h3>Movies</h3>
                    <p>Add, edit, or remove movies.</p>
                    <a href="adminMovies" class="btn-manage" style="background:#9b59b6;">Manage Movies</a>
                </div>
                
                <div class="card" style="border-top-color: #e67e22;">
                    <h3>Theaters</h3>
                    <p>Manage theater locations and rooms.</p>
                    <a href="adminTheaters" class="btn-manage" style="background:#e67e22;">Manage Theaters</a>
                </div>
                
                <div class="card" style="border-top-color: #2ecc71;">
                    <h3>Schedules</h3>
                    <p>Set showtimes for movies in rooms.</p>
                    <a href="adminSchedules" class="btn-manage" style="background:#2ecc71;">Manage Schedules</a>
                </div>
                
                <div class="card" style="border-top-color: #f1c40f;">
                    <h3>Staff</h3>
                    <p>Add or remove staff accounts.</p>
                    <a href="adminStaff" class="btn-manage" style="background:#f1c40f; color:#333;">Manage Staff</a>
                </div>
                
                <div class="card" style="border-top-color: #e74c3c;">
                    <h3>Snacks</h3>
                    <p>Update snack inventory & prices.</p>
                    <a href="adminSnacks" class="btn-manage" style="background:#e74c3c;">Manage Snacks</a>
                </div>
                
                <div class="card" style="border-top-color: #34495e;">
                    <h3>Reports</h3>
                    <p>View total ticket & snack sales.</p>
                    <a href="adminReport" class="btn-manage" style="background:#34495e;">View Reports</a>
                </div>
            </div>
            
        </div>
    </body>
</html>
