package com.foodhub.model;

public class DriverUser extends User {
    public DriverUser() {
        this.setRole("DRIVER");
    }

    public DriverUser(int userId, String name, String email, String password, String phoneNumber, String address) {
        super(userId, name, email, password, phoneNumber, address, "DRIVER", "REGULAR");
    }
}
