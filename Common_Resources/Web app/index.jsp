<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>FoodHub – Order Your Favorite Food</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@400;500;600&display=swap" rel="stylesheet">
    <style>
        *, *::before, *::after { box-sizing: border-box; margin: 0; padding: 0; }

        :root {
            --brand:       #E8400C;
            --brand-light: #FFF0EB;
            --brand-dark:  #B22F06;
            --ink:         #1A1410;
            --ink-2:       #5C4E46;
            --ink-3:       #9E8F88;
            --surface:     #FDFAF8;
            --card:        #FFFFFF;
            --border:      #EDE5DF;
            --radius-sm:   10px;
            --radius-md:   18px;
            --radius-lg:   28px;
            --font-display: 'Playfair Display', Georgia, serif;
            --font-body:   'DM Sans', system-ui, sans-serif;
        }

        html { scroll-behavior: smooth; }

        body {
            font-family: var(--font-body);
            background: var(--surface);
            color: var(--ink);
            line-height: 1.6;
            overflow-x: hidden;
        }

        /* ─── HERO ─── */
        .hero {
            min-height: 92vh;
            display: grid;
            grid-template-columns: 1fr 1fr;
            align-items: center;
            gap: 0;
            padding: 100px 7vw 60px;
            position: relative;
            overflow: hidden;
        }

        .hero::before {
            content: '';
            position: absolute;
            inset: 0;
            background: radial-gradient(ellipse 70% 70% at 70% 50%, #FFF0EB 0%, transparent 70%);
            pointer-events: none;
        }

        .hero-text {
            position: relative;
            z-index: 2;
            max-width: 560px;
        }

        .hero-tag {
            display: inline-flex;
            align-items: center;
            gap: 8px;
            background: var(--brand-light);
            color: var(--brand-dark);
            font-size: 13px;
            font-weight: 600;
            letter-spacing: 0.04em;
            text-transform: uppercase;
            padding: 8px 16px;
            border-radius: 100px;
            border: 1px solid rgba(232, 64, 12, 0.18);
            margin-bottom: 28px;
        }

        .hero-tag::before {
            content: '';
            width: 7px;
            height: 7px;
            background: var(--brand);
            border-radius: 50%;
            animation: pulse 2s infinite;
        }

        @keyframes pulse {
            0%, 100% { opacity: 1; transform: scale(1); }
            50%       { opacity: 0.5; transform: scale(1.4); }
        }

        .hero h1 {
            font-family: var(--font-display);
            font-size: clamp(42px, 5.5vw, 72px);
            font-weight: 900;
            line-height: 1.07;
            color: var(--ink);
            letter-spacing: -0.02em;
            margin-bottom: 22px;
        }

        .hero h1 em {
            font-style: italic;
            color: var(--brand);
        }

        .hero p {
            font-size: 17px;
            color: var(--ink-2);
            margin-bottom: 40px;
            line-height: 1.7;
            max-width: 440px;
        }

        /* Search */
        .search-box {
            display: flex;
            background: #FFFFFF;
            border-radius: var(--radius-md);
            border: 1.5px solid var(--border);
            padding: 6px;
            box-shadow: 0 8px 40px rgba(26,20,16,0.10);
            gap: 6px;
            max-width: 480px;
        }

        .search-box input[type="text"] {
            flex: 1;
            border: none;
            outline: none;
            font-family: var(--font-body);
            font-size: 15px;
            color: #1A1410;
            background: #FFFFFF;
            padding: 12px 16px;
            border-radius: 12px;
            -webkit-appearance: none;
        }

        .search-box input[type="text"]::placeholder { color: #9E8F88; }

        .search-box button {
            background: var(--brand);
            color: #fff;
            border: none;
            border-radius: var(--radius-sm);
            padding: 13px 28px;
            font-family: var(--font-body);
            font-size: 15px;
            font-weight: 600;
            cursor: pointer;
            transition: background 0.2s, transform 0.15s;
            white-space: nowrap;
        }

        .search-box button:hover  { background: var(--brand-dark); transform: scale(1.03); }
        .search-box button:active { transform: scale(0.98); }

        /* Hero image */
        .hero-image {
            position: relative;
            z-index: 2;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .hero-image-wrap {
            position: relative;
            width: 90%;
            max-width: 480px;
        }

        .hero-image-wrap img {
            width: 100%;
            height: 500px;
            object-fit: cover;
            border-radius: 220px 220px var(--radius-lg) var(--radius-lg);
            display: block;
        }

        .hero-badge {
            position: absolute;
            bottom: 36px;
            left: -24px;
            background: #fff;
            border-radius: var(--radius-md);
            padding: 14px 20px;
            box-shadow: 0 12px 40px rgba(26,20,16,0.13);
            display: flex;
            align-items: center;
            gap: 12px;
            font-size: 14px;
            font-weight: 600;
            border: 1px solid var(--border);
        }

        .hero-badge .emoji { font-size: 28px; }

        .hero-badge-sub {
            font-size: 12px;
            font-weight: 400;
            color: var(--ink-3);
        }

        /* ─── CATEGORIES ─── */
        .section {
            padding: 80px 7vw;
        }

        .section-header {
            display: flex;
            align-items: flex-end;
            justify-content: space-between;
            margin-bottom: 40px;
        }

        .section-header h2 {
            font-family: var(--font-display);
            font-size: clamp(28px, 3.5vw, 42px);
            font-weight: 700;
            line-height: 1.1;
            letter-spacing: -0.02em;
        }

        .section-header p {
            color: var(--ink-3);
            font-size: 15px;
        }

        .categories-grid {
            display: grid;
            grid-template-columns: repeat(6, 1fr);
            gap: 16px;
        }

        .category-card {
            background: var(--card);
            border: 1.5px solid var(--border);
            border-radius: var(--radius-md);
            padding: 28px 12px 20px;
            text-align: center;
            text-decoration: none;
            color: var(--ink);
            transition: border-color 0.2s, transform 0.2s, box-shadow 0.2s;
            display: flex;
            flex-direction: column;
            align-items: center;
            gap: 10px;
        }

        .category-card:hover {
            border-color: var(--brand);
            transform: translateY(-4px);
            box-shadow: 0 12px 32px rgba(232, 64, 12, 0.12);
        }

        .category-icon {
            font-size: 38px;
            line-height: 1;
        }

        .category-card span {
            font-size: 14px;
            font-weight: 600;
            color: var(--ink);
        }

        /* ─── FADE-IN ANIMATION ─── */
        .animate-fadeIn  { animation: fadeIn  0.7s ease both; }
        .animate-fadeUp  { animation: fadeUp  0.7s ease both; animation-delay: 0.15s; }

        @keyframes fadeIn  { from { opacity: 0; }                     to { opacity: 1; } }
        @keyframes fadeUp  { from { opacity: 0; transform: translateY(28px); } to { opacity: 1; transform: none; } }

        /* ─── RESPONSIVE ─── */
        @media (max-width: 900px) {
            .hero {
                grid-template-columns: 1fr;
                min-height: auto;
                padding: 80px 6vw 60px;
                text-align: center;
            }

            .hero-text { max-width: 100%; }
            .hero p    { max-width: 100%; }
            .search-box { max-width: 100%; }

            .hero-image { margin-top: 40px; }
            .hero-image-wrap { width: 80%; }
            .hero-image-wrap img { height: 360px; border-radius: var(--radius-lg); }
            .hero-badge { display: none; }

            .categories-grid { grid-template-columns: repeat(3, 1fr); }

            .promo {
                grid-template-columns: 1fr;
                padding: 48px 40px;
                text-align: center;
            }
            .promo::after { display: none; }
            .btn-primary { width: 100%; justify-content: center; }
        }

        @media (max-width: 560px) {
            .categories-grid { grid-template-columns: repeat(2, 1fr); }
            .section { padding: 60px 5vw; }
            .promo { margin: 0 5vw 60px; padding: 40px 28px; }
        }
    </style>
</head>
<body>

    <jsp:include page="jsp/navbar.jsp" />

    <!-- HERO -->
    <section class="hero animate-fadeIn">
        <div class="hero-text">
            <span class="hero-tag">Fast delivery in <%= session.getAttribute("userLocation") != null ? session.getAttribute("userLocation") : "your city" %></span>
            <h1>Order your <em>favorite</em> food anytime</h1>
            <p>Discover top restaurants, fine local flavors, and lightning-fast delivery straight to your door.</p>
            <form action="restaurant" method="GET" class="search-box">
                <input type="hidden" name="action" value="search">
                <input type="text" name="query" placeholder="Search for food or restaurants…" required />
                <button type="submit">Find Food</button>
            </form>
        </div>

        <div class="hero-image">
            <div class="hero-image-wrap">
                <img
                    src="https://images.unsplash.com/photo-1565299624946-b28f40a0ae38?auto=format&fit=crop&w=900&q=80"
                    onerror="this.onerror=null;this.src='https://picsum.photos/seed/food/900/600';"
                    alt="Delicious food"
                    loading="eager"
                />
            </div>
        </div>
    </section>

    <!-- CATEGORIES -->
    <section class="section animate-fadeUp">
        <div class="section-header">
            <div>
                <h2>Popular Categories</h2>
                <p>Choose your favorite meal type</p>
            </div>
        </div>
        <div class="categories-grid">
            <a href="restaurant?action=search&query=Burger" class="category-card">
                <div class="category-icon">🍔</div>
                <span>Burgers</span>
            </a>
            <a href="restaurant?action=search&query=Pizza" class="category-card">
                <div class="category-icon">🍕</div>
                <span>Pizza</span>
            </a>
            <a href="restaurant?action=search&query=Chicken" class="category-card">
                <div class="category-icon">🍗</div>
                <span>Chicken</span>
            </a>
            <a href="restaurant?action=search&query=Noodles" class="category-card">
                <div class="category-icon">🍜</div>
                <span>Noodles</span>
            </a>
            <a href="restaurant?action=search&query=Dessert" class="category-card">
                <div class="category-icon">🍩</div>
                <span>Desserts</span>
            </a>
            <a href="restaurant?action=search&query=Drinks" class="category-card">
                <div class="category-icon">🥤</div>
                <span>Drinks</span>
            </a>
        </div>
    </section>


    <jsp:include page="jsp/footer.jsp" />

</body>
</html>
