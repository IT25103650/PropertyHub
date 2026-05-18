<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Submit a Review | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        body { background: #f1f5f9; font-family: 'Outfit', sans-serif; padding-top: 68px; }
        .navbar { position: fixed; top: 0; width: 100%; z-index: 100; background: #0f172a; padding: 0 5%; height: 68px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 16px rgba(0,0,0,0.25); }
        .navbar .logo { color: white; font-size: 1.4rem; font-weight: 700; text-decoration: none; }
        .navbar .logo span { color: #10b981; }
        .page-wrapper { max-width: 720px; margin: 0 auto; padding: 40px 24px; }
        .page-title { font-size: 2rem; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
        .page-sub { color: #64748b; margin-bottom: 32px; }
        .card { background: white; border-radius: 20px; padding: 36px; box-shadow: 0 1px 8px rgba(0,0,0,0.06); border: 1px solid #f1f5f9; margin-bottom: 24px; }
        .form-group { margin-bottom: 22px; }
        .form-group label { display: block; font-size: 0.88rem; font-weight: 600; color: #475569; margin-bottom: 8px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 12px 16px; border: 1.5px solid #e2e8f0; border-radius: 12px;
            font-family: 'Outfit', sans-serif; font-size: 0.9rem; color: #334155;
            outline: none; transition: border-color 0.2s; background: #f8fafc;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #10b981; background: white; box-shadow: 0 0 0 3px rgba(16,185,129,0.08);
        }
        .star-row { display: flex; gap: 10px; font-size: 2rem; margin-bottom: 8px; }
        .star-row i { color: #e2e8f0; cursor: pointer; transition: color 0.15s, transform 0.15s; }
        .star-row i:hover, .star-row i.active { color: #f59e0b; transform: scale(1.15); }
        .star-label { font-size: 0.85rem; color: #64748b; margin-top: 4px; }
        .btn-submit { width: 100%; padding: 14px; background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; border-radius: 14px; font-family: 'Outfit', sans-serif; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; }
        .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 8px 24px rgba(16,185,129,0.3); }
        .alert-success { background: rgba(16,185,129,0.08); border: 1px solid rgba(16,185,129,0.25); color: #065f46; padding: 16px 20px; border-radius: 14px; margin-bottom: 24px; display: flex; align-items: center; gap: 12px; font-weight: 600; font-size: 0.95rem; }
        .property-banner { background: linear-gradient(135deg,#0f172a,#1e293b); border-radius: 16px; padding: 20px 24px; margin-bottom: 24px; display: flex; align-items: center; gap: 16px; }
        .property-banner img { width: 80px; height: 60px; object-fit: cover; border-radius: 10px; flex-shrink: 0; }
        .property-banner h4 { color: white; font-size: 1rem; margin: 0 0 4px; }
        .property-banner p { color: #64748b; font-size: 0.82rem; margin: 0; }
    </style>
</head>
<body>
<header class="navbar">
    <a href="/" class="logo"><i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span></a>
    <div style="display:flex;gap:12px;align-items:center;">
        <a href="/buyer-dashboard" style="color:#cbd5e1;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-gauge-high"></i> Dashboard</a>
        <a href="/logout" style="color:#f87171;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
</header>

<div class="page-wrapper">
    <div style="margin-bottom:24px;">
        <a href="/property/listing" style="color:#10b981;text-decoration:none;font-size:0.88rem;font-weight:600;"><i class="fa-solid fa-arrow-left"></i> Back to Properties</a>
    </div>

    <h1 class="page-title"><i class="fa-solid fa-star" style="color:#f59e0b;"></i> Write a Review</h1>
    <p class="page-sub">Share your honest experience to help other buyers make informed decisions.</p>

    <c:if test="${param.success == 'true'}">
        <div class="alert-success"><i class="fa-solid fa-circle-check" style="font-size:1.3rem;"></i>
            Your review has been submitted and is pending approval. Thank you!
        </div>
    </c:if>

    <c:if test="${not empty prop}">
        <div class="property-banner">
            <img src="${not empty primaryImg ? primaryImg : 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=200&auto=format&fit=crop'}" alt="${prop.title}">
            <div>
                <h4>${prop.title}</h4>
                <p><i class="fa-solid fa-location-dot" style="color:#10b981;"></i> ${prop.location}</p>
            </div>
        </div>
    </c:if>

    <div class="card">
        <form action="/submit-review" method="POST">
            <input type="hidden" name="property_id" value="${not empty prop.property_id ? prop.property_id : param.propertyId}">
            <input type="hidden" name="user_id" value="${sessionScope.userId}">

            <div class="form-group">
                <label>Your Rating</label>
                <div class="star-row" id="starRow">
                    <i class="fa-solid fa-star" data-val="1"></i>
                    <i class="fa-solid fa-star" data-val="2"></i>
                    <i class="fa-solid fa-star" data-val="3"></i>
                    <i class="fa-solid fa-star" data-val="4"></i>
                    <i class="fa-solid fa-star" data-val="5"></i>
                </div>
                <div class="star-label" id="starLabel">Click to rate</div>
                <input type="hidden" name="rating" id="ratingInput" value="" required>
            </div>

            <div class="form-group">
                <label for="review_text">Your Review <span style="color:#94a3b8;font-weight:400;">(minimum 20 characters)</span></label>
                <textarea id="review_text" name="review_text" rows="5"
                          placeholder="Describe your experience visiting this property. What did you like? What could be better?"
                          minlength="20" required></textarea>
            </div>

            <button type="submit" class="btn-submit" id="submitBtn" disabled>
                <i class="fa-solid fa-paper-plane"></i> Submit Review
            </button>
            <p style="text-align:center;font-size:0.78rem;color:#94a3b8;margin-top:10px;">
                <i class="fa-solid fa-shield-halved"></i> Reviews are moderated before appearing publicly.
            </p>
        </form>
    </div>
</div>

<script>
const stars = document.querySelectorAll('#starRow i');
const ratingInput = document.getElementById('ratingInput');
const starLabel = document.getElementById('starLabel');
const submitBtn = document.getElementById('submitBtn');
const reviewText = document.getElementById('review_text');
const labels = ['','Poor','Fair','Good','Very Good','Excellent'];

function updateStars(val) {
    stars.forEach(s => {
        s.classList.toggle('active', parseInt(s.dataset.val) <= val);
    });
    starLabel.textContent = val > 0 ? `${val}/5 — ${labels[val]}` : 'Click to rate';
    ratingInput.value = val;
    checkSubmit();
}
stars.forEach(s => {
    s.addEventListener('click', () => updateStars(parseInt(s.dataset.val)));
    s.addEventListener('mouseover', () => stars.forEach(x => x.style.color = parseInt(x.dataset.val) <= parseInt(s.dataset.val) ? '#f59e0b' : '#e2e8f0'));
    s.addEventListener('mouseout', () => updateStars(parseInt(ratingInput.value || 0)));
});
reviewText.addEventListener('input', checkSubmit);
function checkSubmit() {
    submitBtn.disabled = !ratingInput.value || reviewText.value.length < 20;
    submitBtn.style.opacity = submitBtn.disabled ? '0.5' : '1';
}
</script>
</body>
</html>
