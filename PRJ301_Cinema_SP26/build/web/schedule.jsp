<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Schedules for ${movie.title}</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #141414; color: white; margin: 0; padding: 0; }
            .navbar { background-color: #000; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
            .navbar .logo { font-size: 24px; font-weight: bold; color: #e50914; text-decoration: none; }
            .navbar .nav-links a { color: white; text-decoration: none; margin-left: 20px; font-size: 16px; }
            .navbar .nav-links a:hover { color: #e50914; }
            
            .container { padding: 40px; max-width: 1000px; margin: 0 auto; }
            
            .movie-header { display: flex; gap: 30px; margin-bottom: 40px; background: #222; padding: 30px; border-radius: 8px; }
            .movie-poster img { width: 250px; border-radius: 8px; box-shadow: 0 4px 10px rgba(0,0,0,0.5); }
            .movie-info h1 { margin-top: 0; font-size: 36px; color: #e50914; }
            .movie-info p { color: #ccc; line-height: 1.6; font-size: 16px; margin-bottom: 10px; }
            .movie-meta { background: #333; display: inline-block; padding: 5px 10px; border-radius: 4px; margin-right: 10px; font-size: 14px; }
            
            .schedule-section h2 { border-bottom: 2px solid #333; padding-bottom: 10px; margin-bottom: 20px; }
            
            .schedule-card { background: #1a1a1a; border: 1px solid #333; padding: 25px; border-radius: 8px; margin-bottom: 20px; display: flex; justify-content: space-between; align-items: center; transition: 0.2s; }
            .schedule-card:hover { border-color: #e50914; background: #222; }
            
            .venue-info h3 { margin: 0 0 5px 0; color: #fff; font-size: 20px; }
            .venue-info p { margin: 0; color: #888; font-size: 14px; }
            
            .time-info { text-align: right; }
            .time-str { font-size: 24px; font-weight: bold; color: #2ecc71; margin-bottom: 5px; }
            .date-str { color: #aaa; font-size: 14px; margin-bottom: 10px; }
            
            .btn-select { background: #e50914; color: white; border: none; padding: 10px 20px; border-radius: 4px; cursor: pointer; font-size: 16px; font-weight: bold; text-decoration: none; display: inline-block; }
            .btn-select:hover { background: #b20710; }
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
            <div class="movie-header">
                <div class="movie-poster">
                    <img src="${requestScope.movie.posterUrl != null ? requestScope.movie.posterUrl : 'https://via.placeholder.com/250x375.png?text=No+Poster'}" alt="${requestScope.movie.title}" onerror="this.src='https://via.placeholder.com/250x375.png?text=No+Poster'"/>
                </div>
                <div class="movie-info">
                    <h1>${requestScope.movie.title}</h1>
                    <div style="margin-bottom: 20px;">
                        <span class="movie-meta">${requestScope.movie.duration} mins</span>
                        <span class="movie-meta">Release: ${requestScope.movie.releaseDate}</span>
                    </div>
                    <p>${requestScope.movie.description}</p>
                </div>
            </div>

            <div class="schedule-section">
                <h2>Available Showtimes</h2>
                
                <c:if test="${empty requestScope.schedules}">
                    <div style="background: #222; padding: 40px; text-align: center; border-radius: 8px; color: #888;">
                        <p>Sorry, there are currently no upcoming showtimes for this movie.</p>
                        <a href="home" style="color: #e50914;">Go back to Movies</a>
                    </div>
                </c:if>

                <c:forEach items="${requestScope.schedules}" var="s">
                    <div class="schedule-card">
                        <div class="venue-info">
                            <h3>${s.theaterName}</h3>
                            <p>Room: ${s.roomName} &bull; Price: <fmt:formatNumber value="${s.price}" pattern="#,###"/> VND</p>
                        </div>
                        <div class="time-info">
                            <div class="time-str">
                                <fmt:formatDate value="${s.startTime}" pattern="HH:mm"/>
                            </div>
                            <div class="date-str">
                                <fmt:formatDate value="${s.startTime}" pattern="EEEE, MMM dd, yyyy"/>
                            </div>
                            <!-- Next step is booking flow where user selects seats! -->
                            <a href="booking?scheduleId=${s.scheduleId}" class="btn-select">Select Seats</a>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </body>
</html>
