<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Manage Snacks - Admin</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; margin: 0; background: #f0f2f5; display: flex; height: 100vh; }
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; cursor: pointer; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }
            .content { flex: 1; padding: 40px; overflow-y: auto; }
            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            
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
            <a href="adminTheaters">Theaters & Rooms</a>
            <a href="adminSchedules">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks" class="active">Snacks & Drinks</a>
            <a href="adminReport">Revenue Report</a>
        </div>
        
        <div class="content">
            <div class="header">
                <h1>Manage Snacks & Drinks</h1>
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
            
            <button class="btn btn-add" onclick="openAddModal()">+ Add New Snack</button>
            
            <table>
                <thead>
                    <tr>
                        <th>Image</th>
                        <th>Name</th>
                        <th>Price (VND)</th>
                        <th>Stock Qty</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <c:forEach items="${requestScope.snacks}" var="s">
                        <tr>
                            <td>
                                <img src="${s.imageUrl}" alt="${s.name}" style="width: 50px; height: 50px; object-fit: cover; border-radius: 4px;">
                            </td>
                            <td><strong>${s.name}</strong></td>
                            <td>${s.price}</td>
                            <td>
                                <span style="color: ${s.stockQuantity < 10 ? 'red' : 'green'}; font-weight: bold;">
                                    ${s.stockQuantity}
                                </span>
                            </td>
                            <td>
                                <button class="btn btn-edit" onclick="openEditModal(${s.snackId}, '${s.name}', ${s.price}, ${s.stockQuantity}, '${s.imageUrl}')">Edit</button>
                                
                                <form action="adminSnacks" method="POST" style="display:inline;" onsubmit="return confirm('Delete this snack?');">
                                    <input type="hidden" name="action" value="delete">
                                    <input type="hidden" name="snackId" value="${s.snackId}">
                                    <button type="submit" class="btn btn-delete">Delete</button>
                                </form>
                            </td>
                        </tr>
                    </c:forEach>
                    <c:if test="${empty requestScope.snacks}">
                        <tr><td colspan="5" style="text-align:center;">No snacks found.</td></tr>
                    </c:if>
                </tbody>
            </table>
        </div>

        <!-- Snack Modal -->
        <div id="snackModal" class="modal">
            <div class="modal-content">
                <span class="close" onclick="closeModal()">&times;</span>
                <h2 id="modalTitle">Add Snack</h2>
                <form action="adminSnacks" method="POST">
                    <input type="hidden" name="action" id="formAction" value="add">
                    <input type="hidden" name="snackId" id="snackId" value="0">
                    
                    <div class="form-group">
                        <label>Name</label>
                        <input type="text" name="name" id="name" required>
                    </div>
                    <div class="form-group">
                        <label>Price (VND)</label>
                        <input type="number" step="500" name="price" id="price" required>
                    </div>
                    <div class="form-group">
                        <label>Stock Quantity</label>
                        <input type="number" name="stockQuantity" id="stockQuantity" required>
                    </div>
                    <div class="form-group">
                        <label>Image URL</label>
                        <input type="text" name="imageUrl" id="imageUrl" placeholder="https://example.com/popcorn.gif">
                    </div>
                    
                    <button type="submit" class="btn btn-add" style="width: 100%;">Save Snack</button>
                </form>
            </div>
        </div>

        <script>
            var modal = document.getElementById("snackModal");

            function openAddModal() {
                document.getElementById("modalTitle").innerText = "Add Snack";
                document.getElementById("formAction").value = "add";
                document.getElementById("snackId").value = "0";
                
                document.getElementById("name").value = "";
                document.getElementById("price").value = "50000";
                document.getElementById("stockQuantity").value = "100";
                document.getElementById("imageUrl").value = "";
                
                modal.style.display = "block";
            }

            function openEditModal(id, name, price, stockQuantity, imageUrl) {
                document.getElementById("modalTitle").innerText = "Edit Snack";
                document.getElementById("formAction").value = "edit";
                document.getElementById("snackId").value = id;
                
                document.getElementById("name").value = name;
                document.getElementById("price").value = price;
                document.getElementById("stockQuantity").value = stockQuantity;
                document.getElementById("imageUrl").value = imageUrl;
                
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
