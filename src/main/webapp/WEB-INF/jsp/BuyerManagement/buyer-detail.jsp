<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${buyer.firstName} ${buyer.lastName} | Buyer Detail</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; align-items:center;
            justify-content:space-between; border-bottom:1px solid rgba(255,255,255,.08); }
        .topbar a { color:#94a3b8; text-decoration:none; font-size:.9rem; }
        .topbar a:hover { color:#6366f1; }
        .container { max-width:960px; margin:0 auto; padding:32px 24px; }
        .profile-card { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
            border-radius:20px; padding:32px; display:grid;
            grid-template-columns:auto 1fr; gap:28px; align-items:start; margin-bottom:28px; }
        .avatar { width:90px; height:90px; border-radius:50%;
            background:linear-gradient(135deg,#6366f1,#8b5cf6);
            display:flex; align-items:center; justify-content:center;
            font-size:2.2rem; font-weight:700; color:#fff; flex-shrink:0; }
        .profile-info h2 { font-size:1.6rem; font-weight:700; }
        .profile-info .role-badge { display:inline-block; background:rgba(99,102,241,.2);
            color:#a5b4fc; padding:3px 12px; border-radius:20px;
            font-size:.78rem; font-weight:600; margin:6px 0; }
        .meta-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:12px; }
        .meta-item label { font-size:.75rem; color:#64748b; display:block; }
        .meta-item span { font-size:.9rem; color:#e2e8f0; }
        .section { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
            border-radius:16px; padding:24px; margin-bottom:20px; }
        .section h3 { font-size:1rem; font-weight:600; margin-bottom:16px; color:#a5b4fc; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:10px 14px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); font-size:.85rem; }
        th { color:#64748b; font-weight:600; font-size:.78rem; text-transform:uppercase; }
        .badge { display:inline-block; padding:2px 10px; border-radius:20px; font-size:.75rem; font-weight:600; }
        .badge-active   { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-inactive { background:rgba(239,68,68,.15); color:#f87171; }
        .badge-pending   { background:rgba(234,179,8,.15); color:#fbbf24; }
        .badge-confirmed { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-cancelled { background:rgba(239,68,68,.15); color:#f87171; }
        .badge-completed { background:rgba(99,102,241,.15); color:#a5b4fc; }
        .action-bar { display:flex; gap:10px; margin-bottom:28px; }
        .btn { display:inline-flex; align-items:center; gap:6px; padding:10px 20px;
            border-radius:10px; font-size:.9rem; font-weight:600; cursor:pointer;
            text-decoration:none; border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#6366f1,#8b5cf6); color:#fff; }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-secondary { background:rgba(255,255,255,.06); color:#94a3b8; }
        .empty { color:#64748b; font-size:.88rem; padding:12px 0; }
    </style>
</head>
<body>
<div class="topbar">
    <a href="/buyers">← Back to Buyers</a>
    <div style="display:flex;gap:16px;">
        <a href="/buyers/edit/${buyer.userId}">Edit Profile</a>
        <a href="/buyers/toggle-status/${buyer.userId}">${buyer.isActive ? 'Deactivate' : 'Activate'}</a>
        <a href="/buyers/delete/${buyer.userId}"
           onclick="return confirm('Permanently delete this buyer?')" style="color:#f87171;">Delete</a>
    </div>
</div>

<div class="container">
    <!-- Profile Card -->
    <div class="profile-card">
        <div class="avatar">
            ${buyer.firstName.substring(0,1)}${buyer.lastName.substring(0,1)}
        </div>
        <div class="profile-info">
            <h2>${buyer.firstName} ${buyer.lastName}</h2>
            <span class="role-badge">🔵 Buyer</span>
            <span class="badge ${buyer.isActive ? 'badge-active' : 'badge-inactive'}"
                  style="margin-left:8px;">${buyer.isActive ? 'Active' : 'Inactive'}</span>
            <div class="meta-grid">
                <div class="meta-item">
                    <label>Email</label>
                    <span>${buyer.email}</span>
                </div>
                <div class="meta-item">
                    <label>Phone</label>
                    <span>${not empty buyer.phone ? buyer.phone : '—'}</span>
                </div>
                <div class="meta-item">
                    <label>Registered</label>
                    <span>${buyer.createdAt}</span>
                </div>
                <div class="meta-item">
                    <label>Buyer ID</label>
                    <span>#${buyer.userId}</span>
                </div>
            </div>
        </div>
    </div>

    <!-- Bookings -->
    <div class="section">
        <h3>📅 Booking History</h3>
        <c:choose>
            <c:when test="${empty bookings}">
                <p class="empty">No bookings found for this buyer.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>Booking ID</th><th>Property</th><th>Date</th><th>Time</th><th>Status</th></tr></thead>
                    <tbody>
                    <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>#${b.booking_id}</td>
                            <td>${b.property_title} — ${b.location}</td>
                            <td>${b.booking_date}</td>
                            <td>${b.booking_time}</td>
                            <td><span class="badge badge-${b.status}">${b.status}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Saved Properties -->
    <div class="section">
        <h3>❤️ Saved Properties</h3>
        <c:choose>
            <c:when test="${empty savedProperties}">
                <p class="empty">No saved properties.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>ID</th><th>Title</th><th>Location</th><th>Price</th><th>Status</th></tr></thead>
                    <tbody>
                    <c:forEach var="p" items="${savedProperties}">
                        <tr>
                            <td>#${p.property_id}</td>
                            <td>${p.title}</td>
                            <td>${p.location}</td>
                            <td>LKR ${p.price}</td>
                            <td><span class="badge badge-${p.status}">${p.status}</span></td>
                        </tr>
                    </c:forEach>
                    </tbody>
                </table>
            </c:otherwise>
        </c:choose>
    </div>

    <!-- Reviews -->
    <div class="section">
        <h3>⭐ Reviews Submitted</h3>
        <c:choose>
            <c:when test="${empty reviews}">
                <p class="empty">No reviews submitted yet.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>ID</th><th>Property</th><th>Rating</th><th>Status</th><th>Date</th></tr></thead>
                    <tbody>
                    <c:forEach var="r" items="${reviews}">
                        <tr>
                            <td>#${r.review_id}</td>
                            <td>${not empty r.property_title ? r.property_title : '—'}</td>
                            <td>⭐ ${r.rating}/5</td>
                            <td><span class="badge badge-${r.status}">${r.status}</span></td>
                            <td>${r.created_at}</td>
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
