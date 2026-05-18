<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib prefix="c" uri="jakarta.tags.core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Edit Admin | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <style>
        * { margin:0; padding:0; box-sizing:border-box; }
        body { font-family:'Inter',sans-serif; background:#0f172a; color:#e2e8f0; min-height:100vh;
               display:flex; align-items:center; justify-content:center; padding:40px 20px; }
        .card { background:rgba(255,255,255,.05); border:1px solid rgba(255,255,255,.1);
                border-radius:20px; padding:40px; width:100%; max-width:560px; }
        .card-title { font-size:1.5rem; font-weight:700; margin-bottom:6px; }
        .card-title span { background:linear-gradient(135deg,#ef4444,#f97316);
                           -webkit-background-clip:text; -webkit-text-fill-color:transparent; }
        .card-sub { color:#64748b; font-size:.88rem; margin-bottom:32px; }
        .form-group { margin-bottom:20px; }
        label { display:block; font-size:.85rem; font-weight:600; color:#94a3b8; margin-bottom:8px; }
        input { width:100%; background:rgba(255,255,255,.06); border:1px solid rgba(255,255,255,.1);
                border-radius:10px; padding:12px 16px; color:#e2e8f0; font-size:.9rem;
                font-family:'Inter',sans-serif; transition:border-color .2s; }
        input:focus { outline:none; border-color:#ef4444; }
        .required { color:#f87171; margin-left:3px; }
        .hint { font-size:.78rem; color:#64748b; margin-top:5px; }
        .btn-row { display:flex; gap:12px; margin-top:28px; }
        .btn { flex:1; padding:12px; border-radius:10px; font-size:.95rem; font-weight:600;
               cursor:pointer; border:none; text-align:center; text-decoration:none;
               display:flex; align-items:center; justify-content:center; transition:all .2s; }
        .btn-primary { background:linear-gradient(135deg,#ef4444,#f97316); color:#fff; }
        .btn-primary:hover { transform:translateY(-2px); box-shadow:0 8px 25px rgba(239,68,68,.4); }
        .btn-secondary { background:rgba(255,255,255,.06); color:#94a3b8; text-decoration:none; }
    </style>
</head>
<body>
<div class="card">
    <div class="card-title">Edit <span>Admin Profile</span></div>
    <div class="card-sub">Editing: <strong>${admin.firstName} ${admin.lastName}</strong> — ID #${admin.userId}</div>

    <form method="post" action="/admins/update/${admin.userId}">
        <div class="form-group">
            <label>First Name <span class="required">*</span></label>
            <input type="text" name="firstName" required value="${admin.firstName}" maxlength="50">
        </div>
        <div class="form-group">
            <label>Last Name <span class="required">*</span></label>
            <input type="text" name="lastName" required value="${admin.lastName}" maxlength="50">
        </div>
        <div class="form-group">
            <label>Email Address <span class="required">*</span></label>
            <input type="email" name="email" required value="${admin.email}" maxlength="100">
        </div>
        <div class="form-group">
            <label>New Password</label>
            <input type="password" name="password" placeholder="Leave blank to keep current password">
            <div class="hint">Only fill this to change the password.</div>
        </div>
        <div class="form-group">
            <label>Phone Number</label>
            <input type="tel" name="phone" value="${admin.phone}" maxlength="20">
        </div>

        <div class="btn-row">
            <button type="submit" class="btn btn-primary">Save Changes</button>
            <a href="/admins/${admin.userId}" class="btn btn-secondary">Cancel</a>
        </div>
    </form>
</div>
</body>
</html>
