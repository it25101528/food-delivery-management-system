<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <title>Driver Registration — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <style>
        body { display: flex; align-items: center; justify-content: center; min-height: 100vh; }
        .register-wrapper { width: 100%; max-width: 460px; padding: 20px; }
        .register-card { background: var(--bg-glass); backdrop-filter: blur(20px); border: 1px solid var(--border); border-radius: var(--r-xl); padding: 40px 36px; box-shadow: var(--shadow); }
        .register-brand { text-align: center; margin-bottom: 28px; }
        .register-brand .icon { width: 60px; height: 60px; background: linear-gradient(135deg, var(--accent), var(--accent2)); border-radius: 16px; display: inline-flex; align-items: center; justify-content: center; font-size: 26px; margin-bottom: 14px; box-shadow: 0 8px 24px rgba(255,107,53,0.3); }
        .register-brand h1 { font-size: 22px; margin-bottom: 4px; }
        .register-brand p { color: var(--text2); font-size: 14px; }
        .form-row { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; }
        .step-indicator { display: flex; justify-content: center; gap: 8px; margin-bottom: 24px; }
        .step-dot { width: 36px; height: 4px; border-radius: 2px; background: var(--border); transition: all 0.3s; }
        .step-dot.active { background: var(--accent); width: 48px; }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <div class="register-card animate-scaleIn">
            <div class="register-brand">
                <div class="icon">🚗</div>
                <h1>Join Food<span style="color: var(--accent);">Hub</span> Drivers</h1>
                <p>Start earning by delivering food today</p>
            </div>
            <div class="step-indicator"><div class="step-dot active"></div><div class="step-dot"></div></div>
            <form action="user" method="POST">
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="role" value="DRIVER">
                <div class="form-group"><label>Full Name</label><input type="text" name="name" class="form-control" placeholder="John Doe" required></div>
                <div class="form-group"><label>Email Address</label><input type="email" name="email" class="form-control" placeholder="driver@email.com" required></div>
                <div class="form-group"><label>Password</label><input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required minlength="6"></div>
                <div class="form-row">
                    <div class="form-group"><label>Phone Number</label><input type="text" name="phone" class="form-control" placeholder="07X XXXX XXX" required></div>
                    <div class="form-group"><label>City / Area</label><input type="text" name="address" class="form-control" placeholder="Colombo" required></div>
                </div>
                <button type="submit" class="btn btn-ember" style="width: 100%; padding: 14px; font-size: 16px; margin-top: 8px;">Create Driver Account →</button>
            </form>
            <p style="text-align: center; color: var(--text2); font-size: 14px; margin-top: 20px;">Already have an account? <a href="driver-login.jsp" style="color: var(--accent); font-weight: 600; text-decoration: none;">Sign In</a></p>
        </div>
        <a href="index.jsp" style="display: block; text-align: center; margin-top: 18px; color: var(--muted); font-size: 13px; text-decoration: none;">← Back to FoodHub</a>
    </div>
</body>
</html>
