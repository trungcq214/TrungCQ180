<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Tickets - Staff Portal</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; color: #333; margin: 0; padding: 0; display: flex; min-height: 100vh;}
            
            /* Sidebar */
            .sidebar { width: 250px; background-color: #2c3e50; color: white; padding-top: 20px; display: flex; flex-direction: column; }
            .sidebar-header { padding: 0 20px 20px 20px; font-size: 24px; font-weight: bold; border-bottom: 1px solid #34495e; color: #e50914;}
            .sidebar-menu { list-style: none; padding: 0; margin: 20px 0; }
            .sidebar-menu li a { display: block; padding: 15px 20px; color: #bdc3c7; text-decoration: none; transition: 0.3s; }
            .sidebar-menu li a:hover, .sidebar-menu li a.active { background-color: #34495e; color: white; border-left: 4px solid #e50914; }
            .sidebar-footer { margin-top: auto; padding: 20px; border-top: 1px solid #34495e; }
            .sidebar-footer a { color: #e74c3c; text-decoration: none; font-weight: bold; }
            
            /* Main Content */
            .main-content { flex: 1; padding: 30px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #2c3e50; }
            .header-user { background: white; padding: 10px 20px; border-radius: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); font-weight: bold; color: #2980b9;}
            
            /* Tables */
            .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
            table { width: 100%; border-collapse: collapse; margin-top: 20px; }
            th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #f8f9fa; color: #2c3e50; font-weight: bold; }
            tr:hover { background-color: #f1f2f6; }
            
            .status-badge { display: inline-block; padding: 5px 10px; border-radius: 12px; font-size: 12px; font-weight: bold; color: white; }
            .status-paid { background-color: #2ecc71; }
            .status-cancelled { background-color: #e74c3c; }
            
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="sidebar-header">Staff Portal</div>
            <ul class="sidebar-menu">
                <li><a href="staff">Dashboard</a></li>
                <li><a href="staffBooking">Point of Sale (POS)</a></li>
                <li><a href="staffSnacks">Sell Snacks</a></li>
                <li><a href="staffTickets" class="active">Sold Tickets & Snacks</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="logout">Logout</a>
            </div>
        </div>
        
        <div class="main-content">
            <div class="header">
                <h1>Manage Sold Tickets</h1>
                <div class="header-user">Logged in as: <a href="profile" style="color: #2980b9; text-decoration: underline;" title="My Profile">${sessionScope.account.username}</a> (Staff)</div>
            </div>
            
            <div class="card">
                <h2>All Transactions</h2>
                
                <c:choose>
                    <c:when test="${empty requestScope.tickets}">
                        <p style="text-align:center; color:#7f8c8d; padding: 20px;">No tickets have been sold yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Ticket ID</th>
                                    <th>Movie</th>
                                    <th>Theater / Room</th>
                                    <th>Seat</th>
                                    <th>Booked Time</th>
                                    <th>Price</th>
                                    <th>Status</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${requestScope.tickets}" var="t">
                                    <tr>
                                        <td>#${t.ticketId}</td>
                                        <td><strong>${t.movieTitle}</strong></td>
                                        <td>${t.theaterName} <br><small style="color:#7f8c8d;">${t.roomName}</small></td>
                                        <td style="color:#e50914; font-weight:bold;">${t.seatName}</td>
                                        <td><fmt:formatDate value="${t.bookingTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td><fmt:formatNumber value="${t.price}" pattern="#,###"/> VND</td>
                                        <td>
                                            <span class="status-badge ${t.status == 'Paid' ? 'status-paid' : 'status-cancelled'}">
                                                ${t.status}
                                            </span>
                                        </td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            <div class="card" style="margin-top: 30px;">
                <h2>Snack & Drink Sales</h2>
                
                <c:choose>
                    <c:when test="${empty requestScope.snackOrders}">
                        <p style="text-align:center; color:#7f8c8d; padding: 20px;">No snacks or drinks have been sold yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Order ID</th>
                                    <th>Snack Name</th>
                                    <th>Quantity</th>
                                    <th>Total Price</th>
                                    <th>Order Time</th>
                                    <th>Customer ID</th>
                                    <th>Staff ID</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${requestScope.snackOrders}" var="o">
                                    <tr>
                                        <td>#${o.orderId}</td>
                                        <td><strong>${o.snackName}</strong></td>
                                        <td>${o.quantity}</td>
                                        <td style="color:#2ecc71; font-weight:bold;"><fmt:formatNumber value="${o.totalPrice}" pattern="#,###"/> VND</td>
                                        <td><fmt:formatDate value="${o.orderTime}" pattern="dd/MM/yyyy HH:mm"/></td>
                                        <td>${o.customerId != null ? o.customerId : 'Walk-in'}</td>
                                        <td>${o.staffId != null ? o.staffId : 'System'}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </body>
</html>
