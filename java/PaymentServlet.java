package com.foodhub.servlet;

import com.foodhub.dao.PaymentDAO;
import com.foodhub.model.Payment;
import com.foodhub.model.User;
import com.foodhub.model.Restaurant;
import com.foodhub.dao.RestaurantDAO;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();
    private RestaurantDAO restaurantDAO = new RestaurantDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("process".equals(action)) {
                Payment p = new Payment();
                p.setOrderId(Integer.parseInt(request.getParameter("orderId")));
                p.setPaymentMethod(request.getParameter("method"));
                p.setAmount(Double.parseDouble(request.getParameter("amount")));
                p.setTransactionId("TXN" + System.currentTimeMillis());
                
                paymentDAO.recordPayment(p);
                response.sendRedirect("order?action=status&id=" + p.getOrderId());
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("stats".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                if ("ADMIN".equals(user.getRole())) {
                    request.setAttribute("payments", paymentDAO.getAllPayments());
                } else if ("RESTAURANT".equals(user.getRole())) {
                    Restaurant res = restaurantDAO.getRestaurantByOwner(user.getUserId());
                    if (res != null) {
                        request.setAttribute("payments", paymentDAO.getPaymentsByRestaurant(res.getId()));
                    }
                }
                request.getRequestDispatcher("payment-stats.jsp").forward(request, response);
            } else if ("history".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }

                if ("ADMIN".equals(user.getRole())) {
                    request.setAttribute("payments", paymentDAO.getAllPayments());
                } else if ("RESTAURANT".equals(user.getRole())) {
                    Restaurant res = restaurantDAO.getRestaurantByOwner(user.getUserId());
                    if (res != null) {
                        request.setAttribute("payments", paymentDAO.getPaymentsByRestaurant(res.getId()));
                    }
                } else {
                    request.setAttribute("payments", paymentDAO.getPaymentsByUser(user.getUserId()));
                }
                request.getRequestDispatcher("payment-history.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
