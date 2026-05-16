package com.foodhub.servlet;

import com.foodhub.dao.OrderDAO;
import com.foodhub.dao.PaymentDAO;
import com.foodhub.dao.RestaurantDAO;
import com.foodhub.model.Order;
import com.foodhub.model.OrderItem;
import com.foodhub.model.Payment;
import com.foodhub.model.Restaurant;
import com.foodhub.model.User;
import com.foodhub.dao.UserDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/order")
public class OrderServlet extends HttpServlet {
    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("place".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                Order order = new Order();
                order.setUserId(user.getUserId());
                order.setRestaurantId(Integer.parseInt(request.getParameter("restaurantId")));
                order.setTotalPrice(Double.parseDouble(request.getParameter("totalPrice")));
                order.setOrderType(request.getParameter("orderType"));
                
                double deliveryFee = 0;
                try {
                    deliveryFee = Double.parseDouble(request.getParameter("deliveryCharge"));
                } catch (Exception ignore) {}
                order.setDeliveryCharge(deliveryFee);
                
                int orderId = orderDAO.placeOrder(order);

                // Save Order Items
                String[] menuItemIds = request.getParameterValues("menuItemId");
                String[] quantities = request.getParameterValues("quantity");
                String[] prices = request.getParameterValues("price");

                if (menuItemIds != null) {
                    List<OrderItem> items = new ArrayList<>();
                    for (int i = 0; i < menuItemIds.length; i++) {
                        OrderItem item = new OrderItem();
                        item.setOrderId(orderId);
                        item.setMenuItemId(Integer.parseInt(menuItemIds[i]));
                        item.setQuantity(Integer.parseInt(quantities[i]));
                        item.setPrice(Double.parseDouble(prices[i]));
                        items.add(item);
                    }
                    orderDAO.saveOrderItems(items);
                }
                
                // Record Payment
                PaymentDAO paymentDAO = new PaymentDAO();
                Payment p = new Payment();
                p.setOrderId(orderId);
                p.setAmount(order.getTotalPrice() + order.getDeliveryCharge());
                p.setPaymentMethod(request.getParameter("paymentMethod"));
                p.setTransactionId("TXN" + System.currentTimeMillis());
                paymentDAO.recordPayment(p);

                response.sendRedirect("order?action=status&id=" + orderId + "&clearCart=true");
            } else if ("updateStatus".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null || (!"ADMIN".equals(user.getRole()) && !"RESTAURANT".equals(user.getRole()) && !"DRIVER".equals(user.getRole()))) {
                    response.sendRedirect("login.jsp?error=Unauthorized");
                    return;
                }
                
                int id = Integer.parseInt(request.getParameter("id"));
                Order order = orderDAO.getOrderById(id);
                
                // If restaurant owner, verify they own the restaurant for this order
                if ("RESTAURANT".equals(user.getRole())) {
                    RestaurantDAO resDAO = new RestaurantDAO();
                    Restaurant myRes = resDAO.getRestaurantByOwner(user.getUserId());
                    if (myRes == null || myRes.getId() != order.getRestaurantId()) {
                        response.sendRedirect("login.jsp?error=Unauthorized_Kitchen");
                        return;
                    }
                }

                // If driver, verify they are assigned to this order
                if ("DRIVER".equals(user.getRole())) {
                    if (order.getDeliveryAgentId() != user.getUserId()) {
                        response.sendRedirect("login.jsp?error=Unauthorized_Driver");
                        return;
                    }
                }

                String status = request.getParameter("status");
                orderDAO.updateStatus(id, status);
                
                // If cancelled, trigger refund
                if ("CANCELLED".equals(status)) {
                    PaymentDAO paymentDAO = new PaymentDAO();
                    paymentDAO.updatePaymentStatus(id, "REFUNDED");
                }
                
                if ("DRIVER".equals(user.getRole())) {
                    response.sendRedirect("driver-dashboard.jsp");
                } else {
                    response.sendRedirect("order?action=history");
                }
            } else if ("assignDriver".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                int driverId = Integer.parseInt(request.getParameter("driverId"));
                orderDAO.assignAgent(orderId, driverId);
                response.sendRedirect("order?action=history");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("history".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                if ("ADMIN".equals(user.getRole())) {
                    request.setAttribute("orders", orderDAO.getAllOrders());
                } else if ("RESTAURANT".equals(user.getRole())) {
                    RestaurantDAO resDAO = new RestaurantDAO();
                    Restaurant myRes = resDAO.getRestaurantByOwner(user.getUserId());
                    if (myRes != null) {
                        request.setAttribute("orders", orderDAO.getOrdersByRestaurant(myRes.getId()));
                    }
                } else {
                    request.setAttribute("orders", orderDAO.getHistoryByUser(user.getUserId()));
                }
                request.setAttribute("drivers", userDAO.getAllDrivers());
                request.getRequestDispatcher("order-history.jsp").forward(request, response);
            } else if ("status".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("order", orderDAO.getOrderById(id));
                request.setAttribute("drivers", userDAO.getAllDrivers());
                request.getRequestDispatcher("order-status.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
