<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c"   uri="http://java.sun.com/jsp/jstl/core"  %>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"   %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Dashboard | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        :root {
            --sidebar-bg: #0f172a;
            --sidebar-hover: #1e293b;
            --sidebar-active: linear-gradient(135deg, #10b981, #059669);
            --accent: #10b981;
            --accent-light: rgba(16, 185, 129, 0.12);
            --blue: #3b82f6;
            --amber: #f59e0b;
            --red: #ef4444;
            --purple: #8b5cf6;
            --body-bg: #f1f5f9;
            --card-bg: #ffffff;
            --text-main: #1e293b;
            --text-muted: #64748b;
            --border: #e2e8f0;
            --radius: 16px;
            --radius-sm: 10px;
            --shadow: 0 1px 3px rgba(0,0,0,0.06), 0 1px 2px rgba(0,0,0,0.04);
            --shadow-md: 0 4px 12px rgba(0,0,0,0.07);
        }
        body { font-family: 'Outfit', sans-serif; background: var(--body-bg); color: var(--text-main); display: flex; min-height: 100vh; }

        /* ========== SIDEBAR ========== */
        .sidebar {
            width: 270px; min-width: 270px; background: var(--sidebar-bg);
            display: flex; flex-direction: column; padding: 28px 16px 20px; position: fixed; top: 0; left: 0; bottom: 0; z-index: 100;
        }
        .sidebar-brand { display: flex; align-items: center; gap: 12px; padding: 0 12px 28px; border-bottom: 1px solid rgba(255,255,255,0.08); margin-bottom: 24px; }
        .sidebar-brand .brand-icon { width: 42px; height: 42px; border-radius: 12px; background: var(--sidebar-active); display: flex; align-items: center; justify-content: center; font-size: 1.2rem; color: white; }
        .sidebar-brand h2 { color: #fff; font-size: 1.15rem; font-weight: 700; letter-spacing: -0.3px; }
        .sidebar-brand h2 span { color: var(--accent); }
        .sidebar-label { font-size: 0.7rem; text-transform: uppercase; letter-spacing: 1.5px; color: #475569; padding: 0 12px; margin-bottom: 8px; font-weight: 600; }
        .sidebar-nav { list-style: none; display: flex; flex-direction: column; gap: 4px; }
        .sidebar-nav li label, .sidebar-nav li a {
            display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: var(--radius-sm);
            color: #94a3b8; font-weight: 500; font-size: 0.92rem; cursor: pointer; transition: all 0.2s ease; text-decoration: none;
        }
        .sidebar-nav li label:hover, .sidebar-nav li a:hover { background: var(--sidebar-hover); color: #e2e8f0; }
        .sidebar-nav li label i, .sidebar-nav li a i { width: 20px; text-align: center; font-size: 1rem; }
        .sidebar-nav li .badge-count { margin-left: auto; background: var(--red); color: white; font-size: 0.7rem; font-weight: 700; padding: 2px 7px; border-radius: 20px; }

        /* Hide radio buttons */
        input[name="admin-panel"] { display: none; }

        /* Active sidebar link styling */
        #panel-overview:checked ~ .sidebar .nav-overview label,
        #panel-users:checked ~ .sidebar .nav-users label,
        #panel-properties:checked ~ .sidebar .nav-properties label,
        #panel-bookings:checked ~ .sidebar .nav-bookings label,
        #panel-reviews:checked ~ .sidebar .nav-reviews label,
        #panel-settings:checked ~ .sidebar .nav-settings label,
        #panel-activitylog:checked ~ .sidebar .nav-activitylog label {
            background: var(--sidebar-active); color: #fff; font-weight: 600; box-shadow: 0 4px 12px rgba(16, 185, 129, 0.3);
        }

        .sidebar-footer { margin-top: auto; padding-top: 16px; border-top: 1px solid rgba(255,255,255,0.08); }
        .sidebar-footer a { display: flex; align-items: center; gap: 12px; padding: 11px 14px; border-radius: var(--radius-sm); color: #f87171; font-weight: 500; font-size: 0.92rem; text-decoration: none; transition: background 0.2s; }
        .sidebar-footer a:hover { background: rgba(248, 113, 113, 0.1); }

        /* ========== MAIN CONTENT ========== */
        .main-wrapper { margin-left: 270px; flex: 1; display: flex; flex-direction: column; }
        .topbar {
            background: var(--card-bg); padding: 16px 36px; display: flex; justify-content: space-between; align-items: center;
            border-bottom: 1px solid var(--border); position: sticky; top: 0; z-index: 50;
        }
        .topbar h1 { font-size: 1.35rem; font-weight: 700; }
        .topbar .admin-badge { display: flex; align-items: center; gap: 10px; background: var(--accent-light); padding: 8px 16px; border-radius: 50px; }
        .topbar .admin-badge i { color: var(--accent); }
        .topbar .admin-badge span { font-size: 0.85rem; font-weight: 600; color: var(--accent); }
        .content-area { padding: 32px 36px; flex: 1; }

        /* ========== PANELS (show/hide via CSS) ========== */
        .panel { display: none; }
        #panel-overview:checked ~ .main-wrapper .panel-overview,
        #panel-users:checked ~ .main-wrapper .panel-users,
        #panel-properties:checked ~ .main-wrapper .panel-properties,
        #panel-bookings:checked ~ .main-wrapper .panel-bookings,
        #panel-reviews:checked ~ .main-wrapper .panel-reviews,
        #panel-settings:checked ~ .main-wrapper .panel-settings,
        #panel-activitylog:checked ~ .main-wrapper .panel-activitylog { display: block; animation: fadeIn 0.35s ease; }
        @keyframes fadeIn { from { opacity: 0; transform: translateY(8px); } to { opacity: 1; transform: translateY(0); } }

        /* ========== STAT CARDS ========== */
        .stats-grid { display: grid; grid-template-columns: repeat(4, 1fr); gap: 20px; margin-bottom: 32px; }
        .stat-card {
            background: var(--card-bg); border-radius: var(--radius); padding: 24px; box-shadow: var(--shadow);
            display: flex; align-items: center; gap: 18px; transition: transform 0.2s, box-shadow 0.2s; border: 1px solid var(--border);
        }
        .stat-card:hover { transform: translateY(-3px); box-shadow: var(--shadow-md); }
        .stat-icon { width: 56px; height: 56px; border-radius: 14px; display: flex; align-items: center; justify-content: center; font-size: 1.3rem; flex-shrink: 0; }
        .stat-icon.green { background: var(--accent-light); color: var(--accent); }
        .stat-icon.blue { background: rgba(59,130,246,0.1); color: var(--blue); }
        .stat-icon.amber { background: rgba(245,158,11,0.1); color: var(--amber); }
        .stat-icon.red { background: rgba(239,68,68,0.1); color: var(--red); }
        .stat-icon.purple { background: rgba(139,92,246,0.1); color: var(--purple); }
        .stat-info h3 { font-size: 1.7rem; font-weight: 700; line-height: 1; margin-bottom: 4px; }
        .stat-info p { color: var(--text-muted); font-size: 0.82rem; font-weight: 500; }

        /* ========== CARDS ========== */
        .card {
            background: var(--card-bg); border-radius: var(--radius); padding: 28px; box-shadow: var(--shadow);
            margin-bottom: 24px; border: 1px solid var(--border);
        }
        .card-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .card-header h3 { font-size: 1.1rem; font-weight: 700; }
        .section-title { font-size: 1.1rem; font-weight: 700; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; }
        .section-title .tag { background: var(--red); color: white; font-size: 0.65rem; font-weight: 700; padding: 3px 8px; border-radius: 6px; text-transform: uppercase; }

        /* ========== TABLES ========== */
        .data-table { width: 100%; border-collapse: collapse; }
        .data-table thead th { padding: 12px 16px; text-align: left; font-size: 0.78rem; font-weight: 600; text-transform: uppercase; letter-spacing: 0.5px; color: var(--text-muted); border-bottom: 2px solid var(--border); }
        .data-table tbody td { padding: 14px 16px; border-bottom: 1px solid var(--border); font-size: 0.9rem; vertical-align: middle; }
        .data-table tbody tr:last-child td { border-bottom: none; }
        .data-table tbody tr:hover { background: #f8fafc; }
        .role-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; display: inline-block; }
        .role-badge.buyer { background: var(--accent-light); color: var(--accent); }
        .role-badge.seller { background: rgba(59,130,246,0.1); color: var(--blue); }
        .role-badge.admin { background: rgba(139,92,246,0.1); color: var(--purple); }
        .role-badge.both { background: rgba(245,158,11,0.1); color: var(--amber); }
        .status-badge { padding: 4px 12px; border-radius: 20px; font-size: 0.75rem; font-weight: 600; display: inline-block; }
        .status-badge.active { background: var(--accent-light); color: var(--accent); }
        .status-badge.available { background: var(--accent-light); color: var(--accent); }
        .status-badge.pending { background: rgba(245,158,11,0.1); color: var(--amber); }
        .status-badge.sold { background: rgba(139,92,246,0.1); color: var(--purple); }
        .status-badge.confirmed { background: rgba(59,130,246,0.1); color: var(--blue); }
        .status-badge.completed { background: var(--accent-light); color: var(--accent); }
        .status-badge.cancelled { background: rgba(239,68,68,0.1); color: var(--red); }

        /* ========== BUTTONS ========== */
        .btn { padding: 8px 18px; border-radius: 8px; font-size: 0.85rem; font-weight: 600; cursor: pointer; border: none; transition: all 0.2s; font-family: inherit; display: inline-flex; align-items: center; gap: 6px; }
        .btn-primary { background: var(--accent); color: white; }
        .btn-primary:hover { background: #059669; }
        .btn-outline { background: transparent; border: 1.5px solid var(--border); color: var(--text-main); }
        .btn-outline:hover { border-color: var(--accent); color: var(--accent); }
        .btn-danger { background: var(--red); color: white; }
        .btn-danger:hover { background: #dc2626; }
        .btn-sm { padding: 5px 12px; font-size: 0.8rem; }
        .btn-ghost { background: transparent; color: var(--text-muted); border: none; }
        .btn-ghost:hover { color: var(--accent); }

        /* ========== REVIEW CARD ========== */
        .review-item { border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 20px; display: flex; justify-content: space-between; align-items: flex-start; gap: 20px; margin-bottom: 12px; transition: border-color 0.2s; }
        .review-item:hover { border-color: var(--accent); }
        .review-stars { color: var(--amber); font-size: 0.9rem; margin-bottom: 6px; }
        .review-text { font-style: italic; color: var(--text-main); margin-bottom: 6px; font-size: 0.92rem; }
        .review-meta { font-size: 0.78rem; color: var(--text-muted); }
        .review-actions { display: flex; gap: 8px; flex-shrink: 0; }

        /* ========== SETTINGS FORM ========== */
        .settings-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 20px; }
        .form-group { margin-bottom: 18px; position: relative; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: var(--text-main); margin-bottom: 6px; }
        .form-group input, .form-group textarea {
            width: 100%; padding: 11px 16px; border: 1px solid rgba(226,232,240,0.8); border-radius: 50px; font-size: 0.85rem;
            font-family: inherit; outline: none; transition: all 0.3s cubic-bezier(0.4,0,0.2,1); background: #fafbfc; color: var(--text-main);
            box-shadow: 0 1px 2px rgba(0,0,0,0.04);
        }
        .form-group textarea { border-radius: 16px; }
        .form-group input:hover, .form-group textarea:hover { border-color: var(--accent); background: white; box-shadow: 0 2px 8px rgba(16,185,129,0.08); }
        .form-group input:focus, .form-group textarea:focus { border-color: var(--accent); background: white; box-shadow: 0 0 0 3px rgba(16,185,129,0.12), 0 2px 8px rgba(16,185,129,0.06); }

        /* ========== CUSTOM DROPDOWN COMPONENT ========== */
        .cselect { position: relative; width: 100%; user-select: none; }
        .cselect-trigger {
            display: flex; align-items: center; justify-content: space-between;
            height: 42px; padding: 0 16px; gap: 10px;
            background: white; border: 1.5px solid var(--border);
            border-radius: 10px; cursor: pointer; font-size: 0.88rem;
            font-family: 'Outfit', sans-serif; font-weight: 500; color: var(--text-main);
            box-shadow: 0 1px 3px rgba(0,0,0,0.05);
            transition: all 0.22s ease;
        }
        .cselect-trigger:hover { border-color: var(--accent); box-shadow: 0 2px 8px rgba(16,185,129,0.08); }
        .cselect.open .cselect-trigger,
        .cselect.cs-open .cselect-trigger { border-color: var(--accent); box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
        .cselect-arrow {
            flex-shrink: 0; display: flex; align-items: center; justify-content: center;
            transition: transform 0.22s ease; color: #94a3b8; font-size: 0.7rem;
        }
        .cselect.open .cselect-arrow,
        .cselect.cs-open .cselect-arrow { transform: rotate(180deg); color: var(--accent); }

        /* Dark panel — matching sidebar palette */
        .cselect-panel {
            display: none;
            position: fixed;
            z-index: 99999;
            background: #1e293b; border: 1px solid rgba(255,255,255,0.07); border-radius: 12px;
            box-shadow: 0 16px 48px rgba(0,0,0,0.35), 0 4px 16px rgba(0,0,0,0.2);
            overflow: hidden;
            min-width: 160px;
        }
        .cselect.cs-open .cselect-panel { display: block; }

        .cselect-option {
            display: flex; align-items: center; justify-content: space-between;
            padding: 11px 18px; font-size: 0.86rem; font-family: 'Outfit', sans-serif;
            color: #cbd5e1; cursor: pointer; transition: background 0.15s ease, color 0.15s ease;
            letter-spacing: 0.01em;
        }
        .cselect-option:hover { background: rgba(255,255,255,0.06); color: #fff; }
        .cselect-option.selected { color: var(--accent); font-weight: 600; background: rgba(16,185,129,0.1); }
        .cselect-option .check-icon { font-size: 0.72rem; display: none; color: var(--accent); }
        .cselect-option.selected .check-icon { display: inline; }
        .cselect-option:not(:last-child) { border-bottom: 1px solid rgba(255,255,255,0.05); }

        /* ========== BOOKING TIMELINE ========== */
        .booking-cards { display: grid; grid-template-columns: repeat(2, 1fr); gap: 16px; }
        .booking-card { border: 1px solid var(--border); border-radius: var(--radius-sm); padding: 18px; transition: border-color 0.2s; }
        .booking-card:hover { border-color: var(--accent); }
        .booking-card h4 { font-size: 0.95rem; margin-bottom: 8px; }
        .booking-card .meta { display: flex; flex-direction: column; gap: 4px; font-size: 0.82rem; color: var(--text-muted); margin-bottom: 10px; }
        .booking-card .meta i { width: 18px; color: var(--accent); }

        /* ========== PROPERTY GRID ========== */
        .prop-thumb { width: 64px; height: 48px; border-radius: 8px; object-fit: cover; }

        /* ========== EMPTY STATE ========== */
        .empty-state { text-align: center; padding: 60px 20px; color: var(--text-muted); }
        .empty-state i { font-size: 3rem; margin-bottom: 16px; opacity: 0.3; }
        .empty-state p { font-size: 0.95rem; }

        /* ========== PROPERTY TOGGLE CHECKBOXES ========== */
        .prop-toggle { display: none !important; }

        /* Filter panel toggle */
        .filter-panel { max-height: 0; overflow: hidden; transition: max-height 0.35s ease, opacity 0.3s ease; opacity: 0; }
        #filter-toggle:checked ~ .main-wrapper .filter-panel { max-height: 200px; opacity: 1; }

        /* ========== MODAL OVERLAY ========== */
        .modal-overlay {
            position: fixed; top: 0; left: 0; right: 0; bottom: 0; z-index: 1000;
            background: rgba(15, 23, 42, 0.6); backdrop-filter: blur(4px);
            display: flex; align-items: center; justify-content: center;
            opacity: 0; visibility: hidden; transition: all 0.3s ease;
        }
        .modal-card {
            background: white; border-radius: var(--radius); padding: 32px; max-width: 620px; width: 90%;
            box-shadow: 0 20px 60px rgba(0,0,0,0.2); position: relative;
            transform: translateY(20px) scale(0.97); transition: transform 0.3s ease;
        }
        .modal-close {
            position: absolute; top: 14px; right: 18px; font-size: 1.6rem; color: var(--text-muted);
            cursor: pointer; line-height: 1; transition: color 0.2s;
        }
        .modal-close:hover { color: var(--red); }

        /* Show modals when corresponding checkbox is checked */
        #view-prop1:checked ~ .main-wrapper .modal-view1,
        #view-prop2:checked ~ .main-wrapper .modal-view2,
        #view-prop3:checked ~ .main-wrapper .modal-view3,
        #view-prop4:checked ~ .main-wrapper .modal-view4,
        #del-prop1:checked ~ .main-wrapper .modal-del1,
        #del-prop2:checked ~ .main-wrapper .modal-del2,
        #del-prop3:checked ~ .main-wrapper .modal-del3,
        #del-prop4:checked ~ .main-wrapper .modal-del4 {
            opacity: 1; visibility: visible;
        }
        #view-prop1:checked ~ .main-wrapper .modal-view1 .modal-card,
        #view-prop2:checked ~ .main-wrapper .modal-view2 .modal-card,
        #view-prop3:checked ~ .main-wrapper .modal-view3 .modal-card,
        #view-prop4:checked ~ .main-wrapper .modal-view4 .modal-card,
        #del-prop1:checked ~ .main-wrapper .modal-del1 .modal-card,
        #del-prop2:checked ~ .main-wrapper .modal-del2 .modal-card,
        #del-prop3:checked ~ .main-wrapper .modal-del3 .modal-card,
        #del-prop4:checked ~ .main-wrapper .modal-del4 .modal-card {
            transform: translateY(0) scale(1);
        }

        @keyframes modalSlideIn { from { transform: translateY(20px) scale(0.97); } to { transform: translateY(0) scale(1); } }
    </style>
</head>
<body>

<!-- Radio buttons for panel switching (CSS-only navigation) -->
<input type="radio" name="admin-panel" id="panel-overview" checked>
<input type="radio" name="admin-panel" id="panel-users">
<input type="radio" name="admin-panel" id="panel-properties">
<input type="radio" name="admin-panel" id="panel-bookings">
<input type="radio" name="admin-panel" id="panel-reviews">
<input type="radio" name="admin-panel" id="panel-settings">
<input type="radio" name="admin-panel" id="panel-activitylog">

<!-- Hidden checkboxes for property interactions -->
<input type="checkbox" id="filter-toggle" class="prop-toggle">
<input type="checkbox" id="view-prop1" class="prop-toggle">
<input type="checkbox" id="view-prop2" class="prop-toggle">
<input type="checkbox" id="view-prop3" class="prop-toggle">
<input type="checkbox" id="view-prop4" class="prop-toggle">
<input type="checkbox" id="del-prop1" class="prop-toggle">
<input type="checkbox" id="del-prop2" class="prop-toggle">
<input type="checkbox" id="del-prop3" class="prop-toggle">
<input type="checkbox" id="del-prop4" class="prop-toggle">

<!-- ========== SIDEBAR ========== -->
<aside class="sidebar">
    <div class="sidebar-brand">
        <div class="brand-icon"><i class="fa-solid fa-house-chimney-window"></i></div>
        <h2>Property<span>Hub</span></h2>
    </div>

    <p class="sidebar-label">Main Menu</p>
    <ul class="sidebar-nav">
        <li class="nav-overview"><label for="panel-overview"><i class="fa-solid fa-chart-pie"></i> Overview</label></li>
        <li class="nav-users"><label for="panel-users"><i class="fa-solid fa-users"></i> Manage Users</label></li>
        <li class="nav-properties"><label for="panel-properties"><i class="fa-solid fa-building"></i> Manage Properties</label></li>
        <li class="nav-bookings"><label for="panel-bookings"><i class="fa-solid fa-calendar-check"></i> Manage Bookings</label></li>
        <li class="nav-reviews"><label for="panel-reviews"><i class="fa-solid fa-star-half-stroke"></i> Review Moderation</label></li>
        <li class="nav-activitylog"><label for="panel-activitylog"><i class="fa-solid fa-clock-rotate-left"></i> Activity Log</label></li>
    </ul>

    <p class="sidebar-label" style="margin-top: 24px;">System</p>
    <ul class="sidebar-nav">
        <li class="nav-settings"><label for="panel-settings"><i class="fa-solid fa-gear"></i> Settings</label></li>
    </ul>

    <div class="sidebar-footer">
        <a href="/admin/logout"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
    </div>
</aside>

<!-- ========== MAIN WRAPPER ========== -->
<div class="main-wrapper">
    <div class="topbar">
        <h1>Admin Dashboard</h1>
        <div class="admin-badge">
            <i class="fa-solid fa-shield-halved"></i>
            <span>System Administrator</span>
        </div>
    </div>

    <div class="content-area">

        <!-- ==================== OVERVIEW PANEL ==================== -->
        <div class="panel panel-overview">
            <div class="stats-grid">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-users"></i></div>
                    <div class="stat-info"><h3>${totalUsers}</h3><p>Total Users</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fa-solid fa-city"></i></div>
                    <div class="stat-info"><h3>${totalProperties}</h3><p>Active Properties</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="fa-solid fa-calendar-check"></i></div>
                    <div class="stat-info"><h3>${totalBookings}</h3><p>Total Bookings</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red"><i class="fa-solid fa-flag"></i></div>
                    <div class="stat-info"><h3>${totalReviews}</h3><p>Total Reviews</p></div>
                </div>
            </div>

            <!-- Recent Users -->
            <div class="card">
                <div class="card-header">
                    <h3>Recent User Registrations</h3>
                    <label for="panel-users" class="btn btn-outline btn-sm" style="cursor:pointer;">View All Users</label>
                </div>
                <table class="data-table">
                    <thead><tr><th>User ID</th><th>Name</th><th>Email</th><th>Role</th></tr></thead>
                    <tbody>
                        <c:forEach var="u" items="${users}" end="4">
                            <tr>
                                <td>#U${u.user_id}</td>
                                <td><strong>${u.first_name} ${u.last_name}</strong></td>
                                <td>${u.email}</td>
                                <td><span class="role-badge ${u.role}">${u.role}</span></td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- Recent Reviews -->
            <div class="card">
                <div class="section-title">Pending Reviews</div>
                <c:set var="pendingCount" value="0"/>
                <c:forEach var="r" items="${reviews}">
                    <c:if test="${r.status == 'pending' && pendingCount < 3}">
                        <c:set var="pendingCount" value="${pendingCount + 1}"/>
                        <div class="review-item">
                            <div>
                                <div class="review-stars">
                                    <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                    <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
                                </div>
                                <p class="review-text">"${r.review_text}"</p>
                                <span class="review-meta">Review by ${r.first_name} ${r.last_name} on '${not empty r.property_title ? r.property_title : "General"}' &bull; ${r.created_at}</span>
                            </div>
                            <div class="review-actions">
                                <a href="/admin/approve-review?id=${r.review_id}" class="btn btn-outline btn-sm" style="color:var(--emerald); border-color:var(--emerald);"><i class="fa-solid fa-check"></i> Approve</a>
                                <a href="/admin/delete-review?id=${r.review_id}" class="btn btn-danger btn-sm" onclick="return confirm('Delete this review?')"><i class="fa-solid fa-trash"></i> Delete</a>
                            </div>
                        </div>
                    </c:if>
                </c:forEach>
                <c:if test="${pendingCount == 0}">
                    <p class="text-muted text-center" style="padding:20px;font-size:0.9rem;">No pending reviews.</p>
                </c:if>
            </div>
        </div>

        <!-- ==================== MANAGE USERS PANEL ==================== -->
        <div class="panel panel-users">
            <div class="stats-grid" style="grid-template-columns: repeat(2, 1fr); margin-bottom: 24px;">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-user-check"></i></div>
                    <div class="stat-info"><h3>${activeUsers}</h3><p>Active Users</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fa-solid fa-user-plus"></i></div>
                    <div class="stat-info"><h3>${newUsersThisMonth}</h3><p>New This Month</p></div>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>All Registered Users</h3>
                    <button class="btn btn-primary btn-sm" onclick="document.getElementById('create-user-modal').style.display='flex'">
                        <i class="fa-solid fa-plus"></i> Add User
                    </button>
                </div>
                <table class="data-table">
                    <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <c:forEach var="u" items="${users}">
                            <tr>
                                <td>#U${u.user_id}</td>
                                <td><strong>${u.first_name} ${u.last_name}</strong></td>
                                <td>${u.email}</td>
                                <td><span class="role-badge ${u.role}">${u.role}</span></td>
                                <td><span class="status-badge ${u.is_active ? 'active' : 'cancelled'}">${u.is_active ? 'Active' : 'Deactivated'}</span></td>
                                <td>
                                    <button type="button" class="btn btn-ghost btn-sm" style="color:var(--blue);" onclick="toggleEditUser(${u.user_id})" title="Edit"><i class="fa-solid fa-pen"></i></button>
                                    <a href="/admin/delete-user?id=${u.user_id}" class="btn btn-ghost btn-sm" style="color:var(--red);" onclick="return confirm('Are you sure you want to delete this user and all their data?')" title="Delete"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr id="edit-user-${u.user_id}" style="display:none; background:#f8fafc;">
                                <td colspan="6">
                                    <form action="/admin/update-user" method="POST" style="padding:15px; border:1px solid var(--border); border-radius:8px; margin: 10px 0;">
                                        <input type="hidden" name="user_id" value="${u.user_id}">
                                        <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:15px; margin-bottom:15px;">
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">First Name</label><input type="text" name="first_name" value="${u.first_name}" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Last Name</label><input type="text" name="last_name" value="${u.last_name}" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Email</label><input type="email" name="email" value="${u.email}" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                        </div>
                                        <div style="display:grid; grid-template-columns:1fr 1fr 1fr 1fr; gap:15px; margin-bottom:15px;">
                                            <div>
                                                <label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Role</label>
                                                <select name="role" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;">
                                                    <option value="buyer" ${u.role == 'buyer' ? 'selected' : ''}>Buyer</option>
                                                    <option value="seller" ${u.role == 'seller' ? 'selected' : ''}>Seller</option>
                                                    <option value="both" ${u.role == 'both' ? 'selected' : ''}>Both</option>
                                                    <option value="admin" ${u.role == 'admin' ? 'selected' : ''}>Admin</option>
                                                </select>
                                            </div>
                                            <div>
                                                <label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Status</label>
                                                <select name="is_active" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;">
                                                    <option value="true" ${u.is_active ? 'selected' : ''}>Active</option>
                                                    <option value="false" ${!u.is_active ? 'selected' : ''}>Deactivated</option>
                                                </select>
                                            </div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Phone</label><input type="text" name="phone" value="${u.phone}" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Password (blank to keep)</label><input type="password" name="password" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                        </div>
                                        <button type="submit" class="btn btn-primary btn-sm">Save Changes</button>
                                        <button type="button" class="btn btn-outline btn-sm" onclick="toggleEditUser(${u.user_id})">Cancel</button>
                                    </form>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <%-- Create User Modal --%>
            <div id="create-user-modal" style="display:none; position:fixed; inset:0; background:rgba(15,23,42,0.6); backdrop-filter:blur(4px); z-index:2000; align-items:center; justify-content:center;">
                <div style="background:white; border-radius:20px; padding:36px; max-width:600px; width:90%; box-shadow:0 20px 60px rgba(0,0,0,0.25); position:relative;">
                    <span onclick="document.getElementById('create-user-modal').style.display='none'" style="position:absolute;top:14px;right:18px;font-size:1.6rem;color:#64748b;cursor:pointer;line-height:1;">&times;</span>
                    <h3 style="margin-bottom:24px; font-size:1.15rem;"><i class="fa-solid fa-user-plus" style="color:var(--accent);"></i> Create New User</h3>
                    <form action="/admin/create-user" method="POST">
                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                            <div>
                                <label style="font-size:0.82rem;font-weight:600;display:block;margin-bottom:5px;">First Name *</label>
                                <input type="text" name="first_name" required placeholder="John" style="width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;font-family:inherit;font-size:0.9rem;outline:none;">
                            </div>
                            <div>
                                <label style="font-size:0.82rem;font-weight:600;display:block;margin-bottom:5px;">Last Name *</label>
                                <input type="text" name="last_name" required placeholder="Doe" style="width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;font-family:inherit;font-size:0.9rem;outline:none;">
                            </div>
                        </div>
                        <div style="margin-bottom:16px;">
                            <label style="font-size:0.82rem;font-weight:600;display:block;margin-bottom:5px;">Email *</label>
                            <input type="email" name="email" required placeholder="user@propertyhub.lk" style="width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;font-family:inherit;font-size:0.9rem;outline:none;">
                        </div>
                        <div style="display:grid; grid-template-columns:1fr 1fr; gap:16px; margin-bottom:16px;">
                            <div>
                                <label style="font-size:0.82rem;font-weight:600;display:block;margin-bottom:5px;">Password *</label>
                                <input type="password" name="password" required placeholder="••••••••" style="width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;font-family:inherit;font-size:0.9rem;outline:none;">
                            </div>
                            <div>
                                <label style="font-size:0.82rem;font-weight:600;display:block;margin-bottom:5px;">Phone</label>
                                <input type="text" name="phone" placeholder="077XXXXXXX" style="width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;font-family:inherit;font-size:0.9rem;outline:none;">
                            </div>
                        </div>
                        <div style="margin-bottom:24px;">
                            <label style="font-size:0.82rem;font-weight:600;display:block;margin-bottom:5px;">Role *</label>
                            <select name="role" required style="width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;font-family:inherit;font-size:0.9rem;outline:none;background:white;">
                                <option value="buyer">Buyer</option>
                                <option value="seller">Seller</option>
                                <option value="both">Buyer &amp; Seller</option>
                                <option value="admin">Admin</option>
                            </select>
                        </div>
                        <div style="display:flex; gap:10px;">
                            <button type="submit" class="btn btn-primary"><i class="fa-solid fa-plus"></i> Create User</button>
                            <button type="button" class="btn btn-outline" onclick="document.getElementById('create-user-modal').style.display='none'">Cancel</button>
                        </div>
                    </form>
                </div>
            </div>
        </div>

        <!-- ==================== MANAGE PROPERTIES PANEL ==================== -->
        <div class="panel panel-properties">
            <div class="stats-grid" style="grid-template-columns: repeat(3, 1fr); margin-bottom: 24px;">
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-building"></i></div>
                    <div class="stat-info"><h3>${totalProperties}</h3><p>Total Listings</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="fa-solid fa-clock"></i></div>
                    <div class="stat-info"><h3>${pendingProperties}</h3><p>Pending Approval</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon purple"><i class="fa-solid fa-handshake"></i></div>
                    <div class="stat-info"><h3>${soldRentedProperties}</h3><p>Sold / Rented</p></div>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>All Property Listings</h3>
                    <label for="filter-toggle" class="btn btn-primary btn-sm" style="cursor:pointer;"><i class="fa-solid fa-filter"></i> Filter</label>
                </div>

                <!-- Filter Dropdown (CSS toggle) -->
                <div class="filter-panel">
                    <div style="display:grid; grid-template-columns: 1fr 1fr 1fr; gap:16px; padding: 20px; background: #f8fafc; border-radius: 12px; margin-bottom: 20px; border: 1px solid var(--border);">
                        <div class="form-group" style="margin-bottom:0;">
                            <label style="display:block; font-size:0.82rem; font-weight:600; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Property Type</label>
                            <div class="cselect" id="cs-type">
                                <div class="cselect-trigger" onclick="toggleCselect('cs-type')">
                                    <span class="cselect-label">All Types</span>
                                    <span class="cselect-arrow"><i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i></span>
                                </div>
                                <div class="cselect-panel">
                                    <div class="cselect-option selected" onclick="selectOption('cs-type', this)">All Types<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-type', this)">House<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-type', this)">Apartment<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-type', this)">Land<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-type', this)">Commercial<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label style="display:block; font-size:0.82rem; font-weight:600; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Status</label>
                            <div class="cselect" id="cs-status">
                                <div class="cselect-trigger" onclick="toggleCselect('cs-status')">
                                    <span class="cselect-label">All Statuses</span>
                                    <span class="cselect-arrow"><i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i></span>
                                </div>
                                <div class="cselect-panel">
                                    <div class="cselect-option selected" onclick="selectOption('cs-status', this)">All Statuses<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-status', this)">Available<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-status', this)">Pending<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-status', this)">Sold<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-status', this)">Rented<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group" style="margin-bottom:0;">
                            <label style="display:block; font-size:0.82rem; font-weight:600; color:var(--text-muted); margin-bottom:6px; text-transform:uppercase; letter-spacing:0.05em;">Sort By</label>
                            <div class="cselect" id="cs-sort">
                                <div class="cselect-trigger" onclick="toggleCselect('cs-sort')">
                                    <span class="cselect-label">Newest First</span>
                                    <span class="cselect-arrow"><i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i></span>
                                </div>
                                <div class="cselect-panel">
                                    <div class="cselect-option selected" onclick="selectOption('cs-sort', this)">Newest First<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-sort', this)">Price: Low to High<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-sort', this)">Price: High to Low<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-sort', this)">Title A-Z<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>

                <table class="data-table">
                    <thead><tr><th>Image</th><th>Title</th><th>Location</th><th>Price (LKR)</th><th>Type</th><th>Status</th><th>Actions</th></tr></thead>
                    <tbody>
                        <c:forEach var="p" items="${properties}">
                            <tr>
                                <td><img class="prop-thumb" src="${not empty p.image_url ? p.image_url : 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=150&q=80'}" alt="Property"></td>
                                <td><strong>${p.title}</strong><br><span style="font-size:0.75rem; color:var(--text-muted);">by ${p.first_name} ${p.last_name}</span></td>
                                <td>${p.location}</td>
                                <td><fmt:formatNumber value="${p.price}" type="number"/></td>
                                <td style="text-transform: capitalize;">${p.property_type}</td>
                                <td><span class="status-badge ${p.status == 'available' ? 'available' : (p.status == 'sold' ? 'sold' : 'pending')}">${p.status}</span></td>
                                <td>
                                    <button type="button" class="btn btn-ghost btn-sm" style="color:var(--blue); cursor:pointer;" onclick="toggleEditProperty(${p.property_id})" title="Edit"><i class="fa-solid fa-pen"></i></button>
                                    <a href="/property-detail?id=${p.property_id}" target="_blank" class="btn btn-ghost btn-sm" style="cursor:pointer;" title="View Details"><i class="fa-solid fa-eye"></i></a>
                                    <a href="/admin/delete-property?id=${p.property_id}" class="btn btn-ghost btn-sm" style="color:var(--red); cursor:pointer;" title="Delete" onclick="return confirm('Are you sure you want to delete this property?')"><i class="fa-solid fa-trash"></i></a>
                                </td>
                            </tr>
                            <tr id="edit-prop-${p.property_id}" style="display:none; background:#f8fafc;">
                                <td colspan="7">
                                    <form action="/admin/update-property" method="POST" style="padding:15px; border:1px solid var(--border); border-radius:8px; margin: 10px 0;">
                                        <input type="hidden" name="property_id" value="${p.property_id}">
                                        <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:15px; margin-bottom:15px;">
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Title</label><input type="text" name="title" value="${p.title}" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Price (LKR)</label><input type="number" name="price" value="${p.price}" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Location</label><input type="text" name="location" value="${p.location}" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                        </div>
                                        <div style="display:grid; grid-template-columns:1fr 1fr 1fr 1fr; gap:15px; margin-bottom:15px;">
                                            <div>
                                                <label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Type</label>
                                                <select name="property_type" class="form-control" required style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;">
                                                    <option value="house" ${p.property_type == 'house' ? 'selected' : ''}>House</option>
                                                    <option value="apartment" ${p.property_type == 'apartment' ? 'selected' : ''}>Apartment</option>
                                                    <option value="land" ${p.property_type == 'land' ? 'selected' : ''}>Land</option>
                                                    <option value="commercial" ${p.property_type == 'commercial' ? 'selected' : ''}>Commercial</option>
                                                </select>
                                            </div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Bedrooms</label><input type="number" name="bedrooms" value="${p.bedrooms}" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Bathrooms</label><input type="number" name="bathrooms" value="${p.bathrooms}" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                            <div><label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Size (sqft)</label><input type="number" name="size_sqft" value="${p.size_sqft}" class="form-control" style="width:100%;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;"></div>
                                        </div>
                                        <div style="margin-bottom:15px;">
                                            <label style="font-size:0.8rem;font-weight:bold;color:var(--text-main);display:block;margin-bottom:5px;">Status</label>
                                            <select name="status" class="form-control" style="width:200px;padding:8px;border:1px solid #cbd5e1;border-radius:6px;font-family:inherit;">
                                                <option value="available" ${p.status == 'available' ? 'selected' : ''}>Available</option>
                                                <option value="pending" ${p.status == 'pending' ? 'selected' : ''}>Pending Approval</option>
                                                <option value="sold" ${p.status == 'sold' ? 'selected' : ''}>Sold</option>
                                                <option value="rented" ${p.status == 'rented' ? 'selected' : ''}>Rented</option>
                                            </select>
                                        </div>
                                        <button type="submit" class="btn btn-primary btn-sm">Save Changes</button>
                                        <button type="button" class="btn btn-outline btn-sm" onclick="toggleEditProperty(${p.property_id})">Cancel</button>
                                    </form>

                                    <%-- ── Property Images Manager ── --%>
                                    <div style="margin-top:18px; padding-top:16px; border-top:2px dashed var(--border);">
                                        <p style="font-size:0.85rem; font-weight:700; margin-bottom:12px; display:flex; align-items:center; gap:8px;">
                                            <i class="fa-solid fa-images" style="color:var(--blue);"></i> Property Images
                                        </p>

                                        <%-- Existing images grid --%>
                                        <div style="display:flex; flex-wrap:wrap; gap:12px; margin-bottom:14px;" id="img-grid-${p.property_id}">
                                            <c:set var="propId" value="${p.property_id}"/>
                                            <c:forEach var="img" items="${propertyImages}">
                                                <c:if test="${img.property_id == propId}">
                                                    <div style="position:relative; width:120px; flex-shrink:0;">
                                                        <img src="${img.image_url}" alt="img"
                                                             style="width:120px; height:90px; object-fit:cover; border-radius:8px; border:2px solid ${img.is_primary ? 'var(--accent)' : 'var(--border)'};">
                                                        <c:if test="${img.is_primary}">
                                                            <span style="position:absolute; top:4px; left:4px; background:var(--accent); color:white; font-size:0.6rem; font-weight:700; padding:2px 6px; border-radius:4px;">PRIMARY</span>
                                                        </c:if>
                                                        <div style="display:flex; gap:4px; margin-top:6px; justify-content:center;">
                                                            <c:if test="${!img.is_primary}">
                                                                <a href="/admin/set-primary-image?image_id=${img.image_id}&property_id=${img.property_id}"
                                                                   class="btn btn-outline btn-sm"
                                                                   style="font-size:0.68rem; padding:3px 7px; color:var(--accent); border-color:var(--accent);"
                                                                   title="Set as Primary">
                                                                    <i class="fa-solid fa-star"></i>
                                                                </a>
                                                            </c:if>
                                                            <a href="/admin/delete-image?image_id=${img.image_id}&property_id=${img.property_id}"
                                                               class="btn btn-danger btn-sm"
                                                               style="font-size:0.68rem; padding:3px 7px;"
                                                               onclick="return confirm('Delete this image?')"
                                                               title="Delete Image">
                                                                <i class="fa-solid fa-trash"></i>
                                                            </a>
                                                        </div>
                                                    </div>
                                                </c:if>
                                            </c:forEach>
                                        </div>

                                        <%-- Add new image form --%>
                                        <form action="/admin/add-image" method="POST"
                                              style="display:flex; align-items:flex-end; gap:10px; flex-wrap:wrap; padding:12px; background:#f8fafc; border-radius:8px; border:1px solid var(--border);">
                                            <input type="hidden" name="property_id" value="${p.property_id}">
                                            <div style="flex:1; min-width:200px;">
                                                <label style="font-size:0.78rem; font-weight:600; display:block; margin-bottom:4px;">Image URL</label>
                                                <input type="url" name="image_url" required placeholder="https://…"
                                                       style="width:100%; padding:7px 10px; border:1px solid #cbd5e1; border-radius:6px; font-family:inherit; font-size:0.85rem;">
                                            </div>
                                            <div style="display:flex; align-items:center; gap:6px; padding-bottom:2px;">
                                                <input type="checkbox" name="is_primary" id="primary-${p.property_id}" value="true" style="width:16px; height:16px; accent-color:var(--accent);">
                                                <label for="primary-${p.property_id}" style="font-size:0.82rem; font-weight:600; cursor:pointer;">Set as Primary</label>
                                            </div>
                                            <button type="submit" class="btn btn-primary btn-sm"><i class="fa-solid fa-plus"></i> Add Image</button>
                                        </form>
                                    </div>
                                </td>
                            </tr>
                        </c:forEach>
                    </tbody>
                </table>
            </div>

            <!-- ===== VIEW DETAIL MODALS (CSS-only) ===== -->
            <div class="modal-overlay modal-view1">
                <div class="modal-card">
                    <label for="view-prop1" class="modal-close">&times;</label>
                    <div style="display:flex; gap:24px;">
                        <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?auto=format&fit=crop&w=400&q=80" style="width:220px; height:160px; border-radius:12px; object-fit:cover;">
                        <div style="flex:1;">
                            <h3 style="margin-bottom:6px;">Modern Luxury Villa</h3>
                            <p style="color:var(--accent); font-size:1.3rem; font-weight:700; margin-bottom:12px;">LKR 85,000,000</p>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.88rem; color:var(--text-muted);">
                                <span><i class="fa-solid fa-location-dot" style="color:var(--accent); width:18px;"></i> Colombo 07</span>
                                <span><i class="fa-solid fa-house" style="color:var(--accent); width:18px;"></i> House</span>
                                <span><i class="fa-solid fa-bed" style="color:var(--accent); width:18px;"></i> 4 Bedrooms</span>
                                <span><i class="fa-solid fa-bath" style="color:var(--accent); width:18px;"></i> 3 Bathrooms</span>
                                <span><i class="fa-solid fa-vector-square" style="color:var(--accent); width:18px;"></i> 3,200 sqft</span>
                                <span><i class="fa-solid fa-user-tie" style="color:var(--accent); width:18px;"></i> Owner: John D.</span>
                            </div>
                            <div style="margin-top:14px;"><span class="status-badge available">Available</span></div>
                        </div>
                    </div>
                    <div style="margin-top:20px; padding-top:16px; border-top:1px solid var(--border); display:flex; gap:10px;">
                        <a href="/property-detail" class="btn btn-primary btn-sm"><i class="fa-solid fa-external-link-alt"></i> Open Full Page</a>
                        <label for="view-prop1" class="btn btn-outline btn-sm" style="cursor:pointer;">Close</label>
                    </div>
                </div>
            </div>
            <div class="modal-overlay modal-view2">
                <div class="modal-card">
                    <label for="view-prop2" class="modal-close">&times;</label>
                    <div style="display:flex; gap:24px;">
                        <img src="https://images.unsplash.com/photo-1512917774080-9991f1c4c750?auto=format&fit=crop&w=400&q=80" style="width:220px; height:160px; border-radius:12px; object-fit:cover;">
                        <div style="flex:1;">
                            <h3 style="margin-bottom:6px;">Skyline Penthouse</h3>
                            <p style="color:var(--accent); font-size:1.3rem; font-weight:700; margin-bottom:12px;">LKR 120,000,000</p>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.88rem; color:var(--text-muted);">
                                <span><i class="fa-solid fa-location-dot" style="color:var(--accent); width:18px;"></i> Nawala</span>
                                <span><i class="fa-solid fa-building" style="color:var(--accent); width:18px;"></i> Apartment</span>
                                <span><i class="fa-solid fa-bed" style="color:var(--accent); width:18px;"></i> 3 Bedrooms</span>
                                <span><i class="fa-solid fa-bath" style="color:var(--accent); width:18px;"></i> 3 Bathrooms</span>
                                <span><i class="fa-solid fa-vector-square" style="color:var(--accent); width:18px;"></i> 2,500 sqft</span>
                                <span><i class="fa-solid fa-user-tie" style="color:var(--accent); width:18px;"></i> Owner: Elite Props</span>
                            </div>
                            <div style="margin-top:14px;"><span class="status-badge available">Available</span></div>
                        </div>
                    </div>
                    <div style="margin-top:20px; padding-top:16px; border-top:1px solid var(--border); display:flex; gap:10px;">
                        <a href="/property-detail" class="btn btn-primary btn-sm"><i class="fa-solid fa-external-link-alt"></i> Open Full Page</a>
                        <label for="view-prop2" class="btn btn-outline btn-sm" style="cursor:pointer;">Close</label>
                    </div>
                </div>
            </div>
            <div class="modal-overlay modal-view3">
                <div class="modal-card">
                    <label for="view-prop3" class="modal-close">&times;</label>
                    <div style="display:flex; gap:24px;">
                        <img src="https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?auto=format&fit=crop&w=400&q=80" style="width:220px; height:160px; border-radius:12px; object-fit:cover;">
                        <div style="flex:1;">
                            <h3 style="margin-bottom:6px;">Cozy Family House</h3>
                            <p style="color:var(--accent); font-size:1.3rem; font-weight:700; margin-bottom:12px;">LKR 45,000,000</p>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.88rem; color:var(--text-muted);">
                                <span><i class="fa-solid fa-location-dot" style="color:var(--accent); width:18px;"></i> Kandy</span>
                                <span><i class="fa-solid fa-house" style="color:var(--accent); width:18px;"></i> House</span>
                                <span><i class="fa-solid fa-bed" style="color:var(--accent); width:18px;"></i> 5 Bedrooms</span>
                                <span><i class="fa-solid fa-bath" style="color:var(--accent); width:18px;"></i> 2 Bathrooms</span>
                                <span><i class="fa-solid fa-vector-square" style="color:var(--accent); width:18px;"></i> 2,800 sqft</span>
                                <span><i class="fa-solid fa-user-tie" style="color:var(--accent); width:18px;"></i> Owner: Sarah S.</span>
                            </div>
                            <div style="margin-top:14px;"><span class="status-badge sold">Sold</span></div>
                        </div>
                    </div>
                    <div style="margin-top:20px; padding-top:16px; border-top:1px solid var(--border); display:flex; gap:10px;">
                        <a href="/property-detail" class="btn btn-primary btn-sm"><i class="fa-solid fa-external-link-alt"></i> Open Full Page</a>
                        <label for="view-prop3" class="btn btn-outline btn-sm" style="cursor:pointer;">Close</label>
                    </div>
                </div>
            </div>
            <div class="modal-overlay modal-view4">
                <div class="modal-card">
                    <label for="view-prop4" class="modal-close">&times;</label>
                    <div style="display:flex; gap:24px;">
                        <img src="https://images.unsplash.com/photo-1560185127-6a3c65d45771?auto=format&fit=crop&w=400&q=80" style="width:220px; height:160px; border-radius:12px; object-fit:cover;">
                        <div style="flex:1;">
                            <h3 style="margin-bottom:6px;">Commercial Office Space</h3>
                            <p style="color:var(--accent); font-size:1.3rem; font-weight:700; margin-bottom:12px;">LKR 250,000,000</p>
                            <div style="display:grid; grid-template-columns:1fr 1fr; gap:8px; font-size:0.88rem; color:var(--text-muted);">
                                <span><i class="fa-solid fa-location-dot" style="color:var(--accent); width:18px;"></i> Colombo 03</span>
                                <span><i class="fa-solid fa-building" style="color:var(--accent); width:18px;"></i> Commercial</span>
                                <span><i class="fa-solid fa-bed" style="color:var(--accent); width:18px;"></i> N/A</span>
                                <span><i class="fa-solid fa-bath" style="color:var(--accent); width:18px;"></i> 4 Restrooms</span>
                                <span><i class="fa-solid fa-vector-square" style="color:var(--accent); width:18px;"></i> 8,500 sqft</span>
                                <span><i class="fa-solid fa-user-tie" style="color:var(--accent); width:18px;"></i> Owner: Nuwan K.</span>
                            </div>
                            <div style="margin-top:14px;"><span class="status-badge pending">Pending Approval</span></div>
                        </div>
                    </div>
                    <div style="margin-top:20px; padding-top:16px; border-top:1px solid var(--border); display:flex; gap:10px;">
                        <a href="/property-detail" class="btn btn-primary btn-sm"><i class="fa-solid fa-external-link-alt"></i> Open Full Page</a>
                        <label for="view-prop4" class="btn btn-outline btn-sm" style="cursor:pointer;">Close</label>
                    </div>
                </div>
            </div>

            <!-- ===== DELETE CONFIRMATION MODALS ===== -->
            <div class="modal-overlay modal-del1">
                <div class="modal-card" style="max-width:440px; text-align:center;">
                    <label for="del-prop1" class="modal-close">&times;</label>
                    <i class="fa-solid fa-triangle-exclamation" style="font-size:3rem; color:var(--red); margin-bottom:16px;"></i>
                    <h3 style="margin-bottom:8px;">Delete Property?</h3>
                    <p style="color:var(--text-muted); font-size:0.9rem; margin-bottom:20px;">Are you sure you want to permanently delete <strong>"Modern Luxury Villa"</strong>? This action cannot be undone.</p>
                    <div style="display:flex; gap:10px; justify-content:center;">
                        <label for="del-prop1" class="btn btn-danger" style="cursor:pointer;"><i class="fa-solid fa-trash"></i> Yes, Delete</label>
                        <label for="del-prop1" class="btn btn-outline" style="cursor:pointer;">Cancel</label>
                    </div>
                </div>
            </div>
            <div class="modal-overlay modal-del2">
                <div class="modal-card" style="max-width:440px; text-align:center;">
                    <label for="del-prop2" class="modal-close">&times;</label>
                    <i class="fa-solid fa-triangle-exclamation" style="font-size:3rem; color:var(--red); margin-bottom:16px;"></i>
                    <h3 style="margin-bottom:8px;">Delete Property?</h3>
                    <p style="color:var(--text-muted); font-size:0.9rem; margin-bottom:20px;">Are you sure you want to permanently delete <strong>"Skyline Penthouse"</strong>? This action cannot be undone.</p>
                    <div style="display:flex; gap:10px; justify-content:center;">
                        <label for="del-prop2" class="btn btn-danger" style="cursor:pointer;"><i class="fa-solid fa-trash"></i> Yes, Delete</label>
                        <label for="del-prop2" class="btn btn-outline" style="cursor:pointer;">Cancel</label>
                    </div>
                </div>
            </div>
            <div class="modal-overlay modal-del3">
                <div class="modal-card" style="max-width:440px; text-align:center;">
                    <label for="del-prop3" class="modal-close">&times;</label>
                    <i class="fa-solid fa-triangle-exclamation" style="font-size:3rem; color:var(--red); margin-bottom:16px;"></i>
                    <h3 style="margin-bottom:8px;">Delete Property?</h3>
                    <p style="color:var(--text-muted); font-size:0.9rem; margin-bottom:20px;">Are you sure you want to permanently delete <strong>"Cozy Family House"</strong>? This action cannot be undone.</p>
                    <div style="display:flex; gap:10px; justify-content:center;">
                        <label for="del-prop3" class="btn btn-danger" style="cursor:pointer;"><i class="fa-solid fa-trash"></i> Yes, Delete</label>
                        <label for="del-prop3" class="btn btn-outline" style="cursor:pointer;">Cancel</label>
                    </div>
                </div>
            </div>
            <div class="modal-overlay modal-del4">
                <div class="modal-card" style="max-width:440px; text-align:center;">
                    <label for="del-prop4" class="modal-close">&times;</label>
                    <i class="fa-solid fa-triangle-exclamation" style="font-size:3rem; color:var(--red); margin-bottom:16px;"></i>
                    <h3 style="margin-bottom:8px;">Delete Property?</h3>
                    <p style="color:var(--text-muted); font-size:0.9rem; margin-bottom:20px;">Are you sure you want to permanently delete <strong>"Commercial Office Space"</strong>? This action cannot be undone.</p>
                    <div style="display:flex; gap:10px; justify-content:center;">
                        <label for="del-prop4" class="btn btn-danger" style="cursor:pointer;"><i class="fa-solid fa-trash"></i> Yes, Delete</label>
                        <label for="del-prop4" class="btn btn-outline" style="cursor:pointer;">Cancel</label>
                    </div>
                </div>
            </div>
        </div>

        <!-- ==================== MANAGE BOOKINGS PANEL ==================== -->
        <div class="panel panel-bookings">
            <div class="stats-grid" style="grid-template-columns: repeat(4, 1fr); margin-bottom: 24px;">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="fa-solid fa-calendar"></i></div>
                    <div class="stat-info"><h3>${totalBookings}</h3><p>Total Bookings</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon blue"><i class="fa-solid fa-hourglass-half"></i></div>
                    <div class="stat-info"><h3>${pendingBookings}</h3><p>Pending</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-circle-check"></i></div>
                    <div class="stat-info"><h3>${confirmedBookings}</h3><p>Confirmed</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red"><i class="fa-solid fa-circle-xmark"></i></div>
                    <div class="stat-info"><h3>${cancelledBookings}</h3><p>Cancelled</p></div>
                </div>
            </div>
            <div class="card">
                <div class="card-header">
                    <h3>Recent Booking Requests</h3>
                </div>
                <div class="booking-cards">
                    <c:forEach var="b" items="${bookings}">
                        <div class="booking-card">
                            <h4><i class="fa-solid fa-${b.viewing_type == 'virtual' ? 'video' : 'person-walking'}" style="color: var(--blue); margin-right: 6px;"></i> ${b.property_title}</h4>
                            <div class="meta">
                                <span><i class="fa-solid fa-user"></i> Booked by: ${b.first_name} ${b.last_name} (${b.email})</span>
                                <span><i class="fa-solid fa-calendar-day"></i> Date: ${b.booking_date} at ${b.booking_time}</span>
                                <span style="text-transform: capitalize;"><i class="fa-solid fa-camera"></i> Type: ${b.viewing_type} Viewing</span>
                            </div>
                            <span class="status-badge ${b.status == 'confirmed' ? 'confirmed' : (b.status == 'cancelled' ? 'cancelled' : 'pending')}">${b.status}</span>
                            <div style="margin-top: 12px; display: flex; gap: 8px;">
                                <button type="button" class="btn btn-outline btn-sm" style="color:var(--blue); border-color:var(--blue);" onclick="toggleEditBooking(${b.booking_id})">Edit</button>
                                <a href="/admin/delete-booking?id=${b.booking_id}" class="btn btn-outline btn-sm" style="color:var(--red); border-color:var(--red);" onclick="return confirm('Delete this booking?')">Delete</a>
                            </div>
                            <div id="edit-booking-${b.booking_id}" style="display:none; margin-top:12px; padding:15px; border-top:1px solid var(--border); background:#f8fafc; border-radius:8px;">
                                <form action="/admin/update-booking" method="POST">
                                    <input type="hidden" name="booking_id" value="${b.booking_id}">
                                    <div style="display:grid; grid-template-columns:1fr 1fr 1fr; gap:10px; margin-bottom:10px;">
                                        <div><label style="font-size:0.8rem;font-weight:bold;">Date</label><input type="date" name="booking_date" value="${b.booking_date}" class="form-control" required style="width:100%;padding:6px;border:1px solid #ccc;border-radius:4px;"></div>
                                        <div><label style="font-size:0.8rem;font-weight:bold;">Time</label><input type="time" name="booking_time" value="${b.booking_time}" class="form-control" required style="width:100%;padding:6px;border:1px solid #ccc;border-radius:4px;"></div>
                                        <div>
                                            <label style="font-size:0.8rem;font-weight:bold;">Status</label>
                                            <select name="status" class="form-control" style="width:100%;padding:6px;border:1px solid #ccc;border-radius:4px;">
                                                <option value="pending" ${b.status == 'pending' ? 'selected' : ''}>Pending</option>
                                                <option value="confirmed" ${b.status == 'confirmed' ? 'selected' : ''}>Confirmed</option>
                                                <option value="cancelled" ${b.status == 'cancelled' ? 'selected' : ''}>Cancelled</option>
                                            </select>
                                        </div>
                                    </div>
                                    <button type="submit" class="btn btn-primary btn-sm">Save</button>
                                    <button type="button" class="btn btn-outline btn-sm" onclick="toggleEditBooking(${b.booking_id})">Cancel</button>
                                </form>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>
        </div>

        <!-- ==================== REVIEW MODERATION PANEL ==================== -->
        <div class="panel panel-reviews">
            <div class="stats-grid" style="grid-template-columns: repeat(3, 1fr); margin-bottom: 24px;">
                <div class="stat-card">
                    <div class="stat-icon amber"><i class="fa-solid fa-star-half-stroke"></i></div>
                    <div class="stat-info"><h3>${totalReviews}</h3><p>Total Reviews</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon red"><i class="fa-solid fa-flag"></i></div>
                    <div class="stat-info"><h3>${pendingReviews}</h3><p>Pending Approval</p></div>
                </div>
                <div class="stat-card">
                    <div class="stat-icon green"><i class="fa-solid fa-check-double"></i></div>
                    <div class="stat-info"><h3>${approvedReviews}</h3><p>Approved</p></div>
                </div>
            </div>
            <div class="card">
                <div class="section-title"><i class="fa-solid fa-flag" style="color: var(--red);"></i> Flagged Reviews Requiring Action</div>
                <c:forEach var="r" items="${reviews}">
                    <div class="review-item" style="display: flex; flex-direction: column; gap: 10px;">
                        <div style="display: flex; justify-content: space-between; align-items: flex-start; width: 100%;">
                            <div>
                                <div class="review-stars">
                                    <c:forEach begin="1" end="${r.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                    <c:forEach begin="${r.rating + 1}" end="5"><i class="fa-regular fa-star"></i></c:forEach>
                                </div>
                                <p class="review-text">"${r.review_text}"</p>
                                <span class="review-meta"><i class="fa-solid fa-user"></i> ${r.first_name} ${r.last_name} &bull; on '${not empty r.property_title ? r.property_title : "General"}' &bull; ${r.created_at}</span>
                            </div>
                            <div class="review-actions">
                                <c:if test="${r.status == 'pending'}">
                                    <a href="/admin/approve-review?id=${r.review_id}" class="btn btn-primary btn-sm" style="background:var(--emerald); border:none;"><i class="fa-solid fa-check"></i> Approve</a>
                                </c:if>
                                <button type="button" class="btn btn-outline btn-sm" onclick="toggleEditForm(${r.review_id})"><i class="fa-solid fa-pen"></i> Edit</button>
                                <a href="/admin/delete-review?id=${r.review_id}" class="btn btn-danger btn-sm" onclick="return confirm('Delete this review?')"><i class="fa-solid fa-trash"></i> Delete</a>
                            </div>
                        </div>
                        
                        <%-- Edit Form (Hidden by default) --%>
                        <div id="edit-form-${r.review_id}" style="display: none; padding: 15px; background: #f8fafc; border-radius: 8px; border: 1px solid var(--border);">
                            <form action="/admin/update-review" method="POST">
                                <input type="hidden" name="review_id" value="${r.review_id}">
                                <div class="form-group" style="margin-bottom: 10px;">
                                    <label style="font-size: 0.85rem; font-weight: bold;">Update Rating (1-5)</label>
                                    <input type="number" name="rating" min="1" max="5" value="${r.rating}" class="form-control" style="padding: 8px; width: 100px; height: 35px;" required>
                                </div>
                                <div class="form-group" style="margin-bottom: 10px;">
                                    <label style="font-size: 0.85rem; font-weight: bold;">Update Review</label>
                                    <textarea name="review_text" class="form-control" rows="2" style="padding: 8px; resize: vertical;" required>${r.review_text}</textarea>
                                </div>
                                <button type="submit" class="btn btn-primary" style="padding: 8px 15px; font-size: 0.85rem;">Save Changes</button>
                                <button type="button" class="btn btn-outline" style="padding: 8px 15px; font-size: 0.85rem;" onclick="toggleEditForm(${r.review_id})">Cancel</button>
                            </form>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>

        <!-- ==================== SETTINGS PANEL ==================== -->
        <div class="panel panel-settings">
            <div class="card">
                <div class="card-header"><h3>System Settings</h3></div>
                <div class="settings-grid">
                    <div>
                        <div class="form-group">
                            <label>Platform Name</label>
                            <input type="text" value="PropertyHub.LK">
                        </div>
                        <div class="form-group">
                            <label>Admin Email</label>
                            <input type="email" value="admin@propertyhub.lk">
                        </div>
                        <div class="form-group">
                            <label>Max Properties Per Seller</label>
                            <input type="number" value="25">
                        </div>
                    </div>
                    <div>
                        <div class="form-group">
                            <label>Default Currency</label>
                            <div class="cselect" id="cs-currency">
                                <div class="cselect-trigger" onclick="toggleCselect('cs-currency')">
                                    <span class="cselect-label">LKR (Sri Lankan Rupee)</span>
                                    <span class="cselect-arrow"><i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i></span>
                                </div>
                                <div class="cselect-panel">
                                    <div class="cselect-option selected" onclick="selectOption('cs-currency', this)">LKR (Sri Lankan Rupee)<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-currency', this)">USD (US Dollar)<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-currency', this)">EUR (Euro)<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Auto-Approve Reviews</label>
                            <div class="cselect" id="cs-reviews">
                                <div class="cselect-trigger" onclick="toggleCselect('cs-reviews')">
                                    <span class="cselect-label">No – Require Admin Approval</span>
                                    <span class="cselect-arrow"><i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i></span>
                                </div>
                                <div class="cselect-panel">
                                    <div class="cselect-option selected" onclick="selectOption('cs-reviews', this)">No – Require Admin Approval<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-reviews', this)">Yes – Auto Approve<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                </div>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Maintenance Mode</label>
                            <div class="cselect" id="cs-maintenance">
                                <div class="cselect-trigger" onclick="toggleCselect('cs-maintenance')">
                                    <span class="cselect-label">Disabled</span>
                                    <span class="cselect-arrow"><i class="fa-solid fa-chevron-down" style="font-size:0.7rem;"></i></span>
                                </div>
                                <div class="cselect-panel">
                                    <div class="cselect-option selected" onclick="selectOption('cs-maintenance', this)">Disabled<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                    <div class="cselect-option" onclick="selectOption('cs-maintenance', this)">Enabled<span class="check-icon"><i class="fa-solid fa-check"></i></span></div>
                                </div>
                            </div>
                        </div>
                    </div>
                </div>
                <div style="padding-top: 10px; border-top: 1px solid var(--border); margin-top: 10px;">
                    <button class="btn btn-primary"><i class="fa-solid fa-floppy-disk"></i> Save Settings</button>
                </div>
            </div>

            <div class="card">
                <div class="card-header"><h3>Database Information</h3></div>
                <table class="data-table">
                    <tbody>
                        <tr><td style="font-weight:600; width: 200px;">Database Host</td><td>localhost:3306</td></tr>
                        <tr><td style="font-weight:600;">Database Name</td><td>propertyhub_db</td></tr>
                        <tr><td style="font-weight:600;">Connection</td><td><span class="status-badge active">Connected</span></td></tr>
                        <tr><td style="font-weight:600;">Last Backup</td><td>2026-03-26 02:00 AM</td></tr>
                    </tbody>
                </table>
            </div>

        <%-- Generate User Report section inside Settings --%>
        <div class="card" style="margin-top:0;">
            <div class="card-header"><h3><i class="fa-solid fa-file-lines" style="color:var(--purple);"></i> Generate User Report</h3></div>
            <p style="color:var(--text-muted); font-size:0.88rem; margin-bottom:18px;">Use the <strong>UserReport</strong> model to generate a filtered summary of registered users by role. The report is logged in the Activity Log.</p>
            <form action="/admin/generate-report" method="GET" style="display:flex; align-items:flex-end; gap:16px; flex-wrap:wrap;">
                <div>
                    <label style="font-size:0.82rem; font-weight:600; display:block; margin-bottom:6px;">Filter by Role</label>
                    <select name="role" style="padding:10px 16px; border:1.5px solid #e2e8f0; border-radius:10px; font-family:inherit; font-size:0.9rem; outline:none; background:white; min-width:200px;">
                        <option value="all">All Roles</option>
                        <option value="buyer">Buyer</option>
                        <option value="seller">Seller</option>
                        <option value="both">Buyer &amp; Seller</option>
                        <option value="admin">Admin</option>
                    </select>
                </div>
                <button type="submit" class="btn btn-primary"><i class="fa-solid fa-file-export"></i> Generate Report</button>
            </form>

            <c:if test="${not empty reportUsers}">
                <div style="margin-top:28px; padding-top:20px; border-top:1px solid var(--border);">
                    <div style="display:flex; justify-content:space-between; align-items:center; margin-bottom:14px;">
                        <div>
                            <p style="font-weight:700; font-size:1rem; margin-bottom:4px;">Report ID: <span style="color:var(--purple);">${reportId}</span></p>
                            <p style="font-size:0.82rem; color:var(--text-muted);">Generated: ${reportAt} &bull; Role Filter: <strong>${reportRole}</strong> &bull; Total Records: <strong>${totalRows}</strong></p>
                        </div>
                    </div>
                    <table class="data-table">
                        <thead><tr><th>ID</th><th>Name</th><th>Email</th><th>Role</th><th>Status</th><th>Registered</th></tr></thead>
                        <tbody>
                            <c:forEach var="ru" items="${reportUsers}">
                                <tr>
                                    <td>#U${ru.user_id}</td>
                                    <td><strong>${ru.first_name} ${ru.last_name}</strong></td>
                                    <td>${ru.email}</td>
                                    <td><span class="role-badge ${ru.role}">${ru.role}</span></td>
                                    <td><span class="status-badge ${ru.is_active ? 'active' : 'cancelled'}">${ru.is_active ? 'Active' : 'Deactivated'}</span></td>
                                    <td style="font-size:0.82rem; color:var(--text-muted);">${ru.created_at}</td>
                                </tr>
                            </c:forEach>
                        </tbody>
                    </table>
                </div>
            </c:if>
        </div>
    </div>

        <!-- ==================== ACTIVITY LOG PANEL ==================== -->
        <div class="panel panel-activitylog">
            <div class="card-header" style="margin-bottom:20px;">
                <h2 style="font-size:1.3rem;font-weight:700;"><i class="fa-solid fa-clock-rotate-left" style="color:var(--purple);"></i> Admin Activity Log</h2>
                <span style="font-size:0.85rem;color:var(--text-muted);">Every admin action is recorded here automatically.</span>
            </div>
            <div class="card">
                <c:choose>
                    <c:when test="${empty activityLog}">
                        <p class="text-muted text-center" style="padding:30px;">No activity recorded yet.</p>
                    </c:when>
                    <c:otherwise>
                        <table class="data-table">
                            <thead><tr><th>#</th><th>Admin</th><th>Action Type</th><th>Description</th><th>Timestamp</th></tr></thead>
                            <tbody>
                                <c:forEach var="log" items="${activityLog}">
                                    <tr>
                                        <td>#${log.log_id}</td>
                                        <td><strong>${log.admin_name}</strong></td>
                                        <td>
                                            <span style="background:rgba(139,92,246,0.1);color:var(--purple);padding:3px 10px;border-radius:20px;font-size:0.75rem;font-weight:600;">${log.action_type}</span>
                                        </td>
                                        <td>${log.description}</td>
                                        <td style="color:var(--text-muted);font-size:0.82rem;">${log.created_at}</td>
                                    </tr>
                                </c:forEach>
                            </tbody>
                        </table>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>

    </div><!-- /content-area -->
