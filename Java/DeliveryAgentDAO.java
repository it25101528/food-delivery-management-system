package com.foodhub.dao;

import com.foodhub.model.DeliveryAgent;
import com.foodhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryAgentDAO {

    // Ensure required columns exist in the delivery_agents table
    private void ensureColumns() {
        try (Connection conn = DBConnection.getConnection(); Statement stmt = conn.createStatement()) {
            // Check for vehicle_number column
            try {
                ResultSet rs = conn.getMetaData().getColumns(null, null, "delivery_agents", "vehicle_number");
                if (!rs.next()) {
                    stmt.executeUpdate("ALTER TABLE delivery_agents ADD COLUMN vehicle_number VARCHAR(50)");
                }
                rs.close();
            } catch (SQLException ignore) {}

            try {
                stmt.executeUpdate("ALTER TABLE delivery_agents MODIFY COLUMN vehicle_type VARCHAR(50) NOT NULL");
            } catch (SQLException ignore) {}

            // Check for user_id column
            try {
                ResultSet rs = conn.getMetaData().getColumns(null, null, "delivery_agents", "user_id");
                if (!rs.next()) {
                    stmt.executeUpdate("ALTER TABLE delivery_agents ADD COLUMN user_id INT");
                }
                rs.close();
            } catch (SQLException ignore) {}

            // Sync all DRIVER-role users from users table into delivery_agents
            // so the dispatch dropdown is always populated with registered drivers
            try {
                String syncSql = "INSERT INTO delivery_agents (name, phone, vehicle_type, vehicle_number, availability, user_id) " +
                                 "SELECT name, phone_number, 'Not Specified', '', 1, user_id " +
                                 "FROM users WHERE role = 'DRIVER' " +
                                 "AND user_id NOT IN (SELECT COALESCE(user_id, -1) FROM delivery_agents WHERE user_id IS NOT NULL)";
                stmt.executeUpdate(syncSql);
            } catch (SQLException e) {
                System.out.println("[DeliveryAgentDAO] Driver sync warning: " + e.getMessage());
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    //insert
    public boolean registerAgent(DeliveryAgent agent) throws SQLException {
        ensureColumns();
        String sql = "INSERT INTO delivery_agents (name, phone, vehicle_type, vehicle_number, availability, user_id) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, agent.getName());
            stmt.setString(2, agent.getPhoneNumber());
            stmt.setString(3, agent.getVehicleType());
            stmt.setString(4, agent.getVehicleNumber());
            stmt.setBoolean(5, true); // Default to available
            stmt.setInt(6, agent.getUserId());
            return stmt.executeUpdate() > 0;
        }
    }

    //read
    public DeliveryAgent getAgentByUserId(int userId) throws SQLException {
        ensureColumns();
        String sql = "SELECT * FROM delivery_agents WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, userId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        }
        return null;
    }

    public DeliveryAgent getAgentById(int agentId) throws SQLException {
        String sql = "SELECT * FROM delivery_agents WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, agentId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    return mapResultSet(rs);
                }
            }
        }
        return null;
    }

    //update
    public boolean updateAgent(DeliveryAgent agent) throws SQLException {
        ensureColumns();
        String sql = "UPDATE delivery_agents SET name=?, phone=?, vehicle_type=?, vehicle_number=?, availability=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, agent.getName());
            stmt.setString(2, agent.getPhoneNumber());
            stmt.setString(3, agent.getVehicleType());
            stmt.setString(4, agent.getVehicleNumber());
            stmt.setBoolean(5, agent.isAvailability());
            stmt.setInt(6, agent.getAgentId());
            return stmt.executeUpdate() > 0;
        }
    }

    //read
    public List<DeliveryAgent> getAllAgents() throws SQLException {
        ensureColumns();
        List<DeliveryAgent> list = new ArrayList<>();
        String sql = "SELECT * FROM delivery_agents";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                list.add(mapResultSet(rs));
            }
        }
        return list;
    }

    private DeliveryAgent mapResultSet(ResultSet rs) throws SQLException {
        DeliveryAgent a = new DeliveryAgent();
        a.setAgentId(rs.getInt("id"));
        a.setName(rs.getString("name"));
        a.setPhoneNumber(rs.getString("phone"));
        a.setAvailability(rs.getBoolean("availability"));
        a.setVehicleType(rs.getString("vehicle_type"));
        try {
            a.setVehicleNumber(rs.getString("vehicle_number"));
        } catch (SQLException ignore) {}
        try {
            a.setUserId(rs.getInt("user_id"));
        } catch (SQLException ignore) {}
        return a;
    }
}
