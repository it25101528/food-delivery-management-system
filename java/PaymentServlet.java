package com.foodhub.mod_billing;

import com.foodhub.mod_billing.PaymentDAO;
import com.foodhub.model.Payment;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/payment")
public class PaymentServlet extends HttpServlet {
    private PaymentDAO paymentDAO = new PaymentDAO();

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
                request.setAttribute("payments", paymentDAO.getAllPayments());
                request.getRequestDispatcher("mod_billing/payment-stats.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
