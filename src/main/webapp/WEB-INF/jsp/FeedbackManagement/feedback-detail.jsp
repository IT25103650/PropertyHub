<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Review Details | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh;
               display:flex; align-items:center; justify-content:center; padding:40px 20px; }
        .card { background:rgba(255,255,255,.04); border:1px solid rgba(255,255,255,.08);
                border-radius:24px; width:100%; max-width:700px; overflow:hidden; }
        .card-header { background:linear-gradient(135deg,#ec4899,#8b5cf6); padding:32px 40px; color:#fff; }
        .header-top { display:flex; justify-content:space-between; align-items:flex-start; margin-bottom:16px; }
        .header-title { font-size:1.6rem; font-weight:700; }
        .badge { display:inline-block; padding:6px 14px; border-radius:20px; font-size:.8rem; font-weight:700;
                 text-transform:uppercase; letter-spacing:.05em; background:rgba(0,0,0,.2); }
        .stars-large { font-size:2rem; color:#fcd34d; letter-spacing:2px; margin-top:8px; }
        .card-body { padding:40px; }
        .grid-2 { display:grid; grid-template-columns:1fr 1fr; gap:32px; margin-bottom:32px; }
        .info-group h3 { font-size:.8rem; color:#64748b; text-transform:uppercase; letter-spacing:.06em;
                         margin-bottom:12px; font-weight:600; }
        .detail-row { margin-bottom:12px; }
        .detail-label { display:block; font-size:.75rem; color:#94a3b8; margin-bottom:2px; }
        .detail-value { font-size:.95rem; font-weight:500; color:#e2e8f0; }
        .review-box { background:rgba(255,255,255,.03); border:1px solid rgba(255,255,255,.06);
                      border-radius:12px; padding:24px; margin-bottom:32px; position:relative; }
        .quote-mark { position:absolute; top:10px; left:16px; font-size:4rem; color:rgba(255,255,255,.05);
                      font-family:serif; line-height:1; }
        .review-box p { font-size:1.05rem; color:#cbd5e1; line-height:1.7; position:relative; z-index:1; }
        .action-bar { display:flex; gap:12px; border-top:1px solid rgba(255,255,255,.08); padding-top:24px; }
        .btn { display:inline-flex; align-items:center; justify-content:center; padding:10px 20px;
               border-radius:10px; font-size:.9rem; font-weight:600; cursor:pointer; text-decoration:none;
               border:none; transition:all .2s; }
        .btn-success { background:rgba(34,197,94,.15); color:#4ade80; border:1px solid rgba(34,197,94,.3); }
        .btn-warning { background:rgba(234,179,8,.15); color:#fbbf24; border:1px solid rgba(234,179,8,.3); }
        .btn-danger  { background:rgba(239,68,68,.15); color:#f87171; border:1px solid rgba(239,68,68,.3); }
        .btn-secondary{ background:rgba(255,255,255,.06); color:#94a3b8; }
        .btn-primary { background:linear-gradient(135deg,#ec4899,#8b5cf6); color:#fff; }
    </style>
</head>
<body>
<div class="card">
    <div class="card-header">
        <div class="header-top">
            <div>
                <div class="header-title">Review Details</div>
                <div style="font-size:.9rem;color:rgba(255,255,255,.8);">Review ID #${feedback.reviewId}</div>
            </div>
            <div class="badge">${feedback.status}</div>
        </div>
        <div class="stars-large">
            <c:forEach begin="1" end="${feedback.rating}" var="i">★</c:forEach><c:forEach begin="${feedback.rating + 1}" end="5" var="i">☆</c:forEach>
        </div>
    </div>

    <div class="card-body">
        <div class="grid-2">
            <!-- Reviewer -->
            <div class="info-group">
                <h3>Author</h3>
                <div class="detail-row">
                    <span class="detail-label">Name</span>
                    <span class="detail-value">${reviewer.first_name} ${reviewer.last_name}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Email</span>
                    <span class="detail-value">${reviewer.email}</span>
                </div>
                <div class="detail-row">
                    <span class="detail-label">Submitted On</span>
                    <span class="detail-value">${feedback.createdAt}</span>
                </div>
            </div>

            <!-- Context -->
            <div class="info-group">
                <h3>Context</h3>
                <div class="detail-row">
                    <span class="detail-label">Target Property</span>
                    <span class="detail-value">
                        <c:choose>
                            <c:when test="${not empty property}">
                                <a href="/properties/${property.property_id}" style="color:#ec4899;">${property.title}</a>
                            </c:when>
                            <c:otherwise><span style="color:#64748b;">Not linked to property</span></c:otherwise>
                        </c:choose>
                    </span>
                </div>
                <c:if test="${not empty property}">
                    <div class="detail-row">
                        <span class="detail-label">Location</span>
                        <span class="detail-value">${property.location}</span>
                    </div>
                </c:if>
            </div>
        </div>

        <div class="review-box">
            <div class="quote-mark">"</div>
            <p>${feedback.reviewText}</p>
        </div>

        <div class="action-bar">
            <a href="javascript:history.back()" class="btn btn-secondary">← Back</a>

            <c:if test="${sessionScope.userRole == 'admin' || sessionScope.userRole == 'both'}">
                <c:if test="${feedback.status == 'pending'}">
                    <a href="/feedback/approve/${feedback.reviewId}" class="btn btn-success">Approve</a>
                    <a href="/feedback/reject/${feedback.reviewId}" class="btn btn-warning">Reject</a>
                </c:if>
                <a href="/feedback/delete/${feedback.reviewId}" class="btn btn-danger"
                   onclick="return confirm('Permanently delete this review?')">Delete Review</a>
            </c:if>

            <c:if test="${sessionScope.userId == feedback.reviewerId}">
                <a href="/feedback/edit/${feedback.reviewId}" class="btn btn-primary">Edit Review</a>
                <a href="/feedback/delete/${feedback.reviewId}" class="btn btn-danger"
                   onclick="return confirm('Delete your review?')">Delete</a>
            </c:if>
        </div>
    </div>
</div>
</body>
</html>
