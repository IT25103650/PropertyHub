<%@ page contentType="text/html;charset=UTF-8" %>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Admin Login | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <style>
        *, *::before, *::after { margin: 0; padding: 0; box-sizing: border-box; }
        body {
            font-family: 'Outfit', sans-serif;
            background: linear-gradient(135deg, #0f172a 0%, #1e293b 50%, #0f2027 100%);
            min-height: 100vh;
            display: flex;
            align-items: center;
            justify-content: center;
            padding: 20px;
        }
        body::before {
            content: '';
            position: fixed;
            inset: 0;
            background: radial-gradient(ellipse at 20% 50%, rgba(16,185,129,0.08) 0%, transparent 60%),
                        radial-gradient(ellipse at 80% 20%, rgba(139,92,246,0.06) 0%, transparent 60%);
            pointer-events: none;
        }
        .login-card {
            background: rgba(255,255,255,0.04);
            backdrop-filter: blur(20px);
            border: 1px solid rgba(255,255,255,0.08);
            border-radius: 24px;
            padding: 50px 44px;
            width: 100%;
            max-width: 440px;
            box-shadow: 0 32px 80px rgba(0,0,0,0.5);
            position: relative;
        }
        .shield-icon {
            width: 72px; height: 72px;
            background: linear-gradient(135deg, #10b981, #059669);
            border-radius: 20px;
            display: flex; align-items: center; justify-content: center;
            font-size: 2rem; color: white;
            margin: 0 auto 24px;
            box-shadow: 0 8px 24px rgba(16,185,129,0.35);
        }
        h1 { color: #fff; font-size: 1.6rem; font-weight: 700; text-align: center; margin-bottom: 6px; }
        .subtitle { color: #94a3b8; font-size: 0.88rem; text-align: center; margin-bottom: 36px; }
        .restricted-badge {
            display: inline-flex; align-items: center; gap: 6px;
            background: rgba(239,68,68,0.12); border: 1px solid rgba(239,68,68,0.2);
            color: #f87171; font-size: 0.72rem; font-weight: 700;
            padding: 4px 12px; border-radius: 20px;
            margin: 0 auto 28px; display: block; text-align: center; width: fit-content;
            margin-left: auto; margin-right: auto;
        }
        .form-group { margin-bottom: 20px; }
        .form-group label { display: block; color: #cbd5e1; font-size: 0.83rem; font-weight: 600; margin-bottom: 8px; }
        .input-wrap { position: relative; }
        .input-wrap i {
            position: absolute; left: 16px; top: 50%; transform: translateY(-50%);
            color: #475569; font-size: 0.9rem;
        }
        .form-control {
            width: 100%; padding: 13px 16px 13px 44px;
            background: rgba(255,255,255,0.06); border: 1.5px solid rgba(255,255,255,0.1);
            border-radius: 12px; color: #fff; font-size: 0.9rem; font-family: inherit;
            outline: none; transition: all 0.25s;
        }
        .form-control:focus { border-color: #10b981; background: rgba(16,185,129,0.06); box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
        .form-control::placeholder { color: #475569; }
        .btn-login {
            width: 100%; padding: 14px; background: linear-gradient(135deg, #10b981, #059669);
            color: white; border: none; border-radius: 12px; font-size: 0.95rem; font-weight: 700;
            cursor: pointer; font-family: inherit; transition: all 0.25s; margin-top: 8px;
            box-shadow: 0 4px 16px rgba(16,185,129,0.3);
        }
        .btn-login:hover { transform: translateY(-2px); box-shadow: 0 8px 24px rgba(16,185,129,0.45); }
        .error-msg {
            background: rgba(239,68,68,0.1); border: 1px solid rgba(239,68,68,0.25);
            color: #f87171; padding: 12px 16px; border-radius: 10px;
            font-size: 0.85rem; margin-bottom: 20px; display: flex; align-items: center; gap: 8px;
        }
        .back-link { text-align: center; margin-top: 24px; }
        .back-link a { color: #64748b; font-size: 0.85rem; text-decoration: none; transition: color 0.2s; }
        .back-link a:hover { color: #10b981; }
    </style>
</head>
<body>
<div class="login-card">
    <div class="shield-icon"><i class="fa-solid fa-shield-halved"></i></div>
    <h1>Admin Portal</h1>
    <p class="subtitle">PropertyHub Administration</p>
    <div class="restricted-badge"><i class="fa-solid fa-lock"></i> RESTRICTED ACCESS</div>

    <c:if test="${param.error == 'true'}">
        <div class="error-msg">
            <i class="fa-solid fa-triangle-exclamation"></i>
            Invalid credentials or insufficient privileges.
        </div>
    </c:if>

    <form action="/admin-login" method="POST">
        <div class="form-group">
            <label>Admin Email</label>
            <div class="input-wrap">
                <i class="fa-solid fa-envelope"></i>
                <input type="email" name="email" class="form-control" placeholder="admin@propertyhub.lk" required autocomplete="email">
            </div>
        </div>
        <div class="form-group">
            <label>Password</label>
            <div class="input-wrap">
                <i class="fa-solid fa-lock"></i>
                <input type="password" name="password" class="form-control" placeholder="••••••••" required autocomplete="current-password">
            </div>
        </div>
        <button type="submit" class="btn-login"><i class="fa-solid fa-shield-halved"></i> &nbsp;Sign In as Admin</button>
    </form>

    <div class="back-link">
        <a href="/"><i class="fa-solid fa-arrow-left"></i> Back to PropertyHub</a>
    </div>
</div>
</body>
</html>
