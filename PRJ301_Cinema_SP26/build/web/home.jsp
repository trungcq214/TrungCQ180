<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Cinema System - Home</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #141414; color: white; margin: 0; padding: 0; }
            .navbar { background-color: #000; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
            .navbar .logo { font-size: 24px; font-weight: bold; color: #e50914; text-decoration: none; }
            .navbar .nav-links a { color: white; text-decoration: none; margin-left: 20px; font-size: 16px; }
            .navbar .nav-links a:hover { color: #e50914; }
            .container { padding: 40px; max-width: 1200px; margin: 0 auto; }
            .movie-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(200px, 1fr)); gap: 30px; margin-top: 30px; }
            .movie-card { background: #222; border-radius: 8px; overflow: hidden; transition: transform 0.2s; cursor: pointer; }
            .movie-card:hover { transform: scale(1.05); }
            .movie-poster { width: 100%; height: 300px; background-color: #333; display: flex; align-items: center; justify-content: center; }
            .movie-info { padding: 15px; }
            .movie-title { font-size: 18px; margin: 0 0 10px 0; font-weight: bold; }
            .movie-meta { color: #aaa; font-size: 14px; margin-bottom: 15px; }
            .btn-book { display: block; width: 100%; padding: 10px; text-align: center; background-color: #e50914; color: white; text-decoration: none; border-radius: 4px; font-weight: bold; }
            .btn-book:hover { background-color: #b20710; }
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
            <h2>Now Showing</h2>
            
            <div class="movie-grid">
                <c:forEach items="${requestScope.movies}" var="m">
                    <div class="movie-card">
                        <div class="movie-poster">
                            <!-- Placeholder for poster. Can use ${m.posterUrl} if available -->
                            <img src="${m.posterUrl != null ? m.posterUrl : 'https://via.placeholder.com/300x450.png?text=No+Poster'}" alt="${m.title}" style="width: 100%; height: 100%; object-fit: cover; opacity: 0.8;" onerror="this.src='https://via.placeholder.com/300x450.png?text=🎬';"/>
                        </div>
                        <div class="movie-info">
                            <h3 class="movie-title">${m.title}</h3>
                            <div class="movie-meta">${m.duration} mins</div>
                            <div class="movie-meta" style="font-size: 12px;">Release: ${m.releaseDate}</div>
                            <a href="schedule?id=${m.movieId}" class="btn-book">Book Ticket</a>
                        </div>
                    </div>
                </c:forEach>
                
                <c:if test="${empty requestScope.movies}">
                    <div style="grid-column: 1 / -1; text-align: center; padding: 50px; background: #222; border-radius: 8px;">
                        <h3 style="color: #888;">No movies are currently showing.</h3>
                        <p style="color: #666;">Please check back later!</p>
                    </div>
                </c:if>
            </div>
        </div>
    </body>
</html>
