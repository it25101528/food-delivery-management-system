<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%
    User sessionUser = (User) session.getAttribute("user");
%>
<style>
    /* ── NAVBAR ── */
    .navbar {
        position: sticky;
        top: 0;
        z-index: 1000;
        width: 100%;
        display: flex;
        align-items: center;
        justify-content: space-between;
        padding: 0 7vw;
        height: 72px;
        background: rgba(253, 250, 248, 0.92);
        backdrop-filter: blur(14px);
        -webkit-backdrop-filter: blur(14px);
        border-bottom: 1px solid #EDE5DF;
    }

    .navbar .logo {
        font-family: 'Playfair Display', 'DM Sans', Georgia, serif;
        font-size: 24px;
        font-weight: 900;
        color: #E8400C;
        text-decoration: none;
        letter-spacing: -0.01em;
        margin-right: 20px;
    }

    .location-selector {
        display: flex;
        align-items: center;
        gap: 8px;
        padding: 6px 14px;
        background: #fff;
        border: 1.5px solid var(--border, #EDE5DF);
        border-radius: 100px;
        font-size: 13px;
        font-weight: 600;
        color: #1A1410;
        cursor: pointer;
        transition: all 0.2s;
    }

    .location-selector:hover {
        border-color: #E8400C;
        background: #FFF0EB;
    }

    .location-selector select {
        border: none;
        background: transparent;
        font-family: inherit;
        font-size: inherit;
        font-weight: inherit;
        color: inherit;
        outline: none;
        cursor: pointer;
    }

    .nav-links {
        display: flex;
        align-items: center;
        gap: 32px;
        list-style: none;
    }

    .nav-links a {
        font-family: 'DM Sans', system-ui, sans-serif;
        text-decoration: none;
        font-size: 15px;
        font-weight: 500;
        color: #5C4E46;
        transition: color 0.2s;
    }

    .nav-links a:hover,
    .nav-links a.active { color: #E8400C; }

    .nav-buttons {
        display: flex;
        align-items: center;
        gap: 10px;
    }

    .nav-cart {
        display: flex;
        align-items: center;
        gap: 7px;
        font-family: 'DM Sans', system-ui, sans-serif;
        font-size: 15px;
        font-weight: 600;
        color: #1A1410;
        background: #F3EDE8;
        padding: 9px 18px;
        border-radius: 100px;
        text-decoration: none;
        transition: background 0.2s;
    }

    .nav-cart:hover { background: #EDE5DF; }

    .nav-cart-count {
        background: #E8400C;
        color: #fff;
        font-size: 11px;
        font-weight: 700;
        padding: 2px 7px;
        border-radius: 100px;
        min-width: 20px;
        text-align: center;
    }

    .nav-btn {
        font-family: 'DM Sans', system-ui, sans-serif;
        font-size: 14px;
        font-weight: 600;
        padding: 9px 20px;
        border-radius: 100px;
        border: none;
        cursor: pointer;
        text-decoration: none;
        transition: background 0.2s, color 0.2s, transform 0.15s;
        display: inline-flex;
        align-items: center;
    }

    .nav-btn-ghost {
        background: transparent;
        color: #5C4E46;
        border: 1.5px solid #EDE5DF;
    }

    .nav-btn-ghost:hover { background: #F3EDE8; color: #1A1410; }

    .nav-btn-solid {
        background: #E8400C;
        color: #fff;
    }

    .nav-btn-solid:hover { background: #B22F06; transform: scale(1.03); }

    .nav-user-chip {
        display: flex;
        align-items: center;
        gap: 8px;
        background: #F3EDE8;
        padding: 7px 16px 7px 8px;
        border-radius: 100px;
        font-size: 14px;
        font-weight: 600;
        color: #1A1410;
        text-decoration: none;
        transition: background 0.2s;
    }

    .nav-user-chip:hover { background: #EDE5DF; }

    .nav-avatar {
        width: 32px;
        height: 32px;
        background: #E8400C;
        color: #fff;
        border-radius: 50%;
        display: flex;
        align-items: center;
        justify-content: center;
        font-size: 13px;
        font-weight: 800;
    }

    @media (max-width: 768px) {
        .nav-links { display: none; }
        .navbar { padding: 0 5vw; }
    }
</style>

<header class="navbar">
    <div style="display: flex; align-items: center;">
        <a href="index.jsp" class="logo">FoodHub</a>
        
        <% if (sessionUser == null || (!"ADMIN".equals(sessionUser.getRole()) && !"RESTAURANT".equals(sessionUser.getRole()))) { %>
        <div class="location-selector">
            <span>📍</span>
            <select onchange="window.location.href='user?action=setLocation&location=' + this.value">
                <% 
                    String currentLoc = (String) session.getAttribute("userLocation");
                    if (currentLoc == null) currentLoc = "Colombo";
                    String[] cities = {"Colombo", "Kandy", "Galle", "Negombo", "Jaffna", "Matara"};
                    for(String city : cities) {
                %>
                    <option value="<%= city %>" <%= city.equals(currentLoc) ? "selected" : "" %>><%= city %></option>
                <% } %>
            </select>
        </div>
        <% } %>
    </div>

    <nav class="nav-links">
        <a href="index.jsp" class="active">Home</a>
        <a href="restaurant?action=list">Restaurants</a>
        <% if (sessionUser != null) { %>
            <% if ("RESTAURANT".equals(sessionUser.getRole())) { %>
                <a href="restaurant-dashboard.jsp">Kitchen Dashboard</a>
                <a href="payment?action=history">Payments</a>
            <% } else if ("ADMIN".equals(sessionUser.getRole())) { %>
                <a href="admin-dashboard.jsp">Admin Dashboard</a>
            <% } else if ("DRIVER".equals(sessionUser.getRole())) { %>
                <a href="driver-dashboard.jsp">Courier Flow</a>
            <% } else { %>
                <a href="order?action=history">My Orders</a>
                <a href="payment?action=history">Payment History</a>
            <% } %>
        <% } %>
    </nav>

    <div class="nav-buttons">
        <% if (sessionUser != null && !"RESTAURANT".equals(sessionUser.getRole()) && !"ADMIN".equals(sessionUser.getRole())) { %>
            <a href="cart.jsp" class="nav-cart">
                🛒 Cart
                <span class="nav-cart-count" id="nav-cart-count">0</span>
            </a>
        <% } %>

        <% if (sessionUser == null) { %>
            <a href="login.jsp" class="nav-btn nav-btn-ghost">Log in</a>
            <a href="register.jsp" class="nav-btn nav-btn-solid">Sign up</a>
        <% } else { %>
            <a href="profile.jsp" class="nav-user-chip">
                <div class="nav-avatar"><%= sessionUser.getName().substring(0,1).toUpperCase() %></div>
                <%= sessionUser.getName().split(" ")[0] %>
            </a>
            <a href="user?action=logout" class="nav-btn nav-btn-ghost">Logout</a>
        <% } %>
    </div>
</header>

<script>
    (function() {
        function updateNavCart() {
            try {
                const cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
                const count = cart.reduce(function(sum, item) { 
                    const qty = parseInt(item.quantity);
                    return sum + (isNaN(qty) ? 0 : qty); 
                }, 0);
                const el = document.getElementById('nav-cart-count');
                if (el) el.textContent = count;
            } catch(e) { console.warn("Cart sync failed", e); }
        }
        // Run immediately
        updateNavCart();
        // And on events
        document.addEventListener('DOMContentLoaded', updateNavCart);
        window.addEventListener('storage', updateNavCart);
        window.addEventListener('cartUpdated', updateNavCart);
    })();
</script>
