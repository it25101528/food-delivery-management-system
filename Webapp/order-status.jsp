<%@ page import="com.foodhub.model.Order" %>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="com.foodhub.model.DeliveryAgent" %>
<%@ page import="com.foodhub.dao.DeliveryAgentDAO" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User sessionUser = (User) session.getAttribute("user");
    Order o = (Order) request.getAttribute("order");
    if (o == null) {
        response.sendRedirect("index.jsp");
        return;
    }
    DeliveryAgentDAO agentDAO = new DeliveryAgentDAO();
    List<DeliveryAgent> agents = agentDAO.getAllAgents();
%>
<!DOCTYPE html>
<html>
<head>
    <title>Order Status - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
    <style>
        .status-tracker { display: flex; justify-content: space-between; margin-top: 40px; position: relative; }
        .status-tracker::before { content: ''; position: absolute; top: 15px; left: 0; right: 0; height: 4px; background: #eee; z-index: 1; }
        .step { position: relative; z-index: 2; text-align: center; width: 100px; }
        .step .circle { width: 34px; height: 34px; background: #eee; border-radius: 50%; margin: 0 auto 10px; display: flex; align-items: center; justify-content: center; font-weight: bold; border: 4px solid white; }
        .step.active .circle { background: #06c167; color: white; }
        .step.active p { color: #06c167; font-weight: 700; }
        .step p { font-size: 13px; color: #6b7280; }
    </style>
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container" style="max-width: 800px;">
        <div class="card" style="padding: 40px; text-align: center;">
            <div style="font-size: 60px; margin-bottom: 20px;">🎉</div>
            <h1 style="margin-bottom: 10px;">Order Summary</h1>
            <p style="color: #6b7280;">Order ID: <strong>#<%= o.getOrderId() %></strong></p>
            <p style="color: #6b7280;">Total Paid: <strong>$<%= o.getTotalPrice() %></strong></p>

            <div class="status-tracker">
                <div class="step <%= "PENDING".equals(o.getOrderStatus()) || "PREPARING".equals(o.getOrderStatus()) || "OUT_FOR_DELIVERY".equals(o.getOrderStatus()) || "DELIVERED".equals(o.getOrderStatus()) ? "active" : "" %>">
                    <div class="circle">1</div>
                    <p>Pending</p>
                </div>
                <div class="step <%= "PREPARING".equals(o.getOrderStatus()) || "OUT_FOR_DELIVERY".equals(o.getOrderStatus()) || "DELIVERED".equals(o.getOrderStatus()) ? "active" : "" %>">
                    <div class="circle">2</div>
                    <p>Preparing</p>
                </div>
                <div class="step <%= "OUT_FOR_DELIVERY".equals(o.getOrderStatus()) || "DELIVERED".equals(o.getOrderStatus()) ? "active" : "" %>">
                    <div class="circle">3</div>
                    <p>On the Way</p>
                </div>
                <div class="step <%= "DELIVERED".equals(o.getOrderStatus()) ? "active" : "" %>">
                    <div class="circle">4</div>
                    <p>Delivered</p>
                </div>
            </div>

            <% if (sessionUser != null && ("ADMIN".equals(sessionUser.getRole()) || "RESTAURANT".equals(sessionUser.getRole()))) { %>
                <!-- Status Update -->
                <div style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 20px; background: #f9fafb; padding: 20px; border-radius: 12px;">
                    <h4 style="margin-bottom: 15px;"><%= "ADMIN".equals(sessionUser.getRole()) ? "Admin" : "Partner" %>: Update Order Status</h4>
                    <form action="../order" method="POST" style="display: flex; gap: 10px; justify-content: center;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="<%= o.getOrderId() %>">
                        <select name="status" class="form-control" style="width: 200px;">
                            <option value="PENDING" <%= "PENDING".equals(o.getOrderStatus()) ? "selected" : "" %>>Pending</option>
                            <option value="PREPARING" <%= "PREPARING".equals(o.getOrderStatus()) ? "selected" : "" %>>Preparing</option>
                            <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equals(o.getOrderStatus()) ? "selected" : "" %>>Out for Delivery</option>
                            <option value="DELIVERED" <%= "DELIVERED".equals(o.getOrderStatus()) ? "selected" : "" %>>Delivered</option>
                            <option value="CANCELLED" <%= "CANCELLED".equals(o.getOrderStatus()) ? "selected" : "" %>>Cancelled</option>
                        </select>
                        <button type="submit" class="btn btn-primary">Update Status</button>
                    </form>
                </div>
            <% } %>

            <% if (sessionUser != null && "ADMIN".equals(sessionUser.getRole())) { %>
                <!-- Driver Assignment -->
                <div style="margin-top: 20px; background: #eff6ff; padding: 20px; border-radius: 12px; border: 1px solid #bfdbfe;">
                    <h4 style="margin-bottom: 15px; color: #1e40af;">Admin: Assign Delivery Agent</h4>
                    <form action="../delivery" method="POST" style="display: flex; gap: 10px; justify-content: center;">
                        <input type="hidden" name="action" value="assign">
                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                        <select name="agentId" class="form-control" style="width: 250px;">
                            <option value="">-- Select Available Agent --</option>
                            <% for (DeliveryAgent agent : agents) { if(agent.isAvailability()) { %>
                                <option value="<%= agent.getAgentId() %>"><%= agent.getName() %> (<%= agent.getVehicleType() %>)</option>
                            <% }} %>
                        </select>
                        <button type="submit" class="btn btn-primary" style="background: #2563eb;">Assign Driver</button>
                    </form>
                </div>
            <% } %>

            <% if ("DELIVERED".equals(o.getOrderStatus())) { %>
                <div style="margin-top: 40px; border-top: 1px solid #eee; padding-top: 30px;">
                    <h3>Rate your experience</h3>
                    <form action="../review" method="POST" style="margin-top: 20px;">
                        <input type="hidden" name="action" value="add">
                        <input type="hidden" name="restaurantId" value="<%= o.getRestaurantId() %>">
                        <div class="form-group">
                            <label>Rating</label>
                            <select name="rating" class="form-control" style="width: 150px;">
                                <option value="5">⭐⭐⭐⭐⭐ (Excellent)</option>
                                <option value="4">⭐⭐⭐⭐ (Good)</option>
                                <option value="3">⭐⭐⭐ (Average)</option>
                                <option value="2">⭐⭐ (Poor)</option>
                                <option value="1">⭐ (Very Bad)</option>
                            </select>
                        </div>
                        <div class="form-group">
                            <label>Your Comment</label>
                            <textarea name="comment" class="form-control" placeholder="Tell us how the food was..." required></textarea>
                        </div>
                        <button type="submit" class="btn btn-primary" style="width: 100%;">Submit Review</button>
                    </form>
                </div>
            <% } %>

            <div style="margin-top: 50px; border-top: 1px solid #eee; padding-top: 30px; display: flex; justify-content: center; gap: 15px;">
                <a href="../restaurant?action=list" class="btn btn-secondary">Order More</a>
                <a href="../order?action=history" class="btn btn-primary">View History</a>
            </div>
        </div>
    </div>

    <script src="../js/cart.js"></script>
    <script>
        // Clear cart if this is a fresh order redirect
        const urlParams = new URLSearchParams(window.location.search);
        if (urlParams.get('clearCart') === 'true') {
            clearCart();
            // Clean up the URL to prevent re-clearing on refresh (optional but cleaner)
            const newUrl = window.location.pathname + window.location.search.replace(/[?&]clearCart=true/, '');
            window.history.replaceState({}, document.title, newUrl);
        }
    </script>
</body>
</html>
