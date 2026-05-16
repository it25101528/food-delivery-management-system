<%@ page import="com.foodhub.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) { response.sendRedirect("login.jsp"); return; }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding: 80px 7vw 120px;">
        <div class="card animate-fadeUp" style="max-width: 600px; margin: 0 auto; border-radius: var(--radius-lg);">
            <div style="padding: 40px; border-bottom: 1.5px solid var(--surface);">
                <h1 class="display-font" style="font-size: 32px; margin-bottom: 8px;">Edit <em>Account</em></h1>
                <p class="text-muted">Update your personal details for a better experience</p>
            </div>
            
            <div style="padding: 40px;">
                <form action="user" method="POST">
                    <input type="hidden" name="action" value="update">
                    
                    <div class="form-group">
                        <label>Legal Name</label>
                        <input type="text" name="name" class="form-control" value="<%= u.getName() %>" required>
                    </div>

                    <div class="form-group" style="margin-top: 24px;">
                        <label>Contact Number</label>
                        <input type="text" name="phone" class="form-control" value="<%= u.getPhoneNumber() %>" required>
                    </div>

                    <div class="form-group" style="margin-top: 24px;">
                        <label>Saved Address</label>
                        <textarea name="address" class="form-control" style="height: 100px; padding: 16px; resize: none;" required><%= u.getAddress() %></textarea>
                    </div>

                    <div style="margin-top: 40px; display: flex; gap: 16px;">
                        <button type="submit" class="btn btn-primary btn-lg" style="flex: 1;">Save Changes</button>
                        <a href="profile.jsp" class="btn btn-secondary" style="display: flex; align-items: center; justify-content: center; padding: 0 24px;">Cancel</a>
                    </div>
                </form>
            </div>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
