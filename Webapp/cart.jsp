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
    <title>Your Basket — FoodHub</title>
    <link rel="stylesheet" href="css/style.css?v=1.2">
    <style>
        .cart-layout { display: grid; grid-template-columns: 1fr 420px; gap: 48px; margin-top: 60px; align-items: start; }
        .cart-item { display: flex; align-items: center; gap: 24px; padding: 28px 0; border-bottom: 1.5px solid var(--surface); transition: all 0.3s; }
        .cart-item:last-child { border-bottom: none; }
        
        .qty-controls { display: flex; align-items: center; gap: 16px; background: var(--surface); padding: 6px 12px; border-radius: 100px; border: 1.5px solid var(--border); }
        .qty-btn { width: 32px; height: 32px; border-radius: 50%; border: none; background: #fff; cursor: pointer; font-weight: 800; transition: all 0.2s; box-shadow: 0 2px 8px rgba(0,0,0,0.05); color: var(--ink); display: flex; align-items: center; justify-content: center; font-size: 18px; }
        .qty-btn:hover { background: var(--brand); color: #fff; transform: scale(1.1); }
        
        .summary-card { position: sticky; top: 100px; padding: 40px; border-radius: var(--radius-lg); }
        
        @media (max-width: 1024px) {
            .cart-layout { grid-template-columns: 1fr; }
            .summary-card { position: static; margin-top: 40px; }
        }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="container" style="padding-top: 80px; padding-bottom: 120px;">
        <header class="animate-fadeIn" style="margin-bottom: 60px;">
            <span class="badge badge-ember" style="margin-bottom: 16px;">YOUR SELECTION</span>
            <h1 style="font-size: 48px; line-height: 1;">Your <em>Basket</em></h1>
            <p class="text-muted" style="font-size: 18px; margin-top: 8px;">Review your choices before we begin the craft.</p>
        </header>

        <div class="cart-layout">
            <div class="animate-fadeUp">
                <div id="cart-container" class="card" style="padding: 0 40px;">
                    <!-- Items injected here -->
                </div>
                
                <div id="empty-state" style="text-align: center; padding: 120px 0; display: none;">
                    <div style="font-size: 100px; margin-bottom: 32px;">🥡</div>
                    <h2 class="display-font" style="font-size: 32px;">Your basket is empty</h2>
                    <p class="text-muted" style="margin-bottom: 40px; font-size: 18px;">Discover the finest local kitchens to fill it up.</p>
                    <a href="restaurant?action=list" class="btn btn-primary btn-lg">Explore Kitchens</a>
                </div>
            </div>

            <aside class="animate-fadeUp" style="animation-delay: 0.1s;">
                <div class="card summary-card">
                    <h3 class="display-font" style="font-size: 26px; margin-bottom: 32px;">Order Summary</h3>
                    
                    <div style="display: flex; flex-direction: column; gap: 20px; margin-bottom: 32px;">
                        <div style="display: flex; justify-content: space-between; font-size: 15px;">
                            <span class="text-muted">Subtotal</span>
                            <span id="summary-subtotal" style="font-weight: 700; color: var(--ink);">$0.00</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; font-size: 15px;">
                            <span class="text-muted">Artisan Delivery Fee</span>
                            <span style="color: var(--brand); font-weight: 800;">$5.00</span>
                        </div>
                        <div style="display: flex; justify-content: space-between; padding-top: 28px; border-top: 2px solid var(--surface); font-size: 26px; font-weight: 900; font-family: var(--font-display);">
                            <span>Total</span>
                            <span id="summary-total" style="color: var(--brand);">$0.00</span>
                        </div>
                    </div>

                    <form action="order" method="POST" id="checkout-form">
                        <input type="hidden" name="action" value="place">
                        <input type="hidden" name="restaurantId" id="res-id-field">
                        <input type="hidden" name="totalPrice" id="total-field">
                        <input type="hidden" name="deliveryCharge" value="5.00">
                        
                        <div class="form-group">
                            <label>Delivery Destination</label>
                            <div style="padding: 18px; background: var(--surface); border-radius: var(--radius-sm); border: 1.5px solid var(--border); font-size: 14px; font-weight: 700; color: var(--ink-2); line-height: 1.4;">
                                📍 <%= u.getAddress() %>
                            </div>
                        </div>
                        
                        <div class="form-group" style="margin-top: 32px;">
                            <label>Payment Method</label>
                            <select name="paymentMethod" class="form-control" style="background-image: none; font-weight: 700;">
                                <option value="CASH">💵 Cash on Delivery</option>
                                <option value="CARD">💳 Visa / Mastercard</option>
                                <option value="WALLET">📱 Digital Wallet</option>
                            </select>
                        </div>

                        <button type="submit" class="btn btn-primary btn-lg" style="width: 100%; padding: 20px; margin-top: 24px; font-size: 16px; box-shadow: 0 10px 25px rgba(232, 64, 12, 0.2);">
                            Place My Order — <span id="btn-total">$0.00</span>
                        </button>
                    </form>
                </div>
            </aside>
        </div>
    </div>

    <jsp:include page="jsp/footer.jsp" />

    <script src="js/cart.js?v=1.2"></script>
    <script>
        /**
         * Renders the basket items from localStorage.
         */
        function renderCart() {
            const container = document.getElementById('cart-container');
            const emptyState = document.getElementById('empty-state');
            const subtotalEl = document.getElementById('summary-subtotal');
            const totalEl = document.getElementById('summary-total');
            const btnTotalEl = document.getElementById('btn-total');
            const checkoutForm = document.getElementById('checkout-form');
            
            const cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
            
            if (cart.length === 0) {
                container.style.display = 'none';
                emptyState.style.display = 'block';
                document.querySelector('aside').style.display = 'none';
                return;
            }
            
            container.style.display = 'block';
            emptyState.style.display = 'none';
            document.querySelector('aside').style.display = 'block';
            
            let subtotal = 0;
            container.innerHTML = cart.map((item, index) => {
                const itemTotal = item.price * item.quantity;
                subtotal += itemTotal;
                return `
                <div class="cart-item">
                    <img src="https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=150&q=80" 
                         style="width: 110px; height: 110px; border-radius: var(--radius-sm); object-fit: cover; background: var(--surface);">
                    <div style="flex: 1;">
                        <h4 style="font-size: 20px; margin-bottom: 6px; font-weight: 700;">\${item.name}</h4>
                        <p class="text-muted" style="font-size: 14px;">$\${item.price.toFixed(2)} unit price</p>
                    </div>
                    <div style="display: flex; align-items: center; gap: 40px;">
                        <div class="qty-controls">
                            <button class="qty-btn" onclick="updateQty(\${index}, -1)" type="button">−</button>
                            <span style="font-weight: 800; min-width: 24px; text-align: center; font-size: 16px;">\${item.quantity}</span>
                            <button class="qty-btn" onclick="updateQty(\${index}, 1)" type="button">+</button>
                        </div>
                        <div style="font-weight: 900; font-size: 20px; min-width: 110px; text-align: right; color: var(--ink); font-family: var(--font-display);">$\${itemTotal.toFixed(2)}</div>
                    </div>
                </div>`;
            }).join('');
            
            const total = subtotal + 5.00;
            const formattedSubtotal = '$' + subtotal.toFixed(2);
            const formattedTotal = '$' + total.toFixed(2);
            
            subtotalEl.innerText = formattedSubtotal;
            totalEl.innerText = formattedTotal;
            btnTotalEl.innerText = formattedTotal;
            
            document.getElementById('total-field').value = subtotal.toFixed(2);
            document.getElementById('res-id-field').value = cart[0].restaurantId;
        }
        
        /**
         * Updates quantity and syncs with global cart state.
         */
        function updateQty(index, delta) {
            let cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
            if (!cart[index]) return;
            
            cart[index].quantity += delta;
            if (cart[index].quantity <= 0) {
                if (!confirm("Remove this item from your basket?")) {
                    cart[index].quantity = 1;
                } else {
                    cart.splice(index, 1);
                }
            }
            
            localStorage.setItem('foodhub_cart', JSON.stringify(cart));
            renderCart();
            if (window.updateCartUI) window.updateCartUI();
        }
        
        /**
         * Finalize order submission.
         */
        document.getElementById('checkout-form').addEventListener('submit', function(e) {
            const cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
            
            // Prevent duplicate submissions if user clicks twice
            const submitBtn = this.querySelector('button[type="submit"]');
            submitBtn.disabled = true;
            submitBtn.innerText = "Processing Craft...";
            
            // Append items to form
            cart.forEach(item => {
                this.appendChild(createHiddenInput('menuItemId', item.id));
                this.appendChild(createHiddenInput('quantity', item.quantity));
                this.appendChild(createHiddenInput('price', item.price));
            });
            
            // Clear cart from local storage immediately so it's fresh on success page
            setTimeout(() => {
                localStorage.removeItem('foodhub_cart');
            }, 100);
        });

        function createHiddenInput(name, value) {
            const input = document.createElement('input');
            input.type = 'hidden';
            input.name = name;
            input.value = value;
            return input;
        }
        
        document.addEventListener('DOMContentLoaded', renderCart);
    </script>
</body>
</html>
