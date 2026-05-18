<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Booking #${booking.bookingId} | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh;
               display:flex; align-items:center; justify-content:center; padding:40px 20px; }
        .card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                border-radius:24px; width:100%; max-width:700px; overflow:hidden; }
        .card-header { background:linear-gradient(135deg,#8b5cf6,#6366f1); padding:32px 40px; color:#fff; }
        .header-top { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:16px; }
        .header-title { font-size:1.8rem; font-weight:700; }
        .header-sub { font-size:.9rem; color:rgba(255,255,255,.8); }
        .badge { display:inline-block; padding:6px 14px; border-radius:20px; font-size:.8rem; font-weight:700;
                 text-transform:uppercase; letter-spacing:.05em; background:rgba(0,0,0,.2); }
        .card-body { padding:40px; }
        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:32px; margin-bottom:32px; }
        .info-group h3 { font-size:.8rem; color:#64748b; text-transform:uppercase; letter-spacing:.06em;
                         margin-bottom:12px; font-weight:600; }
        .detail-row { margin-bottom:12px; }
        .detail-label { display:block; font-size:.75rem; color:#94a3b8; margin-bottom:2px; }
        .detail-value { font-size:.95rem; font-weight:500; color:#e2e8f0; }
        .notes-box { background:rgba(255,255,255,.03); border:1px solid rgba(255,255,255,.06);
                     border-radius:12px; padding:16px; margin-bottom:32px; }
        .notes-box h4 { font-size:.85rem; color:#8b5cf6; margin-bottom:8px; }
        .notes-box p { font-size:.9rem; color:#cbd5e1; line-height:1.6; }
        .action-bar { display:flex; gap:12px; border-top:1px solid rgba(255,255,255,.08); padding-top:24px; }
        .btn { display:inline-flex; align-items:center; justify-content:center; padding:10px 20px;
               border-radius:10px; font-size:.9rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#8b5cf6,#6366f1); color:#fff; }
        .btn-success { background:rgba(34,197,94,.15); color:#4ade80; border:1px solid rgba(34,197,94,.3); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-secondary{ background:rgba(255,255,255,.06); color:#94a3b8; }
        .alert { padding:12px 18px; border-radius:10px; margin-bottom:20px; font-size:.9rem; }
        .alert-success { background:rgba(34,197,94,.12); border:1px solid rgba(34,197,94,.3); color:#4ade80; }
    </style>
</head>
<body>
<div class="card">
    <div class="card-header">
        <div class="header-top">
            <div>
                <div class="header-title">Viewing Appointment</div>
                <div class="header-sub">Booking ID #${booking.bookingId}</div>
            </div>
            <div class="badge">${booking.status}</div>
        </div>
        <div style="font-size:1.1rem;font-weight:500;">
            📅 ${booking.bookingDate} at 🕒 ${booking.bookingTime}
        </div>
    </div>

    <div class="card-body">
        <c:if test="${not empty successMsg}">
            <div class="alert alert-success">✓ ${successMsg}</div>
        </c:if>

        <div class="grid-2">
            <!-- Property & Seller -->
            <div class="info-group">
                <h3>Property Information</h3>
                <div class="detail-row">
                    <span class="detail-label">Title</span>
                    <span class="detail-value"><a href="/properties/${booking.propertyId}" style="color:#8b5cf6;">${property.title}</a></span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Location</span>
                    <span class="detail-value">${property.location}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Price</span>
                    <span class="detail-value">LKR ${property.price}</span>
                </div>
                <div style="margin-top:20px;"></div>
                <h3>Seller Contact</h3>
                <div class="detail-row">
                    <span class="detail-label">Name</span>
                    <span class="detail-value">${property.seller_first_name} ${property.seller_last_name}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email</span>
                    <span class="detail-value">${property.seller_email}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone</span>
                    <span class="detail-value">${not empty property.seller_phone ? property.seller_phone : '—'}</span>
                </div>
            </div>

            <!-- Buyer Details -->
            <div class="info-group">
                <h3>Buyer Details</h3>
                <div class="detail-row">
                    <span class="detail-label">Name</span>
                    <span class="detail-value">${buyer.first_name} ${buyer.last_name}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email</span>
                    <span class="detail-value">${buyer.email}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Phone</span>
                    <span class="detail-value">${not empty buyer.phone ? buyer.phone : '—'}</span>
                </div>
                <div style="margin-top:20px;"></div>
                <h3>Booking Meta</h3>
                <div class="detail-row">
                    <span class="detail-label">Type</span>
                    <span class="detail-value" style="text-transform:capitalize;">${booking.viewingType}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Requested On</span>
                    <span class="detail-value">${booking.createdAt}</span>
                </div>
            </div>
        </div>

        <c:if test="${not empty booking.notes}">
            <div class="notes-box">
                <h4>📝 Buyer Notes</h4>
                <p>${booking.notes}</p>
            </div>
        </c:if>

        <div class="action-bar">
            <a href="javascript:history.back()" class="btn btn-secondary">← Back</a>

            <c:if test="${sessionScope.userRole == 'admin' || sessionScope.userRole == 'seller' || sessionScope.userRole == 'both'}">
                <c:if test="${booking.status == 'pending'}">
                    <a href="/bookings/approve/${booking.bookingId}" class="btn btn-success">Approve</a>
                    <a href="/bookings/reject/${booking.bookingId}" class="btn btn-danger">Reject</a>
                </c:if>
                <c:if test="${booking.status == 'confirmed'}">
                    <a href="/bookings/complete/${booking.bookingId}" class="btn btn-primary">Mark Completed</a>
                </c:if>
            </c:if>

            <c:if test="${sessionScope.userRole == 'buyer' || sessionScope.userRole == 'both' || sessionScope.userRole == 'admin'}">
                <c:if test="${booking.status == 'pending'}">
                    <a href="/bookings/edit/${booking.bookingId}" class="btn btn-warning">Edit Time</a>
                </c:if>
                <c:if test="${booking.status == 'pending' || booking.status == 'confirmed'}">
                    <a href="/bookings/cancel/${booking.bookingId}"
                       class="btn btn-danger" onclick="return confirm('Cancel this appointment?')">Cancel Booking</a>
                </c:if>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
