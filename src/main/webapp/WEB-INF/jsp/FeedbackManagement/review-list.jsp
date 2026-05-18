<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Property Reviews | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        body { background: #f1f5f9; font-family: 'Outfit', sans-serif; padding-top: 68px; }
        .navbar { position: fixed; top: 0; width: 100%; z-index: 100; background: #0f172a; padding: 0 5%; height: 68px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 16px rgba(0,0,0,0.25); }
        .navbar .logo { color: white; font-size: 1.4rem; font-weight: 700; text-decoration: none; }
        .navbar .logo span { color: #10b981; }
        .page-wrapper { max-width: 820px; margin: 0 auto; padding: 40px 24px; }
        .card { background: white; border-radius: 20px; padding: 28px; box-shadow: 0 1px 8px rgba(0,0,0,0.06); border: 1px solid #f1f5f9; margin-bottom: 20px; }
        .review-card { border: 1px solid #e2e8f0; border-radius: 16px; padding: 22px; margin-bottom: 14px; transition: border-color 0.2s; }
        .review-card:hover { border-color: #10b981; }
        .reviewer-name { font-weight: 700; color: #0f172a; }
        .review-date { color: #94a3b8; font-size: 0.78rem; }
        .stars { color: #f59e0b; letter-spacing: 2px; margin: 6px 0; }
        .review-text { font-style: italic; color: #475569; line-height: 1.6; margin-top: 8px; }
        .rating-overview { text-align: center; padding: 28px; background: linear-gradient(135deg,#f0fdf4,#ecfdf5); border-radius: 16px; margin-bottom: 24px; }
        .rating-overview .big-num { font-size: 4rem; font-weight: 800; color: #0f172a; line-height: 1; }
        .rating-overview .stars-lg { color: #f59e0b; font-size: 1.6rem; letter-spacing: 4px; margin: 8px 0; }
        .btn { display: inline-flex; align-items: center; gap: 7px; padding: 10px 20px; border-radius: 10px; font-family: 'Outfit',sans-serif; font-weight: 600; text-decoration: none; font-size: 0.88rem; transition: all 0.2s; border: none; cursor: pointer; }
        .btn-primary { background: linear-gradient(135deg,#10b981,#059669); color: white; }
        .btn-primary:hover { transform: translateY(-1px); box-shadow: 0 6px 18px rgba(16,185,129,0.25); }
        .btn-outline { background: transparent; color: #475569; border: 1.5px solid #e2e8f0; }
        .btn-outline:hover { border-color: #10b981; color: #10b981; }
        .empty-state { text-align: center; padding: 60px 20px; color: #94a3b8; }
        .empty-state i { font-size: 3rem; display: block; margin-bottom: 16px; }
    </style>
</head>
<body>
<header class="navbar">
    <a href="/" class="logo"><i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span></a>
    <div style="display:flex;gap:12px;align-items:center;">
        <a href="/property/listing" style="color:#cbd5e1;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-building"></i> Properties</a>
        <c:if test="${not empty sessionScope.userId}">
            <a href="/buyer-dashboard" style="color:#cbd5e1;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-user"></i> Dashboard</a>
            <a href="/logout" style="color:#f87171;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </c:if>
        <c:if test="${empty sessionScope.userId}">
            <a href="/login" style="color:#cbd5e1;text-decoration:none;font-size:0.9rem;">Log In</a>
        </c:if>
    </div>
</header>

<div class="page-wrapper">
    <div style="margin-bottom:24px;display:flex;justify-content:space-between;align-items:center;flex-wrap:wrap;gap:12px;">
        <div>
            <a href="/property/listing" style="color:#10b981;text-decoration:none;font-size:0.85rem;font-weight:600;"><i class="fa-solid fa-arrow-left"></i> Back to Properties</a>
            <h1 style="font-size:1.8rem;font-weight:700;color:#0f172a;margin:8px 0 4px;"><i class="fa-solid fa-star" style="color:#f59e0b;"></i> Property Reviews</h1>
            <p style="color:#64748b;font-size:0.9rem;margin:0;">What buyers are saying about <strong>${not empty prop.title ? prop.title : 'this property'}</strong></p>
        </div>
        <c:if test="${not empty sessionScope.userId}">
            <a href="/submit-review?propertyId=${not empty prop.property_id ? prop.property_id : param.propertyId}" class="btn btn-primary">
                <i class="fa-solid fa-pen"></i> Write a Review
            </a>
        </c:if>
        <c:if test="${empty sessionScope.userId}">
            <a href="/login?redirect=/review-list?propertyId=${param.propertyId}" class="btn btn-outline">
                <i class="fa-solid fa-lock"></i> Log in to Review
            </a>
        </c:if>
    </div>

    <c:if test="${not empty reviews}">
        <div class="rating-overview">
            <div class="big-num">${avgRating}</div>
            <div class="stars-lg">
                <c:forEach begin="1" end="${avgRating}"><i class="fa-solid fa-star"></i></c:forEach>
                <c:if test="${avgRating < 5}"><i class="fa-regular fa-star"></i></c:if>
            </div>
            <p style="color:#475569;font-weight:600;margin:0;">${fn:length(reviews)} review<c:if test="${fn:length(reviews) != 1}">s</c:if></p>
        </div>
    </c:if>

    <c:choose>
        <c:when test="${empty reviews}">
            <div class="card">
                <div class="empty-state">
                    <i class="fa-solid fa-comment-slash"></i>
                    <p style="font-size:1rem;font-weight:600;margin-bottom:6px;">No reviews yet</p>
                    <p style="font-size:0.88rem;">Be the first to share your experience with this property!</p>
                    <c:if test="${not empty sessionScope.userId}">
                        <a href="/submit-review?propertyId=${param.propertyId}" class="btn btn-primary" style="margin-top:16px;">Write First Review</a>
                    </c:if>
                </div>
            </div>
        </c:when>
        <c:otherwise>
            <div class="card">
                <c:forEach var="r" items="${reviews}">
                    <div class="review-card">
                        <div style="display:flex;justify-content:space-between;align-items:flex-start;">
                            <div>
                                <span class="reviewer-name"><i class="fa-solid fa-user-circle" style="color:#10b981;margin-right:6px;"></i>${r.first_name} ${r.last_name}</span>
                                <div class="stars">
                                    <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                    <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star" style="color:#e2e8f0;"></i></c:forEach>
                                    <span style="color:#64748b;font-size:0.82rem;font-style:normal;margin-left:6px;">${r.rating}/5</span>
                                </div>
                            </div>
                            <span class="review-date">
                                <fmt:parseDate value="${r.created_at}" pattern="yyyy-MM-dd" var="rd" type="date"/>
                                <fmt:formatDate value="${rd}" pattern="MMM dd, yyyy"/>
                            </span>
                        </div>
                        <p class="review-text">"${r.review_text}"</p>
                    </div>
                </c:forEach>
            </div>
        </c:otherwise>
    </c:choose>
</div>
</body>
</html>
