<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${seller.firstName} ${seller.lastName} | Seller Detail</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; justify-content:space-between;
                  border-bottom:1px solid rgba(16,185,129,.2); }
        .topbar a { color:#94a3b8; text-decoration:none; font-size:.9rem; }
        .topbar a:hover { color:#10b981; }
        .container { max-width:960px; margin:0 auto; padding:32px 24px; }
        .profile-card { background:rgba(255,255,255,.05); border:1px solid rgba(16,185,129,.2);
                        border-radius:20px; padding:32px; display:grid;
                        grid-template-columns:auto 1fr; gap:28px; align-items:start; margin-bottom:28px; }
        .avatar { width:90px; height:90px; border-radius:50%;
                  background:linear-gradient(135deg,#10b981,#059669);
                  display:flex; align-items:center; justify-content:center;
                  font-size:2.2rem; font-weight:700; color:#fff; }
        .profile-info h2 { font-size:1.6rem; font-weight:700; }
        .role-badge { display:inline-block; background:rgba(16,185,129,.2); color:#34d399;
                      padding:3px 12px; border-radius:20px; font-size:.78rem; font-weight:600; margin:6px 0; }
        .meta-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:12px; }
        .meta-item label { font-size:.75rem; color:#64748b; display:block; }
        .meta-item span { font-size:.9rem; }
        .section { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                   border-radius:16px; padding:24px; margin-bottom:20px; }
        .section h3 { font-size:1rem; font-weight:600; margin-bottom:16px; color:#34d399; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:10px 14px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); font-size:.85rem; }
        th { color:#64748b; font-weight:600; font-size:.78rem; text-transform:uppercase; }
        .badge { display:inline-block; padding:2px 10px; border-radius:20px; font-size:.75rem; font-weight:600; }
        .badge-active    { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-inactive  { background:rgba(239,68,68,.15); color:#f87171; }
        .badge-available { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-pending   { background:rgba(234,179,8,.15); color:#fbbf24; }
        .badge-sold      { background:rgba(99,102,241,.15); color:#a5b4fc; }
        .badge-confirmed { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-cancelled { background:rgba(239,68,68,.15); color:#f87171; }
        .empty { color:#64748b; font-size:.88rem; padding:12px 0; }
    </style>
</head>
<body>
<div class="topbar">
    <a href="/sellers">← Back to Sellers</a>
    <div style="display:flex;gap:16px;">
        <a href="/sellers/edit/${seller.userId}">Edit</a>
        <a href="/sellers/toggle-status/${seller.userId}">${seller.isActive ? 'Deactivate' : 'Activate'}</a>
        <a href="/sellers/delete/${seller.userId}"
           onclick="return confirm('Delete this seller and all listings?')" style="color:#f87171;">Delete</a>
    </div>
</div>

<div class="container">
    <div class="profile-card">
        <div class="avatar">${seller.firstName.substring(0,1)}${seller.lastName.substring(0,1)}</div>
        <div class="profile-info">
            <h2>${seller.firstName} ${seller.lastName}</h2>
            <span class="role-badge">🟢 Seller</span>
            <span class="badge ${seller.isActive ? 'badge-active' : 'badge-inactive'}" style="margin-left:8px;">
                ${seller.isActive ? 'Active' : 'Inactive'}
            </span>
            <div class="meta-grid">
                <div class="meta-item"><label>Email</label><span>${seller.email}</span></div>
                <div class="meta-item"><label>Phone</label><span>${not empty seller.phone ? seller.phone : '—'}</span></div>
                <div class="meta-item"><label>Properties</label><span>${propertyCount}</span></div>
                <div class="meta-item"><label>Seller ID</label><span>#${seller.userId}</span></div>
            </div>
        </div>
    </div>

    <!-- Properties -->
    <div class="section">
        <h3>🏠 Property Listings (${propertyCount})</h3>
        <c:choose>
            <c:when test="${empty properties}">
                <p class="empty">No properties listed yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>ID</th><th>Title</th><th>Location</th><th>Price</th><th>Type</th><th>Status</th></tr></thead>
                    <tbody>
                        <c:forEach var="p" items="${properties}">
                        <tr>
                            <td>#${p.property_id}</td>
                            <td><a href="/properties/${p.property_id}" style="color:#34d399;">${p.title}</a></td>
                            <td>${p.location}</td>
                            <td>LKR ${p.price}</td>
                            <td>${p.property_type} / ${p.listing_type}</td>
                            <td><span class="badge badge-${p.status}">${p.status}</span></td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Bookings -->
    <div class="section">
        <h3>📅 Viewing Requests</h3>
        <c:choose>
            <c:when test="${empty bookings}">
                <p class="empty">No booking requests yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>Booking ID</th><th>Property</th><th>Buyer</th><th>Date</th><th>Status</th></tr></thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>#${b.booking_id}</td>
                            <td>${b.property_title}</td>
                            <td>${b.first_name} ${b.last_name}</td>
                            <td>${b.booking_date} ${b.booking_time}</td>
                            <td><span class="badge badge-${b.status}">${b.status}</span></td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Reviews -->
    <div class="section">
        <h3>⭐ Property Reviews</h3>
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="empty">No reviews on this seller's properties.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>Review ID</th><th>Property</th><th>Reviewer</th><th>Rating</th><th>Status</th></tr></thead>
                    <tbody>
                        <c:forEach var="r" items="${reviews}">
                        <tr>
                            <td>#${r.review_id}</td>
                            <td>${r.property_title}</td>
                            <td>${r.first_name} ${r.last_name}</td>
                            <td>⭐ ${r.rating}/5</td>
                            <td><span class="badge badge-${r.status}">${r.status}</span></td>
                        </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>
</div>
</body>
</html>
