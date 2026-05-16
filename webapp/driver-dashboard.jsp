<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.User" %>
<%@ page import="com.foodhub.model.Order" %>
<%@ page import="com.foodhub.dao.OrderDAO" %>
<%@ page import="com.foodhub.dao.DeliveryAgentDAO" %>
<%@ page import="com.foodhub.dao.UserDAO" %>
<%@ page import="com.foodhub.model.DeliveryAgent" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    User user = (User) session.getAttribute("user");
    if (user == null || !"DRIVER".equals(user.getRole())) { response.sendRedirect("driver-login.jsp"); return; }
    
    OrderDAO odao = new OrderDAO();
    UserDAO udao = new UserDAO();
    List<Order> allAgentOrders = odao.getOrdersByAgent(user.getUserId());
    
    List<Order> activeOrders = new ArrayList<>();
    List<Order> pastOrders = new ArrayList<>();
    double totalEarnings = 0;
    
    for (Order o : allAgentOrders) {
        if ("DELIVERED".equals(o.getOrderStatus())) {
            pastOrders.add(o);
            totalEarnings += o.getDeliveryCharge();
        } else if (!"CANCELLED".equals(o.getOrderStatus())) {
            activeOrders.add(o);
        }
    }
    
    DeliveryAgentDAO adao = new DeliveryAgentDAO();
    DeliveryAgent agent = adao.getAgentByUserId(user.getUserId());
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Flow — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .courier-layout { max-width: 900px; margin: 0 auto; padding: 60px 20px; }
        .tab-nav { display: flex; gap: 40px; border-bottom: 2px solid var(--surface); margin-bottom: 48px; }
        .tab-link { padding: 16px 0; font-weight: 800; color: var(--ink-3); text-decoration: none; position: relative; cursor: pointer; transition: all 0.2s; font-size: 15px; }
        .tab-link.active { color: var(--brand); }
        .tab-link.active::after { content: ''; position: absolute; bottom: -2px; left: 0; right: 0; height: 2px; background: var(--brand); }
        
        .tab-content { display: none; }
        .tab-content.active { display: block; }
        
        .courier-card { background: #fff; border-radius: var(--radius-lg); padding: 32px; border: 1.5px solid var(--border); box-shadow: var(--shadow); margin-bottom: 32px; transition: all 0.2s; }
        .courier-card:hover { border-color: var(--brand); transform: translateY(-4px); }
        .logistics-info { background: var(--surface); border-radius: var(--radius-md); padding: 24px; margin-bottom: 24px; display: flex; flex-direction: column; gap: 16px; }
        .logistics-step { display: flex; gap: 16px; align-items: center; }
        .logistics-icon { width: 36px; height: 36px; border-radius: 12px; background: #fff; border: 1px solid var(--border); display: flex; align-items: center; justify-content: center; font-size: 18px; }
        
        .earning-card { background: var(--ink); color: #fff; padding: 48px; border-radius: 24px; display: flex; justify-content: space-between; align-items: center; margin-bottom: 48px; }
        .stat-group h4 { color: rgba(255,255,255,0.6); font-size: 12px; text-transform: uppercase; letter-spacing: 0.1em; margin-bottom: 8px; font-weight: 800; }
        .stat-group .value { font-size: 42px; font-family: var(--font-display); font-weight: 900; }
    </style>
</head>
<body style="background: #fdfdfd;">
    <jsp:include page="jsp/navbar.jsp" />

    <div class="courier-layout">
        <header class="animate-fadeIn" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 60px;">
            <div>
                <h1 style="font-size: 42px;">Courier <em>Flow</em></h1>
                <p class="text-muted">Agent: <%= user.getName() %> • Vehicle: <%= (agent != null) ? agent.getVehicleNumber() : "N/A" %></p>
            </div>
            <div style="background: #dcfce7; color: #166534; padding: 12px 24px; border-radius: 100px; font-weight: 800; font-size: 13px; display: flex; align-items: center; gap: 8px;">
                <span style="width: 8px; height: 8px; background: #22c55e; border-radius: 50%;"></span>
                DUTY ACTIVE
            </div>
        </header>

        <nav class="tab-nav">
            <div class="tab-link active" onclick="showTab('active')">ACTIVE DISPATCH</div>
            <div class="tab-link" onclick="showTab('history')">DELIVERY LOGS</div>
            <div class="tab-link" onclick="showTab('earnings')">EARNINGS SUMMARY</div>
        </nav>

        <%-- Active Tab --%>
        <div id="active" class="tab-content active stagger">
            <% if (activeOrders.isEmpty()) { %>
                <div style="text-align: center; padding: 100px 0; border: 2px dashed var(--border); border-radius: 24px;">
                    <div style="font-size: 80px; margin-bottom: 24px;">📭</div>
                    <h3 class="display-font" style="font-size: 24px;">Logistics Clear</h3>
                    <p class="text-muted">Stay on standby for new artisan assignments.</p>
                </div>
            <% } else { 
                for (Order o : activeOrders) { %>
                <div class="courier-card animate-fadeUp">
                    <div style="display: flex; justify-content: space-between; align-items: flex-start; margin-bottom: 24px;">
                        <div>
                            <h4 style="font-size: 18px; font-weight: 800;">Logistics #<%= o.getOrderId() %></h4>
                            <p class="text-muted" style="font-size: 12px;"><%= sdf.format(o.getOrderDate()) %></p>
                        </div>
                        <div class="badge badge-ember"><%= o.getOrderStatus().replace("_", " ") %></div>
                    </div>
                    
                    <div class="logistics-info">
                        <div class="logistics-step">
                            <div class="logistics-icon" style="color: var(--brand);">🍳</div>
                            <div style="font-weight: 600;">Pick up from Kitchen #<%= o.getRestaurantId() %></div>
                        </div>
                        <div class="logistics-step">
                            <div class="logistics-icon">📍</div>
                            <% User customer = udao.getUserById(o.getUserId()); %>
                            <div style="font-weight: 600;">Deliver to: <%= (customer != null) ? customer.getAddress() : "Recipient Address" %></div>
                        </div>
                    </div>

                    <div style="display: flex; gap: 12px;">
                        <% if ("ASSIGNED".equals(o.getOrderStatus())) { %>
                            <form action="order" method="POST" style="flex: 1;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="id" value="<%= o.getOrderId() %>">
                                <input type="hidden" name="status" value="OUT_FOR_DELIVERY">
                                <button type="submit" class="btn btn-primary" style="width: 100%; padding: 18px;">Pick Up Item →</button>
                            </form>
                        <% } else if ("OUT_FOR_DELIVERY".equals(o.getOrderStatus())) { %>
                            <form action="order" method="POST" style="flex: 1;">
                                <input type="hidden" name="action" value="updateStatus">
                                <input type="hidden" name="id" value="<%= o.getOrderId() %>">
                                <input type="hidden" name="status" value="DELIVERED">
                                <button type="submit" class="btn btn-primary" style="width: 100%; background: var(--ink); padding: 18px;">Confirm Delivery ✓</button>
                            </form>
                        <% } %>
                    </div>
                </div>
            <% } } %>
        </div>

        <%-- History Tab --%>
        <div id="history" class="tab-content stagger">
            <% if (pastOrders.isEmpty()) { %>
                <div style="text-align: center; padding: 100px 0;">
                    <p class="text-muted">No completed deliveries yet.</p>
                </div>
            <% } else { 
                for (Order o : pastOrders) { %>
                <div class="card animate-fadeUp" style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 16px; padding: 24px;">
                    <div style="display: flex; gap: 20px; align-items: center;">
                        <div style="width: 48px; height: 48px; background: var(--surface); border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 20px;">📦</div>
                        <div>
                            <h4 style="font-size: 16px; margin: 0;">Order #<%= o.getOrderId() %></h4>
                            <% User pastCust = udao.getUserById(o.getUserId()); %>
                            <p class="text-muted" style="font-size: 12px; margin: 0;">
                                Delivered to: <%= (pastCust != null) ? pastCust.getAddress() : "N/A" %> • <%= sdf.format(o.getOrderDate()) %>
                            </p>
                        </div>
                    </div>
                    <div style="text-align: right;">
                        <div style="font-weight: 800; color: #06c167;">+ $<%= String.format("%.2f", o.getDeliveryCharge()) %></div>
                        <div style="font-size: 10px; color: var(--ink-3); text-transform: uppercase;">Service Fee</div>
                    </div>
                </div>
            <% } } %>
        </div>

        <%-- Earnings Tab --%>
        <div id="earnings" class="tab-content">
            <div class="earning-card animate-fadeUp">
                <div class="stat-group">
                    <h4>Logistics Earnings</h4>
                    <div class="value">$<%= String.format("%.2f", totalEarnings) %></div>
                </div>
                <div class="stat-group" style="text-align: right;">
                    <h4>Deliveries</h4>
                    <div class="value"><%= pastOrders.size() %></div>
                </div>
            </div>
            
            <div class="card animate-fadeUp">
                <h3 class="display-font" style="font-size: 20px; margin-bottom: 24px;">Earnings Summary</h3>
                <div style="display: flex; justify-content: space-between; margin-bottom: 16px; padding-bottom: 16px; border-bottom: 1px solid var(--surface);">
                    <span class="text-muted">Completed Deliveries</span>
                    <span style="font-weight: 700;"><%= pastOrders.size() %> log(s)</span>
                </div>
                <div style="display: flex; justify-content: space-between; font-weight: 800; font-size: 18px; margin-top: 24px;">
                    <span>Total Service Payout</span>
                    <span style="color: var(--brand);">$<%= String.format("%.2f", totalEarnings) %></span>
                </div>
            </div>
        </div>
    </div>

    <script>
        function showTab(tabId) {
            document.querySelectorAll('.tab-content').forEach(c => c.classList.remove('active'));
            document.querySelectorAll('.tab-link').forEach(l => l.classList.remove('active'));
            
            document.getElementById(tabId).classList.add('active');
            event.target.classList.add('active');
        }
    </script>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
