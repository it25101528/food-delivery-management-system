package com.foodhub.mod_billing;

import com.foodhub.model.Payment;
import com.foodhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PaymentDAO {

    public boolean recordPayment(Payment p) throws SQLException {
        ensurePaymentSchema();
        String sql = "INSERT INTO payments (order_id, payment_method, amount, payment_status, transaction_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, p.getOrderId());
            stmt.setString(2, p.getPaymentMethod());
            stmt.setDouble(3, p.getAmount());
            stmt.setString(4, "COMPLETED");
            stmt.setString(5, p.getTransactionId());
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Payment> getAllPayments() throws SQLException {
        ensurePaymentSchema();
        List<Payment> list = new ArrayList<>();
        String sql = "SELECT * FROM payments ORDER BY payment_date DESC";
        try (Connection conn = DBConnection.getConnection();
             Statement stmt = conn.createStatement();
             ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Payment p = new Payment();
                p.setPaymentId(rs.getInt("payment_id"));
                p.setOrderId(rs.getInt("order_id"));
                p.setPaymentMethod(rs.getString("payment_method"));
                p.setAmount(rs.getDouble("amount"));
                p.setPaymentStatus(rs.getString("payment_status"));
                p.setTransactionId(rs.getString("transaction_id"));
                p.setPaymentDate(rs.getTimestamp("payment_date"));
                list.add(p);
            }
        }
        return list;
    }

    private void ensurePaymentSchema() throws SQLException {
        try (Connection conn = DBConnection.getConnection()) {
            // First, ensure the table exists
            try (Statement stmt = conn.createStatement()) {
                stmt.executeUpdate("CREATE TABLE IF NOT EXISTS payments (" +
                        "payment_id INT AUTO_INCREMENT PRIMARY KEY," +
                        "order_id INT NOT NULL," +
                        "amount DECIMAL(10, 2) NOT NULL," +
                        "payment_method VARCHAR(50) NOT NULL," +
                        "payment_status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING'," +
                        "transaction_id VARCHAR(50)," +
                        "payment_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                        ")");
            }

            boolean hasPaymentId = hasColumn(conn, "payment_id");
            boolean hasLegacyId = hasColumn(conn, "id");
            boolean hasPaymentStatus = hasColumn(conn, "payment_status");
            boolean hasLegacyStatus = hasColumn(conn, "status");
            boolean hasTransactionId = hasColumn(conn, "transaction_id");

            try (Statement stmt = conn.createStatement()) {
                // Ensure payment_method is flexible (VARCHAR instead of restrictive ENUM)
                stmt.executeUpdate("ALTER TABLE payments MODIFY COLUMN payment_method VARCHAR(50) NOT NULL");

                if (!hasPaymentId && hasLegacyId) {
                    stmt.executeUpdate("ALTER TABLE payments CHANGE COLUMN id payment_id INT NOT NULL AUTO_INCREMENT");
                }
                if (!hasPaymentStatus && hasLegacyStatus) {
                    stmt.executeUpdate("ALTER TABLE payments CHANGE COLUMN status payment_status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING'");
                    hasPaymentStatus = true;
                }
                if (!hasPaymentStatus) {
                    stmt.executeUpdate("ALTER TABLE payments ADD COLUMN payment_status ENUM('PENDING', 'COMPLETED', 'FAILED') DEFAULT 'PENDING'");
                    hasPaymentStatus = true;
                }
                if (!hasTransactionId) {
                    stmt.executeUpdate("ALTER TABLE payments ADD COLUMN transaction_id VARCHAR(50)");
                }
            }
        }
    }

    private boolean hasColumn(Connection conn, String columnName) throws SQLException {
        String sql = "SHOW COLUMNS FROM payments LIKE ?";
        try (PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setString(1, columnName);
            try (ResultSet rs = stmt.executeQuery()) {
                return rs.next();
            }
        } catch (SQLException e) {
            // If table doesn't exist, it might throw an exception
            return false;
        }
    }
}
