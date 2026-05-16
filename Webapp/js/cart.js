/* ─── FoodHub Cart System ─── */

/**
 * Adds an item to the persistent cart.
 * Re-reads from localStorage to ensure multi-tab consistency.
 */
function addToCart(id, name, price, restaurantId) {
    try {
        console.log("Adding to cart:", {id, name, price, restaurantId});
        let cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
        
        // If adding from a different restaurant, we might want to warn/clear,
        // but for now, we'll just allow it or filter by restaurantId.
        const existingItem = cart.find(i => i.id === id);
        
        if (existingItem) {
            existingItem.quantity += 1;
        } else {
            cart.push({ 
                id: parseInt(id), 
                name: name, 
                price: parseFloat(price), 
                restaurantId: parseInt(restaurantId), 
                quantity: 1 
            });
        }
        
        localStorage.setItem('foodhub_cart', JSON.stringify(cart));
        updateCartUI();
        
        // Optional: Trigger a custom event for pages with specialized sidebars (like menu-view)
        window.dispatchEvent(new Event('cartUpdated'));
        
    } catch (e) {
        console.error("Cart Error:", e);
    }
}

/**
 * Synchronizes all cart-related UI elements on the page.
 */
function updateCartUI() {
    try {
        const cart = JSON.parse(localStorage.getItem('foodhub_cart') || '[]');
        const totalCount = cart.reduce((sum, item) => sum + item.quantity, 0);
        
        // Update Navbar (ID and Class variants for safety)
        const navCount = document.getElementById('nav-cart-count');
        if (navCount) navCount.textContent = totalCount;
        
        const genericCounts = document.querySelectorAll('.cart-count, .nav-cart-count');
        genericCounts.forEach(el => el.textContent = totalCount);
        
        // Update any subtotal displays if they exist
        const subtotalEl = document.getElementById('cart-subtotal');
        if (subtotalEl) {
            const subtotal = cart.reduce((sum, item) => sum + (item.price * item.quantity), 0);
            subtotalEl.textContent = '$' + subtotal.toFixed(2);
        }
    } catch (e) {
        console.warn("UI Sync Error:", e);
    }
}

function clearCart() {
    localStorage.removeItem('foodhub_cart');
    updateCartUI();
    window.dispatchEvent(new Event('cartUpdated'));
}

// Initial Sync
document.addEventListener('DOMContentLoaded', updateCartUI);
// Listen for changes from other tabs
window.addEventListener('storage', updateCartUI);
