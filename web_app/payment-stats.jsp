<%@ page import="com.foodhub.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Statistics - FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <script src="https://cdn.jsdelivr.net/npm/chart.js"></script>
    <style>
        .tab-btn { padding: 10px 20px; border: none; background: none; cursor: pointer; border-bottom: 2px solid transparent; font-weight: 600; color: #64748b; }
        .tab-btn.active { border-bottom-color: #06c167; color: #06c167; }
        .tab-content { display: none; margin-top: 20px; }
        .tab-content.active { display: block; }
        .chart-container { background: white; padding: 20px; border-radius: 12px; border: 1px solid #e2e8f0; margin-bottom: 20px; }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1>Revenue & Payments</h1>
            <a href="admin-dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <%
            List<Payment> payments = (List<Payment>) request.getAttribute("payments");
            double totalRevenue = 0;
            if (payments != null) {
                for (Payment p : payments) totalRevenue += p.getAmount();
            }
        %>

        <div style="border-bottom: 1px solid #e2e8f0; margin-bottom: 20px; display: flex; gap: 10px;">
            <button class="tab-btn active" onclick="showTab('history')">Payment History</button>
            <button class="tab-btn" onclick="showTab('analytics')">Revenue Analytics</button>
        </div>

        <div id="history" class="tab-content active">
            <div class="card" style="padding: 30px; margin-bottom: 30px; background: var(--primary); color: white;">
                <h3>Total System Revenue</h3>
                <h1 style="font-size: 48px; margin-top: 10px;">$<%= String.format("%.2f", totalRevenue) %></h1>
            </div>
    
            <div class="card">
                <table>
                    <thead>
                        <tr>
                            <th>Transaction ID</th>
                            <th>Order ID</th>
                            <th>Method</th>
                            <th>Amount</th>
                            <th>Status</th>
                            <th>Date</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% 
                            if (payments != null && !payments.isEmpty()) {
                                for (Payment p : payments) {
                        %>
                            <tr>
                                <td><code><%= p.getTransactionId() %></code></td>
                                <td>#<%= p.getOrderId() %></td>
                                <td><%= p.getPaymentMethod() %></td>
                                <td><strong>$<%= p.getAmount() %></strong></td>
                                <td><span style="color: #06c167; font-weight: 600;"><%= p.getPaymentStatus() %></span></td>
                                <td><%= p.getPaymentDate() %></td>
                            </tr>
                        <% 
                                }
                            } else {
                        %>
                            <tr><td colspan="6" style="text-align:center; padding:40px;">No payments recorded yet.</td></tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </div>

        <div id="analytics" class="tab-content">
            <div style="display: flex; gap: 20px; align-items: center; margin-bottom: 20px;">
                <h3 style="margin: 0;">System Performance</h3>
                <select id="revenuePeriod" onchange="loadAdminCharts()" class="form-control" style="width: 150px;">
                    <option value="24h">Last 24 Hours</option>
                    <option value="7d" selected>Last 7 Days</option>
                    <option value="30d">Last 30 Days</option>
                </select>
            </div>

            <div style="display: grid; grid-template-columns: 1.5fr 1fr; gap: 20px;">
                <div class="chart-container">
                    <h4>Total Revenue Details</h4>
                    <div id="totalRevenueList" style="margin-top: 15px;">
                        <table style="width: 100%; border-collapse: collapse;">
                            <thead>
                                <tr style="border-bottom: 2px solid #f1f5f9; text-align: left;">
                                    <th style="padding: 12px; color: #64748b;">Period/Date</th>
                                    <th style="padding: 12px; color: #64748b; text-align: right;">Total Revenue</th>
                                </tr>
                            </thead>
                            <tbody id="totalRevenueTableBody">
                                <!-- Loaded via JS -->
                            </tbody>
                        </table>
                    </div>
                </div>
                <div class="chart-container">
                    <h4>Revenue by Restaurant</h4>
                    <canvas id="restaurantRevenueChart"></canvas>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.querySelectorAll('.tab-btn').forEach(b => b.classList.remove('active'));
            document.getElementById(tabId).classList.add('active');
            event.target.classList.add('active');
            if (tabId === 'analytics') loadAdminCharts();
        }

        let totalChart, restaurantChart;

        function loadAdminCharts() {
            const period = document.getElementById('revenuePeriod').value;
            
            // Load Total Revenue List
            const tableBody = document.getElementById('totalRevenueTableBody');
            tableBody.innerHTML = '<tr><td colspan="2" style="text-align:center; padding:15px;">Loading...</td></tr>';

            fetch('analytics?action=adminTotalRevenue&period=' + period)
                .then(res => res.json())
                .then(data => {
                    tableBody.innerHTML = '';
                    if (!data.labels || data.labels.length === 0) {
                        tableBody.innerHTML = '<tr><td colspan="2" style="text-align:center; padding:15px;">No data available.</td></tr>';
                        return;
                    }
                    data.labels.forEach((label, i) => {
                        let displayLabel = label;
                        if (period === '24h') displayLabel = `Hour \${label}:00`;
                        
                        const row = document.createElement('tr');
                        row.style.borderBottom = '1px solid #f1f5f9';
                        row.innerHTML = `
                            <td style="padding: 10px; font-weight: 500;">\${displayLabel}</td>
                            <td style="padding: 10px; text-align: right; font-weight: 700; color: #06c167;">$\${data.values[i].toFixed(2)}</td>
                        `;
                        tableBody.appendChild(row);
                    });
                });

            // Load Restaurant Revenue Chart
            fetch('analytics?action=adminRevenueByRestaurant&period=' + period)
                .then(res => res.json())
                .then(json => {
                    const data = json.data;
                    const ctx = document.getElementById('restaurantRevenueChart').getContext('2d');
                    if (restaurantChart) restaurantChart.destroy();
                    restaurantChart = new Chart(ctx, {
                        type: 'doughnut',
                        data: {
                            labels: data.map(i => i.name),
                            datasets: [{
                                data: data.map(i => i.revenue),
                                backgroundColor: [
                                    '#06c167', '#3b82f6', '#f59e0b', '#ef4444', '#8b5cf6', '#ec4899'
                                ]
                            }]
                        },
                        options: {
                            plugins: {
                                legend: { position: 'bottom' }
                            }
                        }
                    });
                });
        }
    </script>
</body>
</html>
