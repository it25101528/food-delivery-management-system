<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Login - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container" style="max-width: 450px;">
        <div class="card" style="padding: 40px;">
            <h2 style="text-align: center; margin-bottom: 20px;">Welcome Back</h2>
            
            <% if (request.getAttribute("error") != null) { %>
                <p style="color: red; text-align: center;"><%= request.getAttribute("error") %></p>
            <% } %>

            <form action="../user" method="POST">
                <input type="hidden" name="action" value="login">
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" required>
                </div>
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">Log In</button>
            </form>
            <p style="text-align: center; margin-top: 20px;">
                Don't have an account? <a href="register.jsp">Sign Up</a>
            </p>
        </div>
    </div>
</body>
</html>
