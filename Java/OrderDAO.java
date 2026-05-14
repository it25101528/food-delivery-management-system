package com.foodhub.mod_orders;

import com.foodhub.model.Order;
import com.foodhub.model.OrderItem;
import com.foodhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int placeOrder(Order order) throws SQLException {
        String sql = "INSERT INTO orders (user_id, restaurant_id, total_price, order_status, order_type) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, order.getUserId());
            stmt.setInt(2, order.getRestaurantId());
            stmt.setDouble(3, order.getTotalPrice());
            stmt.setString(4, "PENDING");
            stmt.setString(5, order.getOrderType());
            
            stmt.executeUpdate();
            try (ResultSet rs = stmt.getGeneratedKeys()) {
                if (rs.next()) return rs.getInt(1);
            }
        }
        return -1;
    }

    public void saveOrderItems(List<OrderItem> items) throws SQLException {
        String sql = "INSERT INTO order_items (order_id, menu_item_id, quantity, price) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            for (OrderItem item : items) {
                stmt.setInt(1, item.getOrderId());
                stmt.setInt(2, item.getMenuItemId());
                stmt.setInt(3, item.getQuantity());
                stmt.setDouble(4, item.getPrice());
                stmt.addBatch();
            }
            stmt.executeBatch();
        }
    }

    public boolean updateStatus(int orderId, String status) throws SQLException {
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Order> getHistoryByUser(int userId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setRestaurantId(rs.getInt("restaurant_id"));
                    o.setTotalPrice(rs.getDouble("total_price"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    list.add(o);
                }
            }
        }
        return list;
    }

    public List<Order> getAllOrders() throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order o = new Order();
                o.setOrderId(rs.getInt("order_id"));
                o.setUserId(rs.getInt("user_id"));
                o.setRestaurantId(rs.getInt("restaurant_id"));
                o.setTotalPrice(rs.getDouble("total_price"));
                o.setOrderStatus(rs.getString("order_status"));
                o.setOrderType(rs.getString("order_type"));
                o.setOrderDate(rs.getTimestamp("order_date"));
                list.add(o);
            }
        }
        return list;
    }

    public Order getOrderById(int orderId) throws SQLException {
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setRestaurantId(rs.getInt("restaurant_id"));
                    o.setTotalPrice(rs.getDouble("total_price"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    return o;
                }
            }
        }
        return null;
    }

    public boolean assignAgent(int orderId, int agentId) throws SQLException {
        String updateSql = "UPDATE orders SET agent_id = ?, order_status = 'OUT_FOR_DELIVERY' WHERE order_id = ?";
        ensureAgentColumn();
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(updateSql)) {
            stmt.setInt(1, agentId);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        }
    }

    private void ensureAgentColumn() throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            boolean hasAgentId = hasOrderColumn(conn, "agent_id");
            boolean hasDeliveryAgentId = hasOrderColumn(conn, "delivery_agent_id");

            try (Statement stmt = conn.createStatement()) {
                if (!hasAgentId && hasDeliveryAgentId) {
                    stmt.executeUpdate("ALTER TABLE orders CHANGE COLUMN delivery_agent_id agent_id INT");
                } else if (!hasAgentId) {
                    stmt.executeUpdate("ALTER TABLE orders ADD COLUMN agent_id INT");
                }
            }
        }
    }

    private boolean hasOrderColumn(Connection conn, String columnName) throws SQLException {
        String sql = "SHOW COLUMNS FROM orders LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, columnName);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            return false;
        }
    }

    public List<Order> getOrdersByRestaurant(int restaurantId) throws SQLException {
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE restaurant_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = new Order();
                    o.setOrderId(rs.getInt("order_id"));
                    o.setUserId(rs.getInt("user_id"));
                    o.setRestaurantId(rs.getInt("restaurant_id"));
                    o.setTotalPrice(rs.getDouble("total_price"));
                    o.setOrderStatus(rs.getString("order_status"));
                    o.setOrderType(rs.getString("order_type"));
                    o.setOrderDate(rs.getTimestamp("order_date"));
                    list.add(o);
                }
            }
        }
        return list;
    }
}
