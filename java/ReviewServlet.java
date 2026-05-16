package com.foodhub.servlet;

import com.foodhub.dao.ReviewDAO;
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
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                Review r = new Review();
                r.setUserId(user.getUserId());
                r.setRestaurantId(Integer.parseInt(request.getParameter("restaurantId")));
                r.setRating(Integer.parseInt(request.getParameter("rating")));
                r.setComment(request.getParameter("comment"));
                
                reviewDAO.addReview(r);
                response.sendRedirect("order?action=history");
            } else if ("delete".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect("login.jsp?error=Unauthorized");
                    return;
                }
                int id = Integer.parseInt(request.getParameter("id"));
                reviewDAO.deleteReview(id);
                response.sendRedirect("review?action=list");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("list".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null || !"ADMIN".equals(user.getRole())) {
                    response.sendRedirect("login.jsp?error=Unauthorized");
                    return;
                }
                request.setAttribute("reviews", reviewDAO.getAllReviews());
                request.getRequestDispatcher("review-manage.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
