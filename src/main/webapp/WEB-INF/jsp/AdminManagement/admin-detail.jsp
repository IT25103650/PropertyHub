<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${admin.firstName} ${admin.lastName} | Admin Detail</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; justify-content:space-between;
                  border-bottom:1px solid rgba(239,68,68,.2); }
        .topbar a { color:#94a3b8; text-decoration:none; font-size:.9rem; }
        .topbar a:hover { color:#ef4444; }
        .container { max-width:960px; margin:0 auto; padding:32px 24px; }
        .profile-card { background:rgba(255,255,255,.05); border:1px solid rgba(239,68,68,.2);
                        border-radius:20px; padding:32px; display:grid;
                        grid-template-columns:auto 1fr; gap:28px; align-items:start; margin-bottom:28px; }
        .avatar { width:90px; height:90px; border-radius:50%;
                  background:linear-gradient(135deg,#ef4444,#f97316);
                  display:flex; align-items:center; justify-content:center;
                  font-size:2.2rem; font-weight:700; color:#fff; }
        .profile-info h2 { font-size:1.6rem; font-weight:700; }
        .role-badge { display:inline-block; background:rgba(239,68,68,.2); color:#fca5a5;
                      padding:3px 12px; border-radius:20px; font-size:.78rem; font-weight:600; margin:6px 0; }
        .meta-grid { display:grid; grid-template-columns:1fr 1fr; gap:10px; margin-top:12px; }
        .meta-item label { font-size:.75rem; color:#64748b; display:block; }
        .meta-item span { font-size:.9rem; }
        .section { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                   border-radius:16px; padding:24px; margin-bottom:20px; }
        .section h3 { font-size:1rem; font-weight:600; margin-bottom:16px; color:#fca5a5; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:10px 14px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); font-size:.85rem; }
        th { color:#64748b; font-weight:600; font-size:.78rem; text-transform:uppercase; }
        .badge { display:inline-block; padding:2px 10px; border-radius:20px; font-size:.75rem; font-weight:600; }
        .badge-active   { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-inactive { background:rgba(239,68,68,.15); color:#f87171; }
        .empty { color:#64748b; font-size:.88rem; padding:12px 0; }
    </style>
</head>
<body>
<div class="topbar">
    <a href="/admins">← Back to Admins</a>
    <div style="display:flex;gap:16px;">
        <a href="/admins/edit/${admin.userId}">Edit Profile</a>
        <c:if test="${sessionScope.userId != admin.userId}">
            <a href="/admins/toggle-status/${admin.userId}">${admin.isActive ? 'Deactivate' : 'Activate'}</a>
            <a href="/admins/delete/${admin.userId}"
               onclick="return confirm('Permanently delete this admin?')" style="color:#f87171;">Delete</a>
        </c:if>
    </div>
</div>

<div class="container">
    <div class="profile-card">
        <div class="avatar">${admin.firstName.substring(0,1)}${admin.lastName.substring(0,1)}</div>
        <div class="profile-info">
            <h2>${admin.firstName} ${admin.lastName}</h2>
            <span class="role-badge">🛡️ System Administrator</span>
            <span class="badge ${admin.isActive ? 'badge-active' : 'badge-inactive'}" style="margin-left:8px;">
                ${admin.isActive ? 'Active' : 'Inactive'}
            </span>
            <div class="meta-grid">
                <div class="meta-item"><label>Email</label><span>${admin.email}</span></div>
                <div class="meta-item"><label>Phone</label><span>${not empty admin.phone ? admin.phone : '—'}</span></div>
                <div class="meta-item"><label>Created At</label><span>${admin.createdAt}</span></div>
                <div class="meta-item"><label>Admin ID</label><span>#${admin.userId}</span></div>
            </div>
        </div>
    </div>

    <!-- Admin Logs -->
    <div class="section">
        <h3>📋 Recent Activity Logs</h3>
        <c:choose>
            <c:when test="${empty adminLogs}">
                <p class="empty">No recent activity logs found for this admin.</p>
            </c:when>
            <c:otherwise>
                <table>
                    <thead><tr><th>Date & Time</th><th>Action Type</th><th>Description</th></tr></thead>
                    <tbody>
                        <c:forEach var="log" items="${adminLogs}">
                        <tr>
                            <td style="color:#94a3b8;">${log.created_at}</td>
                            <td style="font-weight:600;">${log.action_type}</td>
                            <td>${log.description}</td>
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
