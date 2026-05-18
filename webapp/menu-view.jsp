<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.Restaurant" %>
<%@ page import="com.foodhub.model.MenuItem" %>
<%@ page import="com.foodhub.model.Review" %>
<%@ page import="java.util.List" %>
<%@ page import="java.util.ArrayList" %>
<%
    // Safety check for restaurant data
    Restaurant r = (Restaurant) request.getAttribute("restaurant");
    if (r == null) {
        response.sendRedirect("restaurant?action=list");
        return;
    }
    
    // Ensure lists are initialized
    List<MenuItem> menu = (List<MenuItem>) request.getAttribute("menu");
    if (menu == null) menu = new ArrayList<>();
    
    List<Review> reviews = (List<Review>) request.getAttribute("reviews");
    if (reviews == null) reviews = new ArrayList<>();
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title><%= r.getName() %> — FoodHub</title>
    <link rel="stylesheet" href="css/style.css?v=1.2">
    <style>
        .menu-hero { background: var(--ink); color: #fff; padding: 100px 7vw 80px; position: relative; overflow: hidden; }
        .menu-hero::before { content: ''; position: absolute; inset: 0; background: radial-gradient(circle at 70% 50%, var(--brand) 0%, transparent 70%); opacity: 0.25; }
        .menu-layout { display: grid; grid-template-columns: 1fr 380px; gap: 48px; margin-top: 60px; align-items: start; }
        
        .menu-item-card { display: flex; align-items: center; gap: 24px; padding: 24px; border-radius: var(--radius-md); background: #fff; border: 1px solid var(--border); transition: all 0.3s cubic-bezier(0.4, 0, 0.2, 1); margin-bottom: 24px; }
        .menu-item-card:hover { transform: translateY(-4px); box-shadow: var(--shadow); border-color: var(--brand); }
        .item-image { width: 120px; height: 120px; border-radius: var(--radius-sm); object-fit: cover; background: var(--surface); }
        
        .sticky-sidebar { position: sticky; top: 100px; }
        .empty-placeholder { text-align: center; padding: 80px 0; background: #fff; border-radius: var(--radius-md); border: 1.5px dashed var(--border); }
        
        @media (max-width: 1024px) {
            .menu-layout { grid-template-columns: 1fr; }
            .sticky-sidebar { position: static; }
        }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <header class="menu-hero animate-fadeIn">
        <div class="container" style="position: relative; z-index: 2; display: flex; align-items: center; gap: 48px; flex-wrap: wrap;">
            <img src="https://images.unsplash.com/photo-1550547660-d9450f859349?auto=format&fit=crop&w=300&q=80" alt="<%= r.getName() %>" style="width: 160px; height: 160px; border-radius: 80px; border: 5px solid rgba(255,255,255,0.1); object-fit: cover;">
            <div>
                <h1 style="font-size: 52px; margin-bottom: 12px; line-height: 1;"><%= r.getName() %></h1>
                <p style="color: var(--ink-3); font-size: 18px;"><%= r.getCuisine() %> • 📍 <%= r.getLocation() %></p>
                <div style="display: flex; gap: 20px; margin-top: 28px;">
                    <span class="badge badge-ember" style="padding: 10px 20px; font-size: 13px;">4.8 ★ Exceptional</span>
                    <span style="font-weight: 700; display: flex; align-items: center; gap: 8px; color: #fff;">🛵 25-30 min delivery</span>
                </div>
            </div>
        </div>
    </header>

    <div class="container menu-layout">
        <main class="animate-fadeUp">
            <h2 class="display-font" style="font-size: 32px; margin-bottom: 36px;">Kitchen <em>Signature</em> Menu</h2>
            
            <% if (!menu.isEmpty()) {
                for (MenuItem item : menu) { %>
                <div class="menu-item-card">
                    <img src="<%= (item.getImagePath() != null && !item.getImagePath().isEmpty()) ? item.getImagePath() : "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80" %>" 
                         alt="<%= item.getName() %>" class="item-image">
                    <div style="flex: 1;">
                        <h3 style="font-size: 20px; margin-bottom: 6px;"><%= item.getName() %></h3>
                        <p class="text-muted" style="font-size: 14px; margin-bottom: 20px; line-height: 1.4;">
                            <%= (item.getDescription() != null && !item.getDescription().isEmpty()) ? item.getDescription() : "Crafted with artisanal care using premium local ingredients." %>
                        </p>
                        <div style="display: flex; justify-content: space-between; align-items: center;">
                            <span style="font-family: var(--font-display); font-weight: 900; font-size: 22px; color: var(--ink);">$<%= String.format("%.2f", item.getPrice()) %></span>
                            <button class="btn btn-primary btn-sm" 
                                    onclick="addToCart(<%= item.getId() %>, this.dataset.name, <%= item.getPrice() %>, <%= r.getId() %>)"
                                    data-name="<%= item.getName().replace("\"", "&quot;") %>">
                                Add to Basket
                            </button>
                        </div>
                    </div>
                </div>
            <% } } else { %>
                <div class="empty-placeholder">
                    <div style="font-size: 64px; margin-bottom: 24px;">🥘</div>
                    <h3 class="display-font" style="font-size: 24px;">Menu coming soon</h3>
                    <p class="text-muted">This kitchen is currently preparing their artisanal selection.</p>
                </div>
            <% } %>
        </main>

        <aside class="sticky-sidebar animate-fadeUp" style="animation-delay: 0.2s;">
            <div class="card" style="padding: 32px; border-radius: var(--radius-lg);">
                <h3 class="display-font" style="font-size: 24px; margin-bottom: 28px; display: flex; justify-content: space-between; align-items: center;">
                    Your Basket <span id="cart-count-sidebar" class="badge badge-ember">0</span>
                </h3>
                
                <div id="cart-items-sidebar" style="max-height: 400px; overflow-y: auto; margin-bottom: 28px;">
                    <p class="text-muted" style="text-align: center; padding: 40px 0;">Your basket is empty</p>
                </div>
                
                <div style="border-top: 1.5px solid var(--surface); padding-top: 24px;">
                    <div style="display: flex; justify-content: space-between; margin-bottom: 20px; font-weight: 800; font-size: 20px; font-family: var(--font-display);">
                        <span>Subtotal</span>
                        <span id="cart-subtotal">$0.00</span>
                    </div>
                    <a href="cart.jsp" id="checkout-btn" class="btn btn-primary" 
                       style="width: 100%; padding: 18px; opacity: 0.5; pointer-events: none; transition: all 0.3s; box-shadow: 0 4px 15px rgba(232, 64, 12, 0.2);">
                        Proceed to Checkout →
                    </a>
                </div>
            </div>
        </aside>
    </div>

    <section class="section animate-fadeUp" style="padding-top: 40px; border-top: 1px solid var(--border); margin-top: 80px;">
        <div class="container" style="max-width: 1000px;">
            <div style="display: flex; justify-content: space-between; align-items: flex-end; margin-bottom: 48px;">
                <div>
                    <h2 class="display-font" style="font-size: 32px; margin-bottom: 8px;">Community <em>Feedback</em></h2>
                    <p class="text-muted">Real reviews from verified diners.</p>
                </div>
                <div style="text-align: right;">
                    <div style="font-size: 42px; font-weight: 900; line-height: 1;"><%= String.format("%.1f", r.getRating()) %></div>
                    <div style="color: #facc15; font-size: 18px; margin-top: 4px;">★★★★★</div>
                </div>
            </div>

            <% if (!reviews.isEmpty()) { %>
                <div class="reviews-grid" style="display: grid; grid-template-columns: 1fr; gap: 24px;">
                    <% for (Review review : reviews) { %>
                        <div class="card" style="padding: 24px; border-radius: var(--radius-md);">
                            <div style="display: flex; justify-content: space-between; margin-bottom: 12px;">
                                <div style="display: flex; align-items: center; gap: 12px;">
                                    <div style="width: 40px; height: 40px; background: var(--brand-light); color: var(--brand); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-weight: 800; font-size: 14px;">
                                        <%= (review.getUserName() != null && !review.getUserName().isEmpty()) ? review.getUserName().substring(0,1).toUpperCase() : "U" %>
                                    </div>
                                    <div>
                                        <div style="font-weight: 700; font-size: 15px;"><%= review.getUserName() %></div>
                                        <div style="color: #facc15; font-size: 12px;">
                                            <% for(int i=0; i<review.getRating(); i++) { %>★<% } %>
                                        </div>
                                    </div>
                                </div>
                                <span class="text-muted" style="font-size: 12px;">
                                    <%= new java.text.SimpleDateFormat("MMM dd, yyyy").format(review.getReviewDate()) %>
                                </span>
                            </div>
                            <p style="font-size: 15px; color: var(--ink-2); line-height: 1.6;">
                                "<%= review.getComment() %>"
                            </p>
                        </div>
                    <% } %>
                </div>
            <% } else { %>
                <div class="empty-placeholder" style="padding: 60px 0;">
                    <div style="font-size: 48px; margin-bottom: 16px;">⭐</div>
                    <h3 style="font-size: 18px; font-weight: 700;">No reviews yet</h3>
                    <p class="text-muted">Be the first to share your experience after ordering!</p>
                </div>
            <% } %>
        </div>
    </section>

    <jsp:include page="jsp/footer.jsp" />

    <script src="js/cart.js?v=1.2"></script>
    <script>
        /**
         * Updates the sidebar UI to reflect current cart state.
         * Safe to call repeatedly.
         */
        function updateCartUI() {
            try {
                const cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
                const container = document.getElementById('cart-items-sidebar');
                const countEl = document.getElementById('cart-count-sidebar');
                const subtotalEl = document.getElementById('cart-subtotal');
                const checkoutBtn = document.getElementById('checkout-btn');
                
                // Update total count
                const totalItems = cart.reduce((sum, item) => sum + item.quantity, 0);
                countEl.innerText = totalItems;
                
                if (cart.length === 0) {
                    container.innerHTML = '<p class="text-muted" style="text-align: center; padding: 40px 0;">Your basket is empty</p>';
                    subtotalEl.innerText = '$0.00';
                    checkoutBtn.style.opacity = '0.5';
                    checkoutBtn.style.pointerEvents = 'none';
                    return;
                }
                
                // Enable checkout button
                checkoutBtn.style.opacity = '1';
                checkoutBtn.style.pointerEvents = 'all';
                
                let subtotal = 0;
                container.innerHTML = cart.map(item => {
                    subtotal += item.price * item.quantity;
                    return `<div style="display: flex; justify-content: space-between; margin-bottom: 18px; font-size: 15px; border-bottom: 1px solid var(--surface); padding-bottom: 12px;">
                        <div><span style="font-weight: 800; color: var(--brand); margin-right: 8px;">\${item.quantity}×</span> \${item.name}</div>
                        <div style="font-weight: 600;">$\${(item.price * item.quantity).toFixed(2)}</div>
                    </div>`;
                }).join('');
                
                subtotalEl.innerText = '$' + subtotal.toFixed(2);
                
            } catch (error) {
                console.error("Cart UI Refresh Failed:", error);
            }
        }
        
        // Event Listeners for seamless updates
        document.addEventListener('DOMContentLoaded', updateCartUI);
        window.addEventListener('storage', updateCartUI);
        window.addEventListener('cartUpdated', () => {
            try { updateCartUI(); } catch(e) { console.warn(e); }
        });
    </script>
</body>
</html>
