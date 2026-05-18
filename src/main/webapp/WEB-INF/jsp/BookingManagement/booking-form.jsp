<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt"  prefix="fmt" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book a Viewing | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <style>
        body { background: #f1f5f9; font-family: 'Outfit', sans-serif; padding-top: 68px; }
        .navbar { position: fixed; top: 0; width: 100%; z-index: 100; background: #0f172a; padding: 0 5%; height: 68px; display: flex; align-items: center; justify-content: space-between; box-shadow: 0 2px 16px rgba(0,0,0,0.25); }
        .navbar .logo { color: white; font-size: 1.4rem; font-weight: 700; text-decoration: none; }
        .navbar .logo span { color: #10b981; }
        .page-wrapper { max-width: 880px; margin: 0 auto; padding: 40px 24px; }
        .breadcrumb { color: #64748b; font-size: 0.85rem; margin-bottom: 24px; }
        .breadcrumb a { color: #10b981; text-decoration: none; }
        .page-title { font-size: 2rem; font-weight: 700; color: #0f172a; margin-bottom: 8px; }
        .page-sub { color: #64748b; margin-bottom: 32px; }
        .booking-grid { display: grid; grid-template-columns: 1fr 380px; gap: 28px; }
        @media (max-width: 768px) { .booking-grid { grid-template-columns: 1fr; } }
        .card { background: white; border-radius: 20px; padding: 32px; box-shadow: 0 1px 8px rgba(0,0,0,0.06); border: 1px solid #f1f5f9; }
        .card h3 { font-size: 1.1rem; font-weight: 700; margin-bottom: 20px; color: #0f172a; }
        .form-group { margin-bottom: 18px; }
        .form-group label { display: block; font-size: 0.85rem; font-weight: 600; color: #475569; margin-bottom: 6px; }
        .form-group input, .form-group select, .form-group textarea {
            width: 100%; padding: 11px 14px; border: 1.5px solid #e2e8f0; border-radius: 12px;
            font-family: 'Outfit', sans-serif; font-size: 0.9rem; color: #334155;
            outline: none; transition: border-color 0.2s; background: #f8fafc;
        }
        .form-group input:focus, .form-group select:focus, .form-group textarea:focus {
            border-color: #10b981; background: white; box-shadow: 0 0 0 3px rgba(16,185,129,0.08);
        }
        .view-type-grid { display: grid; grid-template-columns: 1fr 1fr; gap: 12px; margin-bottom: 20px; }
        .view-type-btn { border: 2px solid #e2e8f0; border-radius: 14px; padding: 18px 12px; text-align: center; cursor: pointer; transition: all 0.2s; background: white; }
        .view-type-btn.selected { border-color: #10b981; background: rgba(16,185,129,0.05); }
        .view-type-btn i { font-size: 1.6rem; color: #10b981; display: block; margin-bottom: 8px; }
        .view-type-btn span { font-weight: 600; font-size: 0.9rem; color: #334155; }
        .btn-submit { width: 100%; padding: 14px; background: linear-gradient(135deg, #10b981, #059669); color: white; border: none; border-radius: 14px; font-family: 'Outfit', sans-serif; font-size: 1rem; font-weight: 700; cursor: pointer; transition: all 0.2s; margin-top: 8px; }
        .btn-submit:hover { transform: translateY(-1px); box-shadow: 0 8px 24px rgba(16,185,129,0.3); }
        .property-summary { position: sticky; top: 88px; }
        .prop-img { width: 100%; height: 200px; object-fit: cover; border-radius: 14px; margin-bottom: 18px; }
        .prop-name { font-size: 1.05rem; font-weight: 700; color: #0f172a; margin-bottom: 6px; }
        .prop-loc { color: #64748b; font-size: 0.88rem; margin-bottom: 12px; }
        .prop-price { font-size: 1.3rem; font-weight: 700; color: #10b981; margin-bottom: 14px; }
        .prop-feat { display: flex; gap: 14px; flex-wrap: wrap; font-size: 0.82rem; color: #64748b; }
        .prop-feat span { display: flex; align-items: center; gap: 5px; }
        .alert-success { background: rgba(16,185,129,0.08); border: 1px solid rgba(16,185,129,0.25); color: #065f46; padding: 14px 18px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 500; }
        .alert-danger  { background: rgba(239,68,68,0.08); border: 1px solid rgba(239,68,68,0.25);  color: #991b1b; padding: 14px 18px; border-radius: 12px; margin-bottom: 20px; display: flex; align-items: center; gap: 10px; font-weight: 500; }
    </style>
</head>
<body>
<header class="navbar">
    <a href="/" class="logo"><i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span></a>
    <div style="display:flex;gap:12px;align-items:center;">
        <c:if test="${not empty sessionScope.userId}">
            <a href="/buyer-dashboard" style="color:#cbd5e1;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-user"></i> Dashboard</a>
            <a href="/logout" style="color:#f87171;text-decoration:none;font-size:0.9rem;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
        </c:if>
        <c:if test="${empty sessionScope.userId}">
            <a href="/login" style="color:#cbd5e1;text-decoration:none;font-size:0.9rem;">Log In</a>
        </c:if>
    </div>
</header>

<div class="page-wrapper">
    <div class="breadcrumb">
        <a href="/">Home</a> &rsaquo; <a href="/property/listing">Properties</a>
        <c:if test="${not empty prop}"> &rsaquo; <a href="/property-detail?id=${prop.property_id}">${prop.title}</a></c:if>
        &rsaquo; Book a Viewing
    </div>

    <h1 class="page-title"><i class="fa-solid fa-calendar-check" style="color:#10b981;"></i> Book a Viewing</h1>
    <p class="page-sub">Schedule a physical viewing appointment for this property.</p>

    <c:if test="${param.success == 'true'}">
        <div class="alert-success"><i class="fa-solid fa-circle-check"></i> Your viewing request has been submitted! The seller will confirm shortly.</div>
    </c:if>
    <c:if test="${param.error == 'true'}">
        <div class="alert-danger"><i class="fa-solid fa-circle-xmark"></i> Something went wrong. Please try again or contact us.</div>
    </c:if>
    <c:if test="${param.error == 'missing_booking_info'}">
        <div class="alert-danger"><i class="fa-solid fa-circle-exclamation"></i> Please select both a date and time.</div>
    </c:if>
    <c:if test="${param.login == 'required'}">
        <div class="alert-danger"><i class="fa-solid fa-lock"></i> You need to <a href="/login?redirect=/book?propertyId=${param.propertyId}" style="color:#10b981;font-weight:600;">log in</a> to book a viewing.</div>
    </c:if>

    <div class="booking-grid">
        <div class="card">
            <h3><i class="fa-solid fa-calendar-plus" style="color:#10b981;margin-right:8px;"></i>Viewing Details</h3>

            <form action="/book-appointment" method="POST" id="booking-form-page" onsubmit="var b=this.querySelector('.btn-submit'); b.innerHTML='<i class=\'fa-solid fa-spinner fa-spin\'></i> Requesting...'; b.style.opacity='0.8';">
                <input type="hidden" name="property_id" value="${not empty param.propertyId ? param.propertyId : prop.property_id}">

                <input type="hidden" name="viewing_type" value="physical">
                <div style="background:rgba(16,185,129,0.06);border:1.5px solid rgba(16,185,129,0.2);border-radius:12px;padding:14px 18px;margin-bottom:18px;display:flex;align-items:center;gap:10px;">
                    <i class="fa-solid fa-person-walking" style="font-size:1.3rem;color:#10b981;"></i>
                    <div>
                        <div style="font-weight:700;font-size:0.9rem;color:#334155;">Physical Viewing</div>
                        <div style="font-size:0.78rem;color:#64748b;">Visit the property in person with the seller</div>
                    </div>
                </div>

                <div class="form-group">
                    <label for="booking_date">Preferred Date</label>
                    <input type="date" id="booking_date" name="booking_date" required
                           min="${pageContext.session.attribute != null ? '' : ''}"
                           style="">
                </div>

                <div class="form-group">
                    <label for="booking_time">Preferred Time</label>
                    <select id="booking_time" name="booking_time" required>
                        <option value="">-- Select a time --</option>
                        <option value="09:00:00">9:00 AM</option>
                        <option value="10:00:00">10:00 AM</option>
                        <option value="11:00:00">11:00 AM</option>
                        <option value="12:00:00">12:00 PM</option>
                        <option value="13:00:00">1:00 PM</option>
                        <option value="14:00:00">2:00 PM</option>
                        <option value="15:00:00">3:00 PM</option>
                        <option value="16:00:00">4:00 PM</option>
                        <option value="17:00:00">5:00 PM</option>
                    </select>
                </div>

                <div class="form-group">
                    <label for="notes">Additional Notes <span style="color:#94a3b8;font-weight:400;">(optional)</span></label>
                    <textarea id="notes" name="notes" rows="3" placeholder="Any special requests or questions for the seller..."></textarea>
                </div>

                <button type="submit" class="btn-submit"><i class="fa-solid fa-calendar-check"></i> Confirm Booking Request</button>
            </form>
        </div>

        <div class="property-summary">
            <c:if test="${not empty prop}">
                <div class="card">
                    <img class="prop-img"
                         src="${not empty primaryImg ? primaryImg : 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=600&auto=format&fit=crop'}"
                         alt="${prop.title}">
                    <div class="prop-name">${prop.title}</div>
                    <div class="prop-loc"><i class="fa-solid fa-location-dot" style="color:#10b981;"></i> ${prop.location}</div>
                    <div class="prop-price">${priceStr}</div>
                    <div class="prop-feat">
                        <c:if test="${not empty prop.bedrooms}"><span><i class="fa-solid fa-bed"></i> ${prop.bedrooms} Beds</span></c:if>
                        <c:if test="${not empty prop.bathrooms}"><span><i class="fa-solid fa-bath"></i> ${prop.bathrooms} Baths</span></c:if>
                        <c:if test="${not empty prop.sqft}"><span><i class="fa-solid fa-vector-square"></i> ${prop.sqft} sqft</span></c:if>
                    </div>
                    <a href="/property-detail?id=${prop.property_id}" style="display:block;margin-top:18px;color:#10b981;font-weight:600;text-decoration:none;font-size:0.88rem;"><i class="fa-solid fa-arrow-left"></i> Back to Property</a>
                </div>
            </c:if>
            <c:if test="${empty prop}">
                <div class="card">
                    <p style="color:#64748b;text-align:center;"><i class="fa-solid fa-house-circle-exclamation" style="font-size:2rem;color:#10b981;display:block;margin-bottom:10px;"></i>Property details not available.</p>
                    <a href="/property/listing" style="display:block;margin-top:12px;color:#10b981;font-weight:600;text-decoration:none;font-size:0.88rem;"><i class="fa-solid fa-arrow-left"></i> Browse Properties</a>
                </div>
            </c:if>
        </div>
    </div>
</div>

<script>
// Set min date to today
document.getElementById('booking_date').min = new Date().toISOString().split('T')[0];
</script>
</body>
</html>
