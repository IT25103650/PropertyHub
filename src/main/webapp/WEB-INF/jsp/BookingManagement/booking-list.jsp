<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking Management | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; align-items:center;
                  justify-content:space-between; border-bottom:1px solid rgba(139,92,246,.2); }
        .topbar h1 { font-size:1.4rem; font-weight:700;
                     background:linear-gradient(135deg,#8b5cf6,#6366f1); -webkit-background-clip:text;
                     -webkit-text-fill-color:transparent; }
        .topbar-links a { color:#94a3b8; text-decoration:none; margin-left:20px; font-size:.9rem; }
        .topbar-links a:hover { color:#8b5cf6; }
        .container { max-width:1200px; margin:0 auto; padding:32px 24px; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-title { font-size:1.8rem; font-weight:700; }
        .page-title span { color:#8b5cf6; }
        .filter-bar { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:14px; padding:20px; margin-bottom:24px; display:flex; gap:12px; }
        .filter-bar select { background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
                             border-radius:8px; padding:9px 12px; color:#e2e8f0; font-size:.85rem; }
        .btn { display:inline-flex; align-items:center; gap:6px; padding:10px 18px; border-radius:10px;
               font-size:.88rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#8b5cf6,#6366f1); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(139,92,246,.35); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-info    { background:rgba(59,130,246,.15); color:#60a5fa; border:1px solid rgba(59,130,246,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-success { background:rgba(34,197,94,.15); color:#4ade80; border:1px solid rgba(34,197,94,.3); }
        .btn-sm { padding:6px 12px; font-size:.8rem; }
        .alert { padding:12px 18px; border-radius:10px; margin-bottom:20px; font-size:.9rem; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3); color:#4ade80; }
        .alert-error   { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);  color:#f87171; }
        .stats-row { display:grid; grid-template-columns:repeat(5,1fr); gap:14px; margin-bottom:24px; }
        .stat-card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                     border-radius:12px; padding:18px; text-align:center; }
        .stat-card .num { font-size:1.8rem; font-weight:700; color:#8b5cf6; }
        .stat-card .lbl { font-size:.78rem; color:#94a3b8; }
        .table-wrap { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:16px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:12px 16px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); }
        th { font-size:.76rem; font-weight:600; text-transform:uppercase; color:#94a3b8; background:rgba(255,255,255,.03); }
        td { font-size:.85rem; }
        tr:hover td { background:rgba(255,255,255,.03); }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.73rem; font-weight:600; }
        .badge-pending   { background:rgba(234,179,8,.15); color:#fbbf24; }
        .badge-confirmed { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-completed { background:rgba(99,102,241,.15); color:#a5b4fc; }
        .badge-cancelled { background:rgba(239,68,68,.15); color:#f87171; }
        .actions { display:flex; gap:5px; flex-wrap:wrap; }
        .empty-state { text-align:center; padding:60px; color:#64748b; }
    </style>
</head>
<body>
<div class="topbar">
    <h1>🏠 PropertyHub — Booking Management</h1>
    <div class="topbar-links">
        <a href="/admin-dashboard">Dashboard</a>
        <a href="/buyers">Buyers</a>
        <a href="/properties">Properties</a>
        <a href="/feedback">Feedback</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div>
            <div class="page-title">All <span>Bookings &amp; Viewings</span></div>
            <p style="color:#64748b;font-size:.9rem;margin-top:4px;">
                Component 04 — Manage property viewing appointments
            </p>
        </div>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">✓ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">✗ ${errorMsg}</div>
    </c:if>

    <!-- Stats -->
    <div class="stats-row">
        <div class="stat-card">
            <div class="num">${totalBookings}</div>
            <div class="lbl">Total Bookings</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#fbbf24;">${pendingCount}</div>
            <div class="lbl">Pending</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#4ade80;">${confirmedCount}</div>
            <div class="lbl">Confirmed</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#a5b4fc;">${completedCount}</div>
            <div class="lbl">Completed</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#f87171;">${cancelledCount}</div>
            <div class="lbl">Cancelled</div>
        </div>
    </div>

    <!-- Filters -->
    <div class="filter-bar">
        <form method="get" action="/bookings" style="display:flex;gap:12px;align-items:center;">
            <select name="status">
                <option value="">All Statuses</option>
                <option value="pending"   ${statusFilter=='pending'?'selected':''}>Pending</option>
                <option value="confirmed" ${statusFilter=='confirmed'?'selected':''}>Confirmed</option>
                <option value="completed" ${statusFilter=='completed'?'selected':''}>Completed</option>
                <option value="cancelled" ${statusFilter=='cancelled'?'selected':''}>Cancelled</option>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <c:if test="${not empty statusFilter}">
                <a href="/bookings" class="btn btn-info btn-sm">Clear</a>
            </c:if>
        </form>
    </div>

    <!-- Table -->
    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">📅</div>
                    <p>No bookings found.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Property</th><th>Buyer</th><th>Seller</th>
                            <th>Date &amp; Time</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>#${b.booking_id}</td>
                            <td><a href="/properties/${b.property_id}" style="color:#8b5cf6;">${b.property_title}</a><br>
                                <span style="font-size:.75rem;color:#64748b;">${b.location}</span>
                            </td>
                            <td>${b.first_name} ${b.last_name}<br>
                                <span style="font-size:.75rem;color:#64748b;">${b.buyer_email}</span>
                            </td>
                            <td>${b.seller_first_name} ${b.seller_last_name}</td>
                            <td><strong>${b.booking_date}</strong><br>${b.booking_time}</td>
                            <td><span class="badge badge-${b.status}">${b.status}</span></td>
                            <td>
                                <div class="actions">
                                    <a href="/bookings/${b.booking_id}" class="btn btn-info btn-sm">View</a>
                                    <c:if test="${b.status == 'pending'}">
                                        <a href="/bookings/approve/${b.booking_id}" class="btn btn-success btn-sm">Approve</a>
                                        <a href="/bookings/reject/${b.booking_id}" class="btn btn-warning btn-sm">Reject</a>
                                    </c:if>
                                    <c:if test="${b.status == 'confirmed'}">
                                        <a href="/bookings/complete/${b.booking_id}" class="btn btn-primary btn-sm">Complete</a>
                                    </c:if>
                                    <a href="/bookings/delete/${b.booking_id}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Permanently delete this booking?')">Del</a>
                                </div>
                            </td>
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
