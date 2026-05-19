<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="com.foodhub.model.Order" %>
<%@ page import="com.foodhub.model.Restaurant" %>
<%@ page import="com.foodhub.dao.UserDAO" %>
<%@ page import="com.foodhub.dao.OrderDAO" %>
<%@ page import="com.foodhub.dao.RestaurantDAO" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.Calendar" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) { response.sendRedirect("login.jsp"); return; }

    UserDAO udao = new UserDAO();
    OrderDAO odao = new OrderDAO();
    RestaurantDAO rdao = new RestaurantDAO();

    List<User> customers = udao.getAllCustomers();
    List<Restaurant> kitchens = rdao.getAllRestaurants();
    List<Order> allOrders = odao.getAllOrders();

    double grossRevenue = 0;
    int ordersToday = 0;
    int[] hourlyBuckets = new int[6]; // 0-4, 4-8, 8-12, 12-16, 16-20, 20-24
    Calendar cal = Calendar.getInstance();
    cal.set(Calendar.HOUR_OF_DAY, 0);
    cal.set(Calendar.MINUTE, 0);
    cal.set(Calendar.SECOND, 0);
    long todayStart = cal.getTimeInMillis();

    for (Order o : allOrders) {
        if (!"CANCELLED".equals(o.getOrderStatus())) {
            grossRevenue += o.getTotalPrice();
            if (o.getOrderDate().getTime() >= todayStart) {
                ordersToday++;
                Calendar oCal = Calendar.getInstance();
                oCal.setTime(o.getOrderDate());
                int hour = oCal.get(Calendar.HOUR_OF_DAY);
                int bucketIdx = hour / 4;
                if (bucketIdx < 6) hourlyBuckets[bucketIdx]++;
            }
        }
    }
    
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Platform Control — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .admin-layout { display: grid; grid-template-columns: 280px 1fr; min-height: 100vh; background: #fff; }
        .sidebar { background: var(--ink); color: #fff; padding: 60px 24px; position: sticky; top: 0; height: 100vh; }
        .sidebar-link { display: flex; align-items: center; gap: 16px; padding: 14px 20px; border-radius: 12px; color: var(--ink-3); text-decoration: none; margin-bottom: 8px; transition: all 0.2s; font-weight: 600; font-size: 14px; }
        .sidebar-link:hover, .sidebar-link.active { background: rgba(255,255,255,0.08); color: #fff; }
        .sidebar-link.active { color: var(--brand); }
        .main-content { padding: 80px 7vw; background: var(--surface); }
        
        .stat-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 24px; margin-bottom: 40px; }
        .stat-card { background: #fff; padding: 32px; border-radius: var(--radius-md); box-shadow: var(--shadow); border: 1px solid var(--border); position: relative; overflow: hidden; transition: transform 0.3s cubic-bezier(0.34, 1.56, 0.64, 1); }
        .stat-card:hover { transform: translateY(-8px); }
        .stat-card h4 { color: var(--ink-3); font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 12px; font-weight: 800; }
        .stat-card .value { font-size: 32px; font-family: var(--font-display); font-weight: 900; transition: all 0.5s; }
        
        .value-up { animation: value-pulse-green 0.8s ease-out; }
        @keyframes value-pulse-green {
            0% { color: #06c167; transform: scale(1); }
            50% { transform: scale(1.1); }
            100% { color: inherit; transform: scale(1); }
        }

        .chart-container { background: #fff; padding: 40px; border-radius: var(--radius-lg); margin-bottom: 60px; border: 1px solid var(--border); box-shadow: var(--shadow); }
        
        /* Real-time Indicator */
        .rt-indicator { width: 8px; height: 8px; background: #06c167; border-radius: 50%; display: inline-block; margin-right: 8px; position: relative; }
        .rt-indicator::after { content: ''; position: absolute; inset: -4px; border: 2px solid #06c167; border-radius: 50%; animation: ripple 2s infinite; }
        @keyframes ripple { 0% { transform: scale(1); opacity: 1; } 100% { transform: scale(3); opacity: 0; } }
    </style>
</head>
<body>
    <div class="admin-layout">
        <aside class="sidebar">
            <a href="index.jsp" class="display-font" style="font-size: 24px; color: var(--brand); text-decoration: none; margin-bottom: 60px; display: block; font-weight: 900;">FoodHub</a>
            <nav>
                <a href="admin-dashboard.jsp" class="sidebar-link active">📊 Control Tower</a>
                <a href="restaurant?action=list" class="sidebar-link">🍴 Kitchen Network</a>
                <a href="user?action=list" class="sidebar-link">👥 Citizen Directory</a>
                <a href="order?action=history" class="sidebar-link">📦 Logistics Flow</a>
                <a href="review?action=list" class="sidebar-link">⭐ Reviews</a>
            </nav>
            <div style="margin-top: auto; padding-top: 60px;">
                <a href="user?action=logout" class="sidebar-link" style="color: #ef4444;">🚪 Terminate Session</a>
            </div>
        </aside>

        <main class="main-content">
            <header style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 60px;" class="animate-fadeIn">
                <div>
                    <h1 class="display-font" style="font-size: 42px; margin-bottom: 8px;">System <em>Metrics</em></h1>
                    <div style="display: flex; align-items: center; color: var(--ink-3); font-size: 13px; font-weight: 700;">
                        <span class="rt-indicator"></span> LIVE SYSTEM MONITORING ACTIVE
                    </div>
                </div>
                <div style="display: flex; align-items: center; gap: 20px;">
                    <div style="text-align: right;">
                        <div style="font-weight: 700; font-size: 14px;"><%= admin.getName() %></div>
                        <div style="font-size: 12px; color: var(--ink-3);">Master Administrator</div>
                    </div>
                    <div style="width: 48px; height: 48px; background: var(--brand); border-radius: 50%; display: flex; align-items: center; justify-content: center; color: #fff; font-weight: 900; font-family: var(--font-display);">A</div>
                </div>
            </header>

            <div class="stat-grid">
                <div class="stat-card animate-fadeUp">
                    <h4>Active Citizens</h4>
                    <div class="value" id="val-customers"><%= customers.size() %></div>
                    <div style="color: #06c167; font-size: 12px; font-weight: 700; margin-top: 8px;">↑ Live count</div>
                </div>
                <div class="stat-card animate-fadeUp" style="animation-delay: 0.1s;">
                    <h4>Kitchen Partners</h4>
                    <div class="value" id="val-kitchens"><%= kitchens.size() %></div>
                    <div style="color: #06c167; font-size: 12px; font-weight: 700; margin-top: 8px;">↑ Active network</div>
                </div>
                <div class="stat-card animate-fadeUp" style="animation-delay: 0.2s;">
                    <h4>Daily Velocity</h4>
                    <div class="value" id="val-orders"><%= ordersToday %></div>
                    <div style="color: #06c167; font-size: 12px; font-weight: 700; margin-top: 8px;">↑ Orders today</div>
                </div>
                <div class="stat-card animate-fadeUp" style="animation-delay: 0.3s;">
                    <h4>Gross Revenue</h4>
                    <div class="value" id="val-revenue">$<%= String.format("%.1fk", grossRevenue / 1000.0) %></div>
                    <div style="color: var(--brand); font-size: 12px; font-weight: 700; margin-top: 8px;">↑ Platform total</div>
                </div>
            </div>

            <div class="chart-container animate-fadeUp">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                    <h3 class="display-font" style="font-size: 24px;">Real-time Velocity</h3>
                    <div id="chart-status" style="font-size: 12px; font-weight: 800; color: #06c167;">SYNCED</div>
                </div>
                <canvas id="velocityChart" height="100"></canvas>
            </div>

            <div class="card animate-fadeUp">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 32px;">
                    <h3 class="display-font" style="font-size: 24px;">Recent System Events</h3>
                    <button class="btn btn-ghost btn-sm" style="padding: 8px 16px; font-size: 12px;">Download Logs</button>
                </div>
                <table id="events-table">
                    <thead>
                        <tr>
                            <th>Event Description</th>
                            <th>Module</th>
                            <th>Criticality</th>
                            <th>Timestamp</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (allOrders != null && !allOrders.isEmpty()) {
                            int count = 0;
                            for (Order o : allOrders) {
                                if (count++ > 4) break;
                        %>
                        <tr class="animate-fadeIn">
                            <td style="font-weight: 700;">Logistics Order #<%= o.getOrderId() %> Logged</td>
                            <td>Operations</td>
                            <td><span class="badge badge-ember">Active</span></td>
                            <td class="text-muted"><%= sdf.format(o.getOrderDate()) %></td>
                        </tr>
                        <% } } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>

    <script>
        // Initialize Chart
        const ctx = document.getElementById('velocityChart').getContext('2d');
        const velocityChart = new Chart(ctx, {
            type: 'line',
            data: {
                labels: ['00:00', '04:00', '08:00', '12:00', '16:00', '20:00'],
                datasets: [{
                    label: 'Orders per 4h Block',
                    data: [<%= hourlyBuckets[0] %>, <%= hourlyBuckets[1] %>, <%= hourlyBuckets[2] %>, <%= hourlyBuckets[3] %>, <%= hourlyBuckets[4] %>, <%= hourlyBuckets[5] %>],
                    borderColor: '#e8400c',
                    backgroundColor: 'rgba(232, 64, 12, 0.1)',
                    borderWidth: 4,
                    fill: true,
                    tension: 0.4,
                    pointRadius: 6,
                    pointBackgroundColor: '#fff'
                }]
            },
            options: {
                responsive: true,
                animation: { duration: 2000, easing: 'easeOutQuart' },
                plugins: { legend: { display: false } },
                scales: {
                    x: { grid: { display: false } },
                    y: { beginAtZero: true, grid: { borderDash: [5, 5] } }
                }
            }
        });

        // Polling Logic
        let lastOrderCount = <%= ordersToday %>;
        
        async function updateStats() {
            try {
                const response = await fetch('admin-stats');
                const data = await response.json();
                
                updateValue('val-customers', data.customers);
                updateValue('val-kitchens', data.kitchens);
                updateValue('val-orders', data.ordersToday);
                updateValue('val-revenue', '$' + (data.revenue / 1000).toFixed(1) + 'k');
                
                if (data.ordersToday !== lastOrderCount) {
                    lastOrderCount = data.ordersToday;
                    velocityChart.data.datasets[0].data[6] = data.ordersToday;
                    velocityChart.update();
                    
                    document.getElementById('chart-status').innerText = 'UPDATING...';
                    setTimeout(() => document.getElementById('chart-status').innerText = 'SYNCED', 2000);
                }
            } catch (error) {
                console.error('Real-time sync failed:', error);
            }
        }

        function updateValue(id, newValue) {
            const el = document.getElementById(id);
            if (el.innerText !== String(newValue)) {
                el.innerText = newValue;
                el.classList.remove('value-up');
                void el.offsetWidth; // trigger reflow
                el.classList.add('value-up');
            }
        }

        // Poll every 5 seconds
        setInterval(updateStats, 5000);
    </script>
</body>
</html>
