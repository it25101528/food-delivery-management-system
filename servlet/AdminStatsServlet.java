package com.foodhub.servlet;

import com.foodhub.dao.OrderDAO;
import com.foodhub.dao.RestaurantDAO;
import com.foodhub.dao.UserDAO;
import com.foodhub.model.Order;
import com.foodhub.model.User;
import com.foodhub.model.Restaurant;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Calendar;
import java.util.List;

@WebServlet("/admin-stats")
public class AdminStatsServlet extends HttpServlet {
    private OrderDAO odao = new OrderDAO();
    private UserDAO udao = new UserDAO();
    private RestaurantDAO rdao = new RestaurantDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        response.setContentType("application/json");
        try {
            List<User> customers = udao.getAllCustomers();
            List<Restaurant> kitchens = rdao.getAllRestaurants();
            List<Order> allOrders = odao.getAllOrders();

            double grossRevenue = 0;
            int ordersToday = 0;
            Calendar cal = Calendar.getInstance();
            cal.set(Calendar.HOUR_OF_DAY, 0);
            cal.set(Calendar.MINUTE, 0);
            cal.set(Calendar.SECOND, 0);
            long todayStart = cal.getTimeInMillis();

            for (Order o : allOrders) {
                if (!"CANCELLED".equals(o.getOrderStatus())) {
                    grossRevenue += o.getTotalPrice();
                    if (o.getOrderDate().getTime() >= todayStart) {
                        ordersToday++;
                    }
                }
            }

            String json = String.format(
                "{\"customers\": %d, \"kitchens\": %d, \"ordersToday\": %d, \"revenue\": %.2f}",
                customers.size(), kitchens.size(), ordersToday, grossRevenue
            );
            response.getWriter().write(json);
        } catch (SQLException e) {
            response.setStatus(500);
            response.getWriter().write("{\"error\": \"" + e.getMessage() + "\"}");
        }
    }
}
