<%@ page import="com.foodhub.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>My Profile — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding: 80px 7vw 120px;">
        <div class="card animate-fadeUp" style="max-width: 900px; margin: 0 auto; padding: 0; overflow: hidden; border-radius: var(--radius-lg);">
            <div style="background: var(--ink); padding: 40px; color: #fff; display: flex; align-items: center; gap: 40px; position: relative; overflow: hidden;">
                <div style="position: absolute; inset: 0; background: radial-gradient(circle at 100% 0%, var(--brand) 0%, transparent 60%); opacity: 0.3;"></div>
                <div style="position: relative; z-index: 2; width: 120px; height: 120px; background: rgba(255,255,255,0.1); border: 4px solid rgba(255,255,255,0.2); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 48px; font-family: var(--font-display); font-weight: 900;">
                    <%= u.getName().substring(0,1).toUpperCase() %>
                </div>
                <div style="position: relative; z-index: 2;">
                    <span class="badge badge-ember" style="margin-bottom: 12px; background: var(--brand); color: #fff;"><%= u.getRole() %></span>
                    <h1 class="display-font" style="font-size: 42px; margin-bottom: 8px;"><%= u.getName() %></h1>
                    <p style="color: var(--ink-3); font-size: 16px;"><%= u.getEmail() %></p>
                </div>
            </div>
            
            <div style="padding: 40px;">
                <h3 class="display-font" style="font-size: 24px; margin-bottom: 32px;">Account Information</h3>
                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 40px;">
                    <div>
                        <label class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; display: block; margin-bottom: 8px;">Legal Name</label>
                        <p style="font-size: 18px; font-weight: 600;"><%= u.getName() %></p>
                    </div>
                    <div>
                        <label class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; display: block; margin-bottom: 8px;">Contact Number</label>
                        <p style="font-size: 18px; font-weight: 600;"><%= u.getPhoneNumber() %></p>
                    </div>
                    <div style="grid-column: 1/-1;">
                        <label class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; display: block; margin-bottom: 8px;">Saved Address</label>
                        <p style="font-size: 18px; font-weight: 600;"><%= u.getAddress() %></p>
                    </div>
                </div>
                
                <div style="margin-top: 60px; border-top: 2px solid var(--surface); padding-top: 40px; display: flex; gap: 20px;">
                    <a href="profile-edit.jsp" class="btn btn-primary">Edit Account</a>
                    <a href="user?action=logout" class="btn btn-ghost">Log Out</a>
                    
                    <div style="margin-left: auto; display: flex; gap: 12px;">
                        <% if ("ADMIN".equals(u.getRole())) { %>
                            <a href="admin-dashboard.jsp" class="btn btn-secondary">Platform Control</a>
                        <% } else if ("RESTAURANT".equals(u.getRole())) { %>
                            <a href="restaurant-dashboard.jsp" class="btn btn-secondary">Kitchen Hub</a>
                        <% } else if ("DRIVER".equals(u.getRole())) { %>
                            <a href="driver-dashboard.jsp" class="btn btn-secondary">Courier Dashboard</a>
                        <% } %>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
