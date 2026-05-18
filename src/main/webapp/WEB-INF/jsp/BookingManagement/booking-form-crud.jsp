<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${not empty booking.bookingId ? 'Edit Booking' : 'Create Booking'} | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh;
               display:flex; align-items:center; justify-content:center; padding:40px 20px; }
        .card { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
                border-radius:20px; padding:40px; width:100%; max-width:560px; }
        .card-title { font-size:1.5rem; font-weight:700; margin-bottom:6px; }
        .card-title span { background:linear-gradient(135deg,#8b5cf6,#6366f1);
                           -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .card-sub { color:#64748b; font-size:.88rem; margin-bottom:24px; }
        .prop-preview { background:rgba(139,92,246,.08); border:1px solid rgba(139,92,246,.2);
                        border-radius:12px; padding:16px; margin-bottom:24px; }
        .prop-preview h3 { font-size:1rem; color:#a5b4fc; margin-bottom:4px; }
        .prop-preview p { font-size:.85rem; color:#94a3b8; }
        .form-group { margin-bottom:20px; }
        .form-row { display:grid; grid-template-columns:1fr 1fr; gap:16px; }
        label { display:block; font-size:.85rem; font-weight:600; color:#94a3b8; margin-bottom:8px; }
        input, textarea { width:100%; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
                          border-radius:10px; padding:12px 16px; color:#e2e8f0; font-size:.9rem;
                          font-family:'Inter',sans-serif; transition:border-color .2s; }
        input[type="date"]::-webkit-calendar-picker-indicator,
        input[type="time"]::-webkit-calendar-picker-indicator { filter: invert(1); cursor:pointer; }
        input:focus, textarea:focus { outline:none; border-color:#8b5cf6; }
        textarea { resize:vertical; min-height:100px; }
        .required { color:#f87171; margin-left:3px; }
        .btn-row { display:flex; gap:12px; margin-top:28px; }
        .btn { flex:1; padding:12px; border-radius:10px; font-size:.95rem; font-weight:600;
               cursor:pointer; border:none; text-align:center; text-decoration:none;
               display:flex; align-items:center; justify-content:center; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#8b5cf6,#6366f1); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(139,92,246,.4); }
        .btn-secondary { background:rgba(255,255,255,.06); color:#94a3b8; }
        .btn-secondary:hover { background:rgba(255,255,255,.1); }
        .alert-error { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);
                       color:#f87171; padding:12px 18px; border-radius:10px; margin-bottom:20px; }
    </style>
</head>
<body>
<div class="card">
    <div class="card-title">
        <c:choose>
            <c:when test="${not empty booking.bookingId}">Edit <span>Booking</span></c:when>
            <c:otherwise>Book <span>Viewing Appointment</span></c:otherwise>
        </c:choose>
    </div>
    <div class="card-sub">Component 04 — Booking &amp; Viewing Management</div>

    <c:if test="${not empty errorMsg}">
        <div class="alert-error">✗ ${errorMsg}</div>
    </c:if>

    <c:if test="${not empty prop}">
        <div class="prop-preview">
            <h3>🏠 ${prop.title}</h3>
            <p>${prop.location} &nbsp;|&nbsp; LKR ${prop.price}</p>
            <p style="margin-top:6px;font-size:.8rem;">
                Seller: ${prop.seller_first_name} ${prop.seller_last_name}
            </p>
        </div>
    </c:if>

    <c:set var="actionUrl" value="${not empty booking.bookingId ? '/bookings/update/'.concat(booking.bookingId) : '/bookings/save'}" />

    <form method="post" action="${actionUrl}">
        <c:if test="${empty booking.bookingId}">
            <input type="hidden" name="propertyId" value="${prop.property_id}">
        </c:if>

        <div class="form-row">
            <div class="form-group">
                <label>Preferred Date <span class="required">*</span></label>
                <input type="date" name="bookingDate" required value="${booking.bookingDate}">
            </div>
            <div class="form-group">
                <label>Preferred Time <span class="required">*</span></label>
                <input type="time" name="bookingTime" required value="${booking.bookingTime}">
            </div>
        </div>

        <div class="form-group">
            <label>Additional Notes</label>
            <textarea name="notes" placeholder="Any specific questions or requests for the seller?">${booking.notes}</textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">
                ${not empty booking.bookingId ? 'Save Changes' : 'Confirm Booking'}
            </button>
            <a href="javascript:history.back()" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
