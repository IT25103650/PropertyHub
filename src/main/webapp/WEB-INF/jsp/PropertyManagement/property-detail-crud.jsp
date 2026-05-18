<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${property.title} | Property Detail</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; justify-content:space-between;
                  border-bottom:1px solid rgba(245,158,11,.2); }
        .topbar a { color:#94a3b8; text-decoration:none; font-size:.9rem; }
        .topbar a:hover { color:#f59e0b; }
        .container { max-width:1000px; margin:0 auto; padding:32px 24px; }
        .hero { border-radius:20px; overflow:hidden; margin-bottom:28px; position:relative; background:#1e293b; }
        .hero img { width:100%; height:300px; object-fit:cover; display:block; }
        .hero .no-img { height:200px; display:flex; align-items:center; justify-content:center;
                        color:#64748b; font-size:1rem; }
        .status-pill { position:absolute; top:16px; right:16px; background:rgba(0,0,0,.7);
                       padding:6px 14px; border-radius:20px; font-size:.85rem; font-weight:600; }
        .status-available { color:#4ade80; }
        .status-sold { color:#a5b4fc; }
        .status-rented { color:#60a5fa; }
        .status-pending { color:#fbbf24; }
        .info-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; margin-bottom:28px; }
        .info-card { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.08);
                     border-radius:16px; padding:24px; }
        .info-card h3 { font-size:.85rem; font-weight:600; color:#f59e0b; text-transform:uppercase;
                        letter-spacing:.06em; margin-bottom:16px; }
        .detail-row { display:flex; justify-content:space-between; align-items:center;
                      padding:8px 0; border-bottom:1px solid rgba(255,255,255,.06); }
        .detail-row:last-child { border-bottom:none; }
        .detail-label { color:#94a3b8; font-size:.85rem; }
        .detail-value { font-size:.9rem; font-weight:500; }
        .price-hero { font-size:2rem; font-weight:800; color:#f59e0b; margin-bottom:8px; }
        .action-bar { display:flex; gap:10px; margin-bottom:24px; flex-wrap:wrap; }
        .btn { display:inline-flex; align-items:center; gap:6px; padding:10px 20px; border-radius:10px;
               font-size:.9rem; font-weight:600; cursor:pointer; text-decoration:none; border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#f59e0b,#ef4444); color:#fff; }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-info    { background:rgba(59,130,246,.15); color:#60a5fa; border:1px solid rgba(59,130,246,.3); }
        .section { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                   border-radius:16px; padding:24px; margin-bottom:20px; }
        .section h3 { font-size:1rem; font-weight:600; color:#f59e0b; margin-bottom:16px; }
        .images-grid { display:grid; grid-template-columns:repeat(auto-fill,minmax(120px,1fr)); gap:10px; }
        .images-grid img { width:100%; height:80px; object-fit:cover; border-radius:8px; }
        .review-item { padding:14px; background:rgba(255,255,255,.03); border-radius:10px;
                       margin-bottom:10px; }
        .review-rating { color:#f59e0b; margin-bottom:4px; }
        .review-text { font-size:.88rem; color:#cbd5e1; }
        .review-author { font-size:.78rem; color:#64748b; margin-top:6px; }
        .status-btn { padding:6px 14px; border-radius:8px; font-size:.8rem; font-weight:600;
                      cursor:pointer; border:none; text-decoration:none; transition:all .2s; }
        .empty { color:#64748b; font-size:.88rem; }
    </style>
</head>
<body>
<div class="topbar">
    <a href="/properties">← Back to Properties</a>
    <div style="display:flex;gap:16px;">
        <a href="/properties/edit/${property.propertyId}">Edit Listing</a>
        <a href="/properties/delete/${property.propertyId}"
           onclick="return confirm('Delete this property?')" style="color:#f87171;">Delete</a>
    </div>
</div>

<div class="container">
    <!-- Hero Image -->
    <div class="hero">
        <c:choose>
            <c:when test="${not empty images}">
                <img src="${images[0].image_url}" alt="${property.title}">
            </c:when>
            <c:otherwise>
                <div class="no-img">🏠 No images uploaded yet</div>
            </c:otherwise>
        </c:choose>
        <div class="status-pill status-${property.status}">${property.status}</div>
    </div>

    <!-- Action Bar -->
    <div class="action-bar">
        <a href="/properties/edit/${property.propertyId}" class="btn btn-warning">✏️ Edit Listing</a>
        <a href="/properties/status/${property.propertyId}?status=available" class="btn btn-info">Mark Available</a>
        <a href="/properties/status/${property.propertyId}?status=sold"      class="btn btn-info">Mark Sold</a>
        <a href="/properties/status/${property.propertyId}?status=rented"    class="btn btn-info">Mark Rented</a>
        <a href="/bookings/create?propertyId=${property.propertyId}" class="btn btn-primary">📅 Book Viewing</a>
    </div>

    <!-- Price Header -->
    <div class="price-hero">
        LKR ${property.price}
        <c:if test="${property.listingType == 'rent'}"> <span style="font-size:1rem;color:#94a3b8;">/month</span></c:if>
    </div>
    <div style="font-size:1.4rem;font-weight:700;margin-bottom:24px;">${property.title}</div>

    <!-- Info Grid -->
    <div class="info-grid">
        <div class="info-card">
            <h3>Property Details</h3>
            <div class="detail-row">
                <span class="detail-label">Type</span>
                <span class="detail-value">${property.propertyType} / ${property.listingType}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Location</span>
                <span class="detail-value">${property.location}</span>
            </div>
            <c:if test="${not empty property.address}">
            <div class="detail-row">
                <span class="detail-label">Address</span>
                <span class="detail-value">${property.address}</span>
            </div>
            </c:if>
            <div class="detail-row">
                <span class="detail-label">Bedrooms</span>
                <span class="detail-value">${not empty property.bedrooms ? property.bedrooms : '—'}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Bathrooms</span>
                <span class="detail-value">${not empty property.bathrooms ? property.bathrooms : '—'}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Size</span>
                <span class="detail-value">${not empty property.sqft ? property.sqft.toString().concat(' sqft') : '—'}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">View Count</span>
                <span class="detail-value">${property.viewCount}</span>
            </div>
        </div>

        <div class="info-card">
            <h3>Seller Information</h3>
            <c:choose>
                <c:when test="${not empty owner}">
                    <div class="detail-row">
                        <span class="detail-label">Name</span>
                        <span class="detail-value">${owner.first_name} ${owner.last_name}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Email</span>
                        <span class="detail-value">${owner.email}</span>
                    </div>
                    <div class="detail-row">
                        <span class="detail-label">Phone</span>
                        <span class="detail-value">${not empty owner.phone ? owner.phone : '—'}</span>
                    </div>
                </c:when>
                <c:otherwise>
                    <p class="empty">Seller info not available.</p>
                </c:otherwise>
            </c:choose>
            <div class="detail-row" style="margin-top:12px;">
                <span class="detail-label">Total Bookings</span>
                <span class="detail-value">${bookingCount}</span>
            </div>
            <div class="detail-row">
                <span class="detail-label">Listed</span>
                <span class="detail-value">${property.createdAt}</span>
            </div>
        </div>
    </div>

    <!-- Description -->
    <c:if test="${not empty property.description}">
    <div class="section">
        <h3>📋 Description</h3>
        <p style="line-height:1.7;color:#cbd5e1;">${property.description}</p>
    </div>
    </c:if>

    <!-- Images -->
    <c:if test="${not empty images}">
    <div class="section">
        <h3>📷 All Images (${images.size()})</h3>
        <div class="images-grid">
            <c:forEach var="img" items="${images}">
                <img src="${img.image_url}" alt="Property image">
            </c:forEach>
        </div>
    </div>
    </c:if>

    <!-- Reviews -->
    <div class="section">
        <h3>⭐ Reviews (${reviews.size()})</h3>
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="empty">No reviews yet for this property.</p>
            </c:when>
            <c:otherwise>
                <c:forEach var="r" items="${reviews}">
                <div class="review-item">
                    <div class="review-rating">
                        <c:forEach begin="1" end="${r.rating}" var="i">★</c:forEach>
                        <c:forEach begin="${r.rating + 1}" end="5" var="i">☆</c:forEach>
                        ${r.rating}/5
                    </div>
                    <div class="review-text">${r.review_text}</div>
                    <div class="review-author">by ${r.first_name} ${r.last_name} — ${r.created_at}</div>
                </div>
                </c:forEach>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
