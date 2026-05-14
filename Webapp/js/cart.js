let cart = JSON.parse(localStorage.getItem('foodhub_cart')) || [];

function addToCart(id, name, price, restaurantId) {
    const item = cart.find(i => i.id === id);
    if (item) {
        item.quantity += 1;
    } else {
        cart.push({ id, name, price, restaurantId, quantity: 1 });
    }
    saveCart();
    updateCartUI();
    alert(name + " added to cart!");
}

function saveCart() {
    localStorage.setItem('foodhub_cart', JSON.stringify(cart));
}

function updateCartUI() {
    const counts = document.querySelectorAll('.cart-count');
    const total = cart.reduce((sum, item) => sum + item.quantity, 0);
    counts.forEach(el => el.textContent = total);
}

function clearCart() {
    cart = [];
    saveCart();
    updateCartUI();
}

// Initialize UI on load
document.addEventListener('DOMContentLoaded', updateCartUI);
