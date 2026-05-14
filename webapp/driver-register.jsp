<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <title>Driver Registration - FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700;800&display=swap" rel="stylesheet">
    <style>
        body {
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f172a 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            font-family: 'Inter', sans-serif;
        }
        .register-wrapper {
            width: 100%;
            max-width: 480px;
            padding: 20px;
        }
        .register-card {
            background: rgba(255, 255, 255, 0.05);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255, 255, 255, 0.1);
            border-radius: 24px;
            padding: 44px 40px;
            box-shadow: 0 25px 50px rgba(0, 0, 0, 0.4);
        }
        .register-brand {
            text-align: center;
            margin-bottom: 32px;
        }
        .register-brand .icon {
            width: 64px;
            height: 64px;
            background: linear-gradient(135deg, #3b82f6, #1d4ed8);
            border-radius: 18px;
            display: inline-flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
            margin-bottom: 16px;
            box-shadow: 0 8px 24px rgba(59, 130, 246, 0.4);
        }
        .register-brand h1 {
            font-size: 22px;
            font-weight: 700;
            color: #ffffff;
            margin-bottom: 4px;
        }
        .register-brand h1 span { color: #3b82f6; }
        .register-brand p { color: #94a3b8; font-size: 14px; }

        .register-card .form-group { margin-bottom: 18px; }
        .register-card .form-group label {
            display: block;
            margin-bottom: 7px;
            font-weight: 600;
            font-size: 13px;
            color: #cbd5e1;
            text-transform: uppercase;
            letter-spacing: 0.5px;
        }
        .register-card .form-control {
            width: 100%;
            padding: 13px 16px;
            background: rgba(255, 255, 255, 0.06);
            border: 1px solid rgba(255, 255, 255, 0.12);
            border-radius: 12px;
            color: #f1f5f9;
            font-size: 15px;
            transition: all 0.3s ease;
            outline: none;
        }
        .register-card select.form-control {
            appearance: none;
            -webkit-appearance: none;
            background-image: url("data:image/svg+xml,%3Csvg xmlns='http://www.w3.org/2000/svg' width='12' height='12' fill='%2394a3b8' viewBox='0 0 16 16'%3E%3Cpath d='M8 11L3 6h10z'/%3E%3C/svg%3E");
            background-repeat: no-repeat;
            background-position: right 16px center;
            padding-right: 40px;
        }
        .register-card select.form-control option {
            background: #1e293b;
            color: #f1f5f9;
        }
        .register-card .form-control::placeholder { color: #64748b; }
        .register-card .form-control:focus {
            border-color: #3b82f6;
            box-shadow: 0 0 0 3px rgba(59, 130, 246, 0.15);
            background: rgba(255, 255, 255, 0.08);
        }
        .form-row {
            display: grid;
            grid-template-columns: 1fr 1fr;
            gap: 14px;
        }
        .btn-register {
            width: 100%;
            padding: 14px;
            background: linear-gradient(135deg, #3b82f6, #2563eb);
            color: white;
            border: none;
            border-radius: 12px;
            font-size: 16px;
            font-weight: 700;
            cursor: pointer;
            transition: all 0.3s ease;
            margin-top: 10px;
        }
        .btn-register:hover {
            background: linear-gradient(135deg, #2563eb, #1d4ed8);
            transform: translateY(-2px);
            box-shadow: 0 8px 24px rgba(37, 99, 235, 0.4);
        }
        .login-link {
            text-align: center;
            margin-top: 22px;
            color: #94a3b8;
            font-size: 14px;
        }
        .login-link a { color: #3b82f6; font-weight: 600; text-decoration: none; }
        .login-link a:hover { text-decoration: underline; }
        .back-link {
            display: block;
            text-align: center;
            margin-top: 20px;
            color: #64748b;
            font-size: 13px;
            text-decoration: none;
        }
        .back-link:hover { color: #94a3b8; }

        .step-indicator {
            display: flex;
            justify-content: center;
            gap: 8px;
            margin-bottom: 28px;
        }
        .step-dot {
            width: 36px;
            height: 4px;
            border-radius: 2px;
            background: rgba(255,255,255,0.12);
            transition: all 0.3s;
        }
        .step-dot.active {
            background: #3b82f6;
            width: 48px;
        }
    </style>
</head>
<body>
    <div class="register-wrapper">
        <div class="register-card">
            <div class="register-brand">
                <div class="icon">🚗</div>
                <h1>Join Food<span>Hub</span> Drivers</h1>
                <p>Start earning by delivering food today</p>
            </div>

            <div class="step-indicator">
                <div class="step-dot active"></div>
                <div class="step-dot"></div>
            </div>

            <!-- Step 1: Account Registration (submits to UserServlet) -->
            <form action="user" method="POST">
                <input type="hidden" name="action" value="register">
                <input type="hidden" name="role" value="DRIVER">

                <div class="form-group">
                    <label>Full Name</label>
                    <input type="text" name="name" class="form-control" placeholder="John Doe" required>
                </div>

                <div class="form-group">
                    <label>Email Address</label>
                    <input type="email" name="email" class="form-control" placeholder="driver@email.com" required>
                </div>

                <div class="form-group">
                    <label>Password</label>
                    <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required minlength="6">
                </div>

                <div class="form-row">
                    <div class="form-group">
                        <label>Phone Number</label>
                        <input type="text" name="phone" class="form-control" placeholder="07X XXXX XXX" required>
                    </div>
                    <div class="form-group">
                        <label>City / Area</label>
                        <input type="text" name="address" class="form-control" placeholder="Colombo" required>
                    </div>
                </div>

                <button type="submit" class="btn-register">Create Driver Account</button>
            </form>

            <p class="login-link">
                Already have an account? <a href="driver-login.jsp">Sign In</a>
            </p>
        </div>
        <a href="index.jsp" class="back-link">← Back to FoodHub</a>
    </div>
</body>
</html>
