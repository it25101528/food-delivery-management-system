package com.foodhub.model;

public class User {
    private int userId;
    private String name;
    private String email;
    private String password;
    private String phoneNumber;
    private String address;
    private String role;
    private String userType;

    public User() {

    }

    public User(int userId, String name, String email, String password, String phoneNumber, String address, String role, String userType) {
        this.userId = userId;
        this.name = name;
        this.email = email;
        this.password = password;
        this.phoneNumber = phoneNumber;
        this.address = address;
        this.role = role;
        this.userType = userType;
    }

    // Getters and Setters
    public int getUserId() { return userId; }
    public void setUserId(int userId) { this.userId = userId; }
    public String getName() { return name; }
    public void setName(String name) { this.name = name; }
    public String getEmail() { return email; }
    public void setEmail(String email) { this.email = email; }
    public String getPassword() { return password; }
    public void setPassword(String password) { this.password = password; }
    public String getPhoneNumber() { return phoneNumber; }
    public void setPhoneNumber(String phoneNumber) { this.phoneNumber = phoneNumber; }
    public String getAddress() { return address; }
    public void setAddress(String address) { this.address = address; }
    public String getRole() { return role; }
    public void setRole(String role) { this.role = role; }
    public String getUserType() { return userType; }
    public void setUserType(String userType) { this.userType = userType; }

    // Polymorphism demo: Discount logic
    public double calculateDiscount(double amount) {
        return 0; // Default no discount
    }
}
