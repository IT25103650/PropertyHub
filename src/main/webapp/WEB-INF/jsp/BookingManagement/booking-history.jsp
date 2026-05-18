<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking History | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; padding:40px 20px; }
        .container { max-width:1000px; margin:0 auto; }
        .header { display:flex; justify-content:space-between; align-items:flex-end; margin-bottom:30px; }
        .title { font-size:1.8rem; font-weight:700; color:#8b5cf6; }
        .subtitle { color:#94a3b8; font-size:.9rem; margin-top:4px; }
        .btn { display:inline-flex; align-items:center; gap:6px; padding:10px 18px; border-radius:10px;
               font-size:.88rem; font-weight:600; cursor:pointer; text-decoration:none;
               background:rgba(255,255,255,.06); color:#e2e8f0; transition:all .2s; }
        .btn:hover { background:rgba(255,255,255,.1); }
        .stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:16px; margin-bottom:28px; }
        .stat-card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                     border-radius:14px; padding:20px; text-align:center; }
        .stat-card .num { font-size:1.8rem; font-weight:700; color:#8b5cf6; }
        .stat-card .lbl { font-size:.8rem; color:#94a3b8; margin-top:4px; }
        .table-wrap { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:16px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:14px 20px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); }
        th { font-size:.78rem; font-weight:600; text-transform:uppercase; color:#94a3b8; background:rgba(255,255,255,.03); }
        td { font-size:.9rem; }
        tr:hover td { background:rgba(255,255,255,.03); }
        .badge { display:inline-block; padding:4px 12px; border-radius:20px; font-size:.75rem; font-weight:600; }
        .badge-pending   { background:rgba(234,179,8,.15); color:#fbbf24; }
        .badge-confirmed { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-completed { background:rgba(99,102,241,.15); color:#a5b4fc; }
        .badge-cancelled { background:rgba(239,68,68,.15); color:#f87171; }
        .empty-state { text-align:center; padding:60px; color:#64748b; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3);
                         color:#4ade80; padding:12px; border-radius:10px; margin-bottom:20px; }
    </style>
</head>
<body>
<div class="container">
    <div class="header">
        <div>
            <div class="title">My Viewing Appointments</div>
            <div class="subtitle">Component 04 — Keep track of your property visits</div>
        </div>
        <a href="/buyer-dashboard" class="btn">← Back to Dashboard</a>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert-success">✓ ${successMsg}</div>
    </c:if>

    <div class="stats-row">
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

    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty bookings}">
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">📅</div>
                    <p>You haven't requested any viewings yet.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>Property</th>
                            <th>Date &amp; Time</th>
                            <th>Status</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="b" items="${bookings}">
                        <tr>
                            <td>
                                <a href="/properties/${b.property_id}" style="color:#8b5cf6;font-weight:500;">
                                    ${b.property_title}
                                </a><br>
                                <span style="font-size:.8rem;color:#64748b;">LKR ${b.price} &nbsp;|&nbsp; ${b.location}</span>
                            </td>
                            <td>
                                <strong>${b.booking_date}</strong><br>
                                <span style="font-size:.85rem;color:#94a3b8;">${b.booking_time}</span>
                            </td>
                            <td><span class="badge badge-${b.status}">${b.status}</span></td>
                            <td>
                                <div style="display:flex;gap:6px;">
                                    <a href="/bookings/${b.booking_id}" class="btn" style="padding:6px 12px;font-size:.8rem;">View</a>
                                    <c:if test="${b.status == 'completed'}">
                                        <a href="/feedback/create?propertyId=${b.property_id}&bookingId=${b.booking_id}"
                                           class="btn" style="padding:6px 12px;font-size:.8rem;background:rgba(245,158,11,.15);color:#f59e0b;">Review</a>
                                    </c:if>
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
