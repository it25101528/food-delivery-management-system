package com.foodhub.model;

public class DeliveryAgent {
    private int agentId;
    private String name;
    private String phoneNumber;
    private String vehicleType;
    private String vehicleNumber;
    private boolean availability; // Using boolean as per your database
    private int userId; // Links to user account for login

    public DeliveryAgent() {}

    public DeliveryAgent(int agentId, String name, String phoneNumber, String vehicleType, String vehicleNumber, boolean availability) {
        this.agentId = agentId;
        this.name = name;
        this.phoneNumber = phoneNumber;
        this.vehicleType = vehicleType;
        this.vehicleNumber = vehicleNumber;
        this.availability = availability;
    }

    // Getters and Setters
    public int getAgentId() { return agentId; }
    public void setAgentId(int agentId) { this.agentId = agentId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getVehicleType() { return vehicleType; }
    public void setVehicleType(String vehicleType) { this.vehicleType = vehicleType; }
    public String getVehicleNumber() { return vehicleNumber; }
    public void setVehicleNumber(String vehicleNumber) { this.vehicleNumber = vehicleNumber; }
    public boolean isAvailability() { return availability; }
    public void setAvailability(boolean availability) { this.availability = availability; }
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
}
