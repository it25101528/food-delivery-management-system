<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Login — FoodHub</title>
        <link rel="stylesheet" href="css/style.css">
        <style>
            .auth-container {
                min-height: 80vh;
                display: flex;
                align-items: center;
                justify-content: center;
                padding: 60px 7vw;
            }

            .auth-card {
                max-width: 620px;
                width: 100%;
                border-top: 6px solid var(--brand);
                padding: 20px;
            }

            .auth-header {
                text-align: center;
                margin-bottom: 40px;
            }
        </style>
    </head>

    <body>
        <jsp:include page="jsp/navbar.jsp" />

        <div class="auth-container animate-fadeUp">
            <div class="card auth-card">
                <div class="auth-header">
                    <h1 class="display-font" style="font-size: 32px; margin-bottom: 12px;">Welcome <em>Back</em></h1>
                    <p class="text-muted">Enter your credentials to access your basket</p>
                </div>
                <% if (request.getParameter("error") !=null) { %>
                    <div class="badge badge-ember"
                        style="width: 100%; padding: 16px; margin-bottom: 32px; text-align: center; border-radius: var(--radius-sm);">
                        ⚠️ <%= request.getParameter("error") %>
                    </div>
                    <% } %>
                        <form action="user" method="POST">
                            <input type="hidden" name="action" value="login">
                            <div class="form-group">
                                <label>Email Address</label>
                                <input type="email" name="email" class="form-control" placeholder="name@example.com"
                                    required>
                            </div>
                            <div class="form-group">
                                <label>Security Key (Password)</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••"
                                    required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg"
                                style="width: 100%; padding: 18px; margin-top: 12px; background: #B22F06; color: #fff; border: none;">Log
                                In to FoodHub</button>
                        </form>
                        <div
                            style="text-align: center; margin-top: 32px; border-top: 1.5px solid var(--surface); padding-top: 24px;">
                            <p class="text-muted">Don't have an account? <a href="register.jsp"
                                    style="color: var(--brand); font-weight: 700; text-decoration: none;">Create One
                                    →</a></p>
                        </div>
                        <div style="margin-top: 32px; border-top: 1.5px solid var(--surface); padding-top: 24px;">
                            <p style="font-size: 13px; color: var(--ink-3); text-align: center; margin-bottom: 16px;">
                                Are you a delivery or kitchen partner?</p>
                            <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 12px;">
                                <a href="restaurant-login.jsp" class="btn btn-ghost"
                                    style="font-size: 13px; padding: 12px;">👨‍🍳 Kitchen Login</a>
                                <a href="driver-login.jsp" class="btn btn-ghost"
                                    style="font-size: 13px; padding: 12px;">🛵 Driver Login</a>
                            </div>
                        </div>
            </div>
        </div>

        <jsp:include page="jsp/footer.jsp" />
    </body>

    </html>
