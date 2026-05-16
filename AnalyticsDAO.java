package com.foodhub.dao;

import com.foodhub.util.DBConnection;
import java.sql.*;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class AnalyticsDAO {

    public Map<String, Double> getRestaurantRevenue(int restaurantId, String period) throws SQLException {
        Map<String, Double> data = new HashMap<>();
        String sql = "";
        
        if ("24h".equals(period)) {
            sql = "SELECT HOUR(order_date) as label, SUM(total_price) as revenue FROM orders " +
                  "WHERE restaurant_id = ? AND order_date >= NOW() - INTERVAL 1 DAY " +
                  "GROUP BY label ORDER BY label";
        } else if ("7d".equals(period)) {
            sql = "SELECT DATE_FORMAT(order_date, '%Y-%m-%d') as label, SUM(total_price) as revenue FROM orders " +
                  "WHERE restaurant_id = ? AND order_date >= NOW() - INTERVAL 7 DAY " +
                  "GROUP BY label ORDER BY label";
        } else { // 30d
            sql = "SELECT DATE_FORMAT(order_date, '%Y-%m-%d') as label, SUM(total_price) as revenue FROM orders " +
                  "WHERE restaurant_id = ? AND order_date >= NOW() - INTERVAL 30 DAY " +
                  "GROUP BY label ORDER BY label";
        }

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    data.put(rs.getString("label"), rs.getDouble("revenue"));
                }
            }
        }
        return data;
    }

    public List<Map<String, Object>> getAdminRevenueByRestaurant(String period) throws SQLException {
        List<Map<String, Object>> list = new ArrayList<>();
        String sql = "SELECT r.name, SUM(o.total_price) as revenue FROM orders o " +
                     "JOIN restaurants r ON o.restaurant_id = r.id ";
        
        if ("24h".equals(period)) {
            sql += "WHERE o.order_date >= NOW() - INTERVAL 1 DAY ";
        } else if ("7d".equals(period)) {
            sql += "WHERE o.order_date >= NOW() - INTERVAL 7 DAY ";
        } else {
            sql += "WHERE o.order_date >= NOW() - INTERVAL 30 DAY ";
        }
        
        sql += "GROUP BY r.name ORDER BY revenue DESC";

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Map<String, Object> row = new HashMap<>();
                row.put("name", rs.getString("name"));
                row.put("revenue", rs.getDouble("revenue"));
                list.add(row);
            }
        }
        return list;
    }

    public Map<String, Double> getAdminTotalRevenue(String period) throws SQLException {
        Map<String, Double> data = new HashMap<>();
        String sql = "";
        
        if ("24h".equals(period)) {
            sql = "SELECT HOUR(order_date) as label, SUM(total_price) as revenue FROM orders " +
                  "WHERE order_date >= NOW() - INTERVAL 1 DAY " +
                  "GROUP BY label ORDER BY label";
        } else if ("7d".equals(period)) {
            sql = "SELECT DATE_FORMAT(order_date, '%Y-%m-%d') as label, SUM(total_price) as revenue FROM orders " +
                  "WHERE order_date >= NOW() - INTERVAL 7 DAY " +
                  "GROUP BY label ORDER BY label";
        } else { // 30d
            sql = "SELECT DATE_FORMAT(order_date, '%Y-%m-%d') as label, SUM(total_price) as revenue FROM orders " +
                  "WHERE order_date >= NOW() - INTERVAL 30 DAY " +
                  "GROUP BY label ORDER BY label";
        }

        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                data.put(rs.getString("label"), rs.getDouble("revenue"));
            }
        }
        return data;
    }
}
