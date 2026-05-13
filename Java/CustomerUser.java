package com.foodhub.model;

public class CustomerUser extends User {
    public CustomerUser() {
        this.setRole("CUSTOMER");
    }

    public CustomerUser(int userId, String name, String email, String password, String phoneNumber, String address, String userType) {
        super(userId, name, email, password, phoneNumber, address, "CUSTOMER", userType);
    }
}
