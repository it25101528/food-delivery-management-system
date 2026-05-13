package com.foodhub.mod_billing;

import com.foodhub.model.Review;
import com.foodhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/review")
public class ReviewServlet extends HttpServlet {
    private ReviewDAO reviewDAO = new ReviewDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("mod_customer/login.jsp");
                    return;
                }
                
                Review r = new Review();
                r.setUserId(user.getUserId());
                r.setRestaurantId(Integer.parseInt(request.getParameter("restaurantId")));
                r.setRating(Integer.parseInt(request.getParameter("rating")));
                r.setComment(request.getParameter("comment"));
                
                reviewDAO.addReview(r);
                response.sendRedirect("order?action=history");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
