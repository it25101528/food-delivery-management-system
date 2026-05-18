package com.foodhub.servlet;

import com.foodhub.dao.RestaurantDAO;
import com.foodhub.dao.ReviewDAO;
import com.foodhub.model.Restaurant;
import com.foodhub.model.MenuItem;
import com.foodhub.model.User;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/restaurant")
public class RestaurantServlet extends HttpServlet {
    private RestaurantDAO restaurantDAO = new RestaurantDAO();

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("add".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user == null) {
                    response.sendRedirect("login.jsp");
                    return;
                }
                
                Restaurant r = new Restaurant();
                r.setName(request.getParameter("name"));
                r.setLocation(request.getParameter("location"));
                r.setCuisine(request.getParameter("cuisine"));
                r.setOwnerId(user.getUserId()); // Link to the current logged-in admin/owner
                
                restaurantDAO.addRestaurant(r);
                response.sendRedirect("restaurant?action=list");
            } else if ("addMenuItem".equals(action)) {
                int resId = Integer.parseInt(request.getParameter("restaurantId"));
                User user = (User) request.getSession().getAttribute("user");
                Restaurant res = restaurantDAO.getRestaurantById(resId);
                
                // Security check
                if (user == null || (!"ADMIN".equals(user.getRole()) && (res == null || res.getOwnerId() != user.getUserId()))) {
                    response.sendRedirect("login.jsp?error=Unauthorized");
                    return;
                }

                MenuItem item = new MenuItem();
                item.setRestaurantId(resId);
                item.setName(request.getParameter("name"));
                item.setPrice(Double.parseDouble(request.getParameter("price")));
                item.setCategory(request.getParameter("category"));
                item.setAvailability(true);
                restaurantDAO.addMenuItem(item);
                response.sendRedirect("restaurant?action=menu&id=" + resId);
            } else if ("updatePrice".equals(action)) {
                int resId = Integer.parseInt(request.getParameter("restaurantId"));
                User user = (User) request.getSession().getAttribute("user");
                Restaurant res = restaurantDAO.getRestaurantById(resId);

                // Security check
                if (user == null || (!"ADMIN".equals(user.getRole()) && (res == null || res.getOwnerId() != user.getUserId()))) {
                    response.sendRedirect("login.jsp?error=Unauthorized");
                    return;
                }

                int itemId = Integer.parseInt(request.getParameter("itemId"));
                double price = Double.parseDouble(request.getParameter("price"));
                
                restaurantDAO.updateMenuItemPrice(itemId, price);
                response.sendRedirect("restaurant?action=menu&id=" + resId);
            } else if ("deleteMenuItem".equals(action)) {
                int resId = Integer.parseInt(request.getParameter("restaurantId"));
                User user = (User) request.getSession().getAttribute("user");
                Restaurant res = restaurantDAO.getRestaurantById(resId);
                
                // Security check
                if (user == null || (!"ADMIN".equals(user.getRole()) && (res == null || res.getOwnerId() != user.getUserId()))) {
                    response.sendRedirect("login.jsp?error=Unauthorized");
                    return;
                }
                
                int itemId = Integer.parseInt(request.getParameter("itemId"));
                restaurantDAO.deleteMenuItem(itemId);
                response.sendRedirect("restaurant?action=menu&id=" + resId);
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");
        try {
            if ("list".equals(action)) {
                request.setAttribute("restaurants", restaurantDAO.getAllRestaurants());
                User user = (User) request.getSession().getAttribute("user");
                if (user != null && "ADMIN".equals(user.getRole())) {
                    request.getRequestDispatcher("kitchen-audit.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("restaurant-list.jsp").forward(request, response);
                }
            } else if ("menu".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                request.setAttribute("restaurant", restaurantDAO.getRestaurantById(id));
                request.setAttribute("menu", restaurantDAO.getMenuByRestaurant(id));
                
                ReviewDAO reviewDAO = new ReviewDAO();
                request.setAttribute("reviews", reviewDAO.getReviewsByRestaurant(id));
                
                User user = (User) request.getSession().getAttribute("user");
                if (user != null && "CUSTOMER".equals(user.getRole())) {
                    request.getRequestDispatcher("menu-view.jsp").forward(request, response);
                } else {
                    request.getRequestDispatcher("menu-manage.jsp").forward(request, response);
                }
            } else if ("search".equals(action)) {
                String query = request.getParameter("query");
                request.setAttribute("restaurants", restaurantDAO.searchRestaurants(query));
                request.setAttribute("activeQuery", query);
                request.getRequestDispatcher("restaurant-list.jsp").forward(request, response);
            } else if ("delete".equals(action)) {
                User user = (User) request.getSession().getAttribute("user");
                if (user != null && "ADMIN".equals(user.getRole())) {
                    restaurantDAO.deleteRestaurant(Integer.parseInt(request.getParameter("id")));
                }
                response.sendRedirect("restaurant?action=list");
            }
        } catch (SQLException e) {
            throw new ServletException(e);
        }
    }
}
