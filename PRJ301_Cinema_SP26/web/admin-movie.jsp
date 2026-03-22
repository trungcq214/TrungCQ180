<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Movies - Admin</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            .header-left { display: flex; align-items: center; gap: 15px; }
            .user-info { display: flex; align-items: center; gap: 10px; font-weight: bold; color: #555; }
            .btn-logout { background: #e74c3c; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; }
            .btn-logout:hover { background: #c0392b; }
            .btn-back { background: #95a5a6; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; border: none; cursor: pointer; }
            .btn-back:hover { background: #7f8c8d; }
            
            table { width: 100%; border-collapse: collapse; background: white; box-shadow: 0 1px 3px rgba(0,0,0,0.1); }
            th, td { padding: 12px 15px; text-align: left; border-bottom: 1px solid #ddd; }
            th { background-color: #3498db; color: white; }
            tr:hover { background-color: #f5f5f5; }
            
            .btn { padding: 8px 12px; border: none; border-radius: 4px; cursor: pointer; color: white; font-weight: bold; text-decoration: none; display: inline-block; }
            .btn-add { background: #2ecc71; margin-bottom: 15px; }
            .btn-edit { background: #f39c12; }
            .btn-delete { background: #e74c3c; }
            
            .msg { padding: 10px; border-radius: 4px; margin-bottom: 20px; }
            .msg-success { background: #d4edda; color: #155724; border: 1px solid #c3e6cb; }
            .msg-error { background: #f8d7da; color: #721c24; border: 1px solid #f5c6cb; }
            
            /* Modal Styles */
            .modal { display: none; position: fixed; z-index: 1; left: 0; top: 0; width: 100%; height: 100%; overflow: auto; background-color: rgba(0,0,0,0.4); }
            .modal-content { background-color: #fefefe; margin: 5% auto; padding: 20px; border: 1px solid #888; width: 50%; border-radius: 8px; }
            .close { color: #aaa; float: right; font-size: 28px; font-weight: bold; cursor: pointer; }
            .close:hover { color: black; }
            .form-group { margin-bottom: 15px; }
            .form-group label { display: block; margin-bottom: 5px; font-weight: bold; }
            .form-group input, .form-group textarea { width: 100%; padding: 8px; box-sizing: border-box; border: 1px solid #ccc; border-radius: 4px; }
        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2 style="cursor: pointer" onclick="location.href='admin'">Cinema Admin</h2>
            <a href="admin">Dashboard Summary</a>
            <a href="adminMovies" class="active">Manage Movies</a>
            <a href="adminTheaters">Theaters & Rooms</a>
            <a href="adminSchedules">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks">Snacks & Drinks</a>
            <a href="adminReport">Revenue Report</a>
        </div>
        
        <div class="content">
            <div class="header">
                <div class="header-left">
                    <button class="btn-back" onclick="history.back()">&#8592; Quay lại</button>
                    <h1>Quản lý Phim</h1>
                </div>
                <div class="user-info">
                    Xin chào, <a href="profile" style="color: #3498db; text-decoration: underline;">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</a>
                    <a href="logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>
            
            <c:if test="${not empty sessionScope.message}">
                <div class="msg msg-success">${sessionScope.message}</div>
                <c:remove var="message" scope="session"/>
            </c:if>
            <c:if test="${not empty sessionScope.error}">
                <div class="msg msg-error">${sessionScope.error}</div>
                <c:remove var="error" scope="session"/>
            </c:if>
            
            <button class="btn btn-add" onclick="openAddModal()">+ Add New Movie</button>
            
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Poster</th>
                        <th>Title</th>
                        <th>Duration (m)</th>
                        <th>Release Date</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.movies}" var="m">
                        <tr>
                            <td>${m.movieId}</td>
                            <td>
                                <img src="${m.posterUrl}" alt="Poster" style="width: 50px; height: 75px; object-fit: cover;" onerror="this.src='https://via.placeholder.com/50x75.png?text=No+Img'"/>
                            </td>
                            <td><strong>${m.title}</strong></td>
                            <td>${m.duration}</td>
                            <td>${m.releaseDate}</td>
                            <td>
                                <button class="btn btn-edit" onclick="openEditModal(${m.movieId}, '${m.title}', '${m.duration}', '${m.releaseDate}', '${m.posterUrl}', '${m.description.replace('\'', '\\\'')}')">Edit</button>
                                <form action="adminMovies" method="POST" style="display:inline;" onsubmit="return confirm('Are you sure you want to delete this movie?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="movieId" value="${m.movieId}">
                                    <button type="submit" class="btn btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                </tbody>
            </table>
        </div>

        <!-- Movie Modal -->
        <div id="movieModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2 id="modalTitle">Add Movie</h2>
                <form action="adminMovies" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="movieId" id="movieId" value="0">
                    
                    <div class="form-group">
                        <label>Title</label>
                        <input type="text" name="title" id="title" required>
                    </div>
                    <div class="form-group">
                        <label>Duration (minutes)</label>
                        <input type="number" name="duration" id="duration" required>
                    </div>
                    <div class="form-group">
                        <label>Release Date</label>
                        <input type="date" name="releaseDate" id="releaseDate" required>
                    </div>
                    <div class="form-group">
                        <label>Poster URL</label>
                        <input type="url" name="posterUrl" id="posterUrl">
                    </div>
                    <div class="form-group">
                        <label>Description</label>
                        <textarea name="description" id="description" rows="4"></textarea>
                    </div>
                    
                    <button type="submit" class="btn btn-add" style="width: 100%;">Save Movie</button>
                </form>
            </div>
        </div>

        <script>
            var modal = document.getElementById("movieModal");

            function openAddModal() {
                document.getElementById("modalTitle").innerText = "Add Movie";
                document.getElementById("formAction").value = "add";
                document.getElementById("movieId").value = "0";
                document.getElementById("title").value = "";
                document.getElementById("duration").value = "";
                document.getElementById("releaseDate").value = "";
                document.getElementById("posterUrl").value = "";
                document.getElementById("description").value = "";
                modal.style.display = "block";
            }

            function openEditModal(id, title, duration, releaseDate, poster, desc) {
                document.getElementById("modalTitle").innerText = "Edit Movie";
                document.getElementById("formAction").value = "edit";
                document.getElementById("movieId").value = id;
                document.getElementById("title").value = title;
                document.getElementById("duration").value = duration;
                document.getElementById("releaseDate").value = releaseDate;
                document.getElementById("posterUrl").value = poster;
                document.getElementById("description").value = desc;
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
