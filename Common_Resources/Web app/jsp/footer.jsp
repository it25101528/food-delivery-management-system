<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<style>
    /* ── FOOTER ── */
    .site-footer {
        background: #1A1410;
        color: #fff;
        padding: 72px 7vw 40px;
        margin-top: 80px;
    }

    .footer-grid {
        display: grid;
        grid-template-columns: 2fr 1fr 1fr;
        gap: 48px;
        margin-bottom: 56px;
    }

    .footer-brand .logo {
        font-family: 'Playfair Display', 'DM Sans', Georgia, serif;
        font-size: 24px;
        font-weight: 900;
        color: #E8400C;
        text-decoration: none;
        display: block;
        margin-bottom: 16px;
    }

    .footer-brand p {
        color: #9E8F88;
        font-size: 14px;
        line-height: 1.7;
        max-width: 300px;
    }

    .footer-col h4 {
        font-family: 'DM Sans', system-ui, sans-serif;
        font-size: 11px;
        font-weight: 700;
        text-transform: uppercase;
        letter-spacing: 0.1em;
        color: #9E8F88;
        margin-bottom: 20px;
    }

    .footer-col a {
        display: block;
        color: #C9B8B0;
        text-decoration: none;
        font-size: 14px;
        margin-bottom: 12px;
        transition: color 0.2s;
    }

    .footer-col a:hover { color: #E8400C; }

    .footer-bottom {
        border-top: 1px solid rgba(255,255,255,0.08);
        padding-top: 28px;
        display: flex;
        justify-content: space-between;
        align-items: center;
        flex-wrap: wrap;
        gap: 12px;
    }

    .footer-bottom p {
        font-size: 13px;
        color: #5C4E46;
    }

    @media (max-width: 768px) {
        .footer-grid { grid-template-columns: 1fr; gap: 32px; }
        .footer-bottom { flex-direction: column; text-align: center; }
    }
</style>

<footer class="site-footer">
    <div class="footer-grid">
        <div class="footer-brand">
            <a href="index.jsp" class="logo">FoodHub</a>
            <p>Your favorite meals delivered fast and fresh. Experience the finest local flavors with ease.</p>
        </div>
        <div class="footer-col">
            <h4>Explore</h4>
            <a href="restaurant?action=list">Browse Restaurants</a>
            <a href="register.jsp">Join as a Partner</a>
            <a href="driver-login.jsp">Become a Driver</a>
        </div>
        <div class="footer-col">
            <h4>Support</h4>
            <a href="#">Help Center</a>
            <a href="#">Terms of Service</a>
            <a href="#">Privacy Policy</a>
            <a href="#">Contact Us</a>
        </div>
    </div>
    <div class="footer-bottom">
        <p>© 2024 FoodHub. All rights reserved.</p>
        <p>🌍 English · 💳 Secure Payments</p>
    </div>
</footer>
