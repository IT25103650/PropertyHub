<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>PropertyHub | Agent Profile</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50">
    <!-- Navigation -->
    <header class="navbar" style="padding: 16px 5%; box-shadow: var(--shadow-sm); z-index: 100;">
        <div class="logo">
            <i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span>
        </div>
        <nav class="nav-links">
            <a href="/#home">Home</a>
            <a href="/#properties">Properties</a>
            <a href="/#agents" class="active">Our Agents</a>
            <a href="/#reviews">Reviews</a>
            <a href="/buyer-dashboard" id="navDashboardLink">Dashboard</a>
        </nav>
        <div class="nav-actions" style="position:relative;">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <%-- Profile Avatar Trigger --%>
                    <div id="main-profile-trigger" onclick="toggleMainProfile()" style="display:flex;align-items:center;gap:10px;cursor:pointer;padding:6px 14px;border-radius:30px;background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.2);transition:background 0.2s;">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userProfileImage}">
                                <img src="${sessionScope.userProfileImage}" style="width:32px;height:32px;border-radius:50%;object-fit:cover;border:2px solid #10b981;" alt="Profile">
                            </c:when>
                            <c:otherwise>
                                <div style="width:32px;height:32px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);color:white;display:flex;align-items:center;justify-content:center;font-weight:700;font-size:0.78rem;">${sessionScope.userName.substring(0,1)}</div>
                            </c:otherwise>
                        </c:choose>
                        <span style="font-size:0.9rem;font-weight:600;color:#334155;">${sessionScope.userName}</span>
                        <i class="fa-solid fa-chevron-down" style="font-size:0.6rem;color:#94a3b8;"></i>
                    </div>
                    <%-- Profile Dropdown Panel --%>
                    <div id="main-profile-panel" style="display:none;position:fixed;top:68px;right:20px;background:white;border-radius:14px;box-shadow:0 16px 48px rgba(0,0,0,0.18);border:1px solid #e2e8f0;width:280px;z-index:99999;overflow:hidden;">
                        <div style="padding:18px 20px;background:linear-gradient(135deg,#0f172a,#1e293b);color:white;">
                            <div style="display:flex;align-items:center;gap:12px;">
                                <c:choose>
                                    <c:when test="${not empty sessionScope.userProfileImage}">
                                        <img src="${sessionScope.userProfileImage}" style="width:46px;height:46px;border-radius:50%;object-fit:cover;border:2px solid #10b981;" alt="Profile">
                                    </c:when>
                                    <c:otherwise>
                                        <div style="width:46px;height:46px;border-radius:50%;background:linear-gradient(135deg,#10b981,#059669);display:flex;align-items:center;justify-content:center;font-size:1rem;font-weight:700;">${sessionScope.userName.substring(0,1)}</div>
                                    </c:otherwise>
                                </c:choose>
                                <div>
                                    <div style="font-weight:700;font-size:0.95rem;">${sessionScope.userName}</div>
                                    <div style="font-size:0.75rem;color:#94a3b8;text-transform:capitalize;">${sessionScope.userRole} Account</div>
                                </div>
                            </div>
                        </div>
                        <div style="padding:8px;">
                            <c:set var="profileLink" value="${sessionScope.userRole == 'seller' ? '/seller-dashboard?section=profile' : '/buyer-dashboard?section=profile'}"/>
                            <a href="${profileLink}" style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-radius:8px;color:#334155;font-size:0.87rem;text-decoration:none;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                                <i class="fa-solid fa-user-pen" style="color:#10b981;width:16px;"></i> View / Edit Profile
                            </a>
                            <c:if test="${sessionScope.userRole == 'buyer' || sessionScope.userRole == 'both'}">
                                <a href="/buyer-dashboard" style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-radius:8px;color:#334155;font-size:0.87rem;text-decoration:none;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                                    <i class="fa-solid fa-gauge-high" style="color:#3b82f6;width:16px;"></i> Buyer Dashboard
                                </a>
                            </c:if>
                            <c:if test="${sessionScope.userRole == 'seller' || sessionScope.userRole == 'both'}">
                                <a href="/seller-dashboard" style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-radius:8px;color:#334155;font-size:0.87rem;text-decoration:none;" onmouseover="this.style.background='#f8fafc'" onmouseout="this.style.background='transparent'">
                                    <i class="fa-solid fa-building" style="color:#8b5cf6;width:16px;"></i> Seller Dashboard
                                </a>
                            </c:if>
                            <hr style="margin:6px 0;border:none;border-top:1px solid #f1f5f9;">
                            <a href="/logout" style="display:flex;align-items:center;gap:10px;padding:10px 14px;border-radius:8px;color:#ef4444;font-size:0.87rem;text-decoration:none;" onmouseover="this.style.background='#fef2f2'" onmouseout="this.style.background='transparent'">
                                <i class="fa-solid fa-right-from-bracket" style="width:16px;"></i> Logout
                            </a>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <a href="/login?redirect=/agents?id=${agent.user_id}" class="btn btn-outline flex items-center justify-center font-semibold" style="text-decoration: none;">Log In</a>
                    <a href="/register?redirect=/agents?id=${agent.user_id}" class="btn btn-primary flex items-center justify-center font-semibold" style="text-decoration: none;">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <main class="container mx-auto px-4 py-24 max-w-6xl mt-10">
        <a href="/#agents" class="text-emerald-600 hover:text-emerald-700 font-medium mb-6 inline-flex flex items-center gap-2"><i class="fa-solid fa-arrow-left"></i> Back to Agents</a>
        
        <div class="bg-white rounded-2xl shadow-sm border border-gray-100 overflow-hidden mb-12">
            <div class="flex flex-col md:flex-row min-h-[500px]">
                <!-- Picture on Left -->
                <div class="md:w-5/12 bg-slate-100 relative">
                    <img src="${empty agent.profile_image_url ? 'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800' : agent.profile_image_url}" alt="${agent.first_name} ${agent.last_name}" class="w-full h-full object-cover absolute inset-0">
                </div>
                <!-- Details on Right -->
                <div class="md:w-7/12 p-8 lg:p-12">
                    <div class="flex justify-between items-start mb-4">
                        <div>
                            <h1 class="text-4xl font-bold text-slate-800 mb-2">${agent.first_name} ${agent.last_name}</h1>
                            <p class="text-emerald-600 font-semibold text-lg">Real Estate Agent</p>
                        </div>
                        <span class="bg-blue-50 text-blue-600 px-4 py-2 rounded-full text-sm font-bold tracking-wide">Top Agent</span>
                    </div>

                    <div class="flex items-center gap-1 mb-8">
                        <c:forEach var="i" begin="1" end="5">
                            <i class="fa-solid fa-star ${i <= intRating ? 'text-yellow-400' : 'text-slate-200'} text-xl"></i>
                        </c:forEach>
                        <span class="text-slate-500 ml-2 font-medium">(${reviewCount} Reviews) - ${avgRating}/5</span>
                    </div>

                    <p class="text-slate-600 text-lg leading-relaxed mb-8">
                        With extensive experience in the real estate market, ${agent.first_name} specializes in properties that meet your unique needs. Connect today to explore available listings.
                    </p>

                    <h3 class="font-bold text-xl text-slate-800 mb-4 border-b pb-2">Contact Details</h3>
                    <ul class="space-y-4 mb-8">
                        <li class="flex items-center gap-4 text-slate-600 text-lg hover:text-emerald-600 transition-colors cursor-pointer"><i class="fa-solid fa-phone text-emerald-500 w-6"></i> ${agent.phone != null ? agent.phone : 'Not provided'}</li>
                        <li class="flex items-center gap-4 text-slate-600 text-lg hover:text-emerald-600 transition-colors cursor-pointer"><i class="fa-solid fa-envelope text-emerald-500 w-6"></i> ${agent.email}</li>
                    </ul>

                    <div class="flex gap-4">
                        <button onclick="document.getElementById('messageModal').classList.remove('hidden')" class="bg-emerald-500 text-white px-8 py-3 rounded-lg font-bold hover:bg-emerald-600 transition-colors shadow-lg shadow-emerald-500/20">Message ${agent.first_name}</button>
                    </div>
                </div>
            </div>
        </div>

        <h2 class="text-3xl font-bold text-slate-800 mb-8 border-b pb-4">Properties Managed by ${agent.first_name}</h2>
        <div class="grid grid-cols-1 md:grid-cols-2 lg:grid-cols-3 gap-8">
            <c:forEach var="prop" items="${properties}">
                <div class="property-card bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden group hover:shadow-lg transition-transform duration-300 hover:-translate-y-2 cursor-pointer relative" onclick="window.location.href='/property-detail?id=${prop.property_id}'">
                    <span class="absolute top-4 left-4 ${prop.listing_type == 'sale' ? 'bg-emerald-500' : 'bg-blue-500'} text-white px-3 py-1 rounded-full text-xs font-bold z-10">For ${prop.listing_type == 'sale' ? 'Sale' : 'Rent'}</span>
                    <div class="h-56 overflow-hidden relative">
                        <img src="${prop.primary_image}" class="w-full h-full object-cover group-hover:scale-110 transition-transform duration-500">
                        <div class="absolute bottom-4 right-4 bg-slate-900/80 text-white px-4 py-2 rounded-lg font-bold">${prop.price} LKR</div>
                    </div>
                    <div class="p-6">
                        <h3 class="text-xl font-bold text-slate-800 mb-2 group-hover:text-emerald-600 transition-colors">${prop.title}</h3>
                        <p class="text-slate-500 text-sm mb-4"><i class="fa-solid fa-location-dot mr-1"></i> ${prop.location}</p>
                        <div class="flex justify-between items-center text-sm text-slate-600 border-t pt-4">
                            <span class="flex items-center gap-1"><i class="fa-solid fa-bed text-emerald-500"></i> ${prop.bedrooms} Beds</span>
                            <span class="flex items-center gap-1"><i class="fa-solid fa-bath text-emerald-500"></i> ${prop.bathrooms} Baths</span>
                            <span class="flex items-center gap-1"><i class="fa-solid fa-ruler-combined text-emerald-500"></i> ${prop.sqft} sqft</span>
                        </div>
                    </div>
                </div>
            </c:forEach>
            <c:if test="${empty properties}">
                <div class="col-span-3 text-center py-10 text-slate-500">
                    <i class="fa-solid fa-house-crack text-4xl mb-4 text-slate-300"></i>
                    <p class="text-lg">No available properties listed by this agent currently.</p>
                </div>
            </c:if>
        </div>

        <!-- Reviews Section -->
        <div class="flex justify-between items-center mb-8 mt-16 border-b pb-4">
            <h2 class="text-3xl font-bold text-slate-800">Agent Reviews</h2>
            <button onclick="document.getElementById('reviewSection').scrollIntoView({behavior: 'smooth'})" class="text-emerald-600 font-bold hover:underline">Leave a Review</button>
        </div>
        
        <div class="grid grid-cols-1 lg:grid-cols-3 gap-12">
            <div class="lg:col-span-2 space-y-6">
                <c:forEach var="review" items="${reviews}">
                    <div class="bg-white p-6 rounded-xl shadow-sm border border-gray-100 group hover:border-emerald-200 transition-colors">
                        <div class="flex justify-between items-start mb-4">
                            <div>
                                <h4 class="font-bold text-slate-800">${review.first_name} ${review.last_name}</h4>
                                <div class="flex items-center gap-1 mt-1">
                                    <c:forEach var="i" begin="1" end="5">
                                        <i class="fa-solid fa-star ${i <= review.rating ? 'text-yellow-400' : 'text-slate-200'} text-sm"></i>
                                    </c:forEach>
                                </div>
                            </div>
                            <span class="text-slate-400 text-xs">${review.created_at}</span>
                        </div>
                        <p class="text-slate-600 italic">"${review.review_text}"</p>
                    </div>
                </c:forEach>
                <c:if test="${empty reviews}">
                    <div class="text-center py-10 text-slate-500 bg-white rounded-xl border border-dashed border-slate-200">
                        <i class="fa-solid fa-comments text-4xl mb-4 text-slate-300"></i>
                        <p class="text-lg">No reviews yet for this agent.</p>
                    </div>
                </c:if>
            </div>

            <!-- Leave a Review Form -->
            <div id="reviewSection" class="lg:col-span-1">
                <div class="bg-white p-8 rounded-2xl shadow-sm border border-gray-100 sticky top-24">
                    <h3 class="text-xl font-bold text-slate-800 mb-6 flex items-center gap-2">
                        <i class="fa-solid fa-pen-to-square text-emerald-500"></i> Write a Review
                    </h3>
                    <form action="/submit-agent-review" method="POST">
                        <input type="hidden" name="agentId" value="${agent.user_id}">
                        <div class="mb-4">
                            <label class="block text-sm font-bold text-slate-700 mb-2">Rating</label>
                            <div class="flex flex-row-reverse justify-end gap-1 rating-group">
                                <c:forEach var="i" begin="0" end="4">
                                    <c:set var="val" value="${5 - i}" />
                                    <input type="radio" name="rating" value="${val}" id="star${val}" class="hidden peer" required ${val == 5 ? 'checked' : ''}>
                                    <label for="star${val}" class="cursor-pointer text-2xl text-slate-200 hover:text-yellow-400 peer-checked:text-yellow-400 peer-hover:text-yellow-400 transition-colors">
                                        <i class="fa-solid fa-star"></i>
                                    </label>
                                </c:forEach>
                            </div>
                            <style>
                                .rating-group label:hover,
                                .rating-group label:hover ~ label,
                                .rating-group input:checked ~ label {
                                    color: #fbbf24; /* yellow-400 */
                                }
                            </style>
                        </div>
                        <div class="mb-6">
                            <label class="block text-sm font-bold text-slate-700 mb-2">Your Experience</label>
                            <textarea name="reviewText" rows="4" class="w-full p-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-emerald-500 outline-none text-slate-600" placeholder="Tell us about your experience working with ${agent.first_name}..." required></textarea>
                        </div>
                        <button type="submit" class="w-full bg-slate-800 text-white py-3 rounded-xl font-bold hover:bg-slate-900 transition-all shadow-lg shadow-slate-200">Post Review</button>
                        <p class="text-xs text-slate-400 mt-4 text-center italic">Reviews are subject to admin approval before appearing publicly.</p>
                    </form>
                </div>
            </div>
        </div>

        <!-- Message Modal -->
        <div id="messageModal" class="hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
            <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in duration-300">
                <div class="p-6 border-b flex justify-between items-center bg-slate-50">
                    <h3 class="text-xl font-bold text-slate-800">Send Message to ${agent.first_name}</h3>
                    <button onclick="document.getElementById('messageModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600"><i class="fa-solid fa-xmark text-xl"></i></button>
                </div>
                <form action="/send-agent-inquiry" method="POST" class="p-8">
                    <input type="hidden" name="agentId" value="${agent.user_id}">
                    <div class="mb-6">
                        <label class="block text-sm font-bold text-slate-700 mb-2">Subject Property</label>
                        <select name="propertyId" class="w-full p-3 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-emerald-500">
                            <c:forEach var="p" items="${properties}">
                                <option value="${p.property_id}">${p.title}</option>
                            </c:forEach>
                            <c:if test="${empty properties}">
                                <option value="">General Inquiry</option>
                            </c:if>
                        </select>
                    </div>
                    <div class="mb-8">
                        <label class="block text-sm font-bold text-slate-700 mb-2">Your Message</label>
                        <textarea name="message" rows="5" class="w-full p-4 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-emerald-500 text-slate-600" placeholder="Hi ${agent.first_name}, I'm interested in..." required></textarea>
                    </div>
                    <button type="submit" class="w-full bg-emerald-500 text-white py-4 rounded-xl font-bold hover:bg-emerald-600 transition-all shadow-lg shadow-emerald-500/30">Send Message Now</button>
                </form>
            </div>
        </div>

        <!-- Success/Error Notifications (Simple CSS based) -->
        <c:if test="${not empty param.message_sent}">
            <div class="fixed bottom-8 right-8 bg-emerald-600 text-white px-6 py-4 rounded-2xl shadow-2xl flex items-center gap-3 animate-bounce">
                <i class="fa-solid fa-circle-check text-2xl"></i>
                <div>
                    <p class="font-bold">Message Sent!</p>
                    <p class="text-sm opacity-90">${agent.first_name} will get back to you soon.</p>
                </div>
            </div>
        </c:if>
        <c:if test="${not empty param.review_submitted}">
            <div class="fixed bottom-8 right-8 bg-emerald-600 text-white px-6 py-4 rounded-2xl shadow-2xl flex items-center gap-3 animate-bounce">
                <i class="fa-solid fa-circle-check text-2xl"></i>
                <div>
                    <p class="font-bold">Review Posted!</p>
                    <p class="text-sm opacity-90">Thank you! Your feedback has been published.</p>
                </div>
            </div>
        </c:if>
    </main>

    <!-- Footer -->
    <footer class="footer">
        <div class="footer-bottom">
            <p>&copy; 2026 PropertyHub. All rights reserved.</p>
        </div>
    </footer>
    <script>
    function toggleMainProfile(){
        var p=document.getElementById('main-profile-panel');
        p.style.display=p.style.display==='none'?'block':'none';
    }
    document.addEventListener('click',function(e){
        if(!e.target.closest('#main-profile-trigger')&&!e.target.closest('#main-profile-panel')){
            var p=document.getElementById('main-profile-panel');
            if(p)p.style.display='none';
        }
    });
    </script>
</body>
</html>
