<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Rooms - Admin</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; cursor: pointer; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; display: flex; align-items: center; }
            .btn-back { margin-right: 15px; color: #3498db; text-decoration: none; font-size: 24px; line-height: 1; border: 1px solid #3498db; border-radius: 50%; width: 30px; height: 30px; display: inline-flex; justify-content: center; align-items: center; }
            .btn-back:hover { background: #3498db; color: white; }
            
            table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
            th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #e67e22; color: white; }
            tr:hover { background-color: #f5f5f5; }
            
            .btn { padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; color: white; font-weight: bold; text-decoration: none; display: inline-block; font-size: 14px; }
            .btn-add { background: #2ecc71; margin-bottom: 15px; }
            .btn-edit { background: #f39c12; }
            .btn-delete { background: #e74c3c; }
            
            .msg { padding: 10px; border-radius: 4px; margin-bottom: 20px; }
            .msg-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .msg-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
            
            /* Modal */
            .modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
            .modal-content { background-color: #fefefe; margin: 10% auto; padding: 20px; border: 1px solid #888; width: 40%; border-radius: 8px; }
            .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
            .close:hover { color: black; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
            .form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2 onclick="location.href='admin'">Cinema Admin</h2>
            <a href="admin">Dashboard Summary</a>
            <a href="adminMovies">Manage Movies</a>
            <a href="adminTheaters" class="active">Theaters & Rooms</a>
            <a href="adminSchedules">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks">Snacks & Drinks</a>
            <a href="adminReport">Revenue Report</a>
        </div>
        
        <div class="content">
            <div class="header">
                <h1>
                    <a href="adminTheaters" class="btn-back" title="Back to Theaters">&larr;</a>
                    Rooms in ${requestScope.theater.name}
                </h1>
                <div class="user-info" style="font-weight: bold; color: #555;"><a href="profile" style="color: #3498db; text-decoration: underline;" title="My Profile">Admin Profile</a></div>
            </div>
            
            <c:if test="${not empty sessionScope.message}">
                <div class="msg msg-success">${sessionScope.message}</div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="msg msg-error">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>
            
            <button class="btn btn-add" onclick="openAddModal()">+ Add New Room</button>
            
            <table>
                <thead>
                    <tr>
                        <th>Room ID</th>
                        <th>Room Name</th>
                        <th>Capacity</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.rooms}" var="r">
                        <tr>
                            <td>${r.roomId}</td>
                            <td><strong>${r.name}</strong></td>
                            <td>${r.capacity} seats</td>
                            <td>
                                <button class="btn btn-edit" onclick="openEditModal(${r.roomId}, '${r.name.replace('\'', '\\\'')}', '${r.capacity}')">Edit</button>
                                <a href="adminSeats?theaterId=${requestScope.theater.theaterId}&roomId=${r.roomId}" class="btn btn-manage" style="background:#3498db; padding: 8px 12px; border-radius: 4px; color: white; text-decoration: none; font-size:14px; font-weight:bold; display:inline-block;">Manage Seats</a>
                                
                                <form action="adminRooms" method="POST" style="display:inline;" onsubmit="return confirm('Delete this room permanently? Note: Fails if it has attached schedules!');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="theaterId" value="${requestScope.theater.theaterId}">
                                    <input type="hidden" name="roomId" value="${r.roomId}">
                                    <button type="submit" class="btn btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Modal -->
        <div id="roomModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2 id="modalTitle">Add Room</h2>
                <form action="adminRooms" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="theaterId" value="${requestScope.theater.theaterId}">
                    <input type="hidden" name="roomId" id="roomId" value="0">
                    
                    <div class="form-group">
                        <label>Room Name</label>
                        <input type="text" name="name" id="name" required placeholder="e.g. IMAX 1">
                    </div>
                    <div class="form-group">
                        <label>Capacity</label>
                        <input type="number" name="capacity" id="capacity" required value="30" readonly>
                    </div>
                    
                    <button type="submit" class="btn btn-add" style="width: 100%;">Save Room</button>
                </form>
            </div>
        </div>

        <script>
            var modal = document.getElementById("roomModal");

            function openAddModal() {
                document.getElementById("modalTitle").innerText = "Add Room";
                document.getElementById("formAction").value = "add";
                document.getElementById("roomId").value = "0";
                document.getElementById("name").value = "";
                document.getElementById("capacity").value = "30"; // Fixed to 30
                modal.style.display = "block";
            }

            function openEditModal(id, name, capacity) {
                document.getElementById("modalTitle").innerText = "Edit Room";
                document.getElementById("formAction").value = "edit";
                document.getElementById("roomId").value = id;
                document.getElementById("name").value = name;
                document.getElementById("capacity").value = "30"; // Fixed to 30
                modal.style.display = "block";
            }

            function closeModal() {
                modal.style.display = "none";
            }

            window.onclick = function(event) {
                if (event.target == modal) {
                    modal.style.display = "none";
                }
            }
        </script>
    </body>
</html>
