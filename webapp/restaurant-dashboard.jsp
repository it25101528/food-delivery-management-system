<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="com.foodhub.model.Restaurant" %>
<%@ page import="com.foodhub.dao.RestaurantDAO" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"RESTAURANT".equals(user.getRole())) { response.sendRedirect("restaurant-login.jsp"); return; }
    RestaurantDAO rdao = new RestaurantDAO();
    Restaurant r = rdao.getRestaurantByOwner(user.getUserId());
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kitchen Hub — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .hub-grid { display: grid; grid-template-columns: repeat(3, 1fr); gap: 32px; margin-top: 60px; }
        .action-card { background: #fff; padding: 48px 32px; border-radius: var(--radius-lg); text-align: center; border: 1.5px solid var(--border); transition: all 0.2s; text-decoration: none; color: inherit; }
        .action-card:hover { transform: translateY(-12px); border-color: var(--brand); box-shadow: var(--shadow); }
        .action-icon { width: 96px; height: 96px; background: var(--surface); border-radius: 24px; display: flex; align-items: center; justify-content: center; font-size: 42px; margin: 0 auto 24px; transition: all 0.2s; }
        .action-card:hover .action-icon { background: var(--brand-light); }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding-top: 80px; padding-bottom: 120px;">
        <header class="animate-fadeIn" style="display: flex; justify-content: space-between; align-items: flex-end;">
            <div>
                <h1 style="font-size: 48px;">Kitchen <em>Hub</em></h1>
                <p class="text-muted">Welcome back, Chef <%= user.getName().split(" ")[0] %></p>
            </div>
            <% if (r != null) { %>
                <div class="badge badge-green" style="padding: 12px 24px; font-size: 14px;">Kitchen Status: ACTIVE</div>
            <% } %>
        </header>

        <% if (r == null) { %>
            <div class="card animate-fadeUp" style="margin-top: 60px; text-align: center; padding: 100px 60px; background: var(--brand-light); border: 2px dashed var(--brand);">
                <div style="font-size: 80px; margin-bottom: 32px;">🍳</div>
                <h2 class="display-font" style="font-size: 32px;">Register Your Craft</h2>
                <p class="text-muted" style="max-width: 500px; margin: 16px auto 40px; font-size: 17px;">Join our artisan network to share your culinary vision with the world.</p>
                <a href="restaurant-add.jsp" class="btn btn-primary btn-lg">Start Onboarding →</a>
            </div>
        <% } else { %>
            <div class="hub-grid stagger">
                <a href="restaurant?action=menu&id=<%= r.getId() %>" class="action-card animate-fadeUp">
                    <div class="action-icon">🍴</div>
                    <h3 class="display-font" style="font-size: 22px;">Curate Menu</h3>
                    <p class="text-muted" style="margin-top: 12px; font-size: 14px;">Refine your signature dishes and seasonal offerings.</p>
                </a>
                <a href="order?action=history" class="action-card animate-fadeUp">
                    <div class="action-icon">📦</div>
                    <h3 class="display-font" style="font-size: 22px;">Logistics</h3>
                    <p class="text-muted" style="margin-top: 12px; font-size: 14px;">Manage active culinary requests and dispatch flow.</p>
                </a>
                <a href="payment?action=stats&id=<%= r.getId() %>" class="action-card animate-fadeUp">
                    <div class="action-icon">💰</div>
                    <h3 class="display-font" style="font-size: 22px;">Financials</h3>
                    <p class="text-muted" style="margin-top: 12px; font-size: 14px;">Review your kitchen's earnings and performance metrics.</p>
                </a>
            </div>

            <div class="card animate-fadeUp" style="margin-top: 60px; padding: 48px;">
                <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 40px;">
                    <h3 class="display-font" style="font-size: 28px;">Weekly <em>Performance</em></h3>
                    <span class="text-muted" style="font-weight: 700; font-size: 13px;">7 DAY SNAPSHOT</span>
                </div>
                <div style="display: grid; grid-template-columns: repeat(4, 1fr); gap: 32px;">
                    <div style="text-align: center; padding: 32px; background: var(--surface); border-radius: var(--radius-md);">
                        <div style="font-size: 32px; font-family: var(--font-display); font-weight: 900;">128</div>
                        <div class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; margin-top: 8px;">Completed Requests</div>
                    </div>
                    <div style="text-align: center; padding: 32px; background: var(--surface); border-radius: var(--radius-md);">
                        <div style="font-size: 32px; font-family: var(--font-display); font-weight: 900;">4.9 ★</div>
                        <div class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; margin-top: 8px;">Customer Sentiment</div>
                    </div>
                    <div style="text-align: center; padding: 32px; background: var(--surface); border-radius: var(--radius-md);">
                        <div style="font-size: 32px; font-family: var(--font-display); font-weight: 900;">$2.4k</div>
                        <div class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; margin-top: 8px;">Net Revenue</div>
                    </div>
                    <div style="text-align: center; padding: 32px; background: var(--surface); border-radius: var(--radius-md);">
                        <div style="font-size: 32px; font-family: var(--font-display); font-weight: 900;">18m</div>
                        <div class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em; margin-top: 8px;">Average Craft Time</div>
                    </div>
                </div>
            </div>
        <% } %>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
