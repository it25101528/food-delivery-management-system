<%@ page import="com.foodhub.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>My Profile - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container" style="max-width: 600px;">
        <div class="card" style="padding: 40px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h2>User Profile</h2>
                <span style="background: #dcfce7; color: #166534; padding: 5px 12px; border-radius: 999px; font-weight: 600; font-size: 13px;">
                    <%= u.getUserType() %> MEMBER
                </span>
            </div>

            <form action="../user" method="POST">
                <input type="hidden" name="action" value="update">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" value="<%= u.getName() %>" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" class="form-control" value="<%= u.getEmail() %>" disabled>
                    <small>Email cannot be changed.</small>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" value="<%= u.getPhoneNumber() %>" required>
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <textarea name="address" class="form-control" rows="3" required><%= u.getAddress() %></textarea>
                </div>
                
                <div style="margin-top: 30px; display: flex; gap: 10px;">
                    <button type="submit" class="btn btn-primary">Update Profile</button>
                    <a href="../order?action=history" class="btn btn-secondary">Order History</a>
                </div>
            </form>

            <div style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px;">
                <p style="color: #991b1b; font-weight: 600;">Danger Zone</p>
                <a href="../user?action=delete&id=<%= u.getUserId() %>" class="btn btn-secondary" style="color: #ef4444; border-color: #fca5a5; margin-top: 10px; display: inline-block;" onclick="return confirm('Delete your account permanently?')">Delete Account</a>
            </div>
        </div>
    </div>
</body>
</html>
