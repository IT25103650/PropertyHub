<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Feedback & Review Management | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; align-items:center;
                  justify-content:space-between; border-bottom:1px solid rgba(236,72,153,.2); }
        .topbar h1 { font-size:1.4rem; font-weight:700;
                     background:linear-gradient(135deg,#ec4899,#8b5cf6); -webkit-background-clip:text;
                     -webkit-text-fill-color:transparent; }
        .topbar-links a { color:#94a3b8; text-decoration:none; margin-left:20px; font-size:.9rem; }
        .topbar-links a:hover { color:#ec4899; }
        .container { max-width:1200px; margin:0 auto; padding:32px 24px; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-title { font-size:1.8rem; font-weight:700; }
        .page-title span { color:#ec4899; }
        .filter-bar { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:14px; padding:20px; margin-bottom:24px; display:flex; gap:12px; }
        .filter-bar select { background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
                             border-radius:8px; padding:9px 12px; color:#e2e8f0; font-size:.85rem; }
        .btn { display:inline-flex; align-items:center; gap:6px; padding:10px 18px; border-radius:10px;
               font-size:.88rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#ec4899,#8b5cf6); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(236,72,153,.35); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-info    { background:rgba(59,130,246,.15); color:#60a5fa; border:1px solid rgba(59,130,246,.3); }
        .btn-success { background:rgba(34,197,94,.15); color:#4ade80; border:1px solid rgba(34,197,94,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-sm { padding:6px 12px; font-size:.8rem; }
        .alert { padding:12px 18px; border-radius:10px; margin-bottom:20px; font-size:.9rem; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3); color:#4ade80; }
        .alert-error   { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);  color:#f87171; }
        .stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:24px; }
        .stat-card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                     border-radius:12px; padding:18px; text-align:center; }
        .stat-card .num { font-size:1.8rem; font-weight:700; color:#ec4899; }
        .stat-card .lbl { font-size:.78rem; color:#94a3b8; }
        .table-wrap { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:16px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:12px 16px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); }
        th { font-size:.76rem; font-weight:600; text-transform:uppercase; color:#94a3b8; background:rgba(255,255,255,.03); }
        td { font-size:.85rem; }
        tr:hover td { background:rgba(255,255,255,.03); }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.73rem; font-weight:600; }
        .badge-pending  { background:rgba(234,179,8,.15); color:#fbbf24; }
        .badge-approved { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-rejected { background:rgba(239,68,68,.15); color:#f87171; }
        .actions { display:flex; gap:5px; flex-wrap:wrap; }
        .stars { color:#f59e0b; font-size:.9rem; }
        .review-text { max-width:300px; white-space:nowrap; overflow:hidden; text-overflow:ellipsis; }
        .empty-state { text-align:center; padding:60px; color:#64748b; }
    </style>
</head>
<body>
<div class="topbar">
    <h1>🏠 PropertyHub — Feedback Management</h1>
    <div class="topbar-links">
        <a href="/admin-dashboard">Dashboard</a>
        <a href="/buyers">Buyers</a>
        <a href="/sellers">Sellers</a>
        <a href="/properties">Properties</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div>
            <div class="page-title">All <span>Reviews</span></div>
            <p style="color:#64748b;font-size:.9rem;margin-top:4px;">
                Component 06 — Moderate user feedback and ratings
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
            <div class="num">${totalFeedback}</div>
            <div class="lbl">Total Reviews</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#fbbf24;">${pendingCount}</div>
            <div class="lbl">Pending Moderation</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#4ade80;">${approvedCount}</div>
            <div class="lbl">Approved</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#f87171;">${rejectedCount}</div>
            <div class="lbl">Rejected</div>
        </div>
    </div>

    <!-- Filters -->
    <div class="filter-bar">
        <form method="get" action="/feedback" style="display:flex;gap:12px;align-items:center;">
            <select name="status">
                <option value="">All Statuses</option>
                <option value="pending"  ${statusFilter=='pending'?'selected':''}>Pending</option>
                <option value="approved" ${statusFilter=='approved'?'selected':''}>Approved</option>
                <option value="rejected" ${statusFilter=='rejected'?'selected':''}>Rejected</option>
            </select>
            <button type="submit" class="btn btn-primary btn-sm">Filter</button>
            <c:if test="${not empty statusFilter}">
                <a href="/feedback" class="btn btn-info btn-sm">Clear</a>
            </c:if>
        </form>
    </div>

    <!-- Table -->
    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty feedbackList}">
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">💬</div>
                    <p>No feedback found.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Reviewer</th><th>Property</th>
                            <th>Rating</th><th>Comment</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="f" items="${feedbackList}">
                        <tr>
                            <td>#${f.review_id}</td>
                            <td>${f.first_name} ${f.last_name}<br>
                                <span style="font-size:.75rem;color:#64748b;">${f.reviewer_email}</span>
                            </td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty f.property_title}">
                                        <a href="/properties/${f.property_id}" style="color:#ec4899;">${f.property_title}</a>
                                    </c:when>
                                    <c:otherwise><span style="color:#64748b;">—</span></c:otherwise>
                                </c:choose>
                            </td>
                            <td class="stars">
                                <c:forEach begin="1" end="${f.rating}" var="i">★</c:forEach>
                                <c:forEach begin="${f.rating + 1}" end="5" var="i">☆</c:forEach>
                            </td>
                            <td class="review-text" title="${f.review_text}">${f.review_text}</td>
                            <td><span class="badge badge-${f.status}">${f.status}</span></td>
                            <td>
                                <div class="actions">
                                    <a href="/feedback/${f.review_id}" class="btn btn-info btn-sm">View</a>
                                    <c:if test="${f.status == 'pending'}">
                                        <a href="/feedback/approve/${f.review_id}" class="btn btn-success btn-sm">Approve</a>
                                        <a href="/feedback/reject/${f.review_id}" class="btn btn-warning btn-sm">Reject</a>
                                    </c:if>
                                    <a href="/feedback/delete/${f.review_id}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Permanently delete this review?')">Del</a>
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
