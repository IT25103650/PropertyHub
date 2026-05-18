<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Property | PropertyHub</title>
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
        .form-group { margin-bottom:0; }
        .form-group.full { grid-column:1/-1; }
        label { display:block; font-size:.85rem; font-weight:600; color:#94a3b8; margin-bottom:8px; }
        input, select, textarea {
            width:100%; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
            border-radius:10px; padding:11px 14px; color:#e2e8f0; font-size:.9rem;
            font-family:'Inter',sans-serif; transition:border-color .2s; }
        input:focus, select:focus, textarea:focus { outline:none; border-color:#f59e0b; }
        textarea { resize:vertical; min-height:100px; }
        select option { background:#1e293b; }
        .required { color:#f87171; margin-left:3px; }
        .btn-row { display:flex; gap:12px; margin-top:28px; }
        .btn { flex:1; padding:12px; border-radius:10px; font-size:.95rem; font-weight:600;
               cursor:pointer; border:none; text-align:center; text-decoration:none;
               display:flex; align-items:center; justify-content:center; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#f59e0b,#ef4444); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(245,158,11,.35); }
        .btn-secondary { background:rgba(255,255,255,.06); color:#94a3b8; text-decoration:none; }
        .alert-error { background:rgba(239,68,68,.12); border:1px solid rgba(239,68,68,.3);
                       color:#f87171; padding:12px 18px; border-radius:10px; margin-bottom:20px; }
        .section-divider { grid-column:1/-1; border-top:1px solid rgba(255,255,255,.08);
                           padding-top:16px; margin-top:4px; font-size:.78rem; font-weight:600;
                           color:#64748b; text-transform:uppercase; letter-spacing:.08em; }
    </style>
</head>
<body>
<div class="card">
    <div class="card-title">Create <span>Property Listing</span></div>
    <div class="card-sub">Component 03 — Property Management &nbsp;|&nbsp; Add a new property to the marketplace</div>

    <c:if test="${not empty errorMsg}">
        <div class="alert-error">✗ ${errorMsg}</div>
    </c:if>

    <form method="post" action="/properties/save">
        <div class="form-grid">
            <!-- Basic Info -->
            <div class="section-divider">Basic Information</div>

            <div class="form-group full">
                <label>Property Title <span class="required">*</span></label>
                <input type="text" name="title" required placeholder="e.g. Luxury 3-Bedroom Villa in Colombo 7" maxlength="150">
            </div>
            <div class="form-group">
                <label>Property Type <span class="required">*</span></label>
                <select name="propertyType" required>
                    <option value="">Select type…</option>
                    <option value="house">House</option>
                    <option value="apartment">Apartment</option>
                    <option value="land">Land</option>
                    <option value="commercial">Commercial</option>
                </select>
            </div>
            <div class="form-group">
                <label>Listing Type <span class="required">*</span></label>
                <select name="listingType" required>
                    <option value="">Select…</option>
                    <option value="sale">For Sale</option>
                    <option value="rent">For Rent</option>
                </select>
            </div>
            <div class="form-group full">
                <label>Description</label>
                <textarea name="description" placeholder="Describe the property features, condition, nearby amenities…"></textarea>
            </div>

            <!-- Location & Price -->
            <div class="section-divider">Location &amp; Pricing</div>

            <div class="form-group">
                <label>Location / City <span class="required">*</span></label>
                <input type="text" name="location" required placeholder="e.g. Colombo 7" maxlength="255">
            </div>
            <div class="form-group">
                <label>Full Address</label>
                <input type="text" name="address" placeholder="e.g. No. 12, Temple Road" maxlength="255">
            </div>
            <div class="form-group">
                <label>Price (LKR) <span class="required">*</span></label>
                <input type="number" name="price" required min="0" step="0.01" placeholder="e.g. 25000000">
            </div>
            <div class="form-group">
                <label>Status</label>
                <select name="status">
                    <option value="available">Available</option>
                    <option value="pending">Pending</option>
                    <option value="sold">Sold</option>
                    <option value="rented">Rented</option>
                </select>
            </div>

            <!-- Details -->
            <div class="section-divider">Property Details</div>

            <div class="form-group">
                <label>Bedrooms</label>
                <input type="number" name="bedrooms" min="0" max="99" placeholder="e.g. 3">
            </div>
            <div class="form-group">
                <label>Bathrooms</label>
                <input type="number" name="bathrooms" min="0" max="99" placeholder="e.g. 2">
            </div>
            <div class="form-group">
                <label>Size (sqft)</label>
                <input type="number" name="sqft" min="0" placeholder="e.g. 2400">
            </div>
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Create Listing</button>
            <a href="/properties" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
