package com.foodhub.model;

import java.util.Date;
import java.util.List;
import java.util.ArrayList;

public class Order {
    private int orderId;
    private int userId;
    private int restaurantId;
    private double totalPrice;
    private String orderStatus;
    private String orderType;
    private int deliveryAgentId;
    private double deliveryCharge;
    private Date orderDate;
    private List<OrderItem> items = new ArrayList<>();

    public Order() {}

    // Getters and Setters
    public List<OrderItem> getItems() { return items; }
    public void setItems(List<OrderItem> items) { this.items = items; }
    public int getOrderId() { return orderId; }
    public void setOrderId(int orderId) { this.orderId = orderId; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }
    public double getTotalPrice() { return totalPrice; }
    public void setTotalPrice(double totalPrice) { this.totalPrice = totalPrice; }
    public String getOrderStatus() { return orderStatus; }
    public void setOrderStatus(String orderStatus) { this.orderStatus = orderStatus; }
    public String getOrderType() { return orderType; }
    public void setOrderType(String orderType) { this.orderType = orderType; }
    public int getDeliveryAgentId() { return deliveryAgentId; }
    public void setDeliveryAgentId(int deliveryAgentId) { this.deliveryAgentId = deliveryAgentId; }
    public Date getOrderDate() { return orderDate; }
    public void setOrderDate(Date orderDate) { this.orderDate = orderDate; }
    public double getDeliveryCharge() { return deliveryCharge; }
    public void setDeliveryCharge(double deliveryCharge) { this.deliveryCharge = deliveryCharge; }
}
