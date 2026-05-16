package com.foodhub.dao;

import com.foodhub.model.Order;
import com.foodhub.model.OrderItem;
import com.foodhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class OrderDAO {

    public int placeOrder(Order order) throws SQLException {
        ensureSchema();
        String sql = "INSERT INTO orders (user_id, restaurant_id, total_price, order_status, order_type, delivery_charge) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            stmt.setInt(1, order.getUserId());
            stmt.setInt(2, order.getRestaurantId());
            stmt.setDouble(3, order.getTotalPrice());
            stmt.setString(4, "PENDING");
            stmt.setString(5, order.getOrderType());
            stmt.setDouble(6, order.getDeliveryCharge());
            
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
        ensureSchema();
        String sql = "UPDATE orders SET order_status = ? WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, status);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Order> getHistoryByUser(int userId) throws SQLException {
        ensureSchema();
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE user_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getItemsByOrder(o.getOrderId()));
                    list.add(o);
                }
            }
        }
        return list;
    }

    public Order getOrderById(int orderId) throws SQLException {
        ensureSchema();
        String sql = "SELECT * FROM orders WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getItemsByOrder(o.getOrderId()));
                    return o;
                }
            }
        }
        return null;
    }

    public boolean assignAgent(int orderId, int agentId) throws SQLException {
        ensureSchema();
        String sql = "UPDATE orders SET agent_id = ?, order_status = 'ASSIGNED' WHERE order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, agentId);
            stmt.setInt(2, orderId);
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Order> getOrdersByAgent(int agentId) throws SQLException {
        ensureSchema();
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE agent_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, agentId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getItemsByOrder(o.getOrderId()));
                    list.add(o);
                }
            }
        }
        return list;
    }

    public List<Order> getOrdersByAgentAndStatus(int agentId, String status) throws SQLException {
        ensureSchema();
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE agent_id = ? AND order_status = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, agentId);
            stmt.setString(2, status);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getItemsByOrder(o.getOrderId()));
                    list.add(o);
                }
            }
        }
        return list;
    }

    public List<Order> getOrdersByRestaurant(int restaurantId) throws SQLException {
        ensureSchema();
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders WHERE restaurant_id = ? ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Order o = mapOrder(rs);
                    o.setItems(getItemsByOrder(o.getOrderId()));
                    list.add(o);
                }
            }
        }
        return list;
    }

    public List<Order> getAllOrders() throws SQLException {
        ensureSchema();
        List<Order> list = new ArrayList<>();
        String sql = "SELECT * FROM orders ORDER BY order_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Order o = mapOrder(rs);
                o.setItems(getItemsByOrder(o.getOrderId()));
                list.add(o);
            }
        }
        return list;
    }

    private Order mapOrder(ResultSet rs) throws SQLException {
        Order o = new Order();
        o.setOrderId(rs.getInt("order_id"));
        o.setUserId(rs.getInt("user_id"));
        o.setRestaurantId(rs.getInt("restaurant_id"));
        o.setTotalPrice(rs.getDouble("total_price"));
        o.setOrderStatus(rs.getString("order_status"));
        o.setOrderType(rs.getString("order_type"));
        o.setOrderDate(rs.getTimestamp("order_date"));
        o.setDeliveryAgentId(rs.getInt("agent_id"));
        o.setDeliveryCharge(rs.getDouble("delivery_charge"));
        return o;
    }

    private void ensureSchema() throws SQLException {
        try (Connection conn = DBConnection.getConnection(); Statement s = conn.createStatement()) {
            s.executeUpdate("ALTER TABLE orders MODIFY COLUMN order_status VARCHAR(50)");
            s.executeUpdate("ALTER TABLE orders MODIFY COLUMN order_type VARCHAR(50)");
            
            // Unify agent_id and delivery_charge
            if (!hasColumn(conn, "agent_id")) {
                if (hasColumn(conn, "delivery_agent_id")) {
                    s.executeUpdate("ALTER TABLE orders CHANGE COLUMN delivery_agent_id agent_id INT DEFAULT 0");
                } else {
                    s.executeUpdate("ALTER TABLE orders ADD COLUMN agent_id INT DEFAULT 0");
                }
            }
            if (!hasColumn(conn, "delivery_charge")) {
                s.executeUpdate("ALTER TABLE orders ADD COLUMN delivery_charge DECIMAL(10, 2) DEFAULT 0.00");
            }
        }
    }

    private boolean hasColumn(Connection conn, String col) throws SQLException {
        String sql = "SHOW COLUMNS FROM orders LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, col);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        }
    }

    public List<OrderItem> getItemsByOrder(int orderId) throws SQLException {
        List<OrderItem> items = new ArrayList<>();
        String sql = "SELECT oi.*, mi.name FROM order_items oi JOIN menu_items mi ON oi.menu_item_id = mi.id WHERE oi.order_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, orderId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    OrderItem item = new OrderItem();
                    item.setItemId(rs.getInt("item_id"));
                    item.setOrderId(rs.getInt("order_id"));
                    item.setMenuItemId(rs.getInt("menu_item_id"));
                    item.setQuantity(rs.getInt("quantity"));
                    item.setPrice(rs.getDouble("price"));
                    item.setItemName(rs.getString("name"));
                    items.add(item);
                }
            }
        }
        return items;
    }
}
