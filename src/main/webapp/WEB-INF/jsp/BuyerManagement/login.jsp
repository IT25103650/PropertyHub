<%-- Server-side login logic moved to LoginController --%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PropertyHub | Log In</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="/css/styles.css">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body { background-color: #f8fafc; display: flex; align-items: center; justify-content: center; min-height: 100vh; }
    .auth-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); width: 100%; max-width: 450px; }
  </style>
</head>
<body>
<div class="auth-card border border-gray-100">
  <div class="text-center mb-6">
    <h2 class="text-2xl font-bold text-slate-800">Welcome Back</h2>
    <p class="text-slate-500 mt-2">Log in to access your dashboard.</p>
  </div>
  <form class="auth-form" action="/login" method="POST">
    <c:if test="${param.error == 'true'}">
      <div class="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-lg mb-6 text-sm text-center">
        Invalid email or password. Please try again or create an account.
      </div>
    </c:if>
    <input type="hidden" name="redirect" value="${redirectUrl}">
    <div class="form-group mb-4">
      <label class="block text-sm font-medium text-slate-700 mb-2">Email Address</label>
      <input type="email" name="email" placeholder="Enter your email" required class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:border-emerald-500 transition-colors">
    </div>
    <div class="form-group mb-6">
      <label class="block text-sm font-medium text-slate-700 mb-2">Password</label>
      <input type="password" name="password" placeholder="Enter your password" required class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:border-emerald-500 transition-colors">
    </div>
    <button type="submit" class="w-full bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-3 rounded-lg transition-colors mb-4">Log In</button>
    <div class="text-center mb-6">
      <p class="text-slate-600 font-medium">Don't have an account? <a href="/register?redirect=${redirectUrl}" class="text-emerald-600 hover:text-emerald-700 font-bold hover:underline transition-colors">Sign up</a></p>
    </div>
    <div class="text-center mt-4 border-t border-gray-100 pt-6">
      <p class="text-sm text-gray-500 mb-2">System Administrator?</p>
      <a href="/admin-login" class="text-emerald-600 font-semibold hover:underline text-sm"><i class="fa-solid fa-user-shield"></i> Log in as Admin</a>
      <div class="mt-4"><a href="/" class="text-slate-500 hover:text-emerald-600 text-sm">Return Home</a></div>
    </div>
  </form>
</div>
</body>
</html>
