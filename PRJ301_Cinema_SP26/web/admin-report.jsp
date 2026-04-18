<%@page contentType="text/html" pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
        <title>Revenue Report - Admin</title>
        <script src="https://cdn.jsdelivr.net/npm/chart.js@4.4.2/dist/chart.umd.min.js"></script>
        <style>
            @import url('https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap');

            * { box-sizing: border-box; margin: 0; padding: 0; }

            body {
                font-family: 'Inter', 'Segoe UI', sans-serif;
                background: #f0f2f5;
                display: flex;
                height: 100vh;
            }

            /* ── Sidebar ── */
            .sidebar { width: 250px; background: #2c3e50; color: white; padding-top: 20px; box-shadow: 2px 0 5px rgba(0,0,0,0.1); flex-shrink: 0; }
            .sidebar h2 { text-align: center; margin-bottom: 30px; font-size: 24px; color: #e74c3c; cursor: pointer; }
            .sidebar a { display: block; padding: 15px 25px; color: #ecf0f1; text-decoration: none; font-size: 16px; border-left: 4px solid transparent; transition: 0.3s; }
            .sidebar a:hover, .sidebar a.active { background: #34495e; border-left: 4px solid #e74c3c; }

            /* ── Main content ── */
            .content { flex: 1; padding: 40px; overflow-y: auto; }

            .header { display: flex; justify-content: space-between; align-items: center; border-bottom: 2px solid #ddd; padding-bottom: 20px; margin-bottom: 30px; }
            .header h1 { margin: 0; color: #333; }
            .header-left { display: flex; align-items: center; gap: 15px; }
            .user-info { display: flex; align-items: center; gap: 10px; font-weight: bold; color: #555; }
            .btn-logout { background: #e74c3c; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; }
            .btn-logout:hover { background: #c0392b; }
            .btn-back { background: #95a5a6; color: white; padding: 7px 14px; text-decoration: none; border-radius: 4px; font-size: 14px; border: none; cursor: pointer; }
            .btn-back:hover { background: #7f8c8d; }

            /* ── Stat cards ── */
            .stats-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 40px; }
            .stat-card { background: white; padding: 25px; border-radius: 10px; box-shadow: 0 4px 12px rgba(0,0,0,0.07); text-align: center; border-top: 4px solid #9b59b6; }
            .stat-card.revenue { border-color: #2ecc71; }
            .stat-card.tickets { border-color: #3498db; }
            .stat-card.snacks  { border-color: #f1c40f; }
            .stat-card h3 { margin: 0 0 10px 0; color: #7f8c8d; font-size: 13px; text-transform: uppercase; letter-spacing: 1px; }
            .stat-card .value { font-size: 28px; font-weight: 700; color: #2c3e50; word-break: break-all; }
            .stat-card .sub   { margin-top: 8px; color: #7f8c8d; font-size: 13px; }

            /* ── Chart card ── */
            .chart-card {
                background: white;
                border-radius: 12px;
                padding: 28px 32px 32px;
                box-shadow: 0 4px 20px rgba(0,0,0,0.08);
            }

            .chart-header {
                display: flex;
                justify-content: space-between;
                align-items: center;
                margin-bottom: 24px;
                flex-wrap: wrap;
                gap: 12px;
            }

            .chart-title {
                font-size: 18px;
                font-weight: 700;
                color: #2c3e50;
            }

            .chart-subtitle {
                font-size: 13px;
                color: #95a5a6;
                margin-top: 2px;
            }

            /* Year filter */
            .year-filter { display: flex; align-items: center; gap: 10px; }
            .year-filter label { font-size: 14px; font-weight: 600; color: #555; }

            .year-select {
                padding: 8px 36px 8px 14px;
                border: 2px solid #e0e4ea;
                border-radius: 8px;
                font-size: 14px;
                font-weight: 600;
                color: #2c3e50;
                background: #f8f9fb url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' viewBox='0 0 12 12'%3E%3Cpath fill='%23666' d='M6 8L1 3h10z'/%3E%3C/svg%3E") no-repeat right 12px center;
                -webkit-appearance: none;
                appearance: none;
                cursor: pointer;
                transition: border-color .2s;
            }
            .year-select:focus { outline: none; border-color: #3498db; }

            .chart-canvas-wrap { position: relative; height: 340px; }

        </style>
    </head>
    <body>
        <div class="sidebar">
            <h2 onclick="location.href='admin'">Cinema Admin</h2>
            <a href="admin">Dashboard Summary</a>
            <a href="adminMovies">Manage Movies</a>
            <a href="adminTheaters">Theaters &amp; Rooms</a>
            <a href="adminSchedules">Showtimes</a>
            <a href="adminStaff">Staff Accounts</a>
            <a href="adminSnacks">Snacks &amp; Drinks</a>
            <a href="adminReport" class="active">Revenue Report</a>
        </div>

        <div class="content">
            <div class="header">
                <div class="header-left">
                    <button class="btn-back" onclick="history.back()">&#8592; Quay lại</button>
                    <h1>Báo cáo Doanh thu</h1>
                </div>
                <div class="user-info">
                    Xin chào, <a href="profile" style="color:#3498db;text-decoration:underline;">${sessionScope.account.fullName != null ? sessionScope.account.fullName : sessionScope.account.username}</a>
                    <a href="logout" class="btn-logout">Đăng xuất</a>
                </div>
            </div>

            <!-- ── Stat cards ── -->
            <div class="stats-grid">
                <div class="stat-card revenue">
                    <h3>Tổng Doanh thu</h3>
                    <div class="value">${requestScope.totalRevenue} VND</div>
                </div>
                <div class="stat-card tickets">
                    <h3>Doanh thu Vé</h3>
                    <div class="value">${requestScope.totalTicketRevenue} VND</div>
                    <div class="sub">${requestScope.ticketsSold} vé đã bán</div>
                </div>
                <div class="stat-card snacks">
                    <h3>Doanh thu Snack</h3>
                    <div class="value">${requestScope.totalSnackRevenue} VND</div>
                    <div class="sub">${requestScope.snacksSold} sản phẩm</div>
                </div>
            </div>

            <!-- ── Monthly Revenue Chart ── -->
            <div class="chart-card">
                <div class="chart-header">
                    <div>
                        <div class="chart-title">Doanh thu theo Tháng</div>
                        <div class="chart-subtitle">Tổng hợp vé + snack • Năm ${requestScope.selectedYear}</div>
                    </div>
                    <div class="year-filter">
                        <label for="yearSelect">Lọc năm:</label>
                        <select id="yearSelect" class="year-select" onchange="changeYear(this.value)">
                            <c:forEach var="y" items="${requestScope.availableYears}">
                                <option value="${y}" ${y == requestScope.selectedYear ? 'selected' : ''}>${y}</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="chart-canvas-wrap">
                    <canvas id="revenueChart"></canvas>
                </div>
            </div>
        </div>

        <script>
            const labels     = [${requestScope.chartLabels}];
            const dataTicket = [${requestScope.chartDataTicket}];
            const dataSnack  = [${requestScope.chartDataSnack}];

            const ctx = document.getElementById('revenueChart').getContext('2d');

            // Gradient for tickets (blue)
            const gradTicket = ctx.createLinearGradient(0, 0, 0, 340);
            gradTicket.addColorStop(0, 'rgba(52, 152, 219, 0.85)');
            gradTicket.addColorStop(1, 'rgba(52, 152, 219, 0.30)');

            // Gradient for snacks (amber/orange)
            const gradSnack = ctx.createLinearGradient(0, 0, 0, 340);
            gradSnack.addColorStop(0, 'rgba(243, 156, 18, 0.85)');
            gradSnack.addColorStop(1, 'rgba(243, 156, 18, 0.30)');

            new Chart(ctx, {
                type: 'bar',
                data: {
                    labels: labels,
                    datasets: [
                        {
                            label: '🎟️ Doanh thu Vé',
                            data: dataTicket,
                            backgroundColor: gradTicket,
                            borderColor: '#3498db',
                            borderWidth: 2,
                            borderRadius: 6,
                            borderSkipped: false,
                            hoverBackgroundColor: 'rgba(52,152,219,1)'
                        },
                        {
                            label: '🍿 Doanh thu Snack',
                            data: dataSnack,
                            backgroundColor: gradSnack,
                            borderColor: '#f39c12',
                            borderWidth: 2,
                            borderRadius: 6,
                            borderSkipped: false,
                            hoverBackgroundColor: 'rgba(243,156,18,1)'
                        }
                    ]
                },
                options: {
                    responsive: true,
                    maintainAspectRatio: false,
                    interaction: { mode: 'index', intersect: false },
                    plugins: {
                        legend: {
                            display: true,
                            position: 'bottom',
                            align: 'center',
                            labels: {
                                padding: 20,
                                font: { size: 13, weight: '600' },
                                color: '#444',
                                usePointStyle: true,
                                pointStyle: 'rectRounded',
                                boxWidth: 14,
                                boxHeight: 14
                            }
                        },
                        tooltip: {
                            backgroundColor: '#2c3e50',
                            titleColor: '#ecf0f1',
                            bodyColor: '#bdc3c7',
                            padding: 12,
                            cornerRadius: 8,
                            callbacks: {
                                label: function(ctx) {
                                    const val = ctx.parsed.y;
                                    return ' ' + ctx.dataset.label + ': ' + val.toLocaleString('vi-VN') + ' VND';
                                }
                            }
                        }
                    },
                    scales: {
                        x: {
                            grid: { display: false },
                            ticks: { color: '#555', font: { weight: '600' } }
                        },
                        y: {
                            beginAtZero: true,
                            grid: { color: 'rgba(0,0,0,0.06)' },
                            ticks: {
                                color: '#555',
                                callback: function(v) {
                                    if (v >= 1_000_000) return (v/1_000_000).toFixed(1) + 'M';
                                    if (v >= 1_000)     return (v/1_000).toFixed(0) + 'K';
                                    return v;
                                }
                            }
                        }
                    }
                }
            });

            function changeYear(year) {
                location.href = 'adminReport?year=' + year;
            }
        </script>
    </body>
</html>
