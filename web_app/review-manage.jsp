<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="com.foodhub.model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User admin = (User) session.getAttribute("user");
    if (admin == null || !"ADMIN".equals(admin.getRole())) { response.sendRedirect("login.jsp"); return; }
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Review Moderation — FoodHub Admin</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .admin-layout { display: grid; grid-template-columns: 280px 1fr; min-height: 100vh; }
        .sidebar { background: var(--ink); color: #fff; padding: 60px 24px; position: sticky; top: 0; height: 100vh; }
        .sidebar-link { display: flex; align-items: center; gap: 16px; padding: 14px 20px; border-radius: 12px; color: var(--ink-3); text-decoration: none; margin-bottom: 8px; transition: all 0.2s; font-weight: 600; font-size: 14px; }
        .sidebar-link:hover, .sidebar-link.active { background: rgba(255,255,255,0.08); color: #fff; }
        .sidebar-link.active { color: var(--brand); }
        .main-content { padding: 80px 7vw; background: var(--surface); }
        
        .review-row:hover { background: var(--surface); }
        .rating-stars { color: #facc15; font-size: 14px; }
    </style>
</head>
<body>
    <div class="admin-layout">
        <aside class="sidebar">
            <a href="index.jsp" class="display-font" style="font-size: 24px; color: var(--brand); text-decoration: none; margin-bottom: 60px; display: block; font-weight: 900;">FoodHub</a>
            <nav>
                <a href="admin-dashboard.jsp" class="sidebar-link">📊 Control Tower</a>
                <a href="restaurant?action=list" class="sidebar-link">🍴 Kitchen Network</a>
                <a href="user?action=list" class="sidebar-link">👥 Citizen Directory</a>
                <a href="order?action=history" class="sidebar-link">📦 Logistics Flow</a>
                <a href="review?action=list" class="sidebar-link active">⭐ Reviews</a>
                <a href="payment?action=stats" class="sidebar-link">💰 Treasury</a>
            </nav>
        </aside>

        <main class="main-content">
            <header style="margin-bottom: 60px;">
                <h1 class="display-font" style="font-size: 42px;">Review <em>Moderation</em></h1>
                <p class="text-muted">Manage community feedback and maintain platform quality.</p>
            </header>

            <div class="card animate-fadeUp">
                <table>
                    <thead>
                        <tr>
                            <th>Citizen</th>
                            <th>Rating</th>
                            <th>Comment</th>
                            <th>Timestamp</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody>
                        <% if (reviews != null && !reviews.isEmpty()) {
                            for (Review r : reviews) { %>
                            <tr class="review-row">
                                <td>
                                    <div style="font-weight: 700;"><%= r.getUserName() %></div>
                                    <div style="font-size: 11px; color: var(--ink-3);">ID: #<%= r.getUserId() %></div>
                                </td>
                                <td>
                                    <div class="rating-stars">
                                        <% for(int i=0; i<r.getRating(); i++) { %>★<% } %>
                                    </div>
                                </td>
                                <td style="max-width: 400px; font-size: 14px; line-height: 1.4;">
                                    "<%= r.getComment() %>"
                                </td>
                                <td class="text-muted" style="font-size: 12px;">
                                    <%= sdf.format(r.getReviewDate()) %>
                                </td>
                                <td>
                                    <form action="review" method="POST" onsubmit="return confirm('Permanently delete this review?')">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= r.getId() %>">
                                        <button type="submit" class="btn btn-ghost btn-sm" style="color: #ef4444; border-color: #fee2e2;">Delete</button>
                                    </form>
                                </td>
                            </tr>
                        <% } } else { %>
                            <tr>
                                <td colspan="5" style="text-align: center; padding: 60px;">No reviews found in the system.</td>
                            </tr>
                        <% } %>
                    </tbody>
                </table>
            </div>
        </main>
    </div>
</body>
</html>
