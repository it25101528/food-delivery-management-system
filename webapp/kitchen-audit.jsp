<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.Restaurant" %>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="java.util.List" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) { response.sendRedirect("login.jsp"); return; }
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kitchen Audit — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { background: #fdfdfd; }
        .audit-header { background: #fff; padding: 60px 0; border-bottom: 1px solid var(--border); margin-bottom: 60px; }
        .audit-table { width: 100%; border-collapse: separate; border-spacing: 0; }
        .audit-table th { text-align: left; padding: 16px 24px; color: var(--ink-3); font-size: 11px; text-transform: uppercase; letter-spacing: 0.1em; font-weight: 800; border-bottom: 1px solid var(--border); }
        .audit-table td { padding: 20px 24px; border-bottom: 1px solid var(--surface); vertical-align: middle; }
        .audit-table tr:last-child td { border-bottom: none; }
        
        .delete-btn { color: #ef4444; background: none; border: none; font-weight: 700; cursor: pointer; padding: 8px 16px; border-radius: 8px; transition: all 0.2s; font-size: 13px; }
        .delete-btn:hover { background: #fee2e2; }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <header class="audit-header animate-fadeIn">
        <div class="container" style="display: flex; justify-content: space-between; align-items: center;">
            <div>
                <h1 class="display-font" style="font-size: 42px; margin-bottom: 8px;">Kitchen <em>Audit</em></h1>
                <p class="text-muted">Manage artisan network partners and locations</p>
            </div>
            <a href="admin-dashboard.jsp" class="btn btn-ghost" style="border-color: var(--border); color: var(--brand); font-weight: 800;">← Back to Dashboard</a>
        </div>
    </header>

    <div class="container" style="padding-bottom: 120px;">
        <div class="card animate-fadeUp" style="padding: 0; overflow: hidden;">
            <table class="audit-table">
                <thead>
                    <tr>
                        <th>ID</th>
                        <th>Kitchen Name</th>
                        <th>Location</th>
                        <th>Cuisine</th>
                        <th>Owner ID</th>
                        <th style="text-align: right;">Management</th>
                    </tr>
                </thead>
                <tbody>
                    <% if (restaurants != null && !restaurants.isEmpty()) { 
                        for (Restaurant r : restaurants) { %>
                        <tr>
                            <td style="font-weight: 800; color: var(--brand);">#<%= r.getId() %></td>
                            <td>
                                <div style="font-weight: 700;"><%= r.getName() %></div>
                                <div style="font-size: 12px; color: var(--ink-3);"><%= r.getRating() %> ★ Rating</div>
                            </td>
                            <td class="text-muted"><%= r.getLocation() %></td>
                            <td>
                                <span class="badge badge-ember">
                                    <%= r.getCuisine() %>
                                </span>
                            </td>
                            <td style="font-size: 13px; font-weight: 600;">Partner #<%= r.getOwnerId() %></td>
                            <td style="text-align: right; display: flex; gap: 12px; justify-content: flex-end; align-items: center;">
                                <a href="restaurant?action=menu&id=<%= r.getId() %>" class="btn btn-ghost btn-sm" style="border-color: var(--border); color: var(--ink); font-weight: 700; font-size: 13px;">🍽️ Manage Menu</a>
                                <button onclick="confirmDelete(<%= r.getId() %>, '<%= r.getName() %>')" class="delete-btn">Decommission Kitchen</button>
                            </td>
                        </tr>
                    <% } } else { %>
                        <tr>
                            <td colspan="6" style="text-align: center; padding: 100px 0;">
                                <div style="font-size: 48px; margin-bottom: 16px;">🍳</div>
                                <h3 class="display-font">No kitchens found</h3>
                                <p class="text-muted">The kitchen network is currently empty.</p>
                            </td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function confirmDelete(id, name) {
            if (confirm("Are you sure you want to decommission '" + name + "'?\nThis will remove all menu items and listings associated with this kitchen.")) {
                window.location.href = "restaurant?action=delete&id=" + id;
            }
        }
    </script>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
