<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>${not empty feedback.reviewId ? 'Edit Review' : 'Write a Review'} | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh;
               display:flex; align-items:center; justify-content:center; padding:40px 20px; }
        .card { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
                border-radius:20px; padding:40px; width:100%; max-width:560px; }
        .card-title { font-size:1.5rem; font-weight:700; margin-bottom:6px; }
        .card-title span { background:linear-gradient(135deg,#ec4899,#8b5cf6);
                           -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .card-sub { color:#64748b; font-size:.88rem; margin-bottom:24px; }
        .target-box { background:rgba(236,72,153,.08); border:1px solid rgba(236,72,153,.2);
                      border-radius:12px; padding:16px; margin-bottom:24px; }
        .target-box h3 { font-size:1rem; color:#fbcfe8; margin-bottom:4px; }
        .target-box p { font-size:.85rem; color:#94a3b8; }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:.85rem; font-weight:600; color:#94a3b8; margin-bottom:8px; }
        textarea { width:100%; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
                   border-radius:10px; padding:12px 16px; color:#e2e8f0; font-size:.9rem;
                   font-family:'Inter',sans-serif; transition:border-color .2s; resize:vertical; min-height:120px; }
        textarea:focus { outline:none; border-color:#ec4899; }
        .required { color:#f87171; margin-left:3px; }
        /* Star Rating Radio Buttons */
        .rating { display:flex; flex-direction:row-reverse; justify-content:flex-end; gap:8px; }
        .rating input { display:none; }
        .rating label { font-size:2rem; color:#334155; cursor:pointer; transition:color .2s; }
        .rating label:hover, .rating label:hover ~ label, .rating input:checked ~ label { color:#f59e0b; }

        .btn-row { display:flex; gap:12px; margin-top:28px; }
        .btn { flex:1; padding:12px; border-radius:10px; font-size:.95rem; font-weight:600;
               cursor:pointer; border:none; text-align:center; text-decoration:none;
               display:flex; align-items:center; justify-content:center; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#ec4899,#8b5cf6); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(236,72,153,.4); }
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
            <c:when test="${not empty feedback.reviewId}">Edit <span>Review</span></c:when>
            <c:otherwise>Write a <span>Review</span></c:otherwise>
        </c:choose>
    </div>
    <div class="card-sub">Component 06 — Share your property experience</div>

    <c:if test="${not empty errorMsg}">
        <div class="alert-error">✗ ${errorMsg}</div>
    </c:if>

    <c:if test="${not empty targetProperty}">
        <div class="target-box">
            <h3>🏠 ${targetProperty.title}</h3>
            <p>${targetProperty.location}</p>
            <c:if test="${not empty linkedBookingId}">
                <p style="margin-top:6px;font-size:.8rem;color:#fbcfe8;">Verified stay — auto-approval enabled.</p>
            </c:if>
        </div>
    </c:if>

    <c:set var="actionUrl" value="${not empty feedback.reviewId ? '/feedback/update/'.concat(feedback.reviewId) : '/feedback/save'}" />

    <form method="post" action="${actionUrl}">
        <c:if test="${empty feedback.reviewId && not empty targetProperty}">
            <input type="hidden" name="targetPropertyId" value="${targetProperty.property_id}">
        </c:if>
        <c:if test="${not empty linkedBookingId}">
            <input type="hidden" name="bookingId" value="${linkedBookingId}">
        </c:if>

        <div class="form-group">
            <label>Rating <span class="required">*</span></label>
            <div class="rating">
                <input type="radio" id="star5" name="rating" value="5" ${feedback.rating == 5 ? 'checked' : ''} required><label for="star5">★</label>
                <input type="radio" id="star4" name="rating" value="4" ${feedback.rating == 4 ? 'checked' : ''}><label for="star4">★</label>
                <input type="radio" id="star3" name="rating" value="3" ${feedback.rating == 3 ? 'checked' : ''}><label for="star3">★</label>
                <input type="radio" id="star2" name="rating" value="2" ${feedback.rating == 2 ? 'checked' : ''}><label for="star2">★</label>
                <input type="radio" id="star1" name="rating" value="1" ${feedback.rating == 1 ? 'checked' : ''}><label for="star1">★</label>
            </div>
        </div>

        <div class="form-group">
            <label>Review Comment <span class="required">*</span></label>
            <textarea name="reviewText" required placeholder="Tell us about your experience..." minlength="10">${feedback.reviewText}</textarea>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">
                ${not empty feedback.reviewId ? 'Save Changes' : 'Submit Review'}
            </button>
            <a href="javascript:history.back()" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
