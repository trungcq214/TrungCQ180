<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Payment - Checkout</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; color: #333; margin: 0; padding: 0; }
            .navbar { background-color: #000; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
            .navbar .logo { font-size: 24px; font-weight: bold; color: #e50914; text-decoration: none; }
            .navbar .nav-links a { color: white; text-decoration: none; margin-left: 20px; font-size: 16px; }
            
            .container { padding: 40px; max-width: 900px; margin: 0 auto; display: flex; gap: 40px; }
            
            .checkout-col { flex: 2; background: white; padding: 30px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.1); }
            .summary-col { flex: 1; background: #fff; padding: 30px; border-radius: 8px; border-top: 5px solid #e50914; box-shadow: 0 4px 10px rgba(0,0,0,0.1); align-self: start; }
            
            h2 { margin-top: 0; border-bottom: 2px solid #f0f2f5; padding-bottom: 15px; }
            
            .form-group { margin-bottom: 20px; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; color: #555; }
            .form-group input { width: 100%; padding: 10px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; }
            
            .summary-item { display: flex; justify-content: space-between; margin-bottom: 15px; border-bottom: 1px dashed #eee; padding-bottom: 10px; }
            .total-price { font-size: 24px; font-weight: bold; color: #2ecc71; text-align: right; margin: 20px 0; }
            
            .btn-pay { background: #2ecc71; color: white; border: none; padding: 15px; width: 100%; font-size: 18px; font-weight: bold; border-radius: 4px; cursor: pointer; transition: 0.3s; margin-top: 20px; }
            .btn-pay:hover { background: #27ae60; }
            
            .msg-error { background: #f8d7da; color: #721c24; padding: 15px; border-radius: 4px; border: 1px solid #f5c6cb; margin-bottom: 20px; }
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
            <div class="checkout-col">
                <h2>Payment Details</h2>
                
                <c:if test="${not empty requestScope.error}">
                    <div class="msg-error">${requestScope.error}</div>
                </c:if>
                
                <div style="background: #f8f9fa; padding: 20px; border-radius: 8px; margin-bottom: 20px; border-left: 4px solid #3498db;">
                    <p style="margin:0; color: #2c3e50;">
                        <strong>Demo Mode:</strong> No actual payment gateway is integrated. <br>
                        Click "Confirm Purchase" below to finalize your booking directly.
                    </p>
                </div>

                <form action="payment" method="POST">
                    <input type="hidden" name="scheduleId" value="${requestScope.schedule.scheduleId}">
                    <input type="hidden" name="seatIds" value="${requestScope.seatIdsStr}">
                    
                    <c:choose>
                        <c:when test="${sessionScope.account.role == 1 || sessionScope.account.role == 2}">
                            <!-- Staff View -->
                            <div class="form-group">
                                <label>Customer Email (Leave empty for Walk-in)</label>
                                <input type="email" name="customerEmail" placeholder="e.g. customer@example.com">
                            </div>
                            <div class="form-group">
                                <label>Staff Name (Processing Order)</label>
                                <input type="text" value="${sessionScope.account.fullName}" readonly style="background: #e9ecef;">
                            </div>
                        </c:when>
                        <c:otherwise>
                            <!-- Customer View -->
                            <div class="form-group">
                                <label>Cardholder Name</label>
                                <input type="text" value="${sessionScope.account.fullName}" readonly style="background: #e9ecef;">
                            </div>
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" value="${sessionScope.account.email}" readonly style="background: #e9ecef;">
                            </div>
                        </c:otherwise>
                    </c:choose>
                    
                    <button type="submit" class="btn-pay" onclick="this.innerHTML='Processing...'; this.style.opacity='0.8';">Confirm Purchase & Pay</button>
                    <a href="booking?scheduleId=${requestScope.schedule.scheduleId}" style="display: block; text-align: center; margin-top: 15px; color: #e50914; text-decoration: none;">&larr; Go back to Seat Selection</a>
                </form>
            </div>
            
            <div class="summary-col">
                <h2>Booking Summary</h2>
                
                <div style="text-align: center; margin-bottom: 20px;">
                    <img src="${requestScope.movie.posterUrl}" style="width: 120px; border-radius: 8px; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                </div>
                
                <div class="summary-item">
                    <span>Movie</span>
                    <strong>${requestScope.movie.title}</strong>
                </div>
                <div class="summary-item">
                    <span>Theater</span>
                    <strong>${requestScope.schedule.theaterName}</strong>
                </div>
                <div class="summary-item">
                    <span>Room</span>
                    <strong>${requestScope.schedule.roomName}</strong>
                </div>
                <div class="summary-item">
                    <span>Showtime</span>
                    <strong style="color:#2ecc71;">
                        <fmt:formatDate value="${requestScope.schedule.startTime}" pattern="HH:mm (dd/MM/yyyy)"/>
                    </strong>
                </div>
                <div class="summary-item" style="flex-direction: column;">
                    <span style="margin-bottom: 5px;">Selected Seats:</span>
                    <strong style="color: #3498db; font-size: 18px;">
                        <c:forEach items="${requestScope.selectedSeats}" var="s" varStatus="loop">
                            ${s.seatName}${!loop.last ? ', ' : ''}
                        </c:forEach>
                    </strong>
                </div>
                
                <div class="total-price">
                    Total: <fmt:formatNumber value="${requestScope.totalAmount}" pattern="#,###"/> VND
                </div>
            </div>
        </div>
    </body>
</html>
