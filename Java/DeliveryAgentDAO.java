package com.foodhub.mod_delivery;

import com.foodhub.model.DeliveryAgent;
import com.foodhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DeliveryAgentDAO {

    public boolean registerAgent(DeliveryAgent agent) throws SQLException {
        String sql = "INSERT INTO delivery_agents (name, phone, vehicle_type, availability) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, agent.getName());
            stmt.setString(2, agent.getPhoneNumber());
            stmt.setString(3, agent.getVehicleType());
            stmt.setBoolean(4, true); // Default to available
            return stmt.executeUpdate() > 0;
        }
    }

    public List<DeliveryAgent> getAllAgents() throws SQLException {
        List<DeliveryAgent> list = new ArrayList<>();
        String sql = "SELECT * FROM delivery_agents";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                DeliveryAgent a = new DeliveryAgent();
                a.setAgentId(rs.getInt("id"));
                a.setName(rs.getString("name"));
                a.setPhoneNumber(rs.getString("phone"));
                a.setAvailability(rs.getBoolean("availability"));
                a.setVehicleType(rs.getString("vehicle_type"));
                list.add(a);
            }
        }
        return list;
    }
}
