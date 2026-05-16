<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="com.foodhub.model.Payment" %>
<%@ page import="java.util.List" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%
    List<Payment> payments = (List<Payment>) request.getAttribute("payments");
    SimpleDateFormat sdf = new SimpleDateFormat("MMM dd, yyyy • HH:mm");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Payment History — FoodHub</title>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;900&family=DM+Sans:wght@400;500;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="css/style.css">
    <style>
        :root {
            --brand: #E8400C;
            --brand-light: #FFF0EB;
            --ink: #1A1410;
            --ink-2: #5C4E46;
            --surface: #FDFAF8;
            --border: #EDE5DF;
            --success: #10B981;
            --radius-lg: 24px;
            --shadow-soft: 0 10px 30px rgba(26, 20, 16, 0.05);
        }

        body {
            background-color: var(--surface);
            color: var(--ink);
            font-family: 'DM Sans', sans-serif;
            margin: 0;
        }

        .history-container {
            max-width: 1000px;
            margin: 60px auto;
            padding: 0 7vw;
        }

        .page-header {
            margin-bottom: 48px;
            text-align: center;
        }

        .page-header h1 {
            font-family: 'Playfair Display', serif;
            font-size: 48px;
            font-weight: 900;
            margin-bottom: 12px;
            letter-spacing: -0.02em;
        }

        .page-header p {
            color: var(--ink-2);
            font-size: 18px;
        }

        .payment-card {
            background: #fff;
            border: 1px solid var(--border);
            border-radius: var(--radius-lg);
            padding: 32px;
            margin-bottom: 24px;
            display: grid;
            grid-template-columns: auto 1fr auto;
            align-items: center;
            gap: 32px;
            transition: transform 0.3s cubic-bezier(0.4, 0, 0.2, 1), box-shadow 0.3s ease;
        }

        .payment-card:hover {
            transform: translateY(-4px);
            box-shadow: var(--shadow-soft);
            border-color: var(--brand);
        }

        .payment-icon {
            width: 64px;
            height: 64px;
            background: var(--brand-light);
            color: var(--brand);
            border-radius: 18px;
            display: flex;
            align-items: center;
            justify-content: center;
            font-size: 28px;
        }

        .payment-details h3 {
            font-size: 20px;
            font-weight: 700;
            margin: 0 0 4px 0;
        }

        .payment-details p {
            color: var(--ink-2);
            font-size: 14px;
            margin: 0;
        }

        .payment-meta {
            text-align: right;
        }

        .amount {
            display: block;
            font-family: 'Playfair Display', serif;
            font-size: 24px;
            font-weight: 900;
            color: var(--ink);
            margin-bottom: 8px;
        }

        .status-badge {
            display: inline-flex;
            align-items: center;
            gap: 6px;
            padding: 6px 14px;
            border-radius: 100px;
            font-size: 12px;
            font-weight: 700;
            text-transform: uppercase;
            letter-spacing: 0.05em;
        }

        .status-completed {
            background: #D1FAE5;
            color: #065F46;
        }

        .status-pending {
            background: #FEF3C7;
            color: #92400E;
        }

        .empty-state {
            text-align: center;
            padding: 100px 0;
        }

        .empty-state .emoji {
            font-size: 80px;
            margin-bottom: 24px;
            display: block;
        }

        @media (max-width: 768px) {
            .payment-card {
                grid-template-columns: 1fr;
                text-align: center;
                gap: 16px;
            }
            .payment-icon { margin: 0 auto; }
            .payment-meta { text-align: center; }
        }

        .animate-up {
            animation: slideUp 0.6s ease both;
        }

        @keyframes slideUp {
            from { opacity: 0; transform: translateY(30px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>
<body>
    <jsp:include page="jsp/navbar.jsp" />

    <div class="history-container">
        <header class="page-header animate-up">
            <h1>Payment <em>History</em></h1>
            <p>Transparency in every transaction. Track your culinary investments.</p>
        </header>

        <% if (payments != null && !payments.isEmpty()) { 
            int i = 0;
            for (Payment p : payments) { 
                i++;
        %>
            <div class="payment-card animate-up" style="animation-delay: <%= 0.1 * i %>s">
                <div class="payment-icon">
                    <%= p.getPaymentMethod().toLowerCase().contains("card") ? "💳" : "💰" %>
                </div>
                <div class="payment-details">
                    <h3>Order #<%= p.getOrderId() %></h3>
                    <p><%= sdf.format(p.getPaymentDate()) %></p>
                    <p style="margin-top: 4px; font-family: monospace; color: var(--ink-3); font-size: 12px;">TXN: <%= p.getTransactionId() %></p>
                </div>
                <div class="payment-meta">
                    <span class="amount">$<%= String.format("%.2f", p.getAmount()) %></span>
                    <span class="status-badge <%= "COMPLETED".equals(p.getPaymentStatus()) ? "status-completed" : "status-pending" %>">
                        <%= p.getPaymentStatus() %>
                    </span>
                </div>
            </div>
        <% } } else { %>
            <div class="empty-state animate-up">
                <span class="emoji">🧾</span>
                <h3>No payments yet</h3>
                <p>Your transaction history will appear here once you place your first order.</p>
                <a href="restaurant?action=list" class="btn btn-primary" style="margin-top: 24px; display: inline-block; padding: 14px 28px; border-radius: 100px; background: var(--brand); color: #fff; text-decoration: none; font-weight: 700;">Explore Restaurants</a>
            </div>
        <% } %>
    </div>

    <jsp:include page="jsp/footer.jsp" />
</body>
</html>
