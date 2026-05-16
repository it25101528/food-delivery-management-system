<%@ page import="com.foodhub.model.Order" %>
<%@ page import="com.foodhub.model.OrderItem" %>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User sessionUser = (User) session.getAttribute("user");
    if (sessionUser == null) { response.sendRedirect("login.jsp"); return; }
    List<Order> orders = (List<Order>) request.getAttribute("orders");
    List<User> drivers = (List<User>) request.getAttribute("drivers");
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Order History — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        :root {
            --brand: #E8400C;
            --brand-light: #FFF0EB;
            --ink: #1A1410;
            --ink-2: #5C4E46;
            --ink-3: #9E8F88;
            --surface: #FDFAF8;
            --border: #EDE5DF;
            --radius-lg: 28px;
            --font-display: 'Playfair Display', serif;
            --font-body: 'DM Sans', sans-serif;
        }

        body { background: #fff; font-family: var(--font-body); }

        .history-container { max-width: 1100px; margin: 80px auto; padding: 0 20px; }
        
        .history-header { margin-bottom: 60px; }
        .history-header h1 { font-family: var(--font-display); font-size: 56px; font-weight: 900; color: #111; letter-spacing: -0.02em; }
        .history-header h1 em { color: var(--brand); font-style: italic; }
        .history-header p { color: #aaa; font-size: 18px; margin-top: 8px; }

        .order-card { 
            background: #fff; 
            border: 1px solid #f0f0f0; 
            border-radius: var(--radius-lg); 
            padding: 32px 48px; 
            margin-bottom: 24px; 
            display: flex; 
            justify-content: space-between; 
            align-items: center; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); 
            text-decoration: none; 
            color: inherit;
            position: relative;
            box-shadow: 0 4px 20px rgba(0,0,0,0.02);
        }
        .order-card:hover { transform: translateY(-4px); box-shadow: 0 20px 40px rgba(0,0,0,0.05); border-color: #eee; }

        .order-main { display: flex; align-items: center; gap: 32px; }
        .order-icon { 
            width: 80px; 
            height: 80px; 
            background: #fafafa; 
            border-radius: 16px; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 32px;
        }

        .order-info h3 { font-size: 22px; font-weight: 800; margin-bottom: 6px; color: #111; }
        .order-info .date { color: #bbb; font-size: 14px; margin-bottom: 12px; font-weight: 500; }
        .order-info .items { color: #888; font-size: 16px; margin-bottom: 16px; font-weight: 500; }

        .mini-progress { height: 3px; background: #f0f0f0; border-radius: 10px; width: 180px; position: relative; overflow: hidden; }
        .mini-progress-fill { position: absolute; height: 100%; background: var(--brand); border-radius: 10px; }

        .order-meta { text-align: right; }
        .order-price { font-family: var(--font-display); font-size: 28px; font-weight: 900; color: #111; margin-bottom: 12px; }
        
        .status-badge { 
            display: inline-block; 
            padding: 8px 20px; 
            border-radius: 100px; 
            font-size: 12px; 
            font-weight: 800; 
            text-transform: uppercase; 
            letter-spacing: 0.05em; 
        }
        .status-pending { background: #fef9c3; color: #a16207; }
        .status-delivered { background: #f0fdf4; color: #15803d; }
        .status-default { background: #f5f5f5; color: #666; }

        .modal { display: none; position: fixed; inset: 0; background: rgba(0,0,0,0.4); backdrop-filter: blur(10px); z-index: 2000; align-items: center; justify-content: center; }
        .modal-content { background: #fff; border-radius: var(--radius-lg); padding: 48px; width: 100%; max-width: 500px; }
        .rating-input label.active { color: #facc15 !important; }

        .animate-fadeUp { animation: fadeUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) both; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(30px); } to { opacity: 1; transform: none; } }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="history-container">
        <header class="history-header animate-fadeUp">
            <h1>Your <em>Past</em> Feasts</h1>
            <p>Relive your culinary adventures</p>
        </header>

        <div class="orders-list">
            <% if (orders != null && !orders.isEmpty()) {
                int i = 0;
                for (Order o : orders) { 
                    i++;
                    String status = o.getOrderStatus() != null ? o.getOrderStatus() : "PENDING";
            %>
                <div class="animate-fadeUp" style="animation-delay: <%= 0.05 * i %>s">
                    <div class="order-card">
                        <a href="order?action=status&id=<%= o.getOrderId() %>" style="position: absolute; inset: 0; z-index: 1;"></a>
                        
                        <div class="order-main">
                            <div class="order-icon">🥡</div>
                            <div class="order-info">
                                <h3>Order #<%= o.getOrderId() %></h3>
                                <div class="date"><%= sdf.format(o.getOrderDate()) %></div>
                                <div class="items">
                                    <% if (o.getItems() != null && !o.getItems().isEmpty()) {
                                        for (int j = 0; j < Math.min(3, o.getItems().size()); j++) {
                                            OrderItem oi = o.getItems().get(j);
                                    %>
                                        <%= oi.getQuantity() %>x <%= oi.getItemName() %><%= (j < Math.min(3, o.getItems().size()) - 1) ? ", " : "" %>
                                    <% } if (o.getItems().size() > 3) { %> ... <% } } %>
                                </div>
                                
                                <%-- Mini Progress --%>
                                <% if (!"CANCELLED".equals(status)) { 
                                    int miniProgress = 20;
                                    if ("PREPARING".equals(status)) miniProgress = 40;
                                    else if ("READY_FOR_PICKUP".equals(status)) miniProgress = 60;
                                    else if ("ASSIGNED".equals(status) || "OUT_FOR_DELIVERY".equals(status)) miniProgress = 80;
                                    else if ("DELIVERED".equals(status)) miniProgress = 100;
                                %>
                                    <div class="mini-progress">
                                        <div class="mini-progress-fill" style="width: <%= miniProgress %>%"></div>
                                    </div>
                                <% } %>
                            </div>
                        </div>

                        <div class="order-meta" style="position: relative; z-index: 2;">
                            <div class="order-price">$<%= String.format("%.2f", o.getTotalPrice()) %></div>
                            
                            <span class="status-badge <%= "DELIVERED".equals(status) ? "status-delivered" : ("PENDING".equals(status) ? "status-pending" : "status-default") %>">
                                <%= status.replace("_", " ") %>
                            </span>

                            <% if ("DELIVERED".equals(status) && "CUSTOMER".equals(sessionUser.getRole())) { %>
                                <button onclick="openReviewModal(event, <%= o.getOrderId() %>, <%= o.getRestaurantId() %>)" 
                                        class="btn btn-ghost btn-sm" style="display: block; width: 100%; margin-top: 16px; padding: 10px; border-radius: 12px; font-weight: 700;">
                                    Rate Order
                                </button>
                            <% } %>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div style="text-align: center; padding: 100px 0;">
                    <div style="font-size: 80px; margin-bottom: 24px;">📜</div>
                    <h2 class="display-font">No history found</h2>
                    <p class="text-muted" style="margin-bottom: 32px;">Your first adventure awaits.</p>
                    <a href="restaurant?action=list" class="btn btn-primary" style="padding: 16px 32px; border-radius: 100px;">Start Browsing</a>
                </div>
            <% } %>
        </div>
    </div>

    <div id="reviewModal" class="modal">
        <div class="modal-content animate-fadeUp">
            <h2 class="display-font" style="font-size: 32px; margin-bottom: 12px;">How was your <em>Meal?</em></h2>
            <p class="text-muted" style="margin-bottom: 32px;">Your feedback helps the community discover the best flavors.</p>
            
            <form action="review" method="POST">
                <input type="hidden" name="action" value="add">
                <input type="hidden" name="restaurantId" id="modalRestaurantId">
                
                <div class="rating-input" id="ratingStars" style="display: flex; gap: 10px; margin-bottom: 32px;">
                    <% for(int i=1; i<=5; i++) { %>
                        <input type="radio" name="rating" id="star<%=i%>" value="<%=i%>" required style="display: none;">
                        <label for="star<%=i%>" onclick="setRating(<%=i%>)" style="font-size: 40px; cursor: pointer; color: #ddd; transition: color 0.2s;">★</label>
                    <% } %>
                </div>
                
                <div class="form-group" style="margin-bottom: 32px;">
                    <textarea name="comment" class="form-control" rows="4" placeholder="Tell us about the flavors, presentation, and delivery..." required style="width: 100%; padding: 16px; border-radius: 16px; border: 1.5px solid var(--border); font-family: inherit; outline: none;"></textarea>
                </div>
                
                <div style="display: flex; gap: 16px;">
                    <button type="button" class="btn btn-ghost" style="flex: 1; padding: 14px; border-radius: 12px;" onclick="closeReviewModal()">Cancel</button>
                    <button type="submit" class="btn btn-primary" style="flex: 1; padding: 14px; border-radius: 12px; background: var(--brand); color: #fff; font-weight: 700; border: none; cursor: pointer;">Submit Review</button>
                </div>
            </form>
        </div>
    </div>

    <script>
        function openReviewModal(event, orderId, restaurantId) {
            event.preventDefault();
            event.stopPropagation();
            document.getElementById('modalRestaurantId').value = restaurantId;
            document.getElementById('reviewModal').style.display = 'flex';
        }

        function closeReviewModal() {
            document.getElementById('reviewModal').style.display = 'none';
        }

        function setRating(rating) {
            const labels = document.querySelectorAll('.rating-input label');
            labels.forEach((label, index) => {
                if (index < rating) {
                    label.classList.add('active');
                } else {
                    label.classList.remove('active');
                }
            });
        }

        window.onclick = function(event) {
            if (event.target == document.getElementById('reviewModal')) {
                closeReviewModal();
            }
        }
    </script>
    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
