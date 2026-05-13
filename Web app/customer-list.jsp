<%@ page import="com.foodhub.model.User" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Customer Management - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1>Registered Customers</h1>
            <a href="../mod_delivery/admin-dashboard.jsp" class="btn btn-secondary">← Back to Dashboard</a>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Name</th>
                        <th>Email</th>
                        <th>Phone</th>
                        <th>Type</th>
                        <th>Actions</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<User> customers = (List<User>) request.getAttribute("customers");
                        if (customers != null) {
                            for (User c : customers) {
                    %>
                        <tr>
                            <td>#<%= c.getUserId() %></td>
                            <td><strong><%= c.getName() %></strong></td>
                            <td><%= c.getEmail() %></td>
                            <td><%= c.getPhoneNumber() %></td>
                            <td>
                                <span style="padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; 
                                      background: <%= "PREMIUM".equals(c.getUserType()) ? "#fef3c7" : "#f3f4f6" %>; 
                                      color: <%= "PREMIUM".equals(c.getUserType()) ? "#92400e" : "#374151" %>;">
                                    <%= c.getUserType() %>
                                </span>
                            </td>
                            <td>
                                <a href="../user?action=delete&id=<%= c.getUserId() %>" 
                                   class="btn btn-secondary" 
                                   style="color: #ef4444; border-color: #fca5a5; padding: 5px 12px; font-size: 12px;"
                                   onclick="return confirm('Are you sure?')">Delete Account</a>
                            </td>
                        </tr>
                    <% 
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 40px;">No customers found.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
