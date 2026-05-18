<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.MenuItem" %>
<%@ page import="com.foodhub.model.Restaurant" %>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="java.util.List" %>
<%
    Restaurant restaurant = (Restaurant) request.getAttribute("restaurant");
    User currentUser = (User) session.getAttribute("user");
    boolean isAuthorized = false;
    if (currentUser != null) {
        if ("ADMIN".equals(currentUser.getRole())) isAuthorized = true;
        else if ("RESTAURANT".equals(currentUser.getRole()) && restaurant != null && restaurant.getOwnerId() == currentUser.getUserId()) isAuthorized = true;
    }
    if (!isAuthorized) { response.sendRedirect("login.jsp?error=Unauthorized Access"); return; }
    int resId = (restaurant != null) ? restaurant.getId() : 0;
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Curate Menu — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .curate-layout { display: grid; grid-template-columns: 1fr 400px; gap: 48px; margin-top: 60px; align-items: start; }
        .dish-card { background: #fff; border-radius: var(--radius-md); padding: 24px; border: 1px solid var(--border); box-shadow: var(--shadow); margin-bottom: 24px; display: flex; align-items: center; gap: 24px; transition: all 0.2s; }
        .dish-card:hover { transform: translateX(8px); border-color: var(--brand); }
        .dish-icon { width: 64px; height: 64px; border-radius: 12px; background: var(--surface); display: flex; align-items: center; justify-content: center; font-size: 28px; }
        .sticky-form { position: sticky; top: 100px; }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding-top: 60px; padding-bottom: 120px;">
        <header class="animate-fadeIn" style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 48px;">
            <div>
                <h1 style="font-size: 42px;">Curate <em>Menu</em></h1>
                <p class="text-muted">Refining the culinary selection for <%= (restaurant != null) ? restaurant.getName() : "your kitchen" %></p>
            </div>
            <a href="<%= (currentUser != null && "ADMIN".equals(currentUser.getRole())) ? "restaurant?action=list" : "restaurant-dashboard.jsp" %>" 
               class="btn btn-ghost">← Back to Hub</a>
        </header>

        <div class="curate-layout">
            <main class="animate-fadeUp">
                <h2 class="display-font" style="font-size: 28px; margin-bottom: 32px;">Active Collection</h2>
                <% List<MenuItem> menu = (List<MenuItem>) request.getAttribute("menu"); %>
                <% if (menu != null && !menu.isEmpty()) { for (MenuItem item : menu) { %>
                    <div class="dish-card">
                        <div class="dish-icon">
                            <% 
                                String cat = item.getCategory();
                                String emoji = "🍽️";
                                if ("Burger".equals(cat)) emoji = "🍔";
                                else if ("Pizza".equals(cat)) emoji = "🍕";
                                else if ("Chicken".equals(cat)) emoji = "🍗";
                                else if ("Noodles".equals(cat)) emoji = "🍜";
                                else if ("Dessert".equals(cat)) emoji = "🍩";
                                else if ("Drinks".equals(cat)) emoji = "🥤";
                            %>
                            <%= emoji %>
                        </div>
                        <div style="flex: 1;">
                            <div style="display: flex; align-items: center; gap: 12px; margin-bottom: 4px;">
                                <h4 style="font-size: 19px; font-weight: 800;"><%= item.getName() %></h4>
                                <span class="badge" style="background: var(--surface); color: var(--ink-2); font-size: 10px;"><%= item.getCategory() %></span>
                            </div>
                            <div style="font-family: var(--font-display); font-weight: 900; font-size: 18px; color: var(--brand);">$<%= String.format("%.2f", item.getPrice()) %></div>
                        </div>
                        <div style="text-align: right;">
                            <form action="restaurant" method="POST" style="display: flex; align-items: center; gap: 12px;">
                                <input type="hidden" name="action" value="updatePrice">
                                <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                <input type="hidden" name="restaurantId" value="<%= resId %>">
                                <input type="number" step="0.01" name="price" value="<%= item.getPrice() %>" class="form-control" style="width: 100px; padding: 10px;">
                                <button type="submit" class="btn btn-primary btn-sm">Update</button>
                            </form>
                            <form action="restaurant" method="POST" onsubmit="return confirm('Delete this dish forever?');" style="display: inline-block; margin-top: 8px;">
                                <input type="hidden" name="action" value="deleteMenuItem">
                                <input type="hidden" name="itemId" value="<%= item.getId() %>">
                                <input type="hidden" name="restaurantId" value="<%= resId %>">
                                <button type="submit" class="btn btn-ghost btn-sm" style="color: #ef4444; border-color: rgba(239, 68, 68, 0.2); width: 100%;">🗑 Delete Dish</button>
                            </form>
                            <div style="margin-top: 10px; font-size: 11px; font-weight: 800; color: <%= item.isAvailability() ? "#06c167" : "#ef4444" %>; letter-spacing: 0.05em;">
                                <%= item.isAvailability() ? "● AVAILABLE" : "○ DEPLETED" %>
                            </div>
                        </div>
                    </div>
                <% } } else { %>
                    <div class="card" style="text-align: center; padding: 100px 40px; border: 2px dashed var(--border);">
                        <div style="font-size: 80px; margin-bottom: 32px;">👨‍🍳</div>
                        <h3 class="display-font" style="font-size: 24px;">Kitchen empty</h3>
                        <p class="text-muted">No signature dishes have been curated yet.</p>
                    </div>
                <% } %>
            </main>

            <aside class="sticky-form animate-fadeUp">
                <div class="card" style="padding: 40px;">
                    <h3 class="display-font" style="font-size: 24px; margin-bottom: 32px;">New Craft</h3>
                    <form action="restaurant" method="POST">
                        <input type="hidden" name="action" value="addMenuItem">
                        <input type="hidden" name="restaurantId" value="<%= resId %>">
                        <div class="form-group">
                            <label>Dish Identity</label>
                            <input type="text" name="name" class="form-control" placeholder="e.g. Signature Truffle Gnocchi" required>
                        </div>
                        <div class="form-group">
                            <label>Base Price ($)</label>
                            <input type="number" step="0.01" name="price" class="form-control" placeholder="0.00" required>
                        </div>
                        <div class="form-group">
                            <label>Classification</label>
                            <select name="category" class="form-control">
                                <option value="Burger">🍔 Burgers</option>
                                <option value="Pizza">🍕 Pizza</option>
                                <option value="Chicken">🍗 Chicken</option>
                                <option value="Noodles">🍜 Noodles</option>
                                <option value="Dessert">🍩 Desserts</option>
                                <option value="Drinks">🥤 Drinks</option>
                            </select>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 18px; margin-top: 16px;">Add to Menu →</button>
                    </form>
                </div>
            </aside>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
