<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Join FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        .auth-container { min-height: 90vh; display: flex; align-items: center; justify-content: center; padding: 60px 7vw; }
        .auth-card { max-width: 680px; width: 100%; border-top: 6px solid var(--brand); padding: 20px; }
        .role-selector { display: grid; grid-template-columns: repeat(3, 1fr); gap: 16px; margin-bottom: 32px; }
        .role-option { 
            border: 2px solid var(--border); 
            padding: 24px 16px; 
            border-radius: var(--radius-md); 
            cursor: pointer; 
            text-align: center; 
            transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1);
            position: relative;
        }
        .role-option:hover { border-color: var(--brand); background: var(--brand-light); transform: translateY(-4px); }
        .role-option.active { 
            border-color: var(--brand); 
            background: var(--brand-light); 
            box-shadow: 0 8px 24px rgba(232, 64, 12, 0.15);
            transform: scale(1.05);
        }
        .role-option.active::after {
            content: '✓';
            position: absolute;
            top: -8px;
            right: -8px;
            background: var(--brand);
            color: #fff;
            width: 24px;
            height: 24px;
            border-radius: 50%;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 12px;
            font-weight: 900;
        }
        .role-option input { display: none; }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="auth-container animate-fadeUp">
        <div class="card auth-card">
            <div style="text-align: center; margin-bottom: 40px;">
                <h1 class="display-font" style="font-size: 32px; margin-bottom: 12px;">Create <em>Account</em></h1>
                <p class="text-muted">Join the Artisan food network today</p>
            </div>
            <form action="user" method="POST">
                <input type="hidden" name="action" value="register">
                
                <div class="form-group">
                    <label>Join as a...</label>
                    <div class="role-selector">
                        <label class="role-option active" id="customerLabel">
                            <input type="radio" name="role" value="CUSTOMER" checked onclick="updateRole('customer')">
                            <div style="font-size: 32px; margin-bottom: 8px;">🍱</div>
                            <div style="font-weight: 800; font-size: 14px;">Customer</div>
                        </label>
                        <label class="role-option" id="restaurantLabel">
                            <input type="radio" name="role" value="RESTAURANT" onclick="updateRole('restaurant')">
                            <div style="font-size: 32px; margin-bottom: 8px;">👨‍🍳</div>
                            <div style="font-weight: 800; font-size: 14px;">Kitchen</div>
                        </label>
                        <label class="role-option" id="driverLabel">
                            <input type="radio" name="role" value="DRIVER" onclick="updateRole('driver')">
                            <div style="font-size: 32px; margin-bottom: 8px;">🛵</div>
                            <div style="font-weight: 800; font-size: 14px;">Courier</div>
                        </label>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 20px;">
                    <div class="form-group">
                        <label>Full Name</label>
                        <input type="text" name="name" class="form-control" placeholder="John Doe" required>
                    </div>
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="phone" class="form-control" placeholder="+94 ..." required>
                    </div>
                </div>
                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                </div>
                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="••••••••" required>
                </div>
                <div class="form-group">
                    <label>Primary Delivery Address</label>
                    <textarea name="address" class="form-control" rows="2" placeholder="Street, City, Postal Code" required></textarea>
                </div>
                
                <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; padding: 18px; margin-top: 12px; background: #B22F06; color: #fff; border: none;">Create My Account</button>
            </form>
            <div style="text-align: center; margin-top: 32px; border-top: 1.5px solid var(--surface); padding-top: 24px;">
                <p class="text-muted">Already a member? <a href="login.jsp" style="color: var(--brand); font-weight: 700; text-decoration: none;">Log In →</a></p>
            </div>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />

    <script>
        function updateRole(role) {
            document.querySelectorAll('.role-option').forEach(opt => opt.classList.remove('active'));
            document.getElementById(role + 'Label').classList.add('active');
        }
    </script>
</body>
</html>
