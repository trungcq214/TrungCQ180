<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions" %>
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
                <c:when test="${empty requestScope.finalOrders}">
                    <div class="info-box">
                        <h3>Không tìm thấy lịch sử!</h3>
                        <p>Bạn chưa mua vé hay đồ ăn uống nào.</p>
                        <a href="home" class="btn-home">Tìm phim ngay</a>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="ticket-list" style="margin-top: 30px; display: grid; gap: 20px;">
                        <c:forEach items="${requestScope.finalOrders}" var="order" varStatus="orderLoop">
                            <c:set var="tickets" value="${order.tickets}" />
                            <c:set var="snacks" value="${order.snacks}" />
                            
                            <c:set var="totalPrice" value="0" />
                            <c:set var="seatNames" value="" />
                            
                            <c:forEach items="${tickets}" var="t" varStatus="st">
                                <c:set var="totalPrice" value="${totalPrice + t.price}" />
                                <c:set var="seatNames" value="${seatNames}${st.first ? '' : ', '}${t.seatName}" />
                            </c:forEach>
                            <c:forEach items="${snacks}" var="s">
                                <c:set var="totalPrice" value="${totalPrice + s.totalPrice}" />
                            </c:forEach>

                            <div style="background: #222; padding: 20px; border-radius: 8px; border-left: 5px solid ${empty tickets ? '#e67e22' : '#2ecc71'};">
                                <div style="display: flex; justify-content: space-between; align-items: flex-start;">
                                    <div>
                                        <c:choose>
                                            <c:when test="${not empty tickets}">
                                                <c:set var="firstT" value="${tickets[0]}" />
                                                <h3 style="margin: 0 0 10px 0; color: #fff;">${firstT.movieTitle}</h3>
                                                <div style="color: #aaa; margin-bottom: 5px;">
                                                    <strong>Rạp:</strong> ${firstT.theaterName} | <strong>Phòng:</strong> ${firstT.roomName}
                                                </div>
                                                <div style="color: #aaa; margin-bottom: 5px;">
                                                    <strong>Ghế:</strong> <span style="color:#e50914; font-weight:bold;">${seatNames}</span>
                                                    <span style="color:#888; margin-left:8px;">(${fn:length(tickets)} vé)</span>
                                                </div>
                                                <div style="color: #aaa; margin-bottom: 5px;">
                                                    <strong>Suất chiếu:</strong> <fmt:formatDate value="${firstT.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                </div>
                                                <c:set var="status" value="${firstT.status}" />
                                            </c:when>
                                            <c:otherwise>
                                                <h3 style="margin: 0 0 10px 0; color: #fff;">Đồ ăn & Uống</h3>
                                                <c:set var="status" value="Đã thanh toán" />
                                            </c:otherwise>
                                        </c:choose>
                                        
                                        <div style="color: #aaa; margin-top: 5px; font-size: 12px;">
                                            <em>Ngày đặt: <fmt:formatDate value="${order.orderTime}" pattern="dd/MM/yyyy HH:mm:ss"/></em>
                                        </div>
                                        
                                        <c:if test="${not empty snacks}">
                                            <div style="margin-top: 12px; padding: 10px; background: #333; border-radius: 4px; border-left: 3px solid #e67e22;">
                                                <strong style="color: #e67e22; font-size: 14px;">Snack kèm theo:</strong>
                                                <c:forEach items="${snacks}" var="s">
                                                    <div style="color: #ccc; font-size: 13px; margin-top: 5px;">
                                                        - ${s.quantity}x ${s.snackName} ( <fmt:formatNumber value="${s.totalPrice}" type="number" groupingUsed="true"/> VND )
                                                    </div>
                                                </c:forEach>
                                            </div>
                                        </c:if>
                                    </div>
                                    <div style="text-align: right;">
                                        <div style="font-size: 12px; color: #888; margin-bottom: 4px;">Tổng Hóa Đơn</div>
                                        <div style="font-size: 24px; font-weight: bold; color: #2ecc71;">
                                            <fmt:formatNumber value="${totalPrice}" type="number" groupingUsed="true"/> VND
                                        </div>
                                        <div style="margin-top: 5px; margin-bottom: 15px; display: inline-block; padding: 4px 10px; border-radius: 12px; background: #444; font-size: 12px; color: white;">${status}</div>
                                        
                                        <c:if test="${not empty tickets}">
                                            <div style="margin-top: 10px;">
                                                <button style="background: transparent; color: #e50914; border: 1px solid #e50914; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: bold;" onclick="document.getElementById('details-${orderLoop.index}').style.display = document.getElementById('details-${orderLoop.index}').style.display === 'none' ? 'block' : 'none'">
                                                    Chi tiết vé lẻ &#x25BC;
                                                </button>
                                            </div>
                                        </c:if>
                                    </div>
                                </div>
                                
                                <c:if test="${not empty tickets}">
                                    <div id="details-${orderLoop.index}" style="display: none; margin-top: 15px; border-top: 1px dashed #444; padding-top: 15px;">
                                        <h4 style="margin: 0 0 10px 0; font-size: 14px; color: #ccc;">Chi Tiết Từng Vé:</h4>
                                        <table style="width: 100%; border-collapse: collapse; font-size: 14px; color: #ddd;">
                                            <thead>
                                                <tr style="border-bottom: 1px solid #555; text-align: left;">
                                                    <th style="padding: 6px;">Mã vé</th>
                                                    <th style="padding: 6px;">Ghế</th>
                                                    <th style="padding: 6px; text-align: right;">Giá tiền</th>
                                                </tr>
                                            </thead>
                                            <tbody>
                                                <c:forEach items="${tickets}" var="dt">
                                                    <tr style="border-bottom: 1px solid #333;">
                                                        <td style="padding: 6px; color: #888;">#${dt.ticketId}</td>
                                                        <td style="padding: 6px; font-weight: bold;">${dt.seatName}</td>
                                                        <td style="padding: 6px; text-align: right;">
                                                            <fmt:formatNumber value="${dt.price}" type="number" groupingUsed="true"/> VND
                                                        </td>
                                                    </tr>
                                                </c:forEach>
                                            </tbody>
                                        </table>
                                    </div>
                                </c:if>
                            </div>
                        </c:forEach>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </body>
</html>
