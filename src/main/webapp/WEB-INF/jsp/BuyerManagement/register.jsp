<%-- Server-side registration logic moved to RegistrationController --%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <title>PropertyHub | Sign Up</title>
  <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
  <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
  <link rel="stylesheet" href="/css/styles.css">
  <script src="https://cdn.tailwindcss.com"></script>
  <style>
    body { background-color: #f8fafc; display: flex; align-items: center; justify-content: center; min-height: 100vh; margin: 40px 0; }
    .auth-card { background: white; padding: 40px; border-radius: 12px; box-shadow: 0 10px 25px rgba(0,0,0,0.05); width: 100%; max-width: 500px; }
  </style>
</head>
<body>
<div class="auth-card border border-gray-100">
  <div class="text-center mb-6">
    <h2 class="text-2xl font-bold text-slate-800">Create an Account</h2>
    <p class="text-slate-500 mt-2">Join PropertyHub today as a Buyer or Seller.</p>
  </div>
  <form class="auth-form" action="/register" method="POST" enctype="multipart/form-data">
    <input type="hidden" name="redirect" value="${redirectUrl}">
    <div class="form-group relative mb-4 cs-wrap" id="cs-role" onclick="toggleCS('cs-role')" style="cursor:pointer;">
      <label class="block mb-2 text-sm font-medium text-slate-700">I want to...</label>
      <input type="hidden" name="role" id="cs-role-val" value="buyer">
      <span class="cs-label" style="display:flex;align-items:center;justify-content:space-between;width:100%;height:48px;padding:0 16px;border:1px solid #e5e7eb;border-radius:8px;font-size:0.9rem;font-weight:500;color:#334155;background:white;cursor:pointer;user-select:none;transition:border-color 0.2s;">
                        <span class="cs-text">Buy Property</span>
                        <i class="fa-solid fa-chevron-down cs-chev" style="font-size:0.7rem;color:#94a3b8;transition:transform 0.22s;"></i>
                    </span>
      <div class="cs-panel" style="display:none;position:fixed;z-index:99999;background:#1e293b;border:1px solid rgba(255,255,255,0.08);border-radius:12px;box-shadow:0 16px 48px rgba(0,0,0,0.35);overflow:hidden;min-width:200px;">
        <div class="cs-opt cs-sel" data-val="buyer" onclick="pickCS('cs-role',this);event.stopPropagation();">Buy Property</div>
        <div class="cs-opt" data-val="seller" onclick="pickCS('cs-role',this);event.stopPropagation();">Sell Property</div>
        <div class="cs-opt" data-val="both" onclick="pickCS('cs-role',this);event.stopPropagation();">Both (Buy &amp; Sell)</div>
      </div>
    </div>
    <div class="form-group mb-4">
      <label class="block text-sm font-medium text-slate-700 mb-2">Full Name</label>
      <input type="text" name="name" placeholder="John Doe" required class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:border-emerald-500 transition-colors">
    </div>
    <div class="form-group mb-4">
      <label class="block text-sm font-medium text-slate-700 mb-2">Email Address</label>
      <input type="email" name="email" placeholder="john@example.com" required class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:border-emerald-500 transition-colors">
    </div>
    <div class="form-group mb-4">
      <label class="block text-sm font-medium text-slate-700 mb-2">Password</label>
      <input type="password" name="password" placeholder="Create a strong password" required class="w-full px-4 py-3 border border-gray-200 rounded-lg outline-none focus:border-emerald-500 transition-colors">
    </div>
    <div class="form-group mb-6">
      <label class="block text-sm font-medium text-slate-700 mb-2">Profile Photo <span style="color:#94a3b8;font-weight:400;">(optional)</span></label>
      <div style="display:flex;align-items:center;gap:16px;">
        <div id="reg-avatar-preview" style="width:64px;height:64px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);display:flex;align-items:center;justify-content:center;color:white;font-weight:700;font-size:1.3rem;overflow:hidden;flex-shrink:0;">
          <i class="fa-solid fa-user"></i>
        </div>
        <div style="flex:1;">
          <label style="display:inline-flex;align-items:center;gap:8px;padding:8px 16px;border:1.5px dashed #e2e8f0;border-radius:10px;cursor:pointer;font-size:0.85rem;color:#64748b;transition:border-color 0.2s;" onmouseover="this.style.borderColor='#10b981'" onmouseout="this.style.borderColor='#e2e8f0'">
            <i class="fa-solid fa-camera" style="color:#10b981;"></i> Choose Photo
            <input type="file" name="profileImage" accept="image/*" style="display:none;" onchange="previewRegAvatar(this)">
          </label>
          <p style="font-size:0.75rem;color:#94a3b8;margin-top:4px;">JPG, PNG — max 5MB. A default avatar will be used if skipped.</p>
        </div>
      </div>
    </div>
    <button type="submit" class="w-full bg-emerald-500 hover:bg-emerald-600 text-white font-bold py-3 rounded-lg transition-colors">Register</button>
    <div class="text-center mt-6">
      <a href="/" class="text-slate-500 hover:text-emerald-600 text-sm">Return Home</a>
    </div>
  </form>
</div>
<style>
  .cs-wrap.cs-open .cs-label { border-color: #10b981 !important; box-shadow: 0 0 0 3px rgba(16,185,129,0.1); }
  .cs-opt { padding:11px 18px;font-size:0.86rem;font-family:'Outfit',sans-serif;color:#cbd5e1;cursor:pointer;transition:background 0.15s,color 0.15s;border-bottom:1px solid rgba(255,255,255,0.05); }
  .cs-opt:last-child { border-bottom:none; }
  .cs-opt:hover { background:rgba(255,255,255,0.07);color:#fff; }
  .cs-opt.cs-sel { color:#10b981;font-weight:600;background:rgba(16,185,129,0.1); }
  .cs-wrap.cs-open .cs-chev { transform:rotate(180deg) !important;color:#10b981 !important; }
</style>
<script>
  (function(){
    function closeAllCS(exceptId){
      document.querySelectorAll('.cs-wrap.cs-open').forEach(function(w){
        if(!exceptId||w.id!==exceptId){w.classList.remove('cs-open');var p=w.querySelector('.cs-panel');if(p)p.style.display='none';}
      });
    }
    window.toggleCS=function(id){
      var w=document.getElementById(id);if(!w)return;
      if(w.classList.contains('cs-open')){closeAllCS();return;}
      closeAllCS(id);
      var label=w.querySelector('.cs-label');var panel=w.querySelector('.cs-panel');
      var rect=label.getBoundingClientRect();
      panel.style.top=(rect.bottom+6)+'px';panel.style.left=rect.left+'px';panel.style.width=rect.width+'px';panel.style.display='block';
      w.classList.add('cs-open');
    };
    window.pickCS=function(id,opt){
      var w=document.getElementById(id);
      w.querySelectorAll('.cs-opt').forEach(function(o){o.classList.remove('cs-sel');});
      opt.classList.add('cs-sel');
      var textEl=w.querySelector('.cs-text');if(textEl)textEl.textContent=opt.textContent;
      var hidden=w.querySelector('input[type=hidden]');if(hidden)hidden.value=opt.dataset.val;
      closeAllCS();
    };
    document.addEventListener('click',function(e){if(!e.target.closest('.cs-wrap'))closeAllCS();});
  })();
  window.previewRegAvatar=function(input){
    var preview=document.getElementById('reg-avatar-preview');
    if(input.files&&input.files[0]){
      var reader=new FileReader();
      reader.onload=function(e){
        preview.innerHTML='<img src="'+e.target.result+'" style="width:100%;height:100%;object-fit:cover;">';
      };
      reader.readAsDataURL(input.files[0]);
    }
  };
</script>
</body>
</html>
