package com.foodhub.model;

public class Restaurant {
    private int id;
    private String name;
    private String location;
    private String cuisine;
    private int ownerId;
    private double rating;

    public Restaurant() {
    }

    public Restaurant(int id, String name, String location, String cuisine, int ownerId, double rating) {
        this.id = id;
        this.name = name;
        this.location = location;
        this.cuisine = cuisine;
        this.ownerId = ownerId;
        this.rating = rating;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getLocation() {
        return location;
    }

    public void setLocation(String location) {
        this.location = location;
    }

    public String getCuisine() {
        return cuisine;
    }

    public void setCuisine(String cuisine) {
        this.cuisine = cuisine;
    }

    public int getOwnerId() {
        return ownerId;
    }

    public void setOwnerId(int ownerId) {
        this.ownerId = ownerId;
    }

    public double getRating() {
        return rating;
    }

    public void setRating(double rating) {
        this.rating = rating;
    }
}
