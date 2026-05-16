package com.foodhub.servlet;

import com.foodhub.dao.DeliveryAgentDAO;
import com.foodhub.dao.OrderDAO;
import com.foodhub.dao.UserDAO;
import com.foodhub.model.DeliveryAgent;
import com.foodhub.model.Order;
import com.foodhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/delivery")
public class DeliveryServlet extends HttpServlet {
    private DeliveryAgentDAO agentDAO = new DeliveryAgentDAO();
    private OrderDAO orderDAO = new OrderDAO();
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("register".equals(action)) {
                DeliveryAgent agent = new DeliveryAgent();
                agent.setVehicleType(request.getParameter("vehicleType"));
                agent.setVehicleNumber(request.getParameter("vehicleNumber"));
                
                // Check if this is a driver self-registration (has userId in session)
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                if (user != null && "DRIVER".equals(user.getRole())) {
                    agent.setName(valueOrDefault(request.getParameter("name"), user.getName()));
                    agent.setPhoneNumber(valueOrDefault(request.getParameter("phone"), user.getPhoneNumber()));
                    agent.setUserId(user.getUserId());
                    agentDAO.registerAgent(agent);
                    response.sendRedirect("driver-dashboard.jsp");
                } else {
                    // Admin registering an agent
                    agent.setName(request.getParameter("name"));
                    agent.setPhoneNumber(request.getParameter("phone"));
                    agentDAO.registerAgent(agent);
                    response.sendRedirect("admin-dashboard.jsp");
                }
            } else if ("assign".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                int agentId = Integer.parseInt(request.getParameter("agentId"));
                
                orderDAO.assignAgent(orderId, agentId);
                response.sendRedirect("order?action=status&id=" + orderId);
            } else if ("updateProfile".equals(action)) {
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                if (user == null || !"DRIVER".equals(user.getRole())) {
                    response.sendRedirect("driver-login.jsp");
                    return;
                }
                
                DeliveryAgent agent = agentDAO.getAgentByUserId(user.getUserId());
                if (agent != null) {
                    agent.setName(valueOrDefault(request.getParameter("name"), user.getName()));
                    agent.setPhoneNumber(valueOrDefault(request.getParameter("phone"), user.getPhoneNumber()));
                    agent.setVehicleType(request.getParameter("vehicleType"));
                    agent.setVehicleNumber(request.getParameter("vehicleNumber"));
                    String avail = request.getParameter("availability");
                    agent.setAvailability("true".equals(avail));
                    agentDAO.updateAgent(agent);
                    
                    // Also update the user record
                    user.setName(request.getParameter("name"));
                    user.setPhoneNumber(request.getParameter("phone"));
                    userDAO.updateUser(user);
                }
                response.sendRedirect("driver-dashboard.jsp?msg=Profile+Updated");
            } else if ("markDelivered".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.updateStatus(orderId, "DELIVERED");
                response.sendRedirect("delivery?action=dashboard");
            } else if ("markPickedUp".equals(action)) {
                int orderId = Integer.parseInt(request.getParameter("orderId"));
                orderDAO.updateStatus(orderId, "OUT_FOR_DELIVERY");
                response.sendRedirect("delivery?action=dashboard");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private String valueOrDefault(String value, String fallback) {
        if (value == null || value.trim().isEmpty()) {
            return fallback != null ? fallback : "";
        }
        return value;
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("list".equals(action)) {
                request.setAttribute("agents", agentDAO.getAllAgents());
                request.getRequestDispatcher("agent-list.jsp").forward(request, response);
            } else if ("dashboard".equals(action)) {
                HttpSession session = request.getSession();
                User user = (User) session.getAttribute("user");
                if (user == null || !"DRIVER".equals(user.getRole())) {
                    response.sendRedirect("driver-login.jsp");
                    return;
                }
                
                DeliveryAgent agent = agentDAO.getAgentByUserId(user.getUserId());
                if (agent == null) {
                    // Driver hasn't registered as agent yet
                    response.sendRedirect("driver-dashboard.jsp");
                    return;
                }
                
                // Get all orders for this agent
                List<Order> allOrders = orderDAO.getOrdersByAgent(agent.getAgentId());
                List<Order> pendingOrders = orderDAO.getOrdersByAgentAndStatus(agent.getAgentId(), "OUT_FOR_DELIVERY");
                List<Order> completedOrders = orderDAO.getOrdersByAgentAndStatus(agent.getAgentId(), "DELIVERED");
                
                request.setAttribute("agent", agent);
                request.setAttribute("allOrders", allOrders);
                request.setAttribute("pendingOrders", pendingOrders);
                request.setAttribute("completedOrders", completedOrders);
                request.getRequestDispatcher("driver-dashboard.jsp").forward(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
