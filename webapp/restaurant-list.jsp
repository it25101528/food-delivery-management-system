<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.Restaurant" %>
<%@ page import="java.util.List" %>
<%
    List<Restaurant> restaurants = (List<Restaurant>) request.getAttribute("restaurants");
    String activeQuery = (String) request.getAttribute("activeQuery");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Restaurants — FoodHub</title>
    <link rel="stylesheet" href="css/style.css?v=1.1">
    <style>
        .filter-tag { display: inline-flex; align-items: center; gap: 8px; background: var(--brand-light); color: var(--brand-dark); padding: 6px 16px; border-radius: 100px; font-size: 13px; font-weight: 700; margin-bottom: 20px; border: 1px solid rgba(232, 64, 12, 0.1); }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <section class="container" style="padding-top: 60px;">
        <header class="section-header animate-fadeIn" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 40px;">
            <div>
                <% if (activeQuery != null && !activeQuery.isEmpty()) { %>
                    <div class="filter-tag">🔍 Filtering by: <%= activeQuery %></div>
                <% } %>
                <h1 style="font-size: 42px;">The <em>Art</em> of Kitchens</h1>
                <p class="text-muted">Discover the finest local flavours near you</p>
            </div>
            <div style="max-width: 360px; flex: 1;">
                <input type="text" id="searchInput" class="form-control" placeholder="Search by name or cuisine..." onkeyup="filterRestaurants()" value="<%= activeQuery != null ? activeQuery : "" %>">
            </div>
        </header>

        <div class="restaurant-grid" style="display: grid; grid-template-columns: repeat(auto-fill, minmax(320px, 1fr)); gap: 32px; margin-bottom: 80px;">
            <% if (restaurants != null && !restaurants.isEmpty()) {
                for (Restaurant r : restaurants) { %>
                <a href="restaurant?action=menu&id=<%= r.getId() %>" class="card restaurant-card animate-fadeUp" style="padding: 0; overflow: hidden; text-decoration: none; color: inherit;">
                    <div style="position: relative;">
                        <img src="https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=600&q=80" alt="<%= r.getName() %>" style="width: 100%; height: 240px; object-fit: cover;">
                        <span class="badge badge-green" style="position: absolute; top: 16px; right: 16px; background: #fff; box-shadow: var(--shadow);"><%= r.getRating() > 0 ? r.getRating() : 4.5 %> ★</span>
                    </div>
                    <div style="padding: 24px;">
                        <h3 style="font-size: 24px; margin-bottom: 6px;"><%= r.getName() %></h3>
                        <p class="text-muted" style="font-size: 14px; margin-bottom: 18px;"><%= r.getCuisine() %> • <%= r.getLocation() %></p>
                        <div style="display: flex; justify-content: space-between; align-items: center; border-top: 1px solid var(--border); padding-top: 16px;">
                            <span style="font-size: 13px; font-weight: 600; color: var(--ink-2);">🛵 25-30 min</span>
                            <span class="badge badge-ember">Free Delivery</span>
                        </div>
                    </div>
                </a>
            <% } } else { %>
                <div style="grid-column: 1/-1; text-align: center; padding: 100px 0;">
                    <div style="font-size: 64px; margin-bottom: 20px;">🏜️</div>
                    <h2 class="display-font">No kitchens found.</h2>
                    <p class="text-muted">Try searching for something else or explore all categories.</p>
                    <a href="restaurant?action=list" class="btn btn-primary" style="margin-top: 24px;">Browse All</a>
                </div>
            <% } %>
        </div>
    </section>

    <jsp:include page="jsp/footer.jsp" />

    <script>
        function filterRestaurants() {
            let filter = document.getElementById('searchInput').value.toLowerCase();
            let cards = document.getElementsByClassName('restaurant-card');
            for (let card of cards) {
                let name = card.getElementsByTagName('h3')[0].innerText.toLowerCase();
                let cuisine = card.getElementsByTagName('p')[0].innerText.toLowerCase();
                if (name.includes(filter) || cuisine.includes(filter)) {
                    card.style.display = "";
                } else {
                    card.style.display = "none";
                }
            }
        }
    </script>
</body>
</html>