</div><!-- /main-wrapper -->

<script>
    function toggleEditForm(reviewId) {
        var form = document.getElementById('edit-form-' + reviewId);
        if (form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }
    
    function toggleEditUser(userId) {
        var form = document.getElementById('edit-user-' + userId);
        if (form.style.display === 'none') {
            form.style.display = 'table-row';
        } else {
            form.style.display = 'none';
        }
    }

    function toggleEditProperty(propertyId) {
        var form = document.getElementById('edit-prop-' + propertyId);
        if (form.style.display === 'none') {
            form.style.display = 'table-row';
        } else {
            form.style.display = 'none';
        }
    }

    function toggleEditBooking(bookingId) {
        var form = document.getElementById('edit-booking-' + bookingId);
        if (form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }

// Auto-select panel from URL ?panel= param
(function() {
    var params = new URLSearchParams(window.location.search);
    var panel = params.get('panel');
    if (panel) {
        var radio = document.getElementById('panel-' + panel);
        if (radio) radio.checked = true;
    }
})();

(function() {
    function closeAll(exceptId) {
        document.querySelectorAll('.cselect.cs-open').forEach(function(d) {
            if (!exceptId || d.id !== exceptId) {
                d.classList.remove('cs-open');
                var p = d.querySelector('.cselect-panel');
                if (p) { p.style.top = ''; p.style.left = ''; p.style.width = ''; }
            }
        });
    }

    window.toggleCselect = function(id) {
        var el = document.getElementById(id);
        if (!el) return;
        if (el.classList.contains('cs-open')) { closeAll(); return; }
        closeAll(id);

        var trigger = el.querySelector('.cselect-trigger');
        var panel   = el.querySelector('.cselect-panel');
        var rect    = trigger.getBoundingClientRect();

        panel.style.top   = (rect.bottom + 8) + 'px';
        panel.style.left  = rect.left + 'px';
        panel.style.width = rect.width + 'px';

        el.classList.add('cs-open');
    };

    window.selectOption = function(id, opt) {
        var el = document.getElementById(id);
        el.querySelectorAll('.cselect-option').forEach(function(o) { o.classList.remove('selected'); });
        opt.classList.add('selected');
        el.querySelector('.cselect-label').textContent = opt.childNodes[0].textContent.trim();
        closeAll();
    };

    document.addEventListener('click', function(e) {
        if (!e.target.closest('.cselect')) closeAll();
    });
})();
</script>
</body>
</html>
