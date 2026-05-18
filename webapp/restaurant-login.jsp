<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>Kitchen Login — FoodHub</title>
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
            }
        </style>
    </head>

    <body>
        <jsp:include page="jsp/navbar.jsp" />

        <div class="auth-container animate-fadeUp">
            <div class="card auth-card">
                <div style="text-align: center; margin-bottom: 40px;">
                    <div style="font-size: 48px; margin-bottom: 16px;">🍳</div>
                    <h1 class="display-font" style="font-size: 32px; margin-bottom: 12px;">Kitchen <em>Login</em></h1>
                    <p class="text-muted">Manage your kitchen and orders</p>
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
                                <input type="email" name="email" class="form-control" placeholder="kitchen@foodhub.com"
                                    required>
                            </div>
                            <div class="form-group">
                                <label>Security Key</label>
                                <input type="password" name="password" class="form-control" placeholder="••••••••"
                                    required>
                            </div>
                            <button type="submit" class="btn btn-primary btn-lg"
                                style="width: 100%; padding: 18px; margin-top: 12px; background: #B22F06; color: #fff; border: none;">Login
                                as Partner</button>
                        </form>
                        <div
                            style="text-align: center; margin-top: 32px; border-top: 1.5px solid var(--surface); padding-top: 24px;">
                            <p class="text-muted">Want to join us? <a href="register.jsp"
                                    style="color: var(--brand); font-weight: 700; text-decoration: none;">Register
                                    Kitchen →</a></p>
                        </div>
            </div>
        </div>

        <jsp:include page="jsp/footer.jsp" />
    </body>

    </html>