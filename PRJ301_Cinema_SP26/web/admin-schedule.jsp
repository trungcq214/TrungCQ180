<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Showtimes - Admin</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; cursor: pointer; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            
            table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); font-size: 14px;}
            th, td { padding: 10px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #9b59b6; color: white; }
            tr:hover { background-color: #f5f5f5; }
            
            .btn { padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; color: white; font-weight: bold; text-decoration: none; display: inline-block; font-size: 14px; }
            .btn-add { background: #2ecc71; margin-bottom: 15px; }
            .btn-delete { background: #e74c3c; }
            
            .msg { padding: 10px; border-radius: 4px; margin-bottom: 20px; }
            .msg-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .msg-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
            
            /* Modal */
            .modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
            .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; width: 40%; border-radius: 8px; }
            .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
            .close:hover { color: black; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
            .form-group select, .form-group input { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2 onclick="location.href='admin'">Cinema Admin</h2>
            <a href="admin">Dashboard Summary</a>
            <a href="adminMovies">Manage Movies</a>
            <a href="adminTheaters">Theaters & Rooms</a>
            <a href="adminSchedules" class="active">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks">Snacks & Drinks</a>
            <a href="adminReport">Revenue Report</a>
        </div>
        
        <div class="content">
            <div class="header">
                <h1>Manage Showtimes</h1>
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
            
            <button class="btn btn-add" onclick="openAddModal()">+ Add New Showtime</button>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Movie</th>
                        <th>Theater</th>
                        <th>Room</th>
                        <th>Start Time</th>
                        <th>End Time</th>
                        <th>Price (VND)</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.schedules}" var="s">
                        <tr>
                            <td>${s.scheduleId}</td>
                            <td><strong>${s.movieTitle}</strong></td>
                            <td>${s.theaterName}</td>
                            <td>${s.roomName}</td>
                            <td>${s.startTime}</td>
                            <td>${s.endTime}</td>
                            <td>${s.price}</td>
                            <td>
                                <form action="adminSchedules" method="POST" style="display:inline;" onsubmit="return confirm('Delete this showtime permanently? This fails if tickets have been sold!');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="scheduleId" value="${s.scheduleId}">
                                    <button type="submit" class="btn btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requestScope.schedules}">
                        <tr><td colspan="8" style="text-align:center;">No showtimes found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Add Modal -->
        <div id="scheduleModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2>Add Showtime</h2>
                <form action="adminSchedules" method="POST">
                    <input type="hidden" name="action" value="add">
                    
                    <div class="form-group">
                        <label>Movie</label>
                        <select name="movieId" required>
                            <option value="">-- Select Movie --</option>
                            <c:forEach items="${requestScope.movies}" var="m">
                                <option value="${m.movieId}">${m.title} (${m.duration} mins)</option>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Theater / Room</label>
                        <select name="roomId" required>
                            <option value="">-- Select Room --</option>
                            <!-- Grouping rooms by theater -->
                            <c:forEach items="${requestScope.theaters}" var="t">
                                <optgroup label="${t.name}">
                                    <c:forEach items="${requestScope.rooms}" var="r">
                                        <c:if test="${r.theaterId == t.theaterId}">
                                            <option value="${r.roomId}">${r.name} (Cap: ${r.capacity})</option>
                                        </c:if>
                                    </c:forEach>
                                </optgroup>
                            </c:forEach>
                        </select>
                    </div>
                    
                    <div class="form-group">
                        <label>Start Time</label>
                        <input type="datetime-local" name="startTime" id="startTime" required>
                    </div>
                    
                    <div class="form-group">
                        <label>End Time</label>
                        <input type="datetime-local" name="endTime" id="endTime" required>
                    </div>
                    
                    <div class="form-group">
                        <label>Price (VND)</label>
                        <input type="number" step="1000" name="price" value="90000" required>
                    </div>
                    
                    <button type="submit" class="btn btn-add" style="width: 100%;">Save Showtime</button>
                </form>
            </div>
        </div>

        <script>
            var modal = document.getElementById("scheduleModal");

            function openAddModal() {
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
