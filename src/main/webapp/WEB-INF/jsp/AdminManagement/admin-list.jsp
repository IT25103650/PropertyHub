<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Management | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; align-items:center;
                  justify-content:space-between; border-bottom:1px solid rgba(239,68,68,.2); }
        .topbar h1 { font-size:1.4rem; font-weight:700;
                     background:linear-gradient(135deg,#ef4444,#f97316); -webkit-background-clip:text;
                     -webkit-text-fill-color:transparent; }
        .topbar-links a { color:#94a3b8; text-decoration:none; margin-left:20px; font-size:.9rem; }
        .topbar-links a:hover { color:#ef4444; }
        .container { max-width:1200px; margin:0 auto; padding:32px 24px; }
        .page-header { display:flex; align-items:center; justify-content:space-between; margin-bottom:32px; }
        .page-title { font-size:1.8rem; font-weight:700; }
        .page-title span { color:#ef4444; }
        .btn { display:inline-flex; align-items:center; gap:8px; padding:10px 20px; border-radius:10px;
               font-size:.9rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#ef4444,#f97316); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(239,68,68,.4); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-info    { background:rgba(59,130,246,.15); color:#60a5fa; border:1px solid rgba(59,130,246,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .search-bar { display:flex; gap:10px; margin-bottom:28px; }
        .search-bar input { flex:1; background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
                            border-radius:10px; padding:10px 16px; color:#e2e8f0; font-size:.9rem; }
        .search-bar input:focus { outline:none; border-color:#ef4444; }
        .alert { padding:12px 18px; border-radius:10px; margin-bottom:20px; font-size:.9rem; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3); color:#4ade80; }
        .alert-error   { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);  color:#f87171; }
        .table-wrap { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:16px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:13px 16px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); }
        th { font-size:.78rem; font-weight:600; text-transform:uppercase; color:#94a3b8; background:rgba(255,255,255,.03); }
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
    <h1>🏠 PropertyHub — Admin Management</h1>
    <div class="topbar-links">
        <a href="/admin-dashboard">Dashboard</a>
        <a href="/buyers">Buyers</a>
        <a href="/sellers">Sellers</a>
        <a href="/properties">Properties</a>
        <a href="/bookings">Bookings</a>
        <a href="/feedback">Feedback</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div>
            <div class="page-title">Admin <span>Accounts</span></div>
            <p style="color:#64748b;font-size:.9rem;margin-top:4px;">
                Component 05 — Manage system administrators
            </p>
        </div>
        <a href="/admins/create" class="btn btn-primary">＋ Create Admin</a>
    </div>

    <c:if test="${not empty successMsg}">
        <div class="alert alert-success">✓ ${successMsg}</div>
    </c:if>
    <c:if test="${not empty errorMsg}">
        <div class="alert alert-error">✗ ${errorMsg}</div>
    </c:if>

    <form method="get" action="/admins" class="search-bar">
        <input type="text" name="search" placeholder="Search by name or email…" value="${search}">
        <button type="submit" class="btn btn-primary">Search</button>
        <c:if test="${not empty search}">
            <a href="/admins" class="btn btn-info">Clear</a>
        </c:if>
    </form>

    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty admins}">
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">🛡️</div>
                    <p>No admin accounts found.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Name</th><th>Email</th>
                            <th>Phone</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="admin" items="${admins}">
                        <tr>
                            <td>#${admin.userId}</td>
                            <td>${admin.firstName} ${admin.lastName}</td>
                            <td>${admin.email}</td>
                            <td>${not empty admin.phone ? admin.phone : '—'}</td>
                            <td>
                                <span class="badge ${admin.isActive ? 'badge-active' : 'badge-inactive'}">
                                    ${admin.isActive ? 'Active' : 'Inactive'}
                                </span>
                            </td>
                            <td>
                                <div class="actions">
                                    <a href="/admins/${admin.userId}" class="btn btn-info">View</a>
                                    <a href="/admins/edit/${admin.userId}" class="btn btn-warning">Edit</a>
                                    <c:if test="${sessionScope.userId != admin.userId}">
                                        <a href="/admins/toggle-status/${admin.userId}" class="btn btn-warning">
                                            ${admin.isActive ? 'Deactivate' : 'Activate'}
                                        </a>
                                        <a href="/admins/delete/${admin.userId}" class="btn btn-danger"
                                           onclick="return confirm('Delete this admin account?')">Delete</a>
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
