<%@ page import="com.foodhub.model.User" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    User u = (User) session.getAttribute("user");
    if (u == null) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <title>Your Cart - FoodHub</title>
    <link rel="stylesheet" href="../css/style.css">
</head>
<body>
    <jsp:include page="../jsp/navbar.jsp" />

    <div class="container">
        <h1>Your Shopping Cart</h1>
        
        <div style="display: grid; grid-template-columns: 2fr 1fr; gap: 40px; margin-top: 30px;">
            <!-- Cart Items -->
            <div class="card" style="padding: 20px;">
                <table id="cartTable">
                    <thead>
                        <tr>
                            <th>Item</th>
                            <th>Price</th>
                            <th>Quantity</th>
                            <th>Total</th>
                            <th>Action</th>
                        </tr>
                    </thead>
                    <tbody id="cartItems">
                        <!-- Filled by JS -->
                    </tbody>
                </table>
            </div>

            <!-- Order Summary -->
            <div class="card" style="padding: 25px;">
                <h3>Order Summary</h3>
                <hr style="margin: 15px 0; border: 0; border-top: 1px solid #eee;">
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span>Subtotal</span>
                    <span id="subtotal">$0.00</span>
                </div>
                <div style="display: flex; justify-content: space-between; margin-bottom: 10px;">
                    <span>Discount (<%= u.getUserType() %>)</span>
                    <span id="discount" style="color: #06c167;">-$0.00</span>
                </div>
                <div style="display: flex; justify-content: space-between; font-weight: 800; font-size: 20px; margin-top: 20px; border-top: 1px solid #eee; padding-top: 20px;">
                    <span>Total</span>
                    <span id="finalTotal">$0.00</span>
                </div>

                <% if ("CUSTOMER".equals(u.getRole())) { %>
                    <form action="../order" method="POST" id="checkoutForm" style="margin-top: 30px;">
                        <input type="hidden" name="action" value="place">
                        <input type="hidden" name="restaurantId" id="resIdField">
                        <input type="hidden" name="totalPrice" id="totalField">
                        <input type="hidden" name="orderType" value="INSTANT">
                        
                        <div class="form-group" style="margin-bottom: 20px;">
                            <label>Payment Method</label>
                            <select name="paymentMethod" class="form-control" required>
                                <option value="CASH">Cash on Delivery</option>
                                <option value="CARD">Credit / Debit Card</option>
                                <option value="UPI">UPI / Wallet</option>
                            </select>
                        </div>
    
                        <button type="submit" class="btn btn-primary" style="width: 100%; padding: 15px;">Place Order & Pay</button>
                    </form>
                <% } else { %>
                    <div style="margin-top: 30px; padding: 20px; background: #fff7ed; color: #9a3412; border-radius: 12px; border: 1px solid #ffedd5; text-align: center;">
                        <div style="font-size: 24px; margin-bottom: 10px;">🚫</div>
                        <p style="font-weight: 600; margin-bottom: 5px;">Checkout Restricted</p>
                        <p style="font-size: 14px; opacity: 0.8;">You are logged in as a <strong><%= u.getRole() %></strong>. Only customers can place orders.</p>
                    </div>
                <% } %>
            </div>
        </div>
    </div>

    <script src="../js/cart.js"></script>
    <script>
        function renderCart() {
            const tbody = document.getElementById('cartItems');
            const subtotalEl = document.getElementById('subtotal');
            const discountEl = document.getElementById('discount');
            const totalEl = document.getElementById('finalTotal');
            const checkoutBtn = document.querySelector('#checkoutForm button');
            
            if (cart.length === 0) {
                tbody.innerHTML = '<tr><td colspan="5" style="text-align:center; padding:40px;">Your cart is empty! <a href="../restaurant?action=list">Go shopping</a></td></tr>';
                subtotalEl.textContent = '$0.00';
                discountEl.textContent = '-$0.00';
                totalEl.textContent = '$0.00';
                if (checkoutBtn) checkoutBtn.disabled = true;
                return;
            }

            if (checkoutBtn) checkoutBtn.disabled = false;

            let subtotal = 0;
            tbody.innerHTML = cart.map((item, index) => {
                const total = item.price * item.quantity;
                subtotal += total;
                return `
                    <tr>
                        <td>\${item.name}</td>
                        <td>$\${item.price}</td>
                        <td>
                            <div style="display: flex; align-items: center; gap: 10px;">
                                <button onclick="updateQuantity(\${index}, -1)" style="width: 25px; height: 25px; border-radius: 50%; border: 1px solid #ddd; background: white; cursor: pointer;">-</button>
                                <span>\${item.quantity}</span>
                                <button onclick="updateQuantity(\${index}, 1)" style="width: 25px; height: 25px; border-radius: 50%; border: 1px solid #ddd; background: white; cursor: pointer;">+</button>
                            </div>
                        </td>
                        <td>$\${total.toFixed(2)}</td>
                        <td><button onclick="removeFromCart(\${index})" style="color:red; border:none; background:none; cursor:pointer;">Remove</button></td>
                    </tr>
                `;
            }).join('');

            // Apply Membership Discount logic
            const userType = '<%= u.getUserType() %>';
            const discountRate = userType === 'PREMIUM' ? 0.15 : 0.05;
            const discount = subtotal * discountRate;
            const finalTotal = subtotal - discount;

            subtotalEl.textContent = `$\${subtotal.toFixed(2)}`;
            discountEl.textContent = `-$\${discount.toFixed(2)}`;
            totalEl.textContent = `$\${finalTotal.toFixed(2)}`;

            // Fill hidden fields
            document.getElementById('totalField').value = finalTotal.toFixed(2);
            if (cart.length > 0) {
                document.getElementById('resIdField').value = cart[0].restaurantId;
            }
        }

        function updateQuantity(index, delta) {
            cart[index].quantity += delta;
            if (cart[index].quantity <= 0) {
                removeFromCart(index);
            } else {
                saveCart();
                renderCart();
                updateCartUI();
            }
        }

        function removeFromCart(index) {
            cart.splice(index, 1);
            saveCart();
            renderCart();
            updateCartUI();
        }

        document.addEventListener('DOMContentLoaded', renderCart);

        document.getElementById('checkoutForm').addEventListener('submit', function(e) {
            const form = this;
            cart.forEach(item => {
                const itemInput = document.createElement('input');
                itemInput.type = 'hidden';
                itemInput.name = 'menuItemId';
                itemInput.value = item.id;
                form.appendChild(itemInput);

                const qtyInput = document.createElement('input');
                qtyInput.type = 'hidden';
                qtyInput.name = 'quantity';
                qtyInput.value = item.quantity;
                form.appendChild(qtyInput);

                const priceInput = document.createElement('input');
                priceInput.type = 'hidden';
                priceInput.name = 'price';
                priceInput.value = item.price;
                form.appendChild(priceInput);
            });
        });
    </script>
</body>
</html>
