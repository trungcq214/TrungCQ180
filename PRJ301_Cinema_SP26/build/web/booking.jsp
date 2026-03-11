<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Select Seats - ${requestScope.movie.title}</title>
        <style>
            body { font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif; background-color: #141414; color: white; margin: 0; padding: 0; }
            .navbar { background-color: #000; padding: 15px 30px; display: flex; justify-content: space-between; align-items: center; }
            .navbar .logo { font-size: 24px; font-weight: bold; color: #e50914; text-decoration: none; }
            .navbar .nav-links a { color: white; text-decoration: none; margin-left: 20px; font-size: 16px; }
            .navbar .nav-links a:hover { color: #e50914; }
            
            .container { padding: 40px; max-width: 1200px; margin: 0 auto; display: flex; gap: 40px; }
            
            .left-col { flex: 2; }
            .right-col { flex: 1; background: #222; padding: 30px; border-radius: 8px; align-self: start; position: sticky; top: 40px; }
            
            /* Screen & Seats */
            .screen { width: 100%; height: 50px; background: linear-gradient(to bottom, #ccc, #111); margin-bottom: 50px; transform: perspective(200px) rotateX(-5deg); box-shadow: 0 15px 30px rgba(255,255,255,0.1); text-align: center; line-height: 50px; color: #000; font-weight: bold; letter-spacing: 5px; }
            
            .seat-map { display: grid; grid-template-columns: repeat(10, 1fr); gap: 15px; justify-content: center; max-width: 800px; margin: 0 auto; }
            
            .seat { background: #444; color: white; text-align: center; padding: 15px 5px; border-radius: 8px 8px 4px 4px; cursor: pointer; font-weight: bold; font-size: 14px; border: 2px solid transparent; transition: 0.2s; position: relative; }
            .seat:hover:not(.booked) { transform: scale(1.1); background: #555; }
            .seat.selected { background: #2ecc71; border-color: #27ae60; box-shadow: 0 0 10px rgba(46, 204, 113, 0.5); }
            .seat.booked { background: #e74c3c; cursor: not-allowed; opacity: 0.6; }
            
            .seat-legend { display: flex; justify-content: center; gap: 30px; margin-top: 40px; }
            .legend-item { display: flex; align-items: center; gap: 10px; font-size: 14px; }
            .legend-box { width: 25px; height: 25px; border-radius: 4px; }
            .box-available { background: #444; }
            .box-selected { background: #2ecc71; }
            .box-booked { background: #e74c3c; }

            /* Right Col Summary */
            .right-col h2 { margin-top: 0; color: #e50914; border-bottom: 2px solid #333; padding-bottom: 15px; }
            .summary-item { display: flex; justify-content: space-between; margin-bottom: 15px; border-bottom: 1px dashed #444; padding-bottom: 10px; font-size: 16px;}
            .total-price { font-size: 24px; font-weight: bold; color: #2ecc71; text-align: right; margin: 20px 0; }
            
            .btn-checkout { background: #e50914; color: white; border: none; padding: 15px; width: 100%; font-size: 18px; font-weight: bold; border-radius: 4px; cursor: pointer; transition: 0.3s; }
            .btn-checkout:hover { background: #b20710; }
            .btn-checkout:disabled { background: #555; cursor: not-allowed; }
            
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
            <div class="left-col">
                <h2 style="text-align: center; margin-bottom: 30px;">Select Your Seats</h2>
                
                <div class="screen">SCREEN</div>
                
                <div class="seat-map">
                    <c:forEach items="${requestScope.seats}" var="seat">
                        <c:set var="isBooked" value="false" />
                        <c:forEach items="${requestScope.bookedSeatIds}" var="bId">
                            <c:if test="${bId == seat.seatId}">
                                <c:set var="isBooked" value="true" />
                            </c:if>
                        </c:forEach>
                        
                        <div class="seat ${isBooked ? 'booked' : ''}" 
                             data-id="${seat.seatId}" 
                             data-name="${seat.seatName}" 
                             data-price="${requestScope.schedule.price}"
                             onclick="toggleSeat(this, ${isBooked})">
                            ${seat.seatName}
                        </div>
                    </c:forEach>
                </div>
                
                <div class="seat-legend">
                    <div class="legend-item"><div class="legend-box box-available"></div> Available</div>
                    <div class="legend-item"><div class="legend-box box-selected"></div> Selected</div>
                    <div class="legend-item"><div class="legend-box box-booked"></div> Booked</div>
                </div>
            </div>
            
            <div class="right-col">
                <h2>Booking Summary</h2>
                
                <div class="summary-item">
                    <span>Movie</span>
                    <strong>${requestScope.movie.title}</strong>
                </div>
                <div class="summary-item">
                    <span>Theater</span>
                    <strong>${requestScope.schedule.theaterName}</strong>
                </div>
                <div class="summary-item">
                    <span>Room</span>
                    <strong>${requestScope.schedule.roomName}</strong>
                </div>
                <div class="summary-item">
                    <span>Showtime</span>
                    <strong style="color:#2ecc71;">
                        <fmt:formatDate value="${requestScope.schedule.startTime}" pattern="HH:mm (dd/MM/yyyy)"/>
                    </strong>
                </div>
                
                <div style="margin-top: 30px;">
                    <h3 style="margin-bottom: 10px; font-size: 16px; color: #aaa;">Selected Seats:</h3>
                    <div id="selected-seats-container" style="min-height: 40px; font-weight: bold; color: white;">
                        None
                    </div>
                </div>
                
                <div class="total-price">
                    Total: <span id="total-price-val">0</span> VND
                </div>
                
                <form action="payment" method="GET" id="bookingForm">
                    <input type="hidden" name="scheduleId" value="${requestScope.schedule.scheduleId}">
                    <input type="hidden" name="seatIds" id="seatIdsInput" value="">
                    <button type="submit" class="btn-checkout" id="btnCheckout" disabled>Proceed to Payment</button>
                </form>
            </div>
        </div>

        <script>
            let selectedSeats = [];
            const THICKET_PRICE = ${requestScope.schedule.price};

            function toggleSeat(element, isBooked) {
                if (isBooked) return;
                
                const seatId = element.getAttribute('data-id');
                const seatName = element.getAttribute('data-name');
                
                if (element.classList.contains('selected')) {
                    // Deselect
                    element.classList.remove('selected');
                    selectedSeats = selectedSeats.filter(s => s.id !== seatId);
                } else {
                    // Select
                    element.classList.add('selected');
                    selectedSeats.push({ id: seatId, name: seatName });
                }
                
                updateSummary();
            }
            
            function updateSummary() {
                const container = document.getElementById('selected-seats-container');
                const totalVal = document.getElementById('total-price-val');
                const btnCheckout = document.getElementById('btnCheckout');
                const seatIdsInput = document.getElementById('seatIdsInput');
                
                if (selectedSeats.length === 0) {
                    container.innerText = "None";
                    totalVal.innerText = "0";
                    btnCheckout.disabled = true;
                    seatIdsInput.value = "";
                } else {
                    const names = selectedSeats.map(s => s.name).join(", ");
                    container.innerText = names;
                    
                    const total = selectedSeats.length * THICKET_PRICE;
                    totalVal.innerText = total.toLocaleString('en-US');
                    
                    btnCheckout.disabled = false;
                    
                    const ids = selectedSeats.map(s => s.id).join(",");
                    seatIdsInput.value = ids;
                }
            }
        </script>
    </body>
</html>
