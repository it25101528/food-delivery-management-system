package com.foodhub.model;

/**
 * Represents a signature dish in the FoodHub ecosystem.
 */
public class MenuItem {
    private int id;
    private int restaurantId;
    private String name;
    private String description;
    private double price;
    private String imagePath;
    private boolean availability;
    private String category;

    public MenuItem() {}

    public MenuItem(int id, int restaurantId, String name, double price, boolean availability, String category) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.name = name;
        this.price = price;
        this.availability = availability;
        this.category = category;
        this.description = ""; // Default empty
        this.imagePath = "";   // Default empty
    }

    public MenuItem(int id, int restaurantId, String name, String description, double price, String imagePath, boolean availability, String category) {
        this.id = id;
        this.restaurantId = restaurantId;
        this.name = name;
        this.description = description;
        this.price = price;
        this.imagePath = imagePath;
        this.availability = availability;
        this.category = category;
    }

    // Getters and Setters
    public int getId() { return id; }
    public void setId(int id) { this.id = id; }

    public int getRestaurantId() { return restaurantId; }
    public void setRestaurantId(int restaurantId) { this.restaurantId = restaurantId; }

    public String getName() { return name; }
    public void setName(String name) { this.name = name; }

    public String getDescription() { return description; }
    public void setDescription(String description) { this.description = description; }

    public double getPrice() { return price; }
    public void setPrice(double price) { this.price = price; }

    public String getImagePath() { return imagePath; }
    public void setImagePath(String imagePath) { this.imagePath = imagePath; }

    public boolean isAvailability() { return availability; }
    public boolean getAvailability() { return availability; } // Standard getter for EL compatibility
    public void setAvailability(boolean availability) { this.availability = availability; }

    public String getCategory() { return category; }
    public void setCategory(String category) { this.category = category; }

    /**
     * Helper for display purposes.
     */
    public String getDisplayLabel() {
        return name + " — " + category;
    }
}
