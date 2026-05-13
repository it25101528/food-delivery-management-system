<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>FoodHub – Fast Delivery</title>
    <link rel="stylesheet" href="../css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <section class="hero">
        <div class="hero-text">
            <h1>Delicious food delivered to your door</h1>
            <p>Order from the best restaurants in your city. Quick, easy, and fresh.</p>
            <div style="margin-top: 30px;">
                <a href="../restaurant?action=list" class="btn btn-primary" style="padding:15px 40px; font-size:18px;">Browse Restaurants</a>
            </div>
        </div>
        <div class="hero-image">
            <img src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=900&q=80" alt="Food">
        </div>
    </section>

    <div class="container">
        <h2>Why choose FoodHub?</h2>
        <div style="display:grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-top:30px;">
            <div class="card" style="padding:20px;">
                <h3>Fast Delivery</h3>
                <p>We deliver in less than 30 minutes.</p>
            </div>
            <div class="card" style="padding:20px;">
                <h3>Top Quality</h3>
                <p>Only the best restaurants are partnered with us.</p>
            </div>
            <div class="card" style="padding:20px;">
                <h3>Best Prices</h3>
                <p>Enjoy exclusive discounts and offers.</p>
            </div>
        </div>
    </div>
</body>
</html>
