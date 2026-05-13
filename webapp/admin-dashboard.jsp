<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Admin Dashboard - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
            <h1>Admin Dashboard</h1>
            <p>Welcome back, <strong><%= admin.getName() %></strong></p>
        </div>

        <div style="display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px;">
            <div class="card" style="padding: 30px; text-align: center;">
                <h2 style="font-size: 36px; color: var(--primary);">Users</h2>
                <p>Manage all customers and owners</p>
                <a href="../user?action=list" class="btn btn-primary" style="margin-top: 20px; display: inline-block;">View Users</a>
            </div>

            <div class="card" style="padding: 30px; text-align: center;">
                <h2 style="font-size: 36px; color: var(--primary);">Restaurants</h2>
                <p>Add and manage restaurants</p>
                <div style="display: flex; gap: 10px; justify-content: center; margin-top: 20px;">
                    <a href="../mod_restaurant/restaurant-add.jsp" class="btn btn-primary">Add New</a>
                    <a href="../restaurant?action=list" class="btn btn-secondary">View All</a>
                </div>
            </div>

            <div class="card" style="padding: 30px; text-align: center;">
                <h2 style="font-size: 36px; color: var(--primary);">Orders</h2>
                <p>Monitor system-wide orders</p>
                <a href="../order?action=history" class="btn btn-primary" style="margin-top: 20px; display: inline-block;">View Orders</a>
            </div>
        </div>

        <div style="margin-top: 40px;">
            <h3>Quick Actions</h3>
            <div style="display: flex; gap: 20px; margin-top: 20px;">
                <a href="../mod_restaurant/restaurant-add.jsp" class="card" style="padding: 15px 30px; text-decoration: none; color: inherit;">➕ Add Restaurant</a>
                <a href="agent-register.jsp" class="card" style="padding: 15px 30px; text-decoration: none; color: inherit;">🚚 Register Agent</a>
                <a href="../payment?action=stats" class="card" style="padding: 15px 30px; text-decoration: none; color: inherit;">💰 View Revenue</a>
            </div>
        </div>
    </div>
</body>
</html>
