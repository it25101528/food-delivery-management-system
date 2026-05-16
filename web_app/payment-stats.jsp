<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.Payment" %>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="java.util.List" %>
<%
    User sessionUser = (User) session.getAttribute("user");
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Financial Insights – FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body style="background: #f3f4f6;">
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding-top: 40px; padding-bottom: 80px;">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;" class="animate-fadeIn">
            <div>
                <h1 style="font-size: 32px; margin-bottom: 8px;">Financial Insights</h1>
                <p class="text-muted">Track revenue and payment status across the platform</p>
            </div>
            <a href="<%= (sessionUser != null && "RESTAURANT".equals(sessionUser.getRole())) ? "restaurant-dashboard.jsp" : "admin-dashboard.jsp" %>" 
               class="btn btn-secondary">← Back to Dashboard</a>
        </div>

        <div class="card animate-fadeUp">
            <table>
                <thead>
                    <tr>
                        <th>Transaction ID</th>
                        <th>Order ID</th>
                        <th>Amount</th>
                        <th>Method</th>
                        <th>Status</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (payments != null) { for (Payment p : payments) { %>
                        <tr>
                            <td style="font-weight: 700;">#TX-<%= p.getPaymentId() %></td>
                            <td style="font-weight: 600;">Order #<%= p.getOrderId() %></td>
                            <td style="font-weight: 800; color: var(--primary);">$<%= String.format("%.2f", p.getAmount()) %></td>
                            <td><span class="badge" style="background: #eef2f7;"><%= p.getPaymentMethod() %></span></td>
                            <td>
                                <% String pStatus = p.getPaymentStatus() != null ? p.getPaymentStatus() : "COMPLETED"; %>
                                <span class="badge <%= "REFUNDED".equals(pStatus) ? "badge-ember" : ("COMPLETED".equals(pStatus) ? "badge-green" : "badge-secondary") %>">
                                    <%= pStatus %>
                                </span>
                            </td>
                        </tr>
                    <% } } %>
                </tbody>
            </table>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
