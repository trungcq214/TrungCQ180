<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Sell Snacks - Staff Portal</title>
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
            
            /* Snack Grid */
            .snack-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(250px, 1fr)); gap: 20px; }
            .snack-card { background: white; border-radius: 8px; padding: 20px; box-shadow: 0 2px 10px rgba(0,0,0,0.05); display: flex; flex-direction: column; align-items: center; text-align: center;}
            .snack-card h3 { margin: 10px 0; color: #2c3e50; }
            .snack-card .price { font-size: 20px; font-weight: bold; color: #2ecc71; margin-bottom: 5px; }
            .snack-card .stock { color: #7f8c8d; margin-bottom: 15px; font-size: 14px;}
            .snack-card .low-stock { color: #e74c3c; font-weight: bold; }
            
            /* Forms */
            .sell-form { width: 100%; display: flex; justify-content: space-between; gap: 10px; }
            .sell-form input[type="number"] { flex: 1; padding: 8px; border: 1px solid #ddd; border-radius: 4px; }
            .btn-sell { background-color: #2ecc71; color: white; border: none; padding: 8px 15px; border-radius: 4px; cursor: pointer; font-weight: bold; transition: 0.2s;}
            .btn-sell:hover { background-color: #27ae60; }
            .btn-sell:disabled { background-color: #95a5a6; cursor: not-allowed; }
            
            /* Toast */
            .toast { padding: 15px 20px; margin-bottom: 20px; border-radius: 4px; font-weight: bold; }
            .toast-success { background-color: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .toast-error { background-color: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <div class="sidebar-header">Staff Portal</div>
            <ul class="sidebar-menu">
                <li><a href="staff">Dashboard</a></li>
                <li><a href="staffBooking">Point of Sale (POS)</a></li>
                <li><a href="staffSnacks" class="active">Sell Snacks</a></li>
                <li><a href="staffTickets">Sold Tickets & Snacks</a></li>
            </ul>
            <div class="sidebar-footer">
                <a href="logout">Logout</a>
            </div>
        </div>
        
        <div class="main-content">
            <div class="header">
                <div class="header-left">
                    <button class="btn-back" onclick="history.back()">&#8592; Quay lại</button>
                    <h1>Sell Snacks Counter</h1>
                </div>
                <div class="header-user">
                    Xin chào, <a href="profile" style="color: #2980b9; text-decoration: underline;">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</a>
                    <a href="logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>
            
            <c:if test="${not empty sessionScope.toastMsg}">
                <div class="toast toast-${sessionScope.toastType}">
                    ${sessionScope.toastMsg}
                </div>
                <c:remove var="toastMsg" scope="session"/>
                <c:remove var="toastType" scope="session"/>
            </c:if>
            
            <div class="snack-grid">
                <c:forEach items="${requestScope.snacks}" var="s">
                    <div class="snack-card">
                        <h3>${s.name}</h3>
                        <div class="price"><fmt:formatNumber value="${s.price}" pattern="#,###"/> VND</div>
                        <div class="stock ${s.stockQuantity < 10 ? 'low-stock' : ''}">Stock: ${s.stockQuantity} remaining</div>
                        
                        <form action="staffSnacks" method="POST" class="sell-form" style="flex-direction: column; gap: 10px;">
                            <input type="hidden" name="action" value="sell">
                            <input type="hidden" name="snackId" value="${s.snackId}">
                            
                            <input type="email" name="customerEmail" placeholder="Customer Email (Optional)" style="padding: 8px; border: 1px solid #ddd; border-radius: 4px; width: 100%; box-sizing: border-box;">
                            
                            <div style="display: flex; gap: 10px; width: 100%;">
                                <input type="number" name="quantity" min="1" max="${s.stockQuantity}" value="1" ${s.stockQuantity == 0 ? 'disabled' : ''} required style="flex:1;">
                                <button type="submit" class="btn-sell" ${s.stockQuantity == 0 ? 'disabled' : ''}>SELL</button>
                            </div>
                        </form>
                    </div>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
