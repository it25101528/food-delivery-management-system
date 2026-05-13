<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Register Agent - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container" style="max-width: 500px;">
        <div class="card" style="padding: 40px;">
            <div style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 30px;">
                <h1>Register Agent</h1>
                <a href="admin-dashboard.jsp" class="btn btn-secondary">Cancel</a>
            </div>

            <form action="../delivery" method="POST">
                <input type="hidden" name="action" value="register">
                <div class="form-group">
                    <label>Agent Name</label>
                    <input type="text" name="name" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Phone Number</label>
                    <input type="text" name="phone" class="form-control" required>
                </div>
                <div class="form-group">
                    <label>Vehicle Type</label>
                    <select name="vehicleType" class="form-control">
                        <option value="BIKE">Bike (Fast/Small Orders)</option>
                        <option value="CAR">Car (Large/Premium Orders)</option>
                    </select>
                </div>
                
                <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 20px;">Register Agent</button>
            </form>
        </div>
    </div>
</body>
</html>
