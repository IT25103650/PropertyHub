<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Buyer Dashboard | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        body { background-color: var(--color-background); }
        .dashboard-layout { display: flex; min-height: 100vh; position: relative; top: 70px; }
        .sidebar { width: 250px; background: white; padding: 30px 20px; box-shadow: var(--shadow-md); position: fixed; height: calc(100vh - 70px); overflow-y: auto; }
        .sidebar-links { display: flex; flex-direction: column; gap: 10px; margin-top: 30px; }
        .sidebar-links a { padding: 12px 15px; border-radius: var(--border-radius-sm); color: var(--color-text-main); font-weight: 500; display: flex; align-items: center; gap: 10px; text-decoration: none; transition: background 0.2s; }
        .sidebar-links a:hover, .sidebar-links a.active { background-color: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
        .main-content { margin-left: 250px; padding: 40px; flex: 1; }
        .card { background: white; border-radius: var(--border-radius-lg); padding: 25px; box-shadow: var(--shadow-sm); margin-bottom: 30px; }
        .dashboard-stats { display: grid; grid-template-columns: repeat(3, 1fr); gap: 20px; margin-bottom: 30px; }
        .stat-card { background: white; padding: 20px; border-radius: var(--border-radius-lg); box-shadow: var(--shadow-sm); display: flex; align-items: center; gap: 20px; }
        .stat-icon { width: 60px; height: 60px; border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; background: rgba(16, 185, 129, 0.1); color: var(--color-primary); }
        .stat-info h3 { font-size: 1.5rem; margin-bottom: 0; }
        .stat-info p { color: var(--color-text-muted); font-size: 0.9rem; }
        .booking-item { padding: 15px; border-bottom: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; }
        .booking-item:last-child { border-bottom: none; }
        .badge-confirmed { background: rgba(16,185,129,0.1); color: var(--color-primary); padding: 5px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .badge-pending   { background: rgba(245,158,11,0.1);  color: #d97706; padding: 5px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .badge-completed { background: rgba(59,130,246,0.1);  color: #2563eb; padding: 5px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .badge-cancelled { background: rgba(239,68,68,0.1);   color: #dc2626; padding: 5px 10px; border-radius: 20px; font-size: 0.8rem; font-weight: 600; }
        .alert-success { background: rgba(16,185,129,0.08); border: 1px solid rgba(16,185,129,0.3); color: #065f46; padding: 12px 18px; border-radius: 8px; margin-bottom: 20px; font-size: 0.9rem; }
    </style>
</head>
<body>

<!-- Navigation -->
<header class="navbar" style="padding: 10px 5%; box-shadow: var(--shadow-md);">
    <div class="logo"><a href="/" style="text-decoration:none;"><i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span></a></div>
    <div class="nav-actions" style="display:flex;align-items:center;gap:12px;position:relative;">
        <!-- Profile dropdown trigger -->
        <div id="profile-trigger" onclick="toggleProfilePanel()" style="display:flex;align-items:center;gap:8px;cursor:pointer;padding:6px 14px;border-radius:30px;background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.2);transition:background 0.2s;">
            <c:choose>
                <c:when test="${not empty profileImage}">
                    <img src="${profileImage}" style="width:32px;height:32px;border-radius:50%;object-fit:cover;border:2px solid #10b981;" alt="Profile">
                </c:when>
                <c:otherwise>
                    <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);color:white;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.82rem;">${initials}</div>
                </c:otherwise>
            </c:choose>
            <span style="font-size:0.9rem;font-weight:600;color:#334155;">Welcome, <strong>${welcomeName}</strong></span>
            <i class="fa-solid fa-chevron-down" style="font-size:0.65rem;color:#64748b;"></i>
        </div>
        <!-- Profile dropdown panel -->
        <div id="profile-panel" style="display:none;position:fixed;top:68px;right:20px;background:white;border-radius:14px;box-shadow:0 16px 48px rgba(0,0,0,0.15);border:1px solid #e2e8f0;width:280px;z-index:99999;padding:0;overflow:hidden;">
            <div style="padding:20px;background:linear-gradient(135deg,#0f172a,#1e293b);color:white;">
                <div style="display:flex;align-items:center;gap:12px;">
                    <c:choose>
                        <c:when test="${not empty profileImage}">
                            <img src="${profileImage}" style="width:48px;height:48px;border-radius:50%;object-fit:cover;border:2px solid #10b981;" alt="Profile">
                        </c:when>
                        <c:otherwise>
                            <div style="width:48px;height:48px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);display:flex;align-items:center;justify-content:center;font-size:1.1rem;font-weight:700;">${initials}</div>
                        </c:otherwise>
                    </c:choose>
                    <div>
                        <div style="font-weight:700;font-size:0.95rem;">${fullName}</div>
                        <div style="font-size:0.78rem;color:#94a3b8;text-transform:capitalize;">${sessionScope.userRole} Account</div>
                    </div>
                </div>
            </div>
            <div style="padding:8px;">
                <a href="/buyer-dashboard?section=profile" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#334155;font-size:0.87rem;text-decoration:none;transition:background 0.15s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                    <i class="fa-solid fa-user-pen" style="color:#10b981;width:16px;"></i> Edit Profile
                </a>
                <a href="/buyer-dashboard?section=bookings" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#334155;font-size:0.87rem;text-decoration:none;transition:background 0.15s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                    <i class="fa-solid fa-calendar-check" style="color:#3b82f6;width:16px;"></i> My Bookings
                </a>
                <a href="/buyer-dashboard?section=saved" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#334155;font-size:0.87rem;text-decoration:none;transition:background 0.15s;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                    <i class="fa-solid fa-heart" style="color:#ef4444;width:16px;"></i> Saved Properties
                </a>
                <hr style="margin:6px 0;border:none;border-top:1px solid #f1f5f9;">
                <a href="/logout" style="display:flex;align-items:center;gap:10px;padding:10px 12px;border-radius:8px;color:#ef4444;font-size:0.87rem;text-decoration:none;transition:background 0.15s;" onmouseover="this.style.background='#fef2f2'" onmouseout="this.style.background='transparent'">
                    <i class="fa-solid fa-right-from-bracket" style="width:16px;"></i> Logout
                </a>
            </div>
        </div>
    </div>
</header>

<div class="dashboard-layout">
    <!-- Sidebar -->
    <aside class="sidebar">
        <c:choose>
            <c:when test="${not empty profileImage}">
                <img src="${profileImage}" class="author-avatar" style="margin: 0 auto; width: 80px; height: 80px; border-radius: 50%; object-fit: cover; border: 3px solid #10b981;" alt="Profile">
            </c:when>
            <c:otherwise>
                <div class="author-avatar" style="margin: 0 auto; width: 80px; height: 80px; font-size: 2rem;">${initials}</div>
            </c:otherwise>
        </c:choose>
        <h4 class="text-center mt-2">${fullName}</h4>
        <p class="text-center text-muted" style="font-size: 0.85rem; text-transform: capitalize;">${sessionScope.userRole} Account</p>

        <nav class="sidebar-links">
            <a href="/buyer-dashboard" class="${empty param.section ? 'active' : ''}"><i class="fa-solid fa-gauge"></i> Dashboard</a>
            <a href="/buyer-dashboard?section=bookings" class="${param.section == 'bookings' ? 'active' : ''}"><i class="fa-solid fa-calendar-check"></i> My Bookings</a>
            <a href="/buyer-dashboard?section=calendar" class="${param.section == 'calendar' ? 'active' : ''}"><i class="fa-solid fa-calendar-days"></i> Booking Calendar</a>
            <a href="/buyer-dashboard?section=saved" class="${param.section == 'saved' ? 'active' : ''}"><i class="fa-solid fa-heart"></i> Saved Properties</a>
            <a href="/buyer-dashboard?section=reviews" class="${param.section == 'reviews' ? 'active' : ''}"><i class="fa-solid fa-star"></i> My Reviews</a>
            <a href="/buyer-dashboard?section=inquiries" class="${param.section == 'inquiries' ? 'active' : ''}">
                <i class="fa-solid fa-envelope"></i> My Messages
                <c:if test="${unreadReplies > 0}">
                    <span style="margin-left:auto;background:#ef4444;color:white;border-radius:20px;font-size:0.7rem;padding:2px 7px;font-weight:700;">${unreadReplies}</span>
                </c:if>
            </a>
            <a href="/buyer-dashboard?section=profile" class="${param.section == 'profile' ? 'active' : ''}"><i class="fa-solid fa-user-pen"></i> Edit Profile</a>
            <a href="/logout" style="color: #ef4444; margin-top: 30px;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </nav>
    </aside>

    <!-- Main Content -->
    <main class="main-content">
        <c:choose>
            <c:when test="${empty param.section}">
                <h2 class="mb-4" style="margin-bottom: 20px;">Buyer Dashboard</h2>
                <c:if test="${param.updated == 'true'}">
                    <div class="alert-success"><i class="fa-solid fa-circle-check"></i> Profile updated successfully!</div>
                </c:if>

                <div class="dashboard-stats">
                    <div class="stat-card">
                        <div class="stat-icon"><i class="fa-solid fa-house"></i></div>
                        <div class="stat-info">
                            <h3>${savedCount}</h3>
                            <p>Saved Properties</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="color: var(--color-accent); background: rgba(245, 158, 11, 0.1);"><i class="fa-solid fa-calendar"></i></div>
                        <div class="stat-info">
                            <h3>${bookingCount}</h3>
                            <p>Upcoming Viewings</p>
                        </div>
                    </div>
                    <div class="stat-card">
                        <div class="stat-icon" style="color: #3b82f6; background: rgba(59, 130, 246, 0.1);"><i class="fa-solid fa-comment-dots"></i></div>
                        <div class="stat-info">
                            <h3>${reviewCount}</h3>
                            <p>Reviews Given</p>
                        </div>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 30px;">
                    <div class="card">
                        <h3><i class="fa-solid fa-magnifying-glass" style="color:#10b981;margin-right:8px;"></i>Browse Properties</h3>
                        <p style="color:#64748b;font-size:0.85rem;margin:8px 0 16px;">Discover new listings and save your favourites.</p>
                        <a href="/property/listing" class="btn btn-outline btn-sm">Explore Listings</a>
                    </div>
                    <div class="card">
                        <h3><i class="fa-solid fa-calendar" style="color:#f59e0b;margin-right:8px;"></i>Quick Bookings</h3>
                        <ul style="margin-top: 15px; padding: 0; list-style: none;">
                            <c:forEach var="b" items="${bookings}" end="2">
                                <li class="booking-item">
                                    <strong>${b.property_title}</strong>
                                    <span class="badge-${b.status}">${b.status}</span>
                                </li>
                            </c:forEach>
                            <c:if test="${empty bookings}">
                                <li style="color:#94a3b8;font-size:0.85rem;padding:8px 0;">No upcoming bookings.</li>
                            </c:if>
                        </ul>
                        <a href="/buyer-dashboard?section=bookings" class="btn btn-outline btn-sm mt-4">View All Bookings</a>
                    </div>
                </div>
            </c:when>

            <%-- ======== INQUIRIES ======== --%>
            <c:when test="${param.section == 'inquiries'}">
                <h2 class="mb-4">My Messages</h2>
                <p style="color:#64748b; margin-bottom:20px;">View your inquiries and responses from property sellers.</p>
                <div class="card">
                    <c:choose>
                        <c:when test="${empty inquiries}">
                            <div class="text-center py-8" style="color:#94a3b8;">
                                <i class="fa-regular fa-envelope" style="font-size:2.5rem; margin-bottom:12px; display:block;"></i>
                                <p>You haven't sent any messages yet.</p>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div style="display:flex; flex-direction:column; gap:20px;">
                                <c:forEach var="inq" items="${inquiries}">
                                    <div style="border:1px solid #e2e8f0; border-radius:12px; padding:16px; background:#fff;">
                                        <div style="display:flex; justify-content:space-between; margin-bottom:12px; border-bottom:1px solid #f1f5f9; padding-bottom:10px;">
                                            <div>
                                                <div style="font-size:0.85rem; color:#3b82f6; font-weight:600;"><a href="/property-detail?id=${inq.property_id}" style="text-decoration:none; color:inherit;">Re: ${inq.property_title}</a></div>
                                                <div style="font-size:0.75rem; color:#94a3b8;">To: ${inq.seller_first_name} ${inq.seller_last_name} &bull; ${inq.created_at}</div>
                                            </div>
                                            <c:if test="${not empty inq.reply_message && inq.is_read}">
                                                <div style="background:#ecfdf5; color:#059669; font-size:0.7rem; font-weight:bold; padding:3px 8px; border-radius:12px; height:max-content;">REPLIED</div>
                                            </c:if>
                                        </div>
                                        <div style="background:#f8fafc; padding:12px; border-radius:8px; font-size:0.9rem; color:#475569; margin-bottom:12px; border-left:3px solid #cbd5e1;">
                                                ${inq.message}
                                        </div>

                                        <c:if test="${not empty inq.reply_message}">
                                            <div style="background:#eff6ff; padding:12px; border-radius:8px; font-size:0.9rem; color:#1e3a8a; border-left:3px solid #3b82f6; margin-left:20px;">
                                                <div style="font-size:0.75rem; font-weight:bold; margin-bottom:4px; display:flex; align-items:center; gap:6px;">
                                                    <i class="fa-solid fa-reply" style="color:#3b82f6;"></i>
                                                    Seller's Reply:
                                                </div>
                                                    ${inq.reply_message}
                                            </div>
                                        </c:if>
                                        <c:if test="${empty inq.reply_message}">
                                            <div style="margin-left:20px; font-size:0.8rem; color:#94a3b8; font-style:italic;">
                                                Waiting for seller's reply...
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>

            <c:when test="${param.section == 'profile'}">
                <h2 class="mb-4">Update Profile</h2>
                <div class="card" style="max-width: 600px;">
                    <form class="auth-form" action="/buyer-dashboard/update-profile" method="POST" enctype="multipart/form-data">
                        <div class="form-group" style="text-align: center; margin-bottom: 20px;">
                            <div style="width:100px; height:100px; border-radius:50%; background:var(--color-bg); display:inline-flex; align-items:center; justify-content:center; border:2px solid #e2e8f0; overflow:hidden; margin-bottom:10px;">
                                <c:choose>
                                    <c:when test="${not empty profileImage}">
                                        <img src="${profileImage}" style="width:100%; height:100%; object-fit:cover;" alt="Current Profile">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="font-size:2rem; color:var(--color-text-muted);">${initials}</div>
                                    </c:otherwise>
                                </c:choose>
                            </div>
                            <div>
                                <label style="cursor:pointer; color:var(--color-primary); font-size:0.9rem; font-weight:600;">
                                    Change Profile Picture
                                    <input type="file" name="profileImageFile" accept="image/*" style="display:none;" onchange="alert('Image selected: ' + this.files[0].name)">
                                </label>
                            </div>
                        </div>
                        <div class="form-group">
                            <label>Full Name</label>
                            <input type="text" name="name" class="form-control" value="${fullName}" required>
                        </div>
                        <div class="form-group">
                            <label>Email</label>
                            <input type="email" name="email" class="form-control" value="${email}" required>
                        </div>
                        <div class="form-group">
                            <label>Contact Number</label>
                            <input type="text" name="phone" class="form-control" value="${phone}" placeholder="+94 ...">
                        </div>
                        <button type="submit" class="btn btn-primary">Save Changes</button>
                    </form>
                </div>

                <div class="card mt-4" style="max-width: 600px; border: 1.5px solid rgba(220,38,38,0.25);">
                    <h3 style="color:#dc2626;margin-bottom:8px;"><i class="fa-solid fa-triangle-exclamation"></i> Danger Zone</h3>
                    <p style="color:var(--color-text-muted);font-size:0.88rem;margin-bottom:16px;">Permanently delete your account and all associated data. This cannot be undone.</p>
                    <form action="/buyer-dashboard/delete-account" method="POST"
                          onsubmit="return confirm('Are you sure? This will permanently delete your account, bookings, and reviews. This cannot be undone.')">
                        <button type="submit" class="btn btn-sm" style="background:transparent; color:#dc2626; border: 1px solid rgba(220,38,38,0.3); padding:7px 14px; border-radius: 8px;">
                            <i class="fa-solid fa-trash"></i> Delete My Account
                        </button>
                    </form>
                </div>
            </c:when>

            <c:when test="${param.section == 'bookings'}">
                <h2 class="mb-4">My Bookings</h2>
                <c:if test="${param.updated == 'true'}">
                    <div class="alert-success"><i class="fa-solid fa-circle-check"></i> Booking updated successfully!</div>
                </c:if>
                <c:if test="${param.cancelled == 'true'}">
                    <div class="alert-success" style="background:rgba(239,68,68,0.07);border-color:rgba(239,68,68,0.25);color:#991b1b;"><i class="fa-solid fa-ban"></i> Booking cancelled.</div>
                </c:if>
                <div class="card">
                    <c:choose>
                        <c:when test="${empty bookings}">
                            <p class="text-muted text-center py-8">No bookings found.</p>
                        </c:when>
                        <c:otherwise>
                            <div style="overflow-x: auto;">
                                <c:forEach var="b" items="${bookings}">
                                    <div style="border:1px solid #f1f5f9;border-radius:12px;padding:16px;margin-bottom:14px;">
                                        <div style="display:flex;justify-content:space-between;align-items:flex-start;flex-wrap:wrap;gap:10px;">
                                            <div>
                                                <div style="font-weight:700;font-size:0.95rem;color:#0f172a;margin-bottom:4px;">${b.property_title}</div>
                                                <div style="font-size:0.82rem;color:#64748b;"><i class="fa-solid fa-location-dot" style="color:#10b981;"></i> ${b.location}</div>
                                                <div style="font-size:0.82rem;color:#64748b;margin-top:3px;">
                                                    <i class="fa-solid fa-calendar"></i>
                                                    <fmt:parseDate value="${b.booking_date}" pattern="yyyy-MM-dd" var="pd" type="date"/>
                                                    <fmt:formatDate value="${pd}" pattern="MMM dd, yyyy"/> @ ${b.booking_time}
                                                    &nbsp;·&nbsp;
                                                    <i class="fa-solid fa-eye" style="text-transform:capitalize;"></i> ${b.viewing_type}
                                                </div>
                                            </div>
                                            <div style="display:flex;align-items:center;gap:8px;">
                                                <span class="badge-${b.status}">${b.status}</span>
                                                <c:if test="${b.status == 'pending'}">
                                                    <button onclick="toggleBookingEdit('edit-${b.booking_id}')" style="background:#3b82f6;color:white;border:none;padding:5px 12px;border-radius:6px;font-size:0.78rem;cursor:pointer;">
                                                        <i class="fa-solid fa-pen"></i> Edit
                                                    </button>
                                                    <a href="/buyer-dashboard/cancel-booking?id=${b.booking_id}" onclick="return confirm('Cancel this booking?')" style="background:#ef4444;color:white;padding:5px 12px;border-radius:6px;font-size:0.78rem;text-decoration:none;">
                                                        <i class="fa-solid fa-ban"></i> Cancel
                                                    </a>
                                                </c:if>
                                            </div>
                                        </div>
                                            <%-- Edit form (hidden) --%>
                                        <c:if test="${b.status == 'pending'}">
                                            <div id="edit-${b.booking_id}" style="display:none;margin-top:14px;padding:14px;background:#f8fafc;border-radius:10px;border:1px solid #e2e8f0;">
                                                <form action="/buyer-dashboard/update-booking" method="POST">
                                                    <input type="hidden" name="booking_id" value="${b.booking_id}">
                                                    <div style="display:grid;grid-template-columns:1fr 1fr 1fr;gap:10px;margin-bottom:10px;">
                                                        <div>
                                                            <label style="font-size:0.8rem;font-weight:600;color:#475569;display:block;margin-bottom:4px;">Date</label>
                                                            <input type="date" name="booking_date" value="${b.booking_date}" required style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:6px;font-size:0.85rem;">
                                                        </div>
                                                        <div>
                                                            <label style="font-size:0.8rem;font-weight:600;color:#475569;display:block;margin-bottom:4px;">Time</label>
                                                            <input type="time" name="booking_time" value="${b.booking_time}" required style="width:100%;padding:8px;border:1px solid #e2e8f0;border-radius:6px;font-size:0.85rem;">
                                                        </div>
                                                        <div>
                                                            <label style="font-size:0.8rem;font-weight:600;color:#475569;display:block;margin-bottom:4px;">View Type</label>
                                                            <input type="hidden" name="viewing_type" value="physical">
                                                            <div style="padding:8px 12px;border:1px solid #d1fae5;border-radius:6px;background:rgba(16,185,129,0.06);font-size:0.85rem;color:#065f46;font-weight:600;display:flex;align-items:center;gap:6px;">
                                                                <i class="fa-solid fa-person-walking" style="color:#10b981;"></i> Physical
                                                            </div>
                                                        </div>
                                                    </div>
                                                    <button type="submit" style="background:#10b981;color:white;border:none;padding:7px 18px;border-radius:7px;font-size:0.83rem;cursor:pointer;font-weight:600;"><i class="fa-solid fa-floppy-disk"></i> Save Changes</button>
                                                    <button type="button" onclick="toggleBookingEdit('edit-${b.booking_id}')" style="background:transparent;border:1px solid #e2e8f0;color:#475569;padding:7px 14px;border-radius:7px;font-size:0.83rem;cursor:pointer;margin-left:8px;">Cancel</button>
                                                </form>
                                            </div>
                                        </c:if>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>

            <%-- ======== BOOKING CALENDAR ======== --%>
            <c:when test="${param.section == 'calendar'}">
                <h2 class="mb-4">Booking Calendar</h2>
                <p style="color:#64748b;margin-bottom:20px;">View all your confirmed and upcoming viewing appointments in a monthly calendar.</p>
                <div class="card" style="padding:0; overflow:hidden;">
                    <div id="cal-header" style="background:linear-gradient(135deg,#10b981,#059669);padding:20px 28px;display:flex;justify-content:space-between;align-items:center;">
                        <button onclick="changeMonth(-1)" style="background:rgba(255,255,255,0.2);border:none;color:white;width:36px;height:36px;border-radius:50%;cursor:pointer;font-size:1.1rem;">&#8249;</button>
                        <h3 id="cal-title" style="color:white;font-size:1.2rem;font-weight:700;margin:0;"></h3>
                        <button onclick="changeMonth(1)" style="background:rgba(255,255,255,0.2);border:none;color:white;width:36px;height:36px;border-radius:50%;cursor:pointer;font-size:1.1rem;">&#8250;</button>
                    </div>
                    <div style="padding:20px;">
                        <div id="cal-grid" style="display:grid;grid-template-columns:repeat(7,1fr);gap:4px;text-align:center;"></div>
                    </div>
                </div>

                <script>
                    // Build bookings map from JSP data
                    var bookingMap = {};
                    <c:forEach var="b" items="${bookings}">
                    <c:if test="${not empty b.booking_date}">
                    (function() {
                        var d = "${b.booking_date}".substring(0,10);
                        if (!bookingMap[d]) bookingMap[d] = [];
                        bookingMap[d].push({
                            title: "${b.property_title}".replace(/"/g,'&quot;'),
                            status: "${b.status}",
                            time: "${b.booking_time}"
                        });
                    })();
                    </c:if>
                    </c:forEach>

                    var curDate = new Date();
                    var curYear = curDate.getFullYear();
                    var curMonth = curDate.getMonth();

                    function renderCalendar(year, month) {
                        var months = ["January","February","March","April","May","June","July","August","September","October","November","December"];
                        document.getElementById('cal-title').textContent = months[month] + ' ' + year;
                        var grid = document.getElementById('cal-grid');
                        grid.innerHTML = '';

                        // Day headers
                        ['Sun','Mon','Tue','Wed','Thu','Fri','Sat'].forEach(function(d) {
                            var el = document.createElement('div');
                            el.style.cssText = 'font-size:0.72rem;font-weight:700;color:#94a3b8;padding:8px 0;text-transform:uppercase;';
                            el.textContent = d;
                            grid.appendChild(el);
                        });

                        var firstDay = new Date(year, month, 1).getDay();
                        var daysInMonth = new Date(year, month+1, 0).getDate();
                        var today = new Date();

                        // Empty cells
                        for (var i = 0; i < firstDay; i++) {
                            grid.appendChild(document.createElement('div'));
                        }

                        for (var day = 1; day <= daysInMonth; day++) {
                            var key = year + '-' + String(month+1).padStart(2,'0') + '-' + String(day).padStart(2,'0');
                            var isToday = (day === today.getDate() && month === today.getMonth() && year === today.getFullYear());
                            var hasBooking = bookingMap[key] && bookingMap[key].length > 0;

                            var cell = document.createElement('div');
                            cell.style.cssText = 'border-radius:10px;padding:8px 4px;min-height:60px;position:relative;cursor:default;transition:background 0.15s;' +
                                (isToday ? 'background:#ecfdf5;border:2px solid #10b981;' : hasBooking ? 'background:#eff6ff;border:1px solid #bfdbfe;' : 'border:1px solid #f1f5f9;');

                            var num = document.createElement('div');
                            num.style.cssText = 'font-size:0.85rem;font-weight:' + (isToday ? '800' : '500') + ';color:' + (isToday ? '#059669' : '#334155') + ';margin-bottom:4px;';
                            num.textContent = day;
                            cell.appendChild(num);

                            if (hasBooking) {
                                bookingMap[key].forEach(function(bk) {
                                    var badge = document.createElement('div');
                                    var color = bk.status === 'confirmed' ? '#3b82f6' : bk.status === 'completed' ? '#10b981' : bk.status === 'cancelled' ? '#ef4444' : '#f59e0b';
                                    badge.style.cssText = 'font-size:0.6rem;font-weight:700;padding:2px 4px;border-radius:4px;color:white;background:' + color + ';overflow:hidden;white-space:nowrap;text-overflow:ellipsis;margin-bottom:2px;';
                                    badge.title = bk.title + ' @ ' + bk.time;
                                    badge.textContent = bk.title.substring(0,10) + (bk.title.length > 10 ? '…' : '');
                                    cell.appendChild(badge);
                                });
                            }
                            grid.appendChild(cell);
                        }
                    }

                    function changeMonth(delta) {
                        curMonth += delta;
                        if (curMonth < 0) { curMonth = 11; curYear--; }
                        if (curMonth > 11) { curMonth = 0; curYear++; }
                        renderCalendar(curYear, curMonth);
                    }

                    renderCalendar(curYear, curMonth);
                </script>

                <%-- Legend --%>
                <div style="display:flex;gap:16px;margin-top:16px;flex-wrap:wrap;font-size:0.8rem;">
                    <span style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;border-radius:3px;background:#f59e0b;display:inline-block;"></span>Pending</span>
                    <span style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;border-radius:3px;background:#3b82f6;display:inline-block;"></span>Confirmed</span>
                    <span style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;border-radius:3px;background:#10b981;display:inline-block;"></span>Completed</span>
                    <span style="display:flex;align-items:center;gap:6px;"><span style="width:12px;height:12px;border-radius:3px;background:#ef4444;display:inline-block;"></span>Cancelled</span>
                </div>
            </c:when>

            <c:when test="${param.section == 'saved'}">
                <h2 class="mb-4">Saved Properties</h2>
                <c:if test="${param.removed == 'true'}">
                    <div class="alert-success" style="background:rgba(239,68,68,0.07);border-color:rgba(239,68,68,0.25);color:#991b1b;"><i class="fa-solid fa-heart-crack"></i> Removed from favourites.</div>
                </c:if>
                <c:if test="${param.alert == 'saved'}">
                    <div class="alert-success"><i class="fa-solid fa-bell"></i> Price alert saved!</div>
                </c:if>
                <div style="display: grid; grid-template-columns: repeat(auto-fill, minmax(280px, 1fr)); gap: 20px;">
                    <c:forEach var="p" items="${savedProperties}">
                        <div class="card" style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">
                            <img src="${not empty p.image_url ? p.image_url : 'https://images.unsplash.com/photo-1560518883-ce09059eeffa?q=80&w=400'}" style="width: 100%; height: 160px; object-fit: cover; cursor:pointer;" onclick="window.location.href='/property-detail?id=${p.property_id}'">
                            <div style="padding: 15px;">
                                <h4 style="margin: 0 0 5px 0;">${p.title}</h4>
                                <p class="text-muted" style="font-size: 0.8rem; margin-bottom: 4px;"><i class="fa-solid fa-location-dot"></i> ${p.location}</p>
                                <div style="color: var(--color-primary); font-weight: 700; margin-bottom:8px;">LKR <fmt:formatNumber value="${p.price}" type="number"/></div>

                                    <%-- Price Alert --%>
                                <c:choose>
                                    <c:when test="${not empty p.alert_price}">
                                        <div style="background:#fffbeb;border:1px solid #fde68a;border-radius:8px;padding:8px 10px;margin-bottom:10px;font-size:0.8rem;color:#92400e;display:flex;justify-content:space-between;align-items:center;">
                                            <span><i class="fa-solid fa-bell" style="color:#f59e0b;"></i> Alert: LKR <fmt:formatNumber value="${p.alert_price}" type="number"/></span>
                                            <button type="button" onclick="document.getElementById('alert-form-${p.property_id}').style.display='block'; this.parentNode.style.display='none';" style="background:none;border:none;color:#f59e0b;font-size:0.75rem;cursor:pointer;font-weight:600;">Edit</button>
                                        </div>
                                    </c:when>
                                    <c:otherwise>
                                        <button type="button" onclick="document.getElementById('alert-form-${p.property_id}').style.display='block'; this.style.display='none';" style="background:none;border:1px dashed #fde68a;color:#92400e;padding:5px 10px;border-radius:6px;font-size:0.75rem;cursor:pointer;font-weight:600;width:100%;margin-bottom:8px;"><i class="fa-solid fa-bell"></i> Set Price Alert</button>
                                    </c:otherwise>
                                </c:choose>
                                <form id="alert-form-${p.property_id}" action="/buyer-dashboard/set-alert" method="POST" style="display:none;margin-bottom:10px;background:#fffbeb;padding:10px;border-radius:8px;border:1px solid #fde68a;">
                                    <input type="hidden" name="property_id" value="${p.property_id}">
                                    <label style="font-size:0.75rem;font-weight:600;color:#92400e;display:block;margin-bottom:4px;">Alert when price drops below (LKR):</label>
                                    <div style="display:flex;gap:6px;">
                                        <input type="number" name="alert_price" value="${p.alert_price}" placeholder="e.g. 5000000" style="flex:1;padding:6px 10px;border:1px solid #fde68a;border-radius:6px;font-size:0.8rem;">
                                        <button type="submit" style="background:#f59e0b;color:white;border:none;padding:6px 12px;border-radius:6px;font-size:0.8rem;cursor:pointer;font-weight:600;">Save</button>
                                    </div>
                                </form>

                                <div style="display:flex;gap:8px;">
                                    <a href="/property-detail?id=${p.property_id}" class="btn btn-outline btn-sm" style="flex:1;text-align:center;">View Details</a>
                                    <a href="/buyer-dashboard/remove-favourite?id=${p.property_id}" onclick="return confirm('Remove from saved?')" style="background:transparent;border:1px solid rgba(239,68,68,0.3);color:#ef4444;padding:6px 12px;border-radius:6px;font-size:0.8rem;text-decoration:none;display:flex;align-items:center;gap:4px;">
                                        <i class="fa-solid fa-heart-crack"></i> Remove
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                    <c:if test="${empty savedProperties}">
                        <div class="card text-center py-12" style="grid-column: 1 / -1;">
                            <i class="fa-solid fa-heart" style="font-size:2rem;color:#e2e8f0;display:block;margin-bottom:10px;"></i>
                            <p class="text-muted">You haven't saved any properties yet.</p>
                            <a href="/property/listing" class="btn btn-outline btn-sm" style="margin-top:10px;">Browse Properties</a>
                        </div>
                    </c:if>
                </div>
            </c:when>

            <c:when test="${param.section == 'reviews'}">
                <h2 class="mb-4">My Reviews</h2>

                <%-- Alert for success/error --%>
                <c:if test="${param.reviewSuccess == 'true'}">
                    <div class="alert-success"><i class="fa-solid fa-circle-check"></i> Review submitted successfully!</div>
                </c:if>

                <div class="card mb-4" style="background: var(--color-background); border: 1px solid #e2e8f0;">
                    <h3 class="mb-3">Write a Review</h3>
                    <form action="/submit-review" method="POST">
                        <input type="hidden" name="user_id" value="${sessionScope.userId}">
                        <input type="hidden" name="from_dashboard" value="true">
                        <div class="form-group">
                            <label>Select Property to Review</label>
                            <select name="target_property_id" class="form-control" required style="padding:10px;border:1px solid #e2e8f0;border-radius:8px;">
                                <option value="">-- Select a property --</option>
                                <c:forEach var="bp" items="${allProperties}">
                                    <option value="${bp.property_id}">${bp.title} — ${bp.location}</option>
                                </c:forEach>
                            </select>
                        </div>

                        <div class="form-group">
                            <label>Rating</label>
                            <div class="star-picker" style="display: flex; gap: 8px; font-size: 1.5rem; color: #cbd5e1; cursor: pointer;">
                                <i class="fa-solid fa-star star-opt" data-rating="1"></i>
                                <i class="fa-solid fa-star star-opt" data-rating="2"></i>
                                <i class="fa-solid fa-star star-opt" data-rating="3"></i>
                                <i class="fa-solid fa-star star-opt" data-rating="4"></i>
                                <i class="fa-solid fa-star star-opt" data-rating="5"></i>
                            </div>
                            <input type="hidden" name="rating" id="review_rating" value="0" required>
                        </div>

                        <div class="form-group" style="margin-top: 15px;">
                            <label>Your Review</label>
                            <textarea name="review_text" class="form-control" rows="3" placeholder="Share your experience..." required style="resize: vertical;"></textarea>
                        </div>

                        <button type="submit" class="btn btn-primary mt-3" id="submit-review-btn">Submit Review</button>
                    </form>
                </div>

                <div class="card">
                    <h3 class="mb-3">Past Reviews</h3>
                    <c:choose>
                        <c:when test="${empty reviews}">
                            <p class="text-muted text-center py-8">No reviews given yet.</p>
                        </c:when>
                        <c:otherwise>
                            <c:forEach var="r" items="${reviews}">
                                <div style="padding: 15px; border-bottom: 1px solid #f1f5f9; margin-bottom: 15px;">
                                    <div style="display: flex; justify-content: space-between; align-items: center;">
                                        <h4 style="margin: 0; color: var(--color-primary);">
                                            <i class="fa-solid fa-star text-yellow-400"></i> ${r.rating}/5
                                            <c:if test="${r.status == 'pending'}"><span style="font-size:0.7rem; background:#fef3c7; color:#d97706; padding:2px 8px; border-radius:12px; margin-left:8px; vertical-align:middle;">Pending</span></c:if>
                                            <c:if test="${r.status == 'approved'}"><span style="font-size:0.7rem; background:#d1fae5; color:#059669; padding:2px 8px; border-radius:12px; margin-left:8px; vertical-align:middle;">Approved</span></c:if>
                                        </h4>
                                        <span class="text-muted" style="font-size: 0.8rem; text-align: right;">
                                                <fmt:parseDate value="${r.created_at}" pattern="yyyy-MM-dd" var="rd" type="date"/>
                                                <fmt:formatDate value="${rd}" pattern="MMM dd, yyyy"/><br>
                                                <a href="#" onclick="toggleEditForm(${r.review_id}); return false;"
                                                   style="color:#3b82f6; text-decoration:none; margin-top:5px; margin-right:10px; display:inline-block;">
                                                   <i class="fa-solid fa-pen"></i> Edit
                                                </a>
                                                <a href="/buyer-dashboard/delete-review?id=${r.review_id}"
                                                   style="color:#dc2626; text-decoration:none; margin-top:5px; display:inline-block;"
                                                   onclick="return confirm('Delete this review?')">
                                                   <i class="fa-solid fa-trash"></i> Delete
                                                </a>
                                            </span>
                                    </div>
                                    <p style="margin: 10px 0; font-style: italic;">"${r.review_text}"</p>
                                    <p class="text-muted" style="font-size: 0.85rem;">
                                        Target: <strong>${not empty r.property_title ? r.property_title : r.agent_name}</strong>
                                    </p>

                                        <%-- Edit Form (Hidden by default) --%>
                                    <div id="edit-form-${r.review_id}" style="display: none; margin-top: 15px; padding: 15px; background: #f8fafc; border-radius: 8px;">
                                        <form action="/buyer-dashboard/update-review" method="POST">
                                            <input type="hidden" name="review_id" value="${r.review_id}">
                                            <div class="form-group" style="margin-bottom: 10px;">
                                                <label style="font-size: 0.85rem; font-weight: bold;">Update Rating (1-5)</label>
                                                <input type="number" name="rating" min="1" max="5" value="${r.rating}" class="form-control" style="padding: 8px; width: 100px;" required>
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
                        </c:otherwise>
                    </c:choose>
                </div>
            </c:when>
        </c:choose>
    </main>
</div>

<script>
    // Profile dropdown toggle
    function toggleProfilePanel() {
        var p = document.getElementById('profile-panel');
        p.style.display = p.style.display === 'none' ? 'block' : 'none';
    }
    document.addEventListener('click', function(e) {
        if (!e.target.closest('#profile-trigger') && !e.target.closest('#profile-panel')) {
            var p = document.getElementById('profile-panel');
            if (p) p.style.display = 'none';
        }
    });

    // Booking edit toggle
    function toggleBookingEdit(id) {
        var el = document.getElementById(id);
        if (el) el.style.display = el.style.display === 'none' ? 'block' : 'none';
    }

    function toggleEditForm(reviewId) {
        var form = document.getElementById('edit-form-' + reviewId);
        if (form.style.display === 'none') {
            form.style.display = 'block';
        } else {
            form.style.display = 'none';
        }
    }

    document.addEventListener('DOMContentLoaded', function() {
        const stars = document.querySelectorAll('.star-opt');
        const ratingInput = document.getElementById('review_rating');

        if (stars.length > 0) {
            stars.forEach(star => {
                star.addEventListener('click', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    ratingInput.value = rating;
                    stars.forEach(s => {
                        s.style.color = parseInt(s.getAttribute('data-rating')) <= rating ? '#eab308' : '#cbd5e1';
                    });
                });
                star.addEventListener('mouseenter', function() {
                    const rating = parseInt(this.getAttribute('data-rating'));
                    stars.forEach(s => {
                        if (parseInt(s.getAttribute('data-rating')) <= rating) s.style.color = '#fde047';
                    });
                });
                star.addEventListener('mouseleave', function() {
                    const currentRating = parseInt(ratingInput.value);
                    stars.forEach(s => {
                        s.style.color = parseInt(s.getAttribute('data-rating')) <= currentRating ? '#eab308' : '#cbd5e1';
                    });
                });
            });
        }
    });
</script>
</body>
</html>
