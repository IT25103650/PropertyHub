<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Property Management | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh; }
        .topbar { background:#1e293b; padding:16px 32px; display:flex; align-items:center;
                  justify-content:space-between; border-bottom:1px solid rgba(245,158,11,.2); }
        .topbar h1 { font-size:1.4rem; font-weight:700;
                     background:linear-gradient(135deg,#f59e0b,#ef4444); -webkit-background-clip:text;
                     -webkit-text-fill-color:transparent; }
        .topbar-links a { color:#94a3b8; text-decoration:none; margin-left:20px; font-size:.9rem; }
        .topbar-links a:hover { color:#f59e0b; }
        .container { max-width:1300px; margin:0 auto; padding:32px 24px; }
        .page-header { display:flex; justify-content:space-between; align-items:center; margin-bottom:24px; }
        .page-title { font-size:1.8rem; font-weight:700; }
        .page-title span { color:#f59e0b; }
        .filter-bar { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:14px; padding:20px; margin-bottom:24px; }
        .filter-bar form { display:grid; grid-template-columns:repeat(auto-fit,minmax(160px,1fr));
                           gap:12px; align-items:end; }
        .filter-group label { font-size:.78rem; color:#94a3b8; font-weight:600; display:block; margin-bottom:6px; }
        .filter-group input, .filter-group select {
            width:100%; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
            border-radius:8px; padding:9px 12px; color:#e2e8f0; font-size:.85rem;
            font-family:'Inter',sans-serif; }
        .filter-group input:focus, .filter-group select:focus { outline:none; border-color:#f59e0b; }
        .btn { display:inline-flex; align-items:center; gap:6px; padding:10px 18px; border-radius:10px;
               font-size:.88rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#f59e0b,#ef4444); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(245,158,11,.35); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-info    { background:rgba(59,130,246,.15); color:#60a5fa; border:1px solid rgba(59,130,246,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-sm { padding:6px 12px; font-size:.8rem; }
        .alert { padding:12px 18px; border-radius:10px; margin-bottom:20px; font-size:.9rem; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3); color:#4ade80; }
        .alert-error   { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);  color:#f87171; }
        .stats-row { display:grid; grid-template-columns:repeat(4,1fr); gap:14px; margin-bottom:24px; }
        .stat-card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                     border-radius:12px; padding:18px; text-align:center; }
        .stat-card .num { font-size:1.8rem; font-weight:700; color:#f59e0b; }
        .stat-card .lbl { font-size:.78rem; color:#94a3b8; }
        .table-wrap { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                      border-radius:16px; overflow:hidden; }
        table { width:100%; border-collapse:collapse; }
        th,td { padding:12px 16px; text-align:left; border-bottom:1px solid rgba(255,255,255,.06); }
        th { font-size:.76rem; font-weight:600; text-transform:uppercase; color:#94a3b8;
             background:rgba(255,255,255,.03); }
        td { font-size:.85rem; }
        tr:hover td { background:rgba(255,255,255,.03); }
        .badge { display:inline-block; padding:3px 10px; border-radius:20px; font-size:.73rem; font-weight:600; }
        .badge-available { background:rgba(34,197,94,.15); color:#4ade80; }
        .badge-pending   { background:rgba(234,179,8,.15); color:#fbbf24; }
        .badge-sold      { background:rgba(99,102,241,.15); color:#a5b4fc; }
        .badge-rented    { background:rgba(59,130,246,.15); color:#60a5fa; }
        .actions { display:flex; gap:5px; }
        .prop-img { width:48px; height:36px; border-radius:6px; object-fit:cover;
                    background:#1e293b; display:flex; align-items:center; justify-content:center;
                    color:#64748b; font-size:.7rem; }
        .price-tag { color:#f59e0b; font-weight:600; }
        .empty-state { text-align:center; padding:60px; color:#64748b; }
    </style>
</head>
<body>
<div class="topbar">
    <h1>🏠 PropertyHub — Property Management</h1>
    <div class="topbar-links">
        <a href="/admin-dashboard">Dashboard</a>
        <a href="/buyers">Buyers</a>
        <a href="/sellers">Sellers</a>
        <a href="/bookings">Bookings</a>
        <a href="/feedback">Feedback</a>
    </div>
</div>

<div class="container">
    <div class="page-header">
        <div>
            <div class="page-title">All <span>Properties</span></div>
            <p style="color:#64748b;font-size:.9rem;margin-top:4px;">
                Component 03 — Manage property listings
            </p>
        </div>
        <a href="/properties/create" class="btn btn-primary">＋ Add Property</a>
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
            <div class="num">${totalProperties}</div>
            <div class="lbl">Total Listings</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#4ade80;">
                <c:set var="avail" value="0"/>
                <c:forEach var="p" items="${properties}">
                    <c:if test="${p.status == 'available'}"><c:set var="avail" value="${avail+1}"/></c:if>
                </c:forEach>
                ${avail}
            </div>
            <div class="lbl">Available</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#a5b4fc;">
                <c:set var="sold" value="0"/>
                <c:forEach var="p" items="${properties}">
                    <c:if test="${p.status == 'sold'}"><c:set var="sold" value="${sold+1}"/></c:if>
                </c:forEach>
                ${sold}
            </div>
            <div class="lbl">Sold</div>
        </div>
        <div class="stat-card">
            <div class="num" style="color:#60a5fa;">
                <c:set var="rented" value="0"/>
                <c:forEach var="p" items="${properties}">
                    <c:if test="${p.status == 'rented'}"><c:set var="rented" value="${rented+1}"/></c:if>
                </c:forEach>
                ${rented}
            </div>
            <div class="lbl">Rented</div>
        </div>
    </div>

    <!-- Filters -->
    <div class="filter-bar">
        <form method="get" action="/properties">
            <div class="filter-group">
                <label>Search Keyword</label>
                <input type="text" name="search" value="${search}" placeholder="Title or location…">
            </div>
            <div class="filter-group">
                <label>Location</label>
                <input type="text" name="location" value="${location}" placeholder="e.g. Colombo">
            </div>
            <div class="filter-group">
                <label>Property Type</label>
                <select name="propType">
                    <option value="">All Types</option>
                    <option value="house"      ${propType=='house'?'selected':''}>House</option>
                    <option value="apartment"  ${propType=='apartment'?'selected':''}>Apartment</option>
                    <option value="land"       ${propType=='land'?'selected':''}>Land</option>
                    <option value="commercial" ${propType=='commercial'?'selected':''}>Commercial</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Listing Type</label>
                <select name="listType">
                    <option value="">For Sale &amp; Rent</option>
                    <option value="sale" ${listType=='sale'?'selected':''}>For Sale</option>
                    <option value="rent" ${listType=='rent'?'selected':''}>For Rent</option>
                </select>
            </div>
            <div class="filter-group">
                <label>Status</label>
                <select name="status">
                    <option value="">Any Status</option>
                    <option value="available" ${status=='available'?'selected':''}>Available</option>
                    <option value="pending"   ${status=='pending'?'selected':''}>Pending</option>
                    <option value="sold"      ${status=='sold'?'selected':''}>Sold</option>
                    <option value="rented"    ${status=='rented'?'selected':''}>Rented</option>
                </select>
            </div>
            <div class="filter-group">
                <label>&nbsp;</label>
                <div style="display:flex;gap:8px;">
                    <button type="submit" class="btn btn-primary btn-sm">Filter</button>
                    <a href="/properties" class="btn btn-info btn-sm">Reset</a>
                </div>
            </div>
        </form>
    </div>

    <!-- Table -->
    <div class="table-wrap">
        <c:choose>
            <c:when test="${empty properties}">
                <div class="empty-state">
                    <div style="font-size:3rem;margin-bottom:12px;">🏗️</div>
                    <p>No properties found matching your criteria.</p>
                </div>
            </c:when>
            <c:otherwise>
                <table>
                    <thead>
                        <tr>
                            <th>ID</th><th>Image</th><th>Title</th><th>Location</th>
                            <th>Type</th><th>Price</th><th>Beds</th><th>Status</th><th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                        <c:forEach var="p" items="${properties}">
                        <tr>
                            <td>#${p.propertyId}</td>
                            <td>
                                <c:choose>
                                    <c:when test="${not empty imageMap[p.propertyId]}">
                                        <img src="${imageMap[p.propertyId]}" class="prop-img" alt="">
                                    </c:when>
                                    <c:otherwise>
                                        <div class="prop-img">No img</div>
                                    </c:otherwise>
                                </c:choose>
                            </td>
                            <td>${p.title}</td>
                            <td>${p.location}</td>
                            <td>${p.propertyType} / ${p.listingType}</td>
                            <td class="price-tag">LKR ${p.price}</td>
                            <td>${not empty p.bedrooms ? p.bedrooms : '—'}</td>
                            <td><span class="badge badge-${p.status}">${p.status}</span></td>
                            <td>
                                <div class="actions">
                                    <a href="/properties/${p.propertyId}" class="btn btn-info btn-sm">View</a>
                                    <a href="/properties/edit/${p.propertyId}" class="btn btn-warning btn-sm">Edit</a>
                                    <a href="/properties/delete/${p.propertyId}"
                                       class="btn btn-danger btn-sm"
                                       onclick="return confirm('Delete this listing?')">Del</a>
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
