package com.foodhub.model;

public class AdminUser extends User {

    public AdminUser() {
        this.setRole("ADMIN");
    }
    
    public AdminUser(int userId, String name, String email, String password, String phoneNumber, String address) {
        super(userId, name, email, password, phoneNumber, address, "ADMIN", "REGULAR");
    }
}
