<%@ page import="com.foodhub.model.Order" %>
<%@ page import="com.foodhub.model.OrderItem" %>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User sessionUser = (User) session.getAttribute("user");
    Order o = (Order) request.getAttribute("order");
    String status = o != null ? o.getOrderStatus() : "PENDING";
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Track Your Artisan Order — FoodHub</title>
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
        
        .status-header { background: #111; height: 160px; width: 100%; position: relative; }
        
        .stepper-container { max-width: 1000px; margin: -60px auto 80px; padding: 0 20px; position: relative; z-index: 10; }
        .stepper { display: flex; justify-content: space-between; position: relative; align-items: center; }
        
        /* Base line (incomplete) */
        .stepper-line { position: absolute; top: 32px; left: 5%; right: 5%; height: 2px; background: rgba(255,255,255,0.2); z-index: 1; }
        
        /* Progress line (completed) */
        .stepper-fill { position: absolute; top: 32px; left: 5%; height: 2px; background: #fff; z-index: 2; transition: width 1s cubic-bezier(0.4, 0, 0.2, 1); }
        
        .step { position: relative; z-index: 3; text-align: center; flex: 1; }
        .step-icon { 
            width: 64px; 
            height: 64px; 
            background: #fff; 
            border-radius: 50%; 
            display: flex; 
            align-items: center; 
            justify-content: center; 
            font-size: 24px; 
            margin: 0 auto 16px; 
            box-shadow: 0 10px 30px rgba(0,0,0,0.1); 
            transition: all 0.4s cubic-bezier(0.4, 0, 0.2, 1);
            border: 2px solid transparent;
        }
        
        /* Active step: Black background, scaled up */
        .step.active .step-icon { 
            background: #000; 
            color: #fff; 
            transform: scale(1.2); 
            box-shadow: 0 15px 40px rgba(0,0,0,0.3); 
            border-color: #fff;
        }
        
        /* Completed step: White background, brand color icon */
        .step.completed .step-icon { 
            background: #fff; 
            color: var(--brand); 
        }

        /* Labels */
        .step-label { 
            font-size: 13px; 
            font-weight: 800; 
            color: #fff; /* On dark header */
            margin-top: 8px; 
            transition: all 0.3s;
            opacity: 0.6;
        }
        .step.active .step-label, .step.completed .step-label { opacity: 1; font-weight: 900; }
        
        .details-grid { display: grid; grid-template-columns: 1.4fr 1fr; gap: 40px; max-width: 1100px; margin: 0 auto; }
        .details-card { background: #fff; border-radius: var(--radius-lg); padding: 50px; border: 1px solid #f0f0f0; box-shadow: 0 10px 40px rgba(0,0,0,0.03); }
        
        .details-card h3 { font-family: var(--font-display); font-size: 40px; font-weight: 900; margin-bottom: 48px; color: #111; letter-spacing: -0.02em; }
        
        .info-row { display: flex; justify-content: space-between; margin-bottom: 32px; align-items: center; }
        .info-label { color: #aaa; font-size: 16px; font-weight: 500; }
        .info-value { color: #111; font-weight: 800; font-size: 17px; }
        
        .total-row { border-top: 1px solid #f5f5f5; padding-top: 40px; margin-top: 10px; display: flex; justify-content: space-between; align-items: center; }
        .total-label { font-size: 32px; font-family: var(--font-display); font-weight: 900; color: #111; }
        .total-value { font-size: 42px; font-family: var(--font-display); font-weight: 900; color: var(--brand); }
        
        .item-list { margin-top: 20px; }
        .item-row { display: flex; justify-content: space-between; align-items: center; margin-bottom: 28px; }
        .item-name-wrap { display: flex; align-items: center; gap: 12px; font-size: 18px; font-weight: 700; }
        .item-qty { color: var(--brand); font-weight: 700; }
        .item-price { font-family: var(--font-display); font-size: 20px; font-weight: 900; color: #111; }
        
        .support-link { color: var(--brand); font-weight: 700; text-decoration: none; border-bottom: 1.5px solid transparent; transition: all 0.2s; }
        .support-link:hover { border-bottom-color: var(--brand); }

        .animate-fadeUp { animation: fadeUp 0.8s cubic-bezier(0.2, 0.8, 0.2, 1) both; }
        @keyframes fadeUp { from { opacity: 0; transform: translateY(40px); } to { opacity: 1; transform: none; } }
        
        @media (max-width: 900px) {
            .details-grid { grid-template-columns: 1fr; }
            .details-card { padding: 32px; }
            .stepper-container { margin-top: -60px; overflow-x: auto; }
            .stepper { min-width: 600px; }
        }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="status-header"></div>

    <div class="container" style="padding-bottom: 120px; max-width: 1200px;">
        <div class="stepper-container animate-fadeUp">
            <div class="stepper">
                <div class="stepper-line"></div>
                <%
                    int stepIdx = 0;
                    if ("PREPARING".equals(status)) stepIdx = 1;
                    else if ("READY_FOR_PICKUP".equals(status)) stepIdx = 2;
                    else if ("ASSIGNED".equals(status) || "OUT_FOR_DELIVERY".equals(status)) stepIdx = 3;
                    else if ("DELIVERED".equals(status)) stepIdx = 4;
                    
                    // Calculate fill width: 0%, 25%, 50%, 75%, 100%
                    int fillWidth = stepIdx * 25; 
                %>
                <div class="stepper-fill" style="width: <%= fillWidth %>%"></div>
                
                <div class="step <%= stepIdx >= 0 ? "completed" : "" %> <%= stepIdx == 0 ? "active" : "" %>">
                    <div class="step-icon">📜</div>
                    <div class="step-label">Confirmed</div>
                </div>
                <div class="step <%= stepIdx >= 1 ? "completed" : "" %> <%= stepIdx == 1 ? "active" : "" %>">
                    <div class="step-icon">🍳</div>
                    <div class="step-label">Preparing</div>
                </div>
                <div class="step <%= stepIdx >= 2 ? "completed" : "" %> <%= stepIdx == 2 ? "active" : "" %>">
                    <div class="step-icon">🥡</div>
                    <div class="step-label">Ready</div>
                </div>
                <div class="step <%= stepIdx >= 3 ? "completed" : "" %> <%= stepIdx == 3 ? "active" : "" %>">
                    <div class="step-icon">🛵</div>
                    <div class="step-label">Dispatch</div>
                </div>
                <div class="step <%= stepIdx >= 4 ? "completed" : "" %> <%= stepIdx == 4 ? "active" : "" %>">
                    <div class="step-icon">🎁</div>
                    <div class="step-label">Delivered</div>
                </div>
            </div>
        </div>

        <div class="details-grid">
            <div class="details-card animate-fadeUp" style="animation-delay: 0.1s;">
                <h3>Order Details</h3>
                <div class="info-row">
                    <span class="info-label">Kitchen</span>
                    <span class="info-value">Restaurant Partner #<%= o != null ? o.getRestaurantId() : "N/A" %></span>
                </div>
                <div class="info-row">
                    <span class="info-label">Drop-off Point</span>
                    <span class="info-value"><%= sessionUser.getAddress() %></span>
                </div>
                <div class="total-row">
                    <span class="total-label">Total Paid</span>
                    <span class="total-value">$<%= o != null ? String.format("%.2f", o.getTotalPrice()) : "0.00" %></span>
                </div>
            </div>

            <div class="details-card animate-fadeUp" style="animation-delay: 0.2s;">
                <h3 style="font-size: 36px;">Items Ordered</h3>
                <div class="item-list">
                    <% if (o != null && o.getItems() != null && !o.getItems().isEmpty()) {
                        for (OrderItem oi : o.getItems()) { %>
                        <div class="item-row">
                            <div class="item-name-wrap">
                                <span class="item-qty"><%= oi.getQuantity() %>x</span>
                                <%= oi.getItemName() %>
                            </div>
                            <div class="item-price">$<%= String.format("%.2f", oi.getPrice() * oi.getQuantity()) %></div>
                        </div>
                    <% } } else { %>
                        <p class="text-muted">No items found for this order.</p>
                    <% } %>
                </div>
                
                <div style="margin-top: 60px; text-align: right; font-size: 15px;">
                    <span class="text-muted" style="font-weight: 500;">Need help?</span> 
                    <a href="#" class="support-link" style="margin-left: 6px;">Support Hub →</a>
                </div>
            </div>
        </div>

        <% if (sessionUser != null && ("ADMIN".equals(sessionUser.getRole()) || "RESTAURANT".equals(sessionUser.getRole()))) { %>
        <div class="details-card animate-fadeUp" style="margin-top: 40px; grid-column: span 2; border: 1.5px solid var(--brand); padding: 40px;">
            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 60px;">
                <div>
                    <h4 class="display-font" style="font-size: 22px; margin-bottom: 12px;">Kitchen <em>Progress</em></h4>
                    <form action="order" method="POST" style="display: flex; gap: 15px;">
                        <input type="hidden" name="action" value="updateStatus">
                        <input type="hidden" name="id" value="<%= o.getOrderId() %>">
                        <select name="status" class="form-control" style="font-weight: 700; flex: 1; padding: 12px; border-radius: 12px; border: 1px solid var(--border);">
                            <option value="PENDING" <%= "PENDING".equals(status) ? "selected" : "" %>>PENDING</option>
                            <option value="PREPARING" <%= "PREPARING".equals(status) ? "selected" : "" %>>PREPARING</option>
                            <option value="READY_FOR_PICKUP" <%= "READY_FOR_PICKUP".equals(status) ? "selected" : "" %>>READY</option>
                            <option value="ASSIGNED" <%= "ASSIGNED".equals(status) ? "selected" : "" %>>ASSIGNED</option>
                            <option value="OUT_FOR_DELIVERY" <%= "OUT_FOR_DELIVERY".equals(status) ? "selected" : "" %>>OUT FOR DELIVERY</option>
                            <option value="DELIVERED" <%= "DELIVERED".equals(status) ? "selected" : "" %>>DELIVERED</option>
                            <option value="CANCELLED" <%= "CANCELLED".equals(status) ? "selected" : "" %>>CANCELLED</option>
                        </select>
                        <button type="submit" class="btn btn-primary" style="padding: 0 25px; border-radius: 12px;">Update</button>
                    </form>
                </div>
                <div style="border-left: 1px solid #f0f0f0; padding-left: 60px;">
                    <h4 class="display-font" style="font-size: 22px; margin-bottom: 12px;">Logistics <em>Dispatch</em></h4>
                    <form action="order" method="POST" style="display: flex; gap: 15px;">
                        <input type="hidden" name="action" value="assignDriver">
                        <input type="hidden" name="orderId" value="<%= o.getOrderId() %>">
                        <select name="driverId" class="form-control" style="font-weight: 700; flex: 1; padding: 12px; border-radius: 12px; border: 1px solid var(--border);">
                            <option value="">Select Courier...</option>
                            <% List<User> drivers = (List<User>) request.getAttribute("drivers");
                               if (drivers != null) { for (User d : drivers) { %>
                                <option value="<%= d.getUserId() %>" <%= (o.getDeliveryAgentId() == d.getUserId()) ? "selected" : "" %>><%= d.getName() %></option>
                            <% } } %>
                        </select>
                        <button type="submit" class="btn btn-ghost" style="padding: 0 25px; border-radius: 12px; border: 1px solid #111; color: #111;">Assign</button>
                    </form>
                </div>
            </div>
        </div>
        <% } %>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
