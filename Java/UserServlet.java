package com.foodhub.mod_customer;

import com.foodhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/user")
public class UserServlet extends HttpServlet {
    private UserDAO userDAO = new UserDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("register".equals(action)) {
                register(request, response);
            } else if ("login".equals(action)) {
                login(request, response);
            } else if ("update".equals(action)) {
                update(request, response);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("logout".equals(action)) {
                request.getSession().invalidate();
                response.sendRedirect("mod_customer/login.jsp");
            } else if ("list".equals(action)) {
                request.setAttribute("customers", userDAO.getAllCustomers());
                request.getRequestDispatcher("mod_customer/customer-list.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                userDAO.deleteUser(Integer.parseInt(request.getParameter("id")));
                response.sendRedirect("user?action=list");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    private void register(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        User user = new User();
        user.setName(request.getParameter("name"));
        user.setEmail(request.getParameter("email"));
        user.setPassword(request.getParameter("password"));
        user.setPhoneNumber(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        String role = request.getParameter("role");
        user.setRole(role != null ? role : "CUSTOMER");
        user.setUserType(request.getParameter("userType"));
        
        userDAO.registerUser(user);
        response.sendRedirect("mod_customer/login.jsp?msg=Registered successfully");
    }

    private void login(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException, ServletException {
        User user = userDAO.authenticate(request.getParameter("email"), request.getParameter("password"));
        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);
            
            // Redirect based on Role
            if ("RESTAURANT".equals(user.getRole())) {
                response.sendRedirect("mod_restaurant/restaurant-dashboard.jsp");
            } else if ("ADMIN".equals(user.getRole())) {
                response.sendRedirect("mod_delivery/admin-dashboard.jsp");
            } else {
                response.sendRedirect("mod_delivery/index.jsp");
            }
        } else {
            request.setAttribute("error", "Invalid email or password");
            // Determine which login page to go back to
            String referer = request.getHeader("Referer");
            if (referer != null && referer.contains("restaurant-login")) {
                request.getRequestDispatcher("mod_restaurant/restaurant-login.jsp").forward(request, response);
            } else {
                request.getRequestDispatcher("mod_customer/login.jsp").forward(request, response);
            }
        }
    }

    private void update(HttpServletRequest request, HttpServletResponse response) throws SQLException, IOException {
        User user = (User) request.getSession().getAttribute("user");
        user.setName(request.getParameter("name"));
        user.setPhoneNumber(request.getParameter("phone"));
        user.setAddress(request.getParameter("address"));
        userDAO.updateUser(user);
        response.sendRedirect("mod_customer/profile.jsp?msg=Updated");
    }
}
