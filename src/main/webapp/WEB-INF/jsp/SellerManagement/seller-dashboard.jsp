<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Seller Dashboard | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        body { background-color: #f1f5f9; font-family: 'Outfit', sans-serif; margin: 0; }
        .navbar { position: fixed; top: 0; width: 100%; z-index: 9999; background: #0f172a; padding: 0 5%; height: 68px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 16px rgba(0,0,0,0.25); }
        .navbar .logo { color: white; font-size: 1.4rem; font-weight: 700; text-decoration: none; display: flex; align-items: center; gap: 8px; }
        .navbar .logo span { color: #10b981; }
        .navbar .nav-right { display: flex; align-items: center; gap: 16px; }
        .navbar .nav-right span { color: #cbd5e1; font-size: 0.9rem; }
        .navbar .nav-right a { color: #f87171; font-size: 0.85rem; font-weight: 600; text-decoration: none; transition: opacity 0.2s; }
        .navbar .nav-right a:hover { opacity: 0.8; }
        .layout { display: flex; min-height: 100vh; padding-top: 68px; }

        /* Sidebar */
        .sidebar { width: 260px; min-width: 260px; background: #0f172a; padding: 28px 16px; position: fixed; top: 68px; height: calc(100vh - 68px); overflow-y: auto; display: flex; flex-direction: column; }
        .avatar-wrap { text-align: center; padding: 16px 0 24px; border-bottom: 1px solid rgba(255,255,255,0.08); }
        .s-avatar { width: 72px; height: 72px; border-radius: 50%; background: linear-gradient(135deg, #10b981, #059669); color: white; font-size: 1.7rem; font-weight: 700; display: flex; align-items: center; justify-content: center; margin: 0 auto 10px; }
        .avatar-wrap h4 { color: white; font-size: 1rem; margin: 0 0 2px; }
        .avatar-wrap p { color: #64748b; font-size: 0.78rem; margin: 0; }
        .nav-links { display: flex; flex-direction: column; gap: 4px; margin-top: 20px; flex: 1; }
        .nav-links a { display: flex; align-items: center; gap: 10px; padding: 11px 14px; border-radius: 10px; color: #94a3b8; font-size: 0.88rem; font-weight: 500; text-decoration: none; transition: all 0.2s; }
        .nav-links a:hover { background: rgba(255,255,255,0.06); color: white; }
        .nav-links a.active { background: rgba(16,185,129,0.15); color: #10b981; }
        .nav-links a i { width: 18px; text-align: center; }
        .nav-links .logout-link { color: #f87171; margin-top: auto; }
        .nav-links .logout-link:hover { background: rgba(239,68,68,0.1); }

        /* Main Content */
        .main { margin-left: 260px; padding: 32px 36px; flex: 1; min-height: 100vh; }
        .page-header { margin-bottom: 28px; }
        .page-header h2 { font-size: 1.6rem; font-weight: 700; color: #0f172a; margin: 0 0 4px; }
        .page-header p { color: #64748b; margin: 0; font-size: 0.9rem; }

        /* Cards & Stats */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 28px; }
        .stat-card { background: white; border-radius: 16px; padding: 22px; box-shadow: 0 1px 8px rgba(0,0,0,0.05); display: flex; align-items: center; gap: 16px; border: 1px solid #f1f5f9; }
        .stat-icon { width: 52px; height: 52px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0; }
        .stat-icon.green  { background: rgba(16,185,129,0.1); color: #10b981; }
        .stat-icon.amber  { background: rgba(245,158,11,0.1);  color: #f59e0b; }
        .stat-icon.blue   { background: rgba(59,130,246,0.1);  color: #3b82f6; }
        .stat-icon.purple { background: rgba(139,92,246,0.1);  color: #8b5cf6; }
        .stat-info h3 { font-size: 1.6rem; font-weight: 700; color: #0f172a; margin: 0 0 2px; }
        .stat-info p { font-size: 0.82rem; color: #64748b; margin: 0; }

        .card { background: white; border-radius: 16px; padding: 24px; box-shadow: 0 1px 8px rgba(0,0,0,0.05); margin-bottom: 24px; border: 1px solid #f1f5f9; }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .card-header h3 { font-size: 1.1rem; font-weight: 700; color: #0f172a; margin: 0; }

        /* Tables */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table th { padding: 11px 12px; text-align: left; font-size: 0.78rem; font-weight: 700; color: #64748b; text-transform: uppercase; letter-spacing: 0.05em; border-bottom: 2px solid #f1f5f9; }
        .data-table td { padding: 12px; font-size: 0.88rem; color: #334155; border-bottom: 1px solid #f8fafc; vertical-align: middle; }
        .data-table tr:last-child td { border-bottom: none; }
        .data-table tr:hover td { background: #f8fafc; }

        /* Badges */
        .badge { display: inline-block; padding: 3px 10px; border-radius: 20px; font-size: 0.74rem; font-weight: 700; text-transform: capitalize; }
        .badge-pending   { background: rgba(245,158,11,0.1);  color: #92400e; }
        .badge-confirmed { background: rgba(16,185,129,0.1);  color: #065f46; }
        .badge-cancelled { background: rgba(239,68,68,0.1);   color: #991b1b; }
        .badge-completed { background: rgba(59,130,246,0.1);  color: #1e40af; }
        .badge-available { background: rgba(16,185,129,0.1);  color: #065f46; }
        .badge-sale      { background: rgba(16,185,129,0.08); color: #059669; }
        .badge-rent      { background: rgba(59,130,246,0.08); color: #1d4ed8; }

        /* Buttons */
        .btn-primary-sm { background: #10b981; color: white; border: none; padding: 7px 16px; border-radius: 8px; font-size: 0.82rem; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-primary-sm:hover { background: #059669; }
        .btn-outline-sm { background: transparent; color: #475569; border: 1px solid #e2e8f0; padding: 7px 14px; border-radius: 8px; font-size: 0.82rem; font-weight: 600; cursor: pointer; text-decoration: none; display: inline-flex; align-items: center; gap: 6px; transition: all 0.2s; }
        .btn-outline-sm:hover { border-color: #10b981; color: #10b981; }
        .btn-danger-sm { background: transparent; color: #dc2626; border: 1px solid rgba(220,38,38,0.3); padding: 7px 14px; border-radius: 8px; font-size: 0.82rem; font-weight: 600; cursor: pointer; text-decoration: none; transition: all 0.2s; }
        .btn-danger-sm:hover { background: #dc2626; color: white; }
        .btn-confirm { background: rgba(16,185,129,0.1); color: #065f46; border: 1px solid rgba(16,185,129,0.25); padding: 5px 12px; border-radius: 7px; font-size: 0.78rem; font-weight: 700; text-decoration: none; transition: all 0.2s; }
        .btn-confirm:hover { background: #10b981; color: white; }
        .btn-complete { background: rgba(59,130,246,0.1); color: #1e40af; border: 1px solid rgba(59,130,246,0.25); padding: 5px 12px; border-radius: 7px; font-size: 0.78rem; font-weight: 700; text-decoration: none; transition: all 0.2s; }
        .btn-complete:hover { background: #3b82f6; color: white; }
        .btn-cancel-s { background: rgba(239,68,68,0.1); color: #991b1b; border: 1px solid rgba(239,68,68,0.25); padding: 5px 12px; border-radius: 7px; font-size: 0.78rem; font-weight: 700; text-decoration: none; transition: all 0.2s; }
        .btn-cancel-s:hover { background: #ef4444; color: white; }

        /* Forms */
        .form-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 18px; }
        .form-group { display: flex; flex-direction: column; gap: 6px; }
        .form-group label { font-size: 0.82rem; font-weight: 600; color: #475569; }
        .form-group input, .form-group select, .form-group textarea {
            padding: 10px 14px; border: 1.5px solid #e2e8f0; border-radius: 10px;
            font-family: 'Outfit', sans-serif; font-size: 0.9rem; color: #334155;
            transition: border-color 0.2s; outline: none; background: #f8fafc;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #10b981; background: white; box-shadow: 0 0 0 3px rgba(16,185,129,0.08);
        }
        .form-group textarea { resize: vertical; min-height: 90px; }
        .form-full { grid-column: 1 / -1; }

        /* Alerts */
        .alert { padding: 12px 18px; border-radius: 10px; font-size: 0.88rem; font-weight: 500; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .alert-success { background: rgba(16,185,129,0.08); border: 1px solid rgba(16,185,129,0.25); color: #065f46; }
        .alert-danger { background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.25); color: #991b1b; }

        .empty-state { text-align: center; padding: 48px 24px; color: #94a3b8; }
        .empty-state i { font-size: 2.5rem; margin-bottom: 12px; display: block; }
        .empty-state p { font-size: 0.9rem; margin: 0; }

        /* Image Upload Zone */
        .img-upload-zone { border: 2px dashed #e2e8f0; border-radius: 12px; padding: 32px 20px; text-align: center; cursor: pointer; transition: border-color 0.2s, background 0.2s; position: relative; }
        .img-upload-zone:hover { border-color: #10b981; background: rgba(16,185,129,0.02); }
        .img-upload-zone input[type="file"] { position: absolute; inset: 0; width: 100%; height: 100%; opacity: 0; cursor: pointer; }
        .img-upload-zone i { font-size: 2rem; color: #10b981; margin-bottom: 10px; display: block; }
        .img-upload-zone p { color: #64748b; margin: 0; font-size: 0.88rem; }
        #img-preview-grid { display: grid; grid-template-columns: repeat(auto-fill, minmax(100px, 1fr)); gap: 10px; margin-top: 14px; }
        #img-preview-grid div { border-radius: 8px; overflow: hidden; aspect-ratio: 1; background: #f1f5f9; }
        #img-preview-grid img { width: 100%; height: 100%; object-fit: cover; }
    </style>
</head>
<body>

    <!-- Navbar -->
    <header class="navbar">
        <a href="/" class="logo"><i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span></a>
        <div class="nav-right" style="position:relative;">
            <!-- Profile dropdown trigger -->
            <div id="s-profile-trigger" onclick="toggleSellerProfile()" style="display:flex;align-items:center;gap:8px;cursor:pointer;padding:6px 14px;border-radius:30px;background:rgba(16,185,129,0.12);border:1px solid rgba(16,185,129,0.25);transition:background 0.2s;">
                <c:choose>
                    <c:when test="${not empty profileImage}">
                        <img src="${profileImage}" style="width:30px;height:30px;border-radius:50%;object-fit:cover;border:2px solid #10b981;" alt="Profile">
                    </c:when>
                    <c:otherwise>
                        <div style="width:30px;height:30px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);color:white;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.78rem;">${initials}</div>
                    </c:otherwise>
                </c:choose>
                <span style="color:#cbd5e1;font-size:0.88rem;">Welcome, <strong style="color:white;">${fullName}</strong></span>
                <i class="fa-solid fa-chevron-down" style="font-size:0.6rem;color:#94a3b8;"></i>
            </div>
            <!-- Profile dropdown panel -->
            <div id="s-profile-panel" style="display:none;position:fixed;top:68px;right:20px;background:white;border-radius:14px;box-shadow:0 16px 48px rgba(0,0,0,0.18);border:1px solid #e2e8f0;width:260px;z-index:99999;overflow:hidden;">
                <div style="padding:16px 20px;background:linear-gradient(135deg,#0f172a,#1e293b);color:white;">
                    <div style="display:flex;align-items:center;gap:10px;">
                        <div style="width:42px;height:42px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);display:flex;align-items:center;justify-content:center;font-size:1rem;font-weight:700;">${initials}</div>
                        <div>
                            <div style="font-weight:700;font-size:0.9rem;">${fullName}</div>
                            <div style="font-size:0.75rem;color:#94a3b8;">Seller Account</div>
                        </div>
                    </div>
                </div>
                <div style="padding:8px;">
                    <a href="/seller-dashboard?section=profile" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#334155;font-size:0.86rem;text-decoration:none;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                        <i class="fa-solid fa-user-pen" style="color:#10b981;width:14px;"></i> Edit Profile
                    </a>
                    <a href="/" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#334155;font-size:0.86rem;text-decoration:none;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                        <i class="fa-solid fa-house" style="color:#3b82f6;width:14px;"></i> Main Site
                    </a>
                    <hr style="margin:6px 0;border:none;border-top:1px solid #f1f5f9;">
                    <a href="/logout" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#ef4444;font-size:0.86rem;text-decoration:none;" onmouseover="this.style.background='#fef2f2'" onmouseout="this.style.background='transparent'">
                        <i class="fa-solid fa-right-from-bracket" style="width:14px;"></i> Logout
                    </a>
                </div>
            </div>
        </div>
    </header>

    <div class="layout">
        <!-- Sidebar -->
        <aside class="sidebar">
            <div class="avatar-wrap">
                <div class="s-avatar">${initials}</div>
                <h4>${fullName}</h4>
                <p>Seller Account</p>
            </div>
            <nav class="nav-links">
                <a href="/seller-dashboard" class="${empty param.section ? 'active' : ''}">
                    <i class="fa-solid fa-gauge-high"></i> Dashboard
                </a>
                <a href="/seller-dashboard?section=properties" class="${param.section == 'properties' ? 'active' : ''}">
                    <i class="fa-solid fa-building"></i> My Properties
                </a>
                <a href="/seller-dashboard?section=add-property" class="${param.section == 'add-property' ? 'active' : ''}">
                    <i class="fa-solid fa-circle-plus"></i> Add Property
                </a>
                <a href="/seller-dashboard?section=bookings" class="${param.section == 'bookings' ? 'active' : ''}">
                    <i class="fa-solid fa-calendar-check"></i> Booking Requests
                    <c:if test="${pendingCount > 0}">
                        <span style="margin-left:auto;background:#f59e0b;color:white;border-radius:20px;font-size:0.7rem;padding:2px 7px;font-weight:700;">${pendingCount}</span>
                    </c:if>
                </a>
                <a href="/seller-dashboard?section=inquiries" class="${param.section == 'inquiries' ? 'active' : ''}">
                    <i class="fa-solid fa-envelope"></i> Messages
                    <c:if test="${unreadInquiries > 0}">
                        <span style="margin-left:auto;background:#f59e0b;color:white;border-radius:20px;font-size:0.7rem;padding:2px 7px;font-weight:700;">${unreadInquiries}</span>
                    </c:if>
                </a>
                <a href="/logout" class="logout-link" style="margin-top: auto;">
                    <i class="fa-solid fa-right-from-bracket"></i> Logout
                </a>
            </nav>
        </aside>

        <!-- Main Content -->
        <main class="main">

            <!-- Alert Messages -->
            <c:if test="${param.updated == 'true'}">
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Updated successfully!</div>
            </c:if>
            <c:if test="${param.added == 'true'}">
                <div class="alert alert-success"><i class="fa-solid fa-circle-check"></i> Property listed successfully!</div>
            </c:if>
            <c:if test="${param.add_error == 'true'}">
                <div class="alert alert-danger"><i class="fa-solid fa-circle-xmark"></i> Failed to publish listing. Please check all required fields and try again.</div>
            </c:if>
            <c:if test="${param.deleted == 'true'}">
                <div class="alert alert-danger"><i class="fa-solid fa-trash"></i> Property deleted.</div>
            </c:if>

            <c:choose>

                <%-- ======== OVERVIEW DASHBOARD ======== --%>
                <c:when test="${empty param.section and empty editProp}">
                    <div class="page-header">
                        <h2>Seller Dashboard</h2>
                        <p>Welcome back, ${firstName}! Here's an overview of your listings and bookings.</p>
                    </div>

                    <div class="stats-grid">
                        <div class="stat-card">
                            <div class="stat-icon green"><i class="fa-solid fa-building"></i></div>
                            <div class="stat-info"><h3>${propertyCount}</h3><p>Listed Properties</p></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon amber"><i class="fa-solid fa-clock"></i></div>
                            <div class="stat-info"><h3>${pendingCount}</h3><p>Pending Bookings</p></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon blue"><i class="fa-solid fa-calendar-check"></i></div>
                            <div class="stat-info"><h3>${confirmedCount}</h3><p>Confirmed Viewings</p></div>
                        </div>
                        <div class="stat-card">
                            <div class="stat-icon purple"><i class="fa-solid fa-list-ol"></i></div>
                            <div class="stat-info"><h3>${bookings.size()}</h3><p>Total Requests</p></div>
                        </div>
                    </div>

                    <!-- Recent Bookings -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fa-solid fa-calendar-clock" style="color:#f59e0b;margin-right:8px;"></i>Recent Booking Requests</h3>
                            <a href="/seller-dashboard?section=bookings" class="btn-outline-sm">View All</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty bookings}">
                                <div class="empty-state"><i class="fa-solid fa-calendar-xmark"></i><p>No booking requests yet.</p></div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead><tr>
                                        <th>Buyer</th><th>Property</th><th>Date</th><th>Type</th><th>Status</th>
                                    </tr></thead>
                                    <tbody>
                                        <c:forEach var="b" items="${bookings}" end="4">
                                            <tr>
                                                <td><strong>${b.first_name} ${b.last_name}</strong></td>
                                                <td>${b.property_title}</td>
                                                <td>${b.booking_date}</td>
                                                <td style="text-transform:capitalize;">${b.viewing_type}</td>
                                                <td><span class="badge badge-${b.status}">${b.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>

                    <!-- My Properties Quick View -->
                    <div class="card">
                        <div class="card-header">
                            <h3><i class="fa-solid fa-building" style="color:#10b981;margin-right:8px;"></i>My Listings</h3>
                            <a href="/seller-dashboard?section=add-property" class="btn-primary-sm"><i class="fa-solid fa-plus"></i> Add Property</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty properties}">
                                <div class="empty-state"><i class="fa-solid fa-house-circle-xmark"></i><p>You haven't added any properties yet.</p></div>
                            </c:when>
                            <c:otherwise>
                                <table class="data-table">
                                    <thead><tr><th>Title</th><th>Location</th><th>Price (LKR)</th><th>Type</th><th>Status</th></tr></thead>
                                    <tbody>
                                        <c:forEach var="p" items="${properties}" end="4">
                                            <tr>
                                                <td><strong>${p.title}</strong></td>
                                                <td>${p.location}</td>
                                                <td><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/></td>
                                                <td><span class="badge badge-${p.listing_type}">${p.listing_type}</span></td>
                                                <td><span class="badge badge-${p.status}">${p.status}</span></td>
                                            </tr>
                                        </c:forEach>
                                    </tbody>
                                </table>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <%-- ======== MY PROPERTIES ======== --%>
                <c:when test="${param.section == 'properties'}">
                    <div class="page-header">
                        <h2>My Properties</h2>
                        <p>Manage all your current listings.</p>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <h3>All Listings (${propertyCount})</h3>
                            <a href="/seller-dashboard?section=add-property" class="btn-primary-sm"><i class="fa-solid fa-plus"></i> Add New</a>
                        </div>
                        <c:choose>
                            <c:when test="${empty properties}">
                                <div class="empty-state"><i class="fa-solid fa-house-circle-xmark"></i><p>No properties listed yet. <a href="/seller-dashboard?section=add-property" style="color:#10b981;">Add your first one!</a></p></div>
                            </c:when>
                            <c:otherwise>
                                <div style="overflow-x:auto;">
                                    <table class="data-table">
                                        <thead><tr>
                                            <th>Title</th><th>Location</th><th>Type</th><th>Price (LKR)</th>
                                            <th>Beds/Baths</th><th>Listing</th><th>Status</th><th>Actions</th>
                                        </tr></thead>
                                        <tbody>
                                            <c:forEach var="p" items="${properties}">
                                                <tr>
                                                    <td><a href="/property-detail?id=${p.property_id}" style="text-decoration:none; color:inherit; font-weight:bold;" target="_blank" title="View Property">${p.title}</a></td>
                                                    <td><i class="fa-solid fa-location-dot" style="color:#10b981;"></i> ${p.location}</td>
                                                    <td style="text-transform:capitalize;">${p.property_type}</td>
                                                    <td style="color:#10b981;font-weight:700;"><fmt:formatNumber value="${p.price}" type="number" maxFractionDigits="0"/></td>
                                                    <td>${p.bedrooms} / ${p.bathrooms}</td>
                                                    <td><span class="badge badge-${p.listing_type}">${p.listing_type}</span></td>
                                                    <td><span class="badge badge-${p.status}">${p.status}</span></td>
                                                     <td style="white-space:nowrap;">
                                                         <a href="/seller-dashboard/edit-property?id=${p.property_id}"
                                                            class="btn-outline-sm" style="margin-right:6px;">
                                                            <i class="fa-solid fa-pen"></i> Edit
                                                         </a>
                                                         <a href="/seller-dashboard/delete-property?id=${p.property_id}"
                                                            class="btn-danger-sm"
                                                            onclick="return confirm('Delete this property? All its bookings will also be removed.')">
                                                            <i class="fa-solid fa-trash"></i> Delete
                                                         </a>
                                                     </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <%-- ======== EDIT PROPERTY ======== --%>
                <c:when test="${not empty editProp}">
                    <div class="page-header">
                        <h2>Edit Property</h2>
                        <p>Update the details for: <strong>${editProp.title}</strong></p>
                    </div>
                    <div class="card" style="max-width: 760px;">
                        <form action="/seller-dashboard/update-property" method="POST">
                            <input type="hidden" name="property_id" value="${editProp.property_id}">
                            <div class="form-grid">
                                <div class="form-group form-full">
                                    <label>Property Title *</label>
                                    <input type="text" name="title" value="${editProp.title}" required>
                                </div>
                                <div class="form-group">
                                    <label>Property Type *</label>
                                    <select name="property_type" required>
                                        <option value="house"    <c:if test="${editProp.property_type == 'house'}">selected</c:if>>House</option>
                                        <option value="apartment"<c:if test="${editProp.property_type == 'apartment'}">selected</c:if>>Apartment</option>
                                        <option value="land"     <c:if test="${editProp.property_type == 'land'}">selected</c:if>>Land</option>
                                        <option value="commercial"<c:if test="${editProp.property_type == 'commercial'}">selected</c:if>>Commercial</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Listing Type *</label>
                                    <select name="listing_type" required>
                                        <option value="sale"<c:if test="${editProp.listing_type == 'sale'}">selected</c:if>>For Sale</option>
                                        <option value="rent"<c:if test="${editProp.listing_type == 'rent'}">selected</c:if>>For Rent</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Price (LKR) *</label>
                                    <input type="number" name="price" value="${editProp.price}" required min="0">
                                </div>
                                <div class="form-group">
                                    <label>Location (City) *</label>
                                    <input type="text" name="location" value="${editProp.location}" required>
                                </div>
                                <div class="form-group">
                                    <label>Address</label>
                                    <input type="text" name="address" value="${editProp.address}">
                                </div>
                                <div class="form-group">
                                    <label>Status *</label>
                                    <select name="status" required>
                                        <option value="available" <c:if test="${editProp.status == 'available'}">selected</c:if>>Available</option>
                                        <option value="pending"   <c:if test="${editProp.status == 'pending'}">selected</c:if>>Pending</option>
                                        <option value="sold"      <c:if test="${editProp.status == 'sold'}">selected</c:if>>Sold</option>
                                        <option value="rented"    <c:if test="${editProp.status == 'rented'}">selected</c:if>>Rented</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Bedrooms</label>
                                    <input type="number" name="bedrooms" value="${editProp.bedrooms}" min="0">
                                </div>
                                <div class="form-group">
                                    <label>Bathrooms</label>
                                    <input type="number" name="bathrooms" value="${editProp.bathrooms}" min="0">
                                </div>
                                <div class="form-group">
                                    <label>Area (sqft)</label>
                                    <input type="number" name="sqft" value="${editProp.sqft}" min="0">
                                </div>
                                <div class="form-group form-full">
                                    <label>Description</label>
                                    <textarea name="description">${editProp.description}</textarea>
                                </div>
                            </div>
                            <div style="margin-top: 24px; display: flex; gap: 12px;">
                                <button type="submit" class="btn-primary-sm" style="padding: 11px 28px; font-size: 0.95rem;">
                                    <i class="fa-solid fa-floppy-disk"></i> Save Changes
                                </button>
                                <a href="/seller-dashboard?section=properties" class="btn-outline-sm" style="padding: 11px 20px; font-size: 0.95rem;">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>

                    <%-- ── Property Image Manager ── --%>
                    <div class="card" style="max-width: 760px;">
                        <div class="card-header" style="margin-bottom: 16px;">
                            <h3><i class="fa-solid fa-images" style="color:#3b82f6; margin-right:8px;"></i>Property Images</h3>
                        </div>

                        <%-- Existing images --%>
                        <c:choose>
                            <c:when test="${empty editPropImages}">
                                <div class="empty-state" style="padding: 24px;">
                                    <i class="fa-solid fa-image" style="font-size:1.8rem;"></i>
                                    <p>No images yet. Add one below.</p>
                                </div>
                            </c:when>
                            <c:otherwise>
                                <div style="display:flex; flex-wrap:wrap; gap:14px; margin-bottom:24px;">
                                    <c:forEach var="img" items="${editPropImages}">
                                        <div style="position:relative; width:130px; flex-shrink:0;">
                                            <img src="${img.image_url}" alt="Property image"
                                                 style="width:130px; height:100px; object-fit:cover; border-radius:10px;
                                                        border:3px solid ${img.is_primary ? '#10b981' : '#e2e8f0'};
                                                        display:block;">
                                            <c:if test="${img.is_primary}">
                                                <span style="position:absolute; top:6px; left:6px; background:#10b981;
                                                             color:white; font-size:0.6rem; font-weight:800;
                                                             padding:2px 7px; border-radius:5px; letter-spacing:.04em;">
                                                    PRIMARY
                                                </span>
                                            </c:if>
                                            <div style="display:flex; gap:5px; margin-top:7px; justify-content:center;">
                                                <a href="/seller-dashboard/delete-image?image_id=${img.image_id}&property_id=${img.property_id}"
                                                   class="btn-danger-sm"
                                                   style="font-size:0.7rem; padding:4px 9px;"
                                                   onclick="return confirm('Delete this image?')"
                                                   title="Delete image">
                                                    <i class="fa-solid fa-trash"></i>
                                                </a>
                                            </div>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>

                        <%-- Add new image by File Upload --%>
                        <div style="border-top:1.5px dashed #e2e8f0; padding-top:18px;">
                            <p style="font-size:0.82rem; font-weight:700; color:#475569; margin-bottom:12px;">
                                <i class="fa-solid fa-plus-circle" style="color:#10b981;"></i> Add New Image
                            </p>
                            <form action="/seller-dashboard/add-image" method="POST" enctype="multipart/form-data"
                                  style="display:flex; align-items:flex-end; gap:12px; flex-wrap:wrap;">
                                <input type="hidden" name="property_id" value="${editProp.property_id}">
                                <div class="form-group" style="flex:1; min-width:220px; margin:0;">
                                    <label>Upload Image</label>
                                    <input type="file" name="image_file" accept="image/*" required>
                                </div>
                                <div style="display:flex; align-items:center; gap:7px; padding-bottom:3px;">
                                    <input type="checkbox" name="is_primary" id="seller-primary-${editProp.property_id}"
                                           value="true" style="width:16px; height:16px; accent-color:#10b981;">
                                    <label for="seller-primary-${editProp.property_id}"
                                           style="font-size:0.82rem; font-weight:600; cursor:pointer; color:#475569;">
                                        Set as Primary
                                    </label>
                                </div>
                                <button type="submit" class="btn-primary-sm">
                                    <i class="fa-solid fa-plus"></i> Add Image
                                </button>
                            </form>
                        </div>
                    </div>
                </c:when>

                <%-- ======== ADD PROPERTY ======== --%>
                <c:when test="${param.section == 'add-property'}">
                    <div class="page-header">
                        <h2>Add New Property</h2>
                        <p>Fill in the details to publish a new listing.</p>
                    </div>
                    <div class="card" style="max-width: 760px;">
                        <form action="/seller-dashboard/add-property" method="POST" enctype="multipart/form-data">
                            <div class="form-grid">
                                <div class="form-group form-full">
                                    <label>Property Title *</label>
                                    <input type="text" name="title" placeholder="e.g. Modern Luxury Villa" required>
                                </div>
                                <div class="form-group">
                                    <label>Property Type *</label>
                                    <select name="property_type" id="property_type_sel">
                                        <option value="">Select type...</option>
                                        <option value="house">House</option>
                                        <option value="apartment">Apartment</option>
                                        <option value="land">Land</option>
                                        <option value="commercial">Commercial</option>
                                    </select>
                                    <span id="proptype-err" style="display:none;color:#dc2626;font-size:0.78rem;margin-top:4px;"><i class="fa-solid fa-circle-exclamation"></i> Please select a property type.</span>
                                </div>
                                <div class="form-group">
                                    <label>Listing Type *</label>
                                    <select name="listing_type" required>
                                        <option value="sale">For Sale</option>
                                        <option value="rent">For Rent</option>
                                    </select>
                                </div>
                                <div class="form-group">
                                    <label>Price (LKR) *</label>
                                    <input type="number" name="price" placeholder="e.g. 25000000" required min="0">
                                </div>
                                <div class="form-group">
                                    <label>Location *</label>
                                    <input type="text" name="location" placeholder="e.g. Colombo 07" required>
                                </div>
                                <div class="form-group">
                                    <label>Bedrooms</label>
                                    <input type="number" name="bedrooms" placeholder="e.g. 3" min="0">
                                </div>
                                <div class="form-group">
                                    <label>Bathrooms</label>
                                    <input type="number" name="bathrooms" placeholder="e.g. 2" min="0">
                                </div>
                                <div class="form-group">
                                    <label>Area (sqft)</label>
                                    <input type="number" name="sqft" placeholder="e.g. 1800" min="0">
                                </div>
                                <div class="form-group form-full">
                                    <label>Description</label>
                                    <textarea name="description" placeholder="Describe the property, its amenities, surroundings, etc."></textarea>
                                </div>
                                <div class="form-group form-full">
                                    <label>Property Photos <span style="color:#94a3b8;font-weight:400;">(select multiple)</span></label>
                                    <div class="img-upload-zone">
                                        <input type="file" name="images" accept="image/*" multiple>
                                        <i class="fa-solid fa-cloud-arrow-up"></i>
                                        <p><strong>Click to upload</strong> or drag &amp; drop photos here</p>
                                        <p style="margin-top:6px;color:#94a3b8;font-size:0.8rem;">PNG, JPG, WEBP — minimum 1, maximum 10 photos</p>
                                    </div>
                                    <div class="img-preview-grid" id="img-preview-grid"></div>
                                </div>
                            </div>
                            <div style="margin-top: 24px; display: flex; gap: 12px;">
                                <button type="submit" class="btn-primary-sm" style="padding: 11px 28px; font-size: 0.95rem;">
                                    <i class="fa-solid fa-circle-plus"></i> Publish Listing
                                </button>
                                <a href="/seller-dashboard?section=properties" class="btn-outline-sm" style="padding: 11px 20px; font-size: 0.95rem;">
                                    Cancel
                                </a>
                            </div>
                        </form>
                    </div>
                </c:when>

                <%-- ======== BOOKING REQUESTS ======== --%>
                <c:when test="${param.section == 'bookings'}">
                    <div class="page-header">
                        <h2>Booking Requests</h2>
                        <p>Review and manage all viewing requests from buyers for your properties.</p>
                    </div>
                    <div class="card">
                        <div class="card-header">
                            <h3>All Requests (${bookings.size()})</h3>
                            <div style="display:flex;gap:10px;font-size:0.82rem;color:#64748b;">
                                <span><span class="badge badge-pending">pending</span></span>
                                <span><span class="badge badge-confirmed">confirmed</span></span>
                                <span><span class="badge badge-completed">completed</span></span>
                                <span><span class="badge badge-cancelled">cancelled</span></span>
                            </div>
                        </div>
                        <c:choose>
                            <c:when test="${empty bookings}">
                                <div class="empty-state"><i class="fa-solid fa-calendar-xmark"></i><p>No booking requests yet.</p></div>
                            </c:when>
                            <c:otherwise>
                                <div style="overflow-x:auto;">
                                    <table class="data-table">
                                        <thead><tr>
                                            <th>Buyer</th><th>Email</th><th>Property</th>
                                            <th>Date &amp; Time</th><th>Type</th><th>Status</th><th>Actions</th>
                                        </tr></thead>
                                        <tbody>
                                            <c:forEach var="b" items="${bookings}">
                                                <tr>
                                                    <td><strong>${b.first_name} ${b.last_name}</strong></td>
                                                    <td style="color:#64748b;font-size:0.82rem;">${b.buyer_email}</td>
                                                    <td><a href="/property-detail?id=${b.property_id}" style="text-decoration:none; color:inherit; font-weight:bold;" target="_blank" title="View Property">${b.property_title}</a></td>
                                                    <td>${b.booking_date}<br><span style="color:#94a3b8;font-size:0.8rem;">${b.booking_time}</span></td>
                                                    <td style="text-transform:capitalize;">${b.viewing_type}</td>
                                                    <td><span class="badge badge-${b.status}">${b.status}</span></td>
                                                    <td style="white-space:nowrap;">
                                                        <c:if test="${b.status == 'pending'}">
                                                            <a href="/seller-dashboard/confirm-booking?id=${b.booking_id}" class="btn-confirm">
                                                                <i class="fa-solid fa-check"></i> Confirm
                                                            </a>
                                                            &nbsp;
                                                            <a href="/seller-dashboard/cancel-booking?id=${b.booking_id}"
                                                               class="btn-cancel-s"
                                                               onclick="return confirm('Cancel this booking request?')">
                                                               <i class="fa-solid fa-xmark"></i> Cancel
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${b.status == 'confirmed'}">
                                                            <a href="/seller-dashboard/complete-booking?id=${b.booking_id}" class="btn-complete">
                                                                <i class="fa-solid fa-flag-checkered"></i> Mark Complete
                                                            </a>
                                                            &nbsp;
                                                            <a href="/seller-dashboard/cancel-booking?id=${b.booking_id}"
                                                               class="btn-cancel-s"
                                                               onclick="return confirm('Cancel this confirmed booking?')">
                                                               <i class="fa-solid fa-xmark"></i> Cancel
                                                            </a>
                                                        </c:if>
                                                        <c:if test="${b.status != 'pending' && b.status != 'confirmed'}">
                                                            <span style="color:#94a3b8;font-size:0.8rem;">–</span>
                                                        </c:if>
                                                    </td>
                                                </tr>
                                            </c:forEach>
                                        </tbody>
                                    </table>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <%-- ======== INQUIRIES ======== --%>
                <c:when test="${param.section == 'inquiries'}">
                    <div class="page-header">
                        <h2>Messages &amp; Inquiries</h2>
                        <p>Respond to messages from buyers regarding your properties.</p>
                    </div>
                    <c:if test="${param.replied == 'true'}">
                        <div class="alert alert-success"><i class="fa-solid fa-check"></i> Reply sent successfully!</div>
                    </c:if>
                    <div class="card">
                        <div class="card-header">
                            <h3>All Messages (${inquiries.size()})</h3>
                        </div>
                        <c:choose>
                            <c:when test="${empty inquiries}">
                                <div class="empty-state"><i class="fa-regular fa-envelope"></i><p>No messages yet.</p></div>
                            </c:when>
                            <c:otherwise>
                                <div style="display:flex; flex-direction:column; gap:20px;">
                                    <c:forEach var="inq" items="${inquiries}">
                                        <div style="border:1px solid #e2e8f0; border-radius:12px; padding:16px; background:#fff; position:relative;">
                                            <c:if test="${!inq.is_read}">
                                                <div style="position:absolute; top:16px; right:16px; background:#ef4444; color:white; font-size:0.7rem; padding:2px 8px; border-radius:10px; font-weight:bold;">NEW</div>
                                            </c:if>
                                            <div style="display:flex; gap:16px; margin-bottom:12px;">
                                                <div style="width:40px; height:40px; border-radius:50%; background:#10b981; color:white; display:flex; align-items:center; justify-content:center; font-weight:bold;">
                                                    ${inq.first_name.charAt(0)}${inq.last_name.charAt(0)}
                                                </div>
                                                <div>
                                                    <div style="font-weight:700; color:#0f172a;">${inq.first_name} ${inq.last_name} <span style="font-weight:400; font-size:0.85rem; color:#64748b;">(${inq.buyer_email})</span></div>
                                                    <div style="font-size:0.85rem; color:#3b82f6; font-weight:600;">Re: ${inq.property_title}</div>
                                                    <div style="font-size:0.75rem; color:#94a3b8;">${inq.created_at}</div>
                                                </div>
                                            </div>
                                            <div style="background:#f8fafc; padding:12px; border-radius:8px; font-size:0.9rem; color:#334155; margin-bottom:12px; border-left:3px solid #cbd5e1;">
                                                ${inq.message}
                                            </div>

                                            <c:choose>
                                                <c:when test="${not empty inq.reply_message}">
                                                    <div style="background:#ecfdf5; padding:12px; border-radius:8px; font-size:0.9rem; color:#065f46; border-left:3px solid #10b981; margin-left:20px;">
                                                        <div style="font-size:0.75rem; font-weight:bold; margin-bottom:4px;"><i class="fa-solid fa-reply"></i> Your Reply:</div>
                                                        ${inq.reply_message}
                                                    </div>
                                                </c:when>
                                                <c:otherwise>
                                                    <button type="button" class="btn-outline-sm" onclick="document.getElementById('reply-form-${inq.inquiry_id}').style.display='block'; this.style.display='none';">
                                                        <i class="fa-solid fa-reply"></i> Reply
                                                    </button>
                                                    <form id="reply-form-${inq.inquiry_id}" action="/seller-dashboard/respond-inquiry" method="POST" style="display:none; margin-top:10px; background:#f8fafc; padding:15px; border-radius:8px; border:1px solid #e2e8f0;">
                                                        <input type="hidden" name="inquiry_id" value="${inq.inquiry_id}">
                                                        <label style="font-size:0.85rem; font-weight:bold; color:#475569; display:block; margin-bottom:6px;">Your Message:</label>
                                                        <textarea name="reply_message" required style="width:100%; min-height:80px; padding:10px; border:1px solid #cbd5e1; border-radius:6px; margin-bottom:10px; font-family:inherit; resize:vertical;"></textarea>
                                                        <div style="display:flex; gap:10px;">
                                                            <button type="submit" class="btn-primary-sm">Send Reply</button>
                                                            <button type="button" class="btn-outline-sm" onclick="document.getElementById('reply-form-${inq.inquiry_id}').style.display='none'; this.parentNode.previousElementSibling.style.display='inline-flex';">Cancel</button>
                                                        </div>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </div>
                                    </c:forEach>
                                </div>
                            </c:otherwise>
                        </c:choose>
                    </div>
                </c:when>

                <%-- ======== UPDATE PROFILE ======== --%>
                <c:when test="${param.section == 'profile'}">
                    <div class="page-header">
                        <h2>Update Profile</h2>
                        <p>Edit your personal information and account settings.</p>
                    </div>
                    <div class="card" style="max-width: 600px;">
                        <form action="/seller-dashboard/update-profile" method="POST" enctype="multipart/form-data">
                            <div class="form-group form-full" style="text-align: center; margin-bottom: 24px;">
                                <div style="width:100px; height:100px; border-radius:50%; background:#f8fafc; display:inline-flex; align-items:center; justify-content:center; border:2px solid #e2e8f0; overflow:hidden; margin-bottom:12px;">
                                    <c:choose>
                                        <c:when test="${not empty profileImage}">
                                            <img src="${profileImage}" style="width:100%; height:100%; object-fit:cover;" alt="Current Profile">
                                        </c:when>
                                        <c:otherwise>
                                            <div style="font-size:2rem; color:#cbd5e1;">${initials}</div>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div>
                                    <label style="cursor:pointer; color:#10b981; font-size:0.9rem; font-weight:600;">
                                        Change Profile Picture
                                        <input type="file" name="profileImageFile" accept="image/*" style="display:none;" onchange="alert('Image selected: ' + this.files[0].name)">
                                    </label>
                                </div>
                            </div>
                            <div class="form-grid">
                                <div class="form-group">
                                    <label>First Name *</label>
                                    <input type="text" name="first_name" value="${firstName}" required>
                                </div>
                                <div class="form-group">
                                    <label>Last Name</label>
                                    <input type="text" name="last_name" value="${lastName}">
                                </div>
                                <div class="form-group form-full">
                                    <label>Email Address *</label>
                                    <input type="email" name="email" value="${email}" required>
                                </div>
                                <div class="form-group form-full">
                                    <label>Contact Number</label>
                                    <input type="text" name="phone" value="${phone}" placeholder="+94 77 ...">
                                </div>
                                <div class="form-group form-full">
                                    <label>New Password <span style="color:#94a3b8;font-weight:400;">(leave blank to keep current)</span></label>
                                    <input type="password" name="password" placeholder="Enter new password...">
                                </div>
                            </div>
                            <div style="margin-top: 24px;">
                                <button type="submit" class="btn-primary-sm" style="padding: 11px 28px; font-size:0.95rem;">
                                    <i class="fa-solid fa-floppy-disk"></i> Save Changes
                                </button>
                            </div>
                        </form>
                    </div>

                    <%-- Danger Zone --%>
                    <div class="card" style="max-width: 600px; border: 1.5px solid rgba(220,38,38,0.25); margin-top: 8px;">
                        <h3 style="color:#dc2626;margin-bottom:8px;"><i class="fa-solid fa-triangle-exclamation"></i> Danger Zone</h3>
                        <p style="color:#64748b;font-size:0.88rem;margin-bottom:16px;">Permanently delete your account and all listings. This cannot be undone.</p>
                        <form action="/seller-dashboard/delete-account" method="POST"
                              onsubmit="return confirm('Are you sure? This will permanently delete your account and ALL your listed properties. This cannot be undone.')">
                            <button type="submit" class="btn-danger-sm" style="padding:9px 20px;">
                                <i class="fa-solid fa-trash"></i> Delete My Account
                            </button>
                        </form>
                    </div>
                </c:when>

            </c:choose>
        </main>
    </div>
</body>
<script src="/js/global-select.js"></script>
<script>
/* ── Add Property form validation ── */
(function(){
    var form = document.querySelector('form[action="/seller-dashboard/add-property"]');
    if (!form) return;
    form.addEventListener('submit', function(e) {
        var propTypeSel = document.getElementById('property_type_sel');
        var errMsg      = document.getElementById('proptype-err');
        if (!propTypeSel || propTypeSel.value !== '') {
            // Check image count
            var imgInput = form.querySelector('input[name="images"]');
            if (imgInput && imgInput.files && imgInput.files.length > 10) {
                e.preventDefault();
                alert('You can upload a maximum of 10 images per property.');
                return;
            }
            return; // valid — let submit proceed
        }

        e.preventDefault();

        // Try to highlight the custom ph-wrap trigger first, fall back to the raw <select>
        var wrap    = propTypeSel.closest('[data-ph-wrap]');
        var trigger = wrap ? wrap.querySelector('[data-ph-trigger]') : propTypeSel;
        if (!trigger) trigger = propTypeSel;

        trigger.style.borderColor = '#ef4444';
        trigger.style.boxShadow   = '0 0 0 3px rgba(239,68,68,0.15)';
        trigger.scrollIntoView({ behavior: 'smooth', block: 'center' });

        if (errMsg) errMsg.style.display = 'block';

        // Remove highlight once user picks a type
        propTypeSel.addEventListener('change', function(){
            trigger.style.borderColor = '';
            trigger.style.boxShadow   = '';
            if (errMsg) errMsg.style.display = 'none';
        }, { once: true });
    });

    // Image preview grid
    var imgInput = form.querySelector('input[name="images"]');
    var grid = document.getElementById('img-preview-grid');
    if (imgInput && grid) {
        imgInput.addEventListener('change', function() {
            grid.innerHTML = '';
            var files = this.files;
            if (files.length > 10) {
                alert('Maximum 10 images allowed. Only the first 10 will be shown.');
            }
            var limit = Math.min(files.length, 10);
            for (var i = 0; i < limit; i++) {
                var reader = new FileReader();
                reader.onload = (function(idx) {
                    return function(e) {
                        var div = document.createElement('div');
                        div.innerHTML = '<img src="' + e.target.result + '" alt="Preview ' + (idx+1) + '">';
                        grid.appendChild(div);
                    };
                })(i);
                reader.readAsDataURL(files[i]);
            }
        });
    }
})();
    function toggleInquiryForm(id) {
        var form = document.getElementById('reply-form-' + id);
        if (form.style.display === 'none' || form.style.display === '') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }


</script>
<script>
    function toggleSellerProfile() {
        var p = document.getElementById('s-profile-panel');
        p.style.display = p.style.display === 'none' ? 'block' : 'none';
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('#s-profile-trigger') && !e.target.closest('#s-profile-panel')) {
            var p = document.getElementById('s-profile-panel');
            if (p) p.style.display = 'none';
        }
    });
</script>
</html>
