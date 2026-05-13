<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Sign Up - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container" style="max-width: 500px;">
        <div class="card" style="padding: 40px;">
            <h2 style="text-align: center; margin-bottom: 20px;">Create Account</h2>
            
            <form action="../user" method="POST">
                <input type="hidden" name="action" value="register">
                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Address</label>
                    <textarea name="address" class="form-control" required></textarea>
                </div>
                <div class="form-group">
                    <label>I want to join as</label>
                    <select name="role" class="form-control">
                        <option value="CUSTOMER">Customer</option>
                        <option value="RESTAURANT">Restaurant Partner</option>
                        <option value="DRIVER">Delivery Agent</option>
                    </select>
                </div>
                <div class="form-group">
                    <label>Membership Type</label>
                    <select name="userType" class="form-control">
                        <option value="REGULAR">Regular (5% Discount)</option>
                        <option value="PREMIUM">Premium (15% Discount)</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">Register</button>
            </form>
        </div>
    </div>
</body>
</html>
