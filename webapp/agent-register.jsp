<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Courier Enrolment — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding: 100px 7vw 140px;">
        <div class="card animate-fadeUp" style="max-width: 600px; margin: 0 auto; border-top: 6px solid var(--brand);">
            <div style="text-align: center; margin-bottom: 48px;">
                <div style="font-size: 64px; margin-bottom: 24px;">🛵</div>
                <h1 class="display-font" style="font-size: 36px;">Courier <em>Enrolment</em></h1>
                <p class="text-muted">Apply to join our master logistics fleet</p>
            </div>
            
            <form action="delivery" method="POST">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label>Legal Identification Name</label>
                    <input type="text" name="name" class="form-control" placeholder="Full name as on ID" required>
                </div>
                
                <div class="form-group">
                    <label>Primary Contact (Phone)</label>
                    <input type="text" name="phone" class="form-control" placeholder="+94 ..." required>
                </div>

                <div class="form-group">
                    <label>Logistics Vehicle Selection</label>
                    <select name="vehicleType" class="form-control">
                        <option value="BIKE">🏍️ Motorbike (Agile & Swift)</option>
                        <option value="CAR">🚗 Standard Vehicle (Secure & Large)</option>
                        <option value="VAN">🚐 Transport Van (Bulk Dispatch)</option>
                    </select>
                </div>

                <div style="margin-top: 40px;">
                    <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; padding: 18px;">Submit Application</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
