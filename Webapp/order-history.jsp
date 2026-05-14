<%@ page import="com.foodhub.model.Order" %>
<%@ page import="java.util.List" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>My Orders - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container">
        <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
            <h1>My Order History</h1>
            <a href="../restaurant?action=list" class="btn btn-primary">Order More Food</a>
        </div>

        <div class="card">
            <table>
                <thead>
                    <tr>
                        <th>Order ID</th>
                        <th>Date</th>
                        <th>Total Price</th>
                        <th>Status</th>
                        <th>Action</th>
                    </tr>
                </thead>
                <tbody>
                    <% 
                        List<Order> orders = (List<Order>) request.getAttribute("orders");
                        if (orders != null && !orders.isEmpty()) {
                            for (Order o : orders) {
                    %>
                        <tr>
                            <td>#<%= o.getOrderId() %></td>
                            <td><%= o.getOrderDate() %></td>
                            <td><strong>$<%= o.getTotalPrice() %></strong></td>
                            <td>
                                <span style="padding: 4px 10px; border-radius: 999px; font-size: 12px; font-weight: 600; 
                                      background: <%= "DELIVERED".equals(o.getOrderStatus()) ? "#dcfce7" : "#fef3c7" %>; 
                                      color: <%= "DELIVERED".equals(o.getOrderStatus()) ? "#166534" : "#92400e" %>;">
                                    <%= o.getOrderStatus() %>
                                </span>
                            </td>
                            <td>
                                <a href="../order?action=status&id=<%= o.getOrderId() %>" class="btn btn-secondary" style="padding: 5px 12px; font-size: 12px;">Track Status</a>
                            </td>
                        </tr>
                    <% 
                            }
                        } else {
                    %>
                        <tr>
                            <td colspan="5" style="text-align: center; padding: 40px;">You haven't placed any orders yet.</td>
                        </tr>
                    <% } %>
                </tbody>
            </table>
        </div>
    </div>
</body>
</html>
