package com.foodhub.model;

public class RestaurantUser extends User {
    public RestaurantUser() {
        this.setRole("RESTAURANT");
    }

    public RestaurantUser(int userId, String name, String email, String password, String phoneNumber, String address) {
        super(userId, name, email, password, phoneNumber, address, "RESTAURANT", "REGULAR");
    }
}
