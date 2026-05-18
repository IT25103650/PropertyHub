<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Property | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh;
               display:flex; align-items:flex-start; justify-content:center; padding:40px 20px; }
        .card { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
                border-radius:20px; padding:40px; width:100%; max-width:680px; }
        .card-title { font-size:1.5rem; font-weight:700; margin-bottom:6px; }
        .card-title span { background:linear-gradient(135deg,#f59e0b,#ef4444);
                           -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .card-sub { color:#64748b; font-size:.88rem; margin-bottom:32px; }
        .form-grid { display:grid; grid-template-columns:1fr 1fr; gap:20px; }
        .form-group { }
        .form-group.full { grid-column:1/-1; }
        label { display:block; font-size:.85rem; font-weight:600; color:#94a3b8; margin-bottom:8px; }
        input, select, textarea {
            width:100%; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
            border-radius:10px; padding:11px 14px; color:#e2e8f0; font-size:.9rem;
            font-family:'Inter',sans-serif; transition:border-color .2s; }
        input:focus, select:focus, textarea:focus { outline:none; border-color:#f59e0b; }
        textarea { resize:vertical; min-height:90px; }
        select option { background:#1e293b; }
        .required { color:#f87171; }
        .btn-row { display:flex; gap:12px; margin-top:28px; }
        .btn { flex:1; padding:12px; border-radius:10px; font-size:.95rem; font-weight:600;
               cursor:pointer; border:none; text-align:center; text-decoration:none;
               display:flex; align-items:center; justify-content:center; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#f59e0b,#ef4444); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); }
        .btn-secondary { background:rgba(255,255,255,.06); color:#94a3b8; text-decoration:none; }
        .section-divider { grid-column:1/-1; border-top:1px solid rgba(255,255,255,.08);
                           padding-top:16px; margin-top:4px; font-size:.78rem; font-weight:600;
                           color:#64748b; text-transform:uppercase; letter-spacing:.08em; }
        .images-section { grid-column:1/-1; }
        .img-thumb { display:inline-block; margin:6px; position:relative; }
        .img-thumb img { width:80px; height:60px; object-fit:cover; border-radius:8px;
                         border:2px solid rgba(255,255,255,.1); }
        .img-thumb .primary-badge { position:absolute; top:2px; left:2px; background:#f59e0b;
                                    color:#000; font-size:.6rem; padding:1px 5px; border-radius:4px; }
    </style>
</head>
<body>
<div class="card">
    <div class="card-title">Edit <span>Property Listing</span></div>
    <div class="card-sub">
        Editing: <strong>${property.title}</strong> — ID #${property.propertyId}
    </div>

    <form method="post" action="/properties/update/${property.propertyId}">
        <div class="form-grid">
            <div class="section-divider">Basic Information</div>

            <div class="form-group full">
                <label>Property Title <span class="required">*</span></label>
                <input type="text" name="title" required value="${property.title}" maxlength="150">
            </div>
            <div class="form-group">
                <label>Property Type <span class="required">*</span></label>
                <select name="propertyType" required>
                    <option value="house"      ${property.propertyType=='house'?'selected':''}>House</option>
                    <option value="apartment"  ${property.propertyType=='apartment'?'selected':''}>Apartment</option>
                    <option value="land"       ${property.propertyType=='land'?'selected':''}>Land</option>
                    <option value="commercial" ${property.propertyType=='commercial'?'selected':''}>Commercial</option>
                </select>
            </div>
            <div class="form-group">
                <label>Listing Type <span class="required">*</span></label>
                <select name="listingType" required>
                    <option value="sale" ${property.listingType=='sale'?'selected':''}>For Sale</option>
                    <option value="rent" ${property.listingType=='rent'?'selected':''}>For Rent</option>
                </select>
            </div>
            <div class="form-group full">
                <label>Description</label>
                <textarea name="description">${property.description}</textarea>
            </div>

            <div class="section-divider">Location &amp; Pricing</div>

            <div class="form-group">
                <label>Location <span class="required">*</span></label>
                <input type="text" name="location" required value="${property.location}">
            </div>
            <div class="form-group">
                <label>Full Address</label>
                <input type="text" name="address" value="${property.address}">
            </div>
            <div class="form-group">
                <label>Price (LKR) <span class="required">*</span></label>
                <input type="number" name="price" required min="0" step="0.01" value="${property.price}">
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="available" ${property.status=='available'?'selected':''}>Available</option>
                    <option value="pending"   ${property.status=='pending'?'selected':''}>Pending</option>
                    <option value="sold"      ${property.status=='sold'?'selected':''}>Sold</option>
                    <option value="rented"    ${property.status=='rented'?'selected':''}>Rented</option>
                </select>
            </div>

            <div class="section-divider">Property Details</div>

            <div class="form-group">
                <label>Bedrooms</label>
                <input type="number" name="bedrooms" min="0" value="${property.bedrooms}">
            </div>
            <div class="form-group">
                <label>Bathrooms</label>
                <input type="number" name="bathrooms" min="0" value="${property.bathrooms}">
            </div>
            <div class="form-group">
                <label>Size (sqft)</label>
                <input type="number" name="sqft" min="0" value="${property.sqft}">
            </div>

            <!-- Current Images -->
            <c:if test="${not empty images}">
                <div class="images-section">
                    <label style="margin-bottom:8px;display:block;">Current Images</label>
                    <c:forEach var="img" items="${images}">
                        <div class="img-thumb">
                            <img src="${img.image_url}" alt="">
                            <c:if test="${img.is_primary}">
                                <span class="primary-badge">★ Primary</span>
                            </c:if>
                        </div>
                    </c:forEach>
                    <p style="font-size:.78rem;color:#64748b;margin-top:8px;">
                        To manage images, use the seller/admin dashboard image manager.
                    </p>
                </div>
            </c:if>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="/properties/${property.propertyId}" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
