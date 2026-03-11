<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Point of Sale - Staff Portal</title>
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
            
            /* Showtimes List */
            .card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); }
            .search-bar { width: 100%; padding: 12px; border: 1px solid #ddd; border-radius: 6px; font-size: 16px; margin-bottom: 20px; box-sizing: border-box;}
            
            table { width: 100%; border-collapse: collapse; }
            th, td { padding: 15px; text-align: left; border-bottom: 1px solid #eee; }
            th { background-color: #f8f9fa; color: #2c3e50; font-weight: bold; }
            tr:hover { background-color: #f1f2f6; }
            
            .btn-book { background-color: #e50914; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; text-decoration: none; display: inline-block; transition: 0.2s;}
            .btn-book:hover { background-color: #b20710; }
            
        </style>
        <script>
            function filterSchedules() {
                let input = document.getElementById("searchInput").value.toLowerCase();
                let rows = document.querySelectorAll("tbody tr");
                
                rows.forEach(row => {
                    let movieAndTheater = row.cells[0].innerText.toLowerCase() + " " + row.cells[1].innerText.toLowerCase();
                    if (movieAndTheater.includes(input)) {
                        row.style.display = "";
                    } else {
                        row.style.display = "none";
                    }
                });
            }
        </script>
    </head>
    <body>
        <div class="sidebar">
            <div class="sidebar-header">Staff Portal</div>
            <ul class="sidebar-menu">
                <li><a href="staff">Dashboard</a></li>
                <li><a href="staffBooking" class="active">Point of Sale (POS)</a></li>
                <li><a href="staffSnacks">Sell Snacks</a></li>
                <li><a href="staffTickets">Sold Tickets & Snacks</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="logout">Logout</a>
            </div>
        </div>
        
        <div class="main-content">
            <div class="header">
                <h1>Ticket POS System</h1>
                <div class="header-user">Logged in as: <a href="profile" style="color: #2980b9; text-decoration: underline;" title="My Profile">${sessionScope.account.username}</a> (Staff)</div>
            </div>
            
            <div class="card">
                <h2>Select a Showtime to Sell Tickets</h2>
                <input type="text" id="searchInput" class="search-bar" placeholder="Search by Movie Title or Theater..." onkeyup="filterSchedules()">
                
                <c:choose>
                    <c:when test="${empty requestScope.schedules}">
                        <p style="text-align:center; color:#7f8c8d; padding: 20px;">No upcoming showtimes available.</p>
                    </c:when>
                    <c:otherwise>
                        <table>
                            <thead>
                                <tr>
                                    <th>Movie Title</th>
                                    <th>Theater / Room</th>
                                    <th>Showtime</th>
                                    <th>Price</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach items="${requestScope.schedules}" var="s">
                                    <tr>
                                        <td><strong>${s.movieTitle}</strong></td>
                                        <td>${s.theaterName} <br><small style="color:#7f8c8d;">${s.roomName}</small></td>
                                        <td>
                                            <fmt:formatDate value="${s.startTime}" pattern="dd/MM/yyyy"/><br>
                                            <strong style="color: #2980b9;"><fmt:formatDate value="${s.startTime}" pattern="HH:mm"/></strong>
                                        </td>
                                        <td><fmt:formatNumber value="${s.price}" pattern="#,###"/> VND</td>
                                        <td>
                                            <a href="booking?scheduleId=${s.scheduleId}" class="btn-book">Select Seats</a>
                                        </td>
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
