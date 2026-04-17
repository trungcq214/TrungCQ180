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
            .header-left { display: flex; align-items: center; gap: 15px; }
            .header-user { display: flex; align-items: center; gap: 10px; background: white; padding: 10px 20px; border-radius: 20px; box-shadow: 0 2px 5px rgba(0,0,0,0.05); font-weight: bold; color: #2980b9;}
            .btn-back { background: #95a5a6; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; border: none; cursor: pointer; }
            .btn-back:hover { background: #7f8c8d; }
            .btn-logout { background: #e74c3c; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; }
            .btn-logout:hover { background: #c0392b; }
            
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
                <div class="header-left">
                    <button class="btn-back" onclick="history.back()">&#8592; Quay lại</button>
                    <h1>Manage Sold Tickets</h1>
                </div>
                <div class="header-user">
                    Xin chào, <a href="profile" style="color: #2980b9; text-decoration: underline;">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</a>
                    <a href="logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>
            
            <div class="card">
                <h2>All Transactions</h2>
                
                <c:choose>
                    <c:when test="${empty requestScope.finalOrders}">
                        <p style="text-align:center; color:#7f8c8d; padding: 20px;">No transactions found.</p>
                    </c:when>
                    <c:otherwise>
                        <div class="ticket-list" style="margin-top: 20px; display: grid; gap: 20px;">
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

                                <div style="background: #222; color: #eee; padding: 20px; border-radius: 8px; border-left: 5px solid ${empty tickets ? '#e67e22' : '#2ecc71'};">
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
                                                        <span style="color:#888; margin-left:8px;">(${java.lang.reflect.Array.getLength(tickets) != null ? tickets.size() : 0} vé)</span>
                                                    </div>
                                                    <div style="color: #aaa; margin-bottom: 5px;">
                                                        <strong>Suất chiếu:</strong> <fmt:formatDate value="${firstT.startTime}" pattern="dd/MM/yyyy HH:mm"/>
                                                    </div>
                                                    <div style="color: #aaa; margin-bottom: 5px;">
                                                        <strong>Khách hàng ID:</strong> ${firstT.customerId != null ? firstT.customerId : 'Khách Vãng Lai (Walk-in)'} |
                                                        <strong>Bán bởi Staff ID:</strong> ${firstT.staffId != null ? firstT.staffId : 'Online (Hệ thống)'}
                                                    </div>
                                                    <c:set var="status" value="${firstT.status}" />
                                                </c:when>
                                                <c:otherwise>
                                                    <h3 style="margin: 0 0 10px 0; color: #fff;">Đồ ăn & Uống</h3>
                                                    <c:set var="status" value="Đã thanh toán" />
                                                    <c:set var="firstS" value="${snacks[0]}" />
                                                    <div style="color: #aaa; margin-bottom: 5px;">
                                                        <strong>Khách hàng ID:</strong> ${firstS.customerId != null ? firstS.customerId : 'Khách Vãng Lai (Walk-in)'} |
                                                        <strong>Bán bởi Staff ID:</strong> ${firstS.staffId != null ? firstS.staffId : 'Online (Hệ thống)'}
                                                    </div>
                                                </c:otherwise>
                                            </c:choose>
                                            
                                            <div style="color: #aaa; margin-top: 5px; font-size: 12px;">
                                                <em>Thời gian tạo: <fmt:formatDate value="${order.orderTime}" pattern="dd/MM/yyyy HH:mm:ss"/></em>
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
                                            <div style="margin-top: 5px; margin-bottom: 15px; display: inline-block; padding: 4px 10px; border-radius: 12px; background: #444; font-size: 12px; color: ${status == 'Paid' || status == 'Đã thanh toán' ? '#2ecc71' : '#e74c3c'};">
                                                ${status}
                                            </div>
                                            
                                            <c:if test="${not empty tickets}">
                                                <div style="margin-top: 10px;">
                                                    <button style="background: transparent; color: #e50914; border: 1px solid #e50914; padding: 5px 12px; border-radius: 4px; cursor: pointer; font-size: 13px; font-weight: bold;" onclick="document.getElementById('staff-details-${orderLoop.index}').style.display = document.getElementById('staff-details-${orderLoop.index}').style.display === 'none' ? 'block' : 'none'">
                                                        Chi tiết vé lẻ &#x25BC;
                                                    </button>
                                                </div>
                                            </c:if>
                                        </div>
                                    </div>
                                    
                                    <c:if test="${not empty tickets}">
                                        <div id="staff-details-${orderLoop.index}" style="display: none; margin-top: 15px; border-top: 1px dashed #444; padding-top: 15px;">
                                            <h4 style="margin: 0 0 10px 0; font-size: 14px; color: #ccc;">Chi Tiết Từng Vé:</h4>
                                            <table style="width: 100%; border-collapse: collapse; font-size: 14px; color: #ddd; background: transparent; box-shadow: none;">
                                                <thead>
                                                    <tr style="border-bottom: 1px solid #555; text-align: left; background-color: transparent;">
                                                        <th style="padding: 6px; color: #ddd; font-weight: bold;">Mã vé</th>
                                                        <th style="padding: 6px; color: #ddd; font-weight: bold;">Ghế</th>
                                                        <th style="padding: 6px; color: #ddd; font-weight: bold;">Trạng thái</th>
                                                        <th style="padding: 6px; text-align: right; color: #ddd; font-weight: bold;">Giá tiền</th>
                                                    </tr>
                                                </thead>
                                                <tbody>
                                                    <c:forEach items="${tickets}" var="dt">
                                                        <tr style="border-bottom: 1px solid #333; background-color: transparent;">
                                                            <td style="padding: 6px; color: #888;">#${dt.ticketId}</td>
                                                            <td style="padding: 6px; font-weight: bold;">${dt.seatName}</td>
                                                            <td style="padding: 6px;">
                                                                <span class="status-badge ${dt.status == 'Paid' ? 'status-paid' : 'status-cancelled'}">
                                                                    ${dt.status}
                                                                </span>
                                                            </td>
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
        </div>
    </body>
</html>
