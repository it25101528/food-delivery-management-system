package com.foodhub.mod_billing;

import com.foodhub.model.Review;
import com.foodhub.util.DBConnection;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class ReviewDAO {

    public boolean addReview(Review r) throws SQLException {
        String sql = "INSERT INTO reviews (user_id, restaurant_id, rating, comment) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, r.getUserId());
            stmt.setInt(2, r.getRestaurantId());
            stmt.setInt(3, r.getRating());
            stmt.setString(4, r.getComment());
            return stmt.executeUpdate() > 0;
        }
    }

    public List<Review> getReviewsByRestaurant(int restaurantId) throws SQLException {
        List<Review> list = new ArrayList<>();
        String sql = "SELECT * FROM reviews WHERE restaurant_id = ? ORDER BY review_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement stmt = conn.prepareStatement(sql)) {
            stmt.setInt(1, restaurantId);
            try (ResultSet rs = stmt.executeQuery()) {
                while (rs.next()) {
                    Review r = new Review();
                    r.setId(rs.getInt("id"));
                    r.setUserId(rs.getInt("user_id"));
                    r.setRestaurantId(rs.getInt("restaurant_id"));
                    r.setRating(rs.getInt("rating"));
                    r.setComment(rs.getString("comment"));
                    r.setReviewDate(rs.getTimestamp("review_date"));
                    list.add(r);
                }
            }
        }
        return list;
    }
}
