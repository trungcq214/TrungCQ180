<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Staff Dashboard - Cinema</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background-color: #2c3e50; color: white; padding-top: 20px; display: flex; flex-direction: column; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar-header { padding: 0 20px 20px 20px; font-size: 24px; font-weight: bold; border-bottom: 1px solid #34495e; color: #e50914;}
            .sidebar-menu { list-style: none; padding: 0; margin: 20px 0; }
            .sidebar-menu li a { display: block; padding: 15px 20px; color: #bdc3c7; text-decoration: none; transition: 0.3s; font-size: 16px; border-left: 4px solid transparent;}
            .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #34495e; color: white; border-left: 4px solid #e50914; }
            .sidebar-footer { margin-top: auto; padding: 20px; border-top: 1px solid #34495e; }
            .sidebar-footer a { color: #e74c3c; text-decoration: none; font-weight: bold; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            .user-info { font-weight: bold; color: #555; display: flex; align-items: center; gap: 10px; }
            .btn-logout { background: #e74c3c; color: white; padding: 8px 15px; text-decoration: none; border-radius: 4px; }
            .btn-logout:hover { background: #c0392b; }
            .btn-back { background: #95a5a6; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; border: none; cursor: pointer; }
            .btn-back:hover { background: #7f8c8d; }
            .header-left { display: flex; align-items: center; gap: 15px; }
            
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
            <div class="sidebar-header">Staff Portal</div>
            <ul class="sidebar-menu">
                <li><a href="staff" class="active">Dashboard</a></li>
                <li><a href="staffBooking">Point of Sale (POS)</a></li>
                <li><a href="staffSnacks">Sell Snacks</a></li>
                <li><a href="staffTickets">Sold Tickets &amp; Snacks</a></li>
            </ul>
        </div>
        
        <div class="content">
            <div class="header">
                <div class="header-left">
                    <a href="javascript:history.back()" class="btn-back">Back</a>
                    <h1>Point of Sale Dashboard</h1>
                </div>
                <div class="user-info">
                    Xin chào, <a href="profile" style="color: #555; text-decoration: underline; font-weight: bold;">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</a>
                    <a href="logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>
            
            <c:if test="${not empty message}">
                <div class="msg-success">${message}</div>
            </c:if>
            
            <div class="grid-container">
                <div class="card" style="border-top-color: #2ecc71;">
                    <h3>Tickets</h3>
                    <p>Select showtimes and book seats for walk-in customers.</p>
                    <a href="staffBooking" class="btn-manage" style="background:#2ecc71;">Sell Tickets</a>
                </div>
                
                <div class="card" style="border-top-color: #e67e22;">
                    <h3>Snack Counter</h3>
                    <p>Process food and drink orders.</p>
                    <a href="staffSnacks" class="btn-manage" style="background:#e67e22;">Sell Snacks</a>
                </div>
                
                <div class="card" style="border-top-color: #34495e;">
                    <h3>Sales History</h3>
                    <p>Review the list of tickets sold today.</p>
                    <a href="staffTickets" class="btn-manage" style="background:#34495e;">View Shift Sales</a>
                </div>
            </div>
            
        </div>
    </body>
</html>
