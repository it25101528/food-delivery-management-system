package com.foodhub.servlet;

import com.foodhub.dao.AnalyticsDAO;
import com.foodhub.dao.RestaurantDAO;
import com.foodhub.model.Restaurant;
import com.foodhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.Map;
import java.util.List;
import java.util.stream.Collectors;

@WebServlet("/analytics")
public class AnalyticsServlet extends HttpServlet {
    private AnalyticsDAO analyticsDAO = new AnalyticsDAO();
    private RestaurantDAO restaurantDAO = new RestaurantDAO();

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        if (user == null) {
            response.sendError(HttpServletResponse.SC_UNAUTHORIZED);
            return;
        }

        String action = request.getParameter("action");
        String period = request.getParameter("period");
        if (period == null) period = "7d";

        response.setContentType("application/json");
        StringBuilder json = new StringBuilder("{");

        try {
            if ("restaurantRevenue".equals(action)) {
                Restaurant res = restaurantDAO.getRestaurantByOwner(user.getUserId());
                if (res != null) {
                    Map<String, Double> data = analyticsDAO.getRestaurantRevenue(res.getId(), period);
                    appendMapToJson(json, data);
                }
            } else if ("adminRevenueByRestaurant".equals(action) && "ADMIN".equals(user.getRole())) {
                List<Map<String, Object>> data = analyticsDAO.getAdminRevenueByRestaurant(period);
                json.append("\"data\": [");
                String rows = data.stream()
                    .map(m -> String.format("{\"name\":\"%s\", \"revenue\":%.2f}", m.get("name"), (Double)m.get("revenue")))
                    .collect(Collectors.joining(","));
                json.append(rows).append("]");
            } else if ("adminTotalRevenue".equals(action) && "ADMIN".equals(user.getRole())) {
                Map<String, Double> data = analyticsDAO.getAdminTotalRevenue(period);
                appendMapToJson(json, data);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }

        json.append("}");
        response.getWriter().write(json.toString());
    }

    private void appendMapToJson(StringBuilder json, Map<String, Double> data) {
        json.append("\"labels\": [");
        String labels = data.keySet().stream().map(s -> "\"" + s + "\"").collect(Collectors.joining(","));
        json.append(labels).append("],");
        json.append("\"values\": [");
        String values = data.values().stream().map(String::valueOf).collect(Collectors.joining(","));
        json.append(values).append("]");
    }
}
