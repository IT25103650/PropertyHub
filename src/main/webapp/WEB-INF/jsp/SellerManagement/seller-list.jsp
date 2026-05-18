<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Seller Management | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:linear-gradient(135deg,#1e293b,#0f172a); padding:16px 32px;
                  display:flex; align-items:center; justify-content:space-between;
                  border-bottom:1px solid rgba(16,185,129,.2); }
        .topbar h1 { font-size:1.4rem; font-weight:700;
                     background:linear-gradient(135deg,#10b981,#34d399); -webkit-background-clip:text;
                     -webkit-text-fill-color:transparent; }
        .topbar-links a { color:#94a3b8; text-decoration:none; margin-left:20px; font-size:.9rem; }
        .topbar-links a:hover { color:#10b981; }
        .container { max-width:1200px; margin:0 auto; padding:32px 24px; }
        .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:32px; }
        .page-title { font-size:1.8rem; font-weight:700; }
        .page-title span { color:#10b981; }
        .btn { display:inline-flex; align-items:center; gap:8px; padding:10px 20px; border-radius:10px;
               font-size:.9rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#10b981,#059669); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(16,185,129,.4); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-danger:hover { background:rgba(239,68,68,.25); }
        .btn-info    { background:rgba(59,130,246,.15); color:#60a5fa; border:1px solid rgba(59,130,246,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .search-bar { display:flex; gap:10px; margin-bottom:28px; }
        .search-bar input { flex:1; background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
                            border-radius:10px; padding:10px 16px; color:#e2e8f0; font-size:.9rem; }
        .search-bar input:focus { outline:none; border-color:#10b981; }
        .stats-row { display:grid; grid-template-columns:repeat(3,1fr); gap:16px; margin-bottom:28px; }
        .stat-card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                     border-radius:14px; padding:20px; text-align:center; }
        .stat-card .num { font-size:2rem; font-weight:700; color:#10b981; }
        .stat-card .lbl { font-size:.8rem; color:#94a3b8; margin-top:4px; }
        .alert { padding:12px 18px; border-radius:10px; margin-bottom:20px; font-size:.9rem; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3); color:#4ade80; }
        .alert-error   { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);  color:#f87171; }
        .table-wrap { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:16px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:13px 16px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); }
        th { font-size:.78rem; font-weight:600; text-transform:uppercase; color:#94a3b8;
             background:rgba(255,255,255,.03); }
        td { font-size:.88rem; }
        tr:hover td { background:rgba(255,255,255,.03); }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.75rem; font-weight:600; }
        .badge-active   { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-inactive { background:rgba(239,68,68,.15); color:#f87171; }
        .actions { display:flex; gap:6px; flex-wrap:wrap; }
        .empty-state { text-align:center; padding:60px 20px; color:#64748b; }
    </style>
</head>
<body>
<div class="topbar">
    <h1>🏠 PropertyHub — Seller Management</h1>
    <div class="topbar-links">
        <a href="/admin-dashboard">Dashboard</a>
        <a href="/buyers">Buyers</a>
        <a href="/properties">Properties</a>
        <a href="/bookings">Bookings</a>
        <a href="/feedback">Feedback</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div>
            <div class="page-title">All <span>Sellers</span></div>
            <p style="color:#64748b;font-size:.9rem;margin-top:4px;">
                Component 02 — Manage registered seller accounts
            </p>
        </div>
        <a href="/sellers/create" class="btn btn-primary">＋ Add Seller</a>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">✓ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">✗ ${errorMsg}</div>
    </c:if>

    <div class="stats-row">
        <div class="stat-card">
            <div class="num">${totalSellers}</div>
            <div class="lbl">Total Sellers</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#4ade80;">
                <c:set var="active" value="0"/>
                <c:forEach var="s" items="${sellers}">
                    <c:if test="${s.isActive}"><c:set var="active" value="${active+1}"/></c:if>
                </c:forEach>
                ${active}
            </div>
            <div class="lbl">Active Sellers</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#f87171;">${totalSellers - active}</div>
            <div class="lbl">Deactivated</div>
        </div>
    </div>

    <form method="get" action="/sellers" class="search-bar">
        <input type="text" name="search" placeholder="Search by name or email…" value="${search}">
        <button type="submit" class="btn btn-primary">Search</button>
        <c:if test="${not empty search}">
            <a href="/sellers" class="btn btn-info">Clear</a>
        </c:if>
    </form>

    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty sellers}">
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">🏪</div>
                    <p>No sellers found.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Name</th><th>Email</th>
                            <th>Phone</th><th>Status</th><th>Joined</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="seller" items="${sellers}">
                        <tr>
                            <td>#${seller.userId}</td>
                            <td>${seller.firstName} ${seller.lastName}</td>
                            <td>${seller.email}</td>
                            <td>${not empty seller.phone ? seller.phone : '—'}</td>
                            <td>
                                <span class="badge ${seller.isActive ? 'badge-active' : 'badge-inactive'}">
                                    ${seller.isActive ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                            <td>${seller.createdAt}</td>
                            <td>
                                <div class="actions">
                                    <a href="/sellers/${seller.userId}" class="btn btn-info">View</a>
                                    <a href="/sellers/edit/${seller.userId}" class="btn btn-warning">Edit</a>
                                    <a href="/sellers/toggle-status/${seller.userId}" class="btn btn-warning">
                                        ${seller.isActive ? 'Deactivate' : 'Activate'}
                                    </a>
                                    <a href="/sellers/delete/${seller.userId}"
                                       class="btn btn-danger"
                                       onclick="return confirm('Delete seller and all their listings?')">Delete</a>
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
