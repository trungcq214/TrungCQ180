<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>My Profile - Cinema System</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #f0f2f5; margin: 0; padding: 0; display: flex; justify-content: center; align-items: center; min-height: 100vh; }
            .profile-container { background: white; width: 100%; max-width: 500px; padding: 40px; border-radius: 8px; box-shadow: 0 4px 15px rgba(0,0,0,0.1); }
            .header { text-align: center; margin-bottom: 30px; }
            .header h2 { margin: 0; color: #333; }
            .header p { color: #777; font-size: 14px; }
            .form-group { margin-bottom: 20px; }
            .form-group label { display: block; margin-bottom: 8px; font-weight: bold; color: #555; }
            .form-group input { width: 100%; padding: 12px; border: 1px solid #ccc; border-radius: 4px; box-sizing: border-box; font-size: 14px; }
            .form-group input:focus { border-color: #3498db; outline: none; }
            .form-group input[readonly] { background-color: #e9ecef; cursor: not-allowed; }
            
            .btn-save { width: 100%; background: #2ecc71; color: white; padding: 12px; border: none; border-radius: 4px; font-size: 16px; font-weight: bold; cursor: pointer; transition: background 0.3s; }
            .btn-save:hover { background: #27ae60; }
            .btn-back { display: block; text-align: center; margin-top: 15px; color: #3498db; text-decoration: none; font-size: 14px; }
            .btn-back:hover { text-decoration: underline; }
            
            .msg { padding: 10px; border-radius: 4px; margin-bottom: 20px; text-align: center; }
            .msg-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .msg-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
        </style>
    </head>
    <body>
        <div class="profile-container">
            <div class="header">
                <h2>My Profile</h2>
                <p>Update your personal information</p>
            </div>
            
            <c:if test="${not empty sessionScope.message}">
                <div class="msg msg-success">${sessionScope.message}</div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="msg msg-error">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>
            
            <form action="profile" method="POST">
                <div class="form-group">
                    <label>Username</label>
                    <input type="text" value="${sessionScope.account.username}" readonly>
                </div>
                
                <div class="form-group">
                    <label>Role</label>
                    <input type="text" value="${sessionScope.account.role == 2 ? 'Administrator' : (sessionScope.account.role == 1 ? 'Staff' : 'Customer')}" readonly>
                </div>

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="fullName" value="${sessionScope.account.fullName}" required>
                </div>
                
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" value="${sessionScope.account.email}" required>
                </div>
                
                <div class="form-group">
                    <label>New Password (leave blank to keep current)</label>
                    <input type="password" name="password" placeholder="••••••••">
                </div>
                
                <button type="submit" class="btn-save">Save Changes</button>
                
                <c:choose>
                    <c:when test="${sessionScope.account.role == 2}">
                        <a href="admin" class="btn-back">Return to Dashboard</a>
                    </c:when>
                    <c:when test="${sessionScope.account.role == 1}">
                        <a href="staff" class="btn-back">Return to Staff Portal</a>
                    </c:when>
                    <c:otherwise>
                        <a href="home" class="btn-back">Return to Home</a>
                    </c:otherwise>
                </c:choose>
            </form>
        </div>
    </body>
</html>
