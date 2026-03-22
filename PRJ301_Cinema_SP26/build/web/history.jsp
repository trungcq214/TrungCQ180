<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Ticket History</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #141414; color: white; margin: 0; padding: 0; }
            .navbar { background-color: #000; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
            .navbar .logo { font-size: 24px; font-weight: bold; color: #e50914; text-decoration: none; }
            .navbar .nav-links a { color: white; text-decoration: none; margin-left: 20px; font-size: 16px; }
            .navbar .nav-links a:hover { color: #e50914; }
            .container { padding: 40px; max-width: 1000px; margin: 0 auto; }
            
            h2 { border-bottom: 2px solid #333; padding-bottom: 10px; }
            
            .info-box { background: #222; padding: 30px; border-radius: 8px; border-left: 5px solid #e50914; margin-top: 30px; text-align: center; }
            .info-box h3 { color: #fff; margin-top: 0; }
            .info-box p { color: #aaa; font-size: 16px; }
            
            .btn-home { display: inline-block; padding: 10px 20px; background-color: #e50914; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; margin-top: 20px; }
            .btn-home:hover { background-color: #b20710; }
            .btn-back { display: inline-block; padding: 9px 18px; background: #555; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; margin-bottom: 15px; border: none; cursor: pointer; font-size: 14px; }
            .btn-back:hover { background: #333; }
        </style>
    </head>
    <body>
        <div class="navbar">
            <a href="home" class="logo">CINEMA</a>
            <div class="nav-links">
                <a href="home">Movies</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.account}">
                        <a href="history" style="margin-right: 15px;">My Tickets</a>
                        <span style="color: #aaa; margin-right: 15px;">|</span>
                        <a href="profile" style="color: #fff; font-weight: bold; margin-right: 15px; text-decoration: underline;" title="My Profile">${sessionScope.account.fullName}</a>
                        <a href="logout" style="background: #e50914; padding: 5px 10px; border-radius: 4px;">Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="login" style="background: #e50914; padding: 5px 15px; border-radius: 4px; font-weight: bold;">Login</a>
                        <a href="register">Sign Up</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

        <div class="container">
            <button class="btn-back" onclick="history.back()">&#8592; Quay lại</button>
            <h2>Lịch sử Mua hàng</h2>
            
            <c:choose>
                <c:when test="${empty requestScope.tickets}">
                    <div class="info-box">
                        <h3>No Tickets Found!</h3>
                        <p>You have not purchased any movie tickets yet.</p>
                        <a href="home" class="btn-home">Browse Movies</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ticket-list" style="margin-top: 30px; display: grid; gap: 20px;">
                        <c:forEach items="${requestScope.tickets}" var="t">
                            <div style="background: #222; padding: 20px; border-radius: 8px; border-left: 5px solid #2ecc71; display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <h3 style="margin: 0 0 10px 0; color: #fff;">${t.movieTitle}</h3>
                                    <div style="color: #aaa; margin-bottom: 5px;">
                                        <strong>Theater:</strong> ${t.theaterName} | <strong>Room:</strong> ${t.roomName} | <strong>Seat:</strong> <span style="color:#e50914; font-weight:bold;">${t.seatName}</span>
                                    </div>
                                    <div style="color: #aaa; margin-bottom: 5px;">
                                        <strong>Showtime:</strong> ${t.startTime}
                                    </div>
                                    <div style="color: #aaa;">
                                        <strong>Seller:</strong> ${t.staffId != null ? t.staffId : 'System'}
                                    </div>
                                    <div style="color: #aaa; margin-top: 5px; font-size: 12px;">
                                        <em>Booked On: ${t.bookingTime}</em>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-size: 20px; font-weight: bold; color: #2ecc71;">${t.price} VND</div>
                                    <div style="margin-top: 5px; display: inline-block; padding: 4px 10px; border-radius: 12px; background: #333; font-size: 12px; color: white;">${t.status}</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
            
            <h2 style="margin-top: 50px;">Snack & Drink Orders</h2>
            
            <c:choose>
                <c:when test="${empty requestScope.snackOrders}">
                    <div class="info-box" style="border-left-color: #e67e22;">
                        <h3>No Snack Orders</h3>
                        <p>You haven't bought any snacks or drinks yet.</p>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ticket-list" style="margin-top: 30px; display: grid; gap: 20px;">
                        <c:forEach items="${requestScope.snackOrders}" var="o">
                            <div style="background: #222; padding: 20px; border-radius: 8px; border-left: 5px solid #e67e22; display: flex; justify-content: space-between; align-items: center;">
                                <div>
                                    <h3 style="margin: 0 0 10px 0; color: #fff;">${o.snackName}</h3>
                                    <div style="color: #aaa; margin-bottom: 5px;">
                                        <strong>Quantity:</strong> ${o.quantity}
                                    </div>
                                    <div style="color: #aaa;">
                                        <strong>Seller:</strong> ${o.staffId != null ? o.staffId : 'System'}
                                    </div>
                                    <div style="color: #aaa; margin-top: 5px; font-size: 12px;">
                                        <em>Ordered On: <fmt:formatDate value="${o.orderTime}" pattern="dd/MM/yyyy HH:mm"/></em>
                                    </div>
                                </div>
                                <div style="text-align: right;">
                                    <div style="font-size: 20px; font-weight: bold; color: #2ecc71;">${o.totalPrice} VND</div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
