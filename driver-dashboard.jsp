<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="com.foodhub.model.Order" %>
<%@ page import="com.foodhub.dao.OrderDAO" %>
<%@ page import="com.foodhub.dao.DeliveryAgentDAO" %>
<%@ page import="com.foodhub.model.DeliveryAgent" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DRIVER".equals(user.getRole())) { response.sendRedirect("driver-login.jsp"); return; }
    OrderDAO odao = new OrderDAO();
    List<Order> assignedOrders = odao.getAssignedOrders(user.getUserId());
    DeliveryAgentDAO adao = new DeliveryAgentDAO();
    DeliveryAgent agent = adao.getAgentByUserId(user.getUserId());
    SimpleDateFormat sdf = new SimpleDateFormat("HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier App — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .courier-card { background: #fff; border-radius: var(--radius-lg); padding: 32px; border: 1.5px solid var(--border); box-shadow: var(--shadow); margin-bottom: 32px; transition: all 0.2s; }
        .courier-card:hover { border-color: var(--brand); transform: translateY(-4px); }
        .logistics-info { background: var(--surface); border-radius: var(--radius-md); padding: 24px; margin-bottom: 32px; display: flex; flex-direction: column; gap: 20px; }
        .logistics-step { display: flex; gap: 16px; align-items: flex-start; }
        .logistics-icon { width: 32px; height: 32px; border-radius: 50%; background: #fff; border: 2px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: 14px; flex-shrink: 0; }
        .action-group { display: flex; gap: 16px; }
    </style>
</head>
<body style="background: var(--surface);">
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding-top: 60px; padding-bottom: 120px; max-width: 850px;">
        <header class="animate-fadeIn" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 48px;">
            <div>
                <h1 style="font-size: 42px;">Courier <em>Flow</em></h1>
                <p class="text-muted">Master Courier: <%= user.getName() %> | Vehicle: <%= (agent != null) ? agent.getVehicleNumber() : "N/A" %></p>
            </div>
            <div style="display: flex; align-items: center; gap: 12px; background: #fff; padding: 10px 20px; border-radius: 100px; border: 1px solid var(--border);">
                <span style="width: 10px; height: 10px; background: #06c167; border-radius: 50%; display: block;"></span>
                <span style="font-weight: 700; font-size: 14px;">AVAILABLE FOR DISPATCH</span>
            </div>
        </header>

        <h2 class="display-font" style="font-size: 28px; margin-bottom: 32px;">Active Assignments</h2>

        <div class="stagger">
            <% if (assignedOrders != null && !assignedOrders.isEmpty()) {
                for (Order o : assignedOrders) { %>
                <div class="courier-card animate-fadeUp">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 32px;">
                        <div>
                            <h4 style="font-size: 20px; font-weight: 800;">Logistics Order #<%= o.getOrderId() %></h4>
                            <p class="text-muted" style="font-size: 13px;">Dispatched at <%= sdf.format(o.getOrderDate()) %></p>
                        </div>
                        <div style="text-align: right;">
                            <div style="font-family: var(--font-display); font-weight: 900; font-size: 22px; color: var(--brand);">$<%= String.format("%.2f", o.getTotalPrice()) %></div>
                            <span class="badge badge-ember" style="margin-top: 8px;"><%= o.getOrderStatus() %></span>
                        </div>
                    </div>
                    
                    <div class="logistics-info">
                        <div class="logistics-step">
                            <div class="logistics-icon" style="border-color: var(--brand); color: var(--brand);">🍳</div>
                            <div>
                                <label class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em;">Pickup Kitchen</label>
                                <div style="font-weight: 700; font-size: 16px; margin-top: 4px;">Artisan Partner #<%= o.getRestaurantId() %></div>
                            </div>
                        </div>
                        <div class="logistics-step">
                            <div class="logistics-icon">📍</div>
                            <div>
                                <label class="text-muted" style="font-size: 11px; font-weight: 800; text-transform: uppercase; letter-spacing: 0.1em;">Citizen Drop-off</label>
                                <div style="font-weight: 700; font-size: 16px; margin-top: 4px;">Recipient Address Placeholder</div>
                            </div>
                        </div>
                    </div>

                    <div class="action-group">
                        <% if ("ASSIGNED".equals(o.getOrderStatus())) { %>
                            <form action="order" method="POST" style="flex: 1;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="id" value="<%= o.getOrderId() %>">
                                <input type="hidden" name="status" value="OUT_FOR_DELIVERY">
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 18px;">Pick Up from Kitchen →</button>
                            </form>
                        <% } else if ("OUT_FOR_DELIVERY".equals(o.getOrderStatus())) { %>
                            <form action="order" method="POST" style="flex: 1;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="id" value="<%= o.getOrderId() %>">
                                <input type="hidden" name="status" value="DELIVERED">
                                <button type="submit" class="btn btn-primary" style="width: 100%; background: var(--ink); padding: 18px;">Confirm Delivery ✓</button>
                            </form>
                        <% } %>
                        <button class="btn btn-ghost" style="padding: 18px; width: 120px;">Open Map</button>
                    </div>
                </div>
            <% } } else { %>
                <div class="card" style="text-align: center; padding: 100px 40px; border: 2px dashed var(--border);">
                    <div style="font-size: 80px; margin-bottom: 32px;">🛵</div>
                    <h3 class="display-font" style="font-size: 24px;">All Dispatch Completed</h3>
                    <p class="text-muted" style="max-width: 400px; margin: 0 auto;">Our logistics network is clear. Please remain on standby for new artisan deliveries.</p>
                </div>
            <% } %>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
