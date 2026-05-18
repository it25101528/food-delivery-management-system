<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Kitchen Onboarding — FoodHub</title>
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding: 100px 7vw 140px;">
        <div class="card animate-fadeUp" style="max-width: 650px; margin: 0 auto; border-top: 6px solid var(--brand);">
            <div style="text-align: center; margin-bottom: 48px;">
                <div style="font-size: 64px; margin-bottom: 24px;">🏢</div>
                <h1 class="display-font" style="font-size: 36px;">Kitchen <em>Onboarding</em></h1>
                <p class="text-muted">Introduce your culinary vision to our artisan community</p>
            </div>
            
            <form action="restaurant" method="POST">
                <input type="hidden" name="action" value="add">
                
                <div class="form-group">
                    <label>Kitchen Identity (Name)</label>
                    <input type="text" name="name" class="form-control" placeholder="e.g. The Spiced Saffron" required>
                </div>
                
                <div class="form-group">
                    <label>Signature Cuisine Type</label>
                    <input type="text" name="cuisine" class="form-control" placeholder="e.g. Traditional Sri Lankan, Italian Bistro" required>
                </div>
                
                <div class="form-group">
                    <label>Operating City / Precinct</label>
                    <input type="text" name="location" class="form-control" placeholder="e.g. Colombo 07" required>
                </div>
                
                <div class="form-group">
                    <label>Kitchen Visuals (Image URL)</label>
                    <input type="text" name="imageUrl" class="form-control" placeholder="https://images.unsplash.com/...">
                    <p style="font-size: 11px; color: var(--ink-3); margin-top: 8px; font-style: italic;">Provide a link to a high-quality capture of your space or signature dish.</p>
                </div>

                <div style="margin-top: 40px;">
                    <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; padding: 18px;">Register My Kitchen →</button>
                </div>
            </form>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
