<%@ page import="com.foodhub.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Payment Statistics - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1>Revenue & Payments</h1>
            <a href="../mod_delivery/admin-dashboard.jsp" class="btn btn-secondary">Back to Dashboard</a>
        </div>

        <%
            List<Payment> payments = (List<Payment>) request.getAttribute("payments");
            double totalRevenue = 0;
            if (payments != null) {
                for (Payment p : payments) totalRevenue += p.getAmount();
            }
        %>

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
</body>
</html>
