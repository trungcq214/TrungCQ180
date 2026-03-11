<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Revenue Report - Admin</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; cursor: pointer; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            
            .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
            .stat-card { background: white; padding: 25px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.05); text-align: center; border-top: 4px solid #9b59b6; }
            .stat-card.revenue { border-color: #2ecc71; }
            .stat-card.tickets { border-color: #3498db; }
            .stat-card.snacks { border-color: #f1c40f; }
            
            .stat-card h3 { margin: 0 0 10px 0; color: #7f8c8d; font-size: 16px; text-transform: uppercase; letter-spacing: 1px; }
            .stat-card .value { font-size: 36px; font-weight: bold; color: #2c3e50; }
            
            .info-box { background: #e8f4f8; padding: 20px; border-radius: 8px; border-left: 5px solid #3498db; margin-bottom: 30px; }
            .info-box h3 { margin-top: 0; color: #2980b9; }
            .info-box p { color: #34495e; margin-bottom: 0; line-height: 1.5; }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2 onclick="location.href='admin'">Cinema Admin</h2>
            <a href="admin">Dashboard Summary</a>
            <a href="adminMovies">Manage Movies</a>
            <a href="adminTheaters">Theaters & Rooms</a>
            <a href="adminSchedules">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks">Snacks & Drinks</a>
            <a href="adminReport" class="active">Revenue Report</a>
        </div>
        
        <div class="content">
            <div class="header">
                <h1>Revenue Report</h1>
                <div class="user-info" style="font-weight: bold; color: #555;"><a href="profile" style="color: #3498db; text-decoration: underline;" title="My Profile">Admin Profile</a></div>
            </div>
            
            <div class="stats-grid">
                <div class="stat-card revenue">
                    <h3>Total Overall Revenue</h3>
                    <div class="value">${requestScope.totalRevenue} VND</div>
                </div>
                
                <div class="stat-card tickets">
                    <h3>Ticket Revenue</h3>
                    <div class="value">${requestScope.totalTicketRevenue} VND</div>
                    <div style="margin-top: 10px; color: #7f8c8d;">${requestScope.ticketsSold} Tickets Sold</div>
                </div>
                
                <div class="stat-card snacks">
                    <h3>Snack Revenue</h3>
                    <div class="value">${requestScope.totalSnackRevenue} VND</div>
                    <div style="margin-top: 10px; color: #7f8c8d;">${requestScope.snacksSold} Items Sold</div>
                </div>
            </div>
        </div>
    </body>
</html>
