<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<%
    // Spring MVC forwards internally to JSP, so request.getRequestURI()
    // returns the internal path like /WEB-INF/jsp/property-detail.jsp.
    // The REAL browser-facing URL is stored in the forward attribute.
    String reqUri = (String) request.getAttribute("jakarta.servlet.forward.request_uri");
    if (reqUri == null) reqUri = (String) request.getAttribute("javax.servlet.forward.request_uri");
    if (reqUri == null) reqUri = request.getRequestURI(); // fallback

    String queryStr = (String) request.getAttribute("jakarta.servlet.forward.query_string");
    if (queryStr == null) queryStr = (String) request.getAttribute("javax.servlet.forward.query_string");
    if (queryStr == null) queryStr = request.getQueryString();

    String fullUrl = reqUri + (queryStr != null && !queryStr.isEmpty() ? "?" + queryStr : "");
    pageContext.setAttribute("currentUrl", fullUrl);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>${prop.title} | PropertyHub</title>
    <!-- Google Fonts -->
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <!-- Font Awesome -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <!-- Main Stylesheet -->
    <link rel="stylesheet" href="/css/styles.css">
    <!-- Tailwind CSS -->
    <script src="https://cdn.tailwindcss.com"></script>
    <style>
        .hero-banner {
            height: 60vh;
            min-height: 450px;
            background: linear-gradient(to top, rgba(15, 23, 42, 0.95), rgba(15, 23, 42, 0.2)), url('${primaryImg}') center/cover no-repeat;
            position: relative;
            background-attachment: fixed;
        }
        .glass-card {
            background: rgba(255, 255, 255, 0.9);
            backdrop-filter: blur(16px);
            border: 1px solid rgba(255, 255, 255, 0.5);
            box-shadow: 0 20px 40px rgba(0, 0, 0, 0.05);
            border-radius: 20px;
        }
        .feature-badge {
            background: rgba(16, 185, 129, 0.1);
            color: var(--color-primary-dark);
            padding: 8px 16px;
            border-radius: 999px;
            font-weight: 600;
            display: inline-flex;
            align-items: center;
            gap: 8px;
            transition: all 0.3s ease;
        }
        .feature-badge:hover {
            background: var(--color-primary);
            color: white;
            transform: translateY(-2px);
        }
        
        /* Custom Select styling to match modern UI */
        .custom-select-wrapper { position: relative; }
        .custom-select {
            appearance: none;
            width: 100%;
            padding: 12px 16px;
            border: 1px solid #e2e8f0;
            border-radius: 12px;
            background: #f8fafc;
            color: #334155;
            font-family: inherit;
            font-size: 1rem;
            cursor: pointer;
            transition: all 0.2s;
        }
        .custom-select:focus {
            outline: none;
            border-color: var(--color-primary);
            box-shadow: 0 0 0 3px rgba(16, 185, 129, 0.1);
            background: white;
        }
        .select-icon {
            position: absolute;
            right: 16px;
            top: 50%;
            transform: translateY(-50%);
            color: #94a3b8;
            pointer-events: none;
        }
    </style>
</head>
<body class="bg-slate-50 text-slate-800 font-['Outfit'] antialiased selection:bg-emerald-200">

    <!-- Navigation -->
    <header class="fixed top-0 w-full z-50 transition-all duration-300 bg-white/90 backdrop-blur-md shadow-sm border-b border-gray-100" style="padding: 1rem 5%;">
        <div class="flex justify-between items-center max-w-7xl mx-auto">
            <a href="/" class="text-2xl font-bold text-slate-800 flex items-center gap-2 hover:text-emerald-500 transition-colors">
                <i class="fa-solid fa-house-chimney-window text-emerald-500"></i>
                Property<span class="text-emerald-500">Hub</span>
            </a>
            <div class="flex items-center gap-6">
                <a href="/" class="text-slate-600 hover:text-emerald-500 font-medium transition-colors">Home</a>
                <a href="#details" class="text-slate-600 hover:text-emerald-500 font-medium transition-colors">Details</a>
                <a href="#reviews" class="text-slate-600 hover:text-emerald-500 font-medium transition-colors">Reviews</a>
                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <span style="color:#334155;font-size:0.9rem;font-weight:500;">Hi, <strong>${sessionScope.userName}</strong></span>
                        <c:if test="${sessionScope.userRole == 'buyer' || sessionScope.userRole == 'both'}">
                            <a href="/buyer-dashboard" class="text-slate-600 hover:text-emerald-500 font-medium transition-colors"><i class="fa-solid fa-user"></i> Buyer</a>
                        </c:if>
                        <c:if test="${sessionScope.userRole == 'seller' || sessionScope.userRole == 'both'}">
                            <a href="/seller-dashboard" class="text-slate-600 hover:text-emerald-500 font-medium transition-colors"><i class="fa-solid fa-building"></i> Seller</a>
                        </c:if>
                        <a href="/logout" class="text-red-500 hover:text-red-600 font-medium transition-colors text-sm"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                    </c:when>
                    <c:otherwise>
                        <a href="/login?redirect=${currentUrl}" class="text-slate-600 hover:text-emerald-500 font-medium transition-colors">Log In</a>
                        <a href="/register?redirect=${currentUrl}" class="bg-emerald-500 hover:bg-emerald-600 text-white px-4 py-2 rounded-lg font-semibold transition-colors text-sm">Sign Up</a>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </header>

    <!-- Interactive Hero Banner -->
    <div class="hero-banner flex items-end pb-12 pt-32 mt-0">
        <div class="w-full max-w-7xl mx-auto px-6">
            <div class="flex flex-col md:flex-row justify-between items-end gap-6">
                <div class="text-white animate-[slideUp_0.8s_ease]">
                    <div class="flex items-center gap-3 mb-4">
                        <span class="bg-emerald-500 text-white text-xs font-bold px-3 py-1 uppercase rounded-full tracking-wider shadow-lg">${listType}</span>
                        <span class="bg-black/40 backdrop-blur-md text-white text-xs font-semibold px-3 py-1 rounded-full"><i class="fa-regular fa-building mr-1"></i> ${prop.propertyType}</span>
                    </div>
                    <h1 class="text-4xl md:text-6xl font-bold mb-2 drop-shadow-xl">${prop.title}</h1>
                    <p class="text-lg md:text-xl text-slate-200 flex items-center gap-2">
                        <i class="fa-solid fa-location-dot text-emerald-400"></i> ${prop.location}
                    </p>
                </div>
                <div class="text-right text-white">
                    <p class="text-sm font-medium text-emerald-300 mb-1 uppercase tracking-wider">Asking Price</p>
                    <h2 class="text-4xl md:text-5xl font-bold drop-shadow-lg text-emerald-400">${priceStr}</h2>
                </div>
            </div>
        </div>
    </div>

    <!-- Property Image Carousel -->
    <c:if test="${not empty images && images.size() > 0}">
    <div class="w-full max-w-7xl mx-auto px-6 pt-8 relative z-10 -mt-8">
        <div class="glass-card overflow-hidden" style="padding:0;">
            <!-- Main Carousel Image -->
            <div style="position:relative;width:100%;height:420px;overflow:hidden;background:#0f172a;border-radius:20px 20px 0 0;">
                <c:choose>
                    <c:when test="${empty images}">
                        <img src="https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=1200&auto=format&fit=crop&q=80" class="carousel-slide active" 
                             style="position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;opacity:1;" alt="Property Graphic">
                    </c:when>
                    <c:otherwise>
                        <c:forEach var="img" items="${images}" varStatus="loop">
                            <img src="${img.image_url}" class="carousel-slide ${loop.index == 0 ? 'active' : ''}"
                                 style="position:absolute;top:0;left:0;width:100%;height:100%;object-fit:cover;opacity:${loop.index == 0 ? '1' : '0'};transition:opacity 0.6s ease-in-out;"
                                 alt="Property Image ${loop.index + 1}">
                        </c:forEach>
                    </c:otherwise>
                </c:choose>
                <!-- Navigation Arrows -->
                <c:if test="${images.size() > 1}">
                    <button onclick="carouselPrev()" style="position:absolute;left:16px;top:50%;transform:translateY(-50%);width:44px;height:44px;border-radius:50%;background:rgba(0,0,0,0.5);backdrop-filter:blur(4px);border:1px solid rgba(255,255,255,0.2);color:white;font-size:1.1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:background 0.2s;" onmouseover="this.style.background='rgba(16,185,129,0.8)'" onmouseout="this.style.background='rgba(0,0,0,0.5)'">
                        <i class="fa-solid fa-chevron-left"></i>
                    </button>
                    <button onclick="carouselNext()" style="position:absolute;right:16px;top:50%;transform:translateY(-50%);width:44px;height:44px;border-radius:50%;background:rgba(0,0,0,0.5);backdrop-filter:blur(4px);border:1px solid rgba(255,255,255,0.2);color:white;font-size:1.1rem;cursor:pointer;display:flex;align-items:center;justify-content:center;transition:background 0.2s;" onmouseover="this.style.background='rgba(16,185,129,0.8)'" onmouseout="this.style.background='rgba(0,0,0,0.5)'">
                        <i class="fa-solid fa-chevron-right"></i>
                    </button>
                </c:if>
                <!-- Image Counter -->
                <div style="position:absolute;bottom:16px;right:16px;background:rgba(0,0,0,0.6);backdrop-filter:blur(4px);color:white;padding:6px 14px;border-radius:20px;font-size:0.8rem;font-weight:600;">
                    <i class="fa-solid fa-images" style="margin-right:4px;color:#10b981;"></i>
                    <span id="carousel-counter">1</span> / ${images.size()}
                </div>
            </div>
            <!-- Thumbnail Strip -->
            <c:if test="${images.size() > 1}">
            <div style="padding:12px 16px;display:flex;gap:8px;overflow-x:auto;background:white;border-radius:0 0 20px 20px;">
                <c:forEach var="img" items="${images}" varStatus="loop">
                    <div onclick="carouselGoTo(${loop.index})" style="width:80px;height:56px;border-radius:8px;overflow:hidden;cursor:pointer;border:2px solid ${loop.index == 0 ? '#10b981' : 'transparent'};flex-shrink:0;transition:border-color 0.2s,transform 0.2s;" class="carousel-thumb" data-index="${loop.index}" onmouseover="this.style.transform='scale(1.05)'" onmouseout="this.style.transform='scale(1)'">
                        <img src="${img.image_url}" style="width:100%;height:100%;object-fit:cover;" alt="Thumb ${loop.index + 1}">
                    </div>
                </c:forEach>
            </div>
            </c:if>
        </div>
    </div>
    </c:if>

    <!-- Main Content -->
    <main class="w-full max-w-7xl mx-auto px-6 py-12 relative z-10">
        <div class="flex flex-col lg:flex-row gap-8 items-start">
            
            <!-- Left Column: Details & Reviews -->
            <div class="w-full lg:w-2/3 flex flex-col gap-8">
                
                <!-- Property Overview Glass Card -->
                <div class="glass-card p-8 animate-[slideUp_1s_ease]">
                    <div class="flex flex-wrap gap-4 mb-8">
                        <c:if test="${not empty prop.bedrooms}"><div class="feature-badge"><i class="fa-solid fa-bed text-lg"></i> ${prop.bedrooms} Bedrooms</div></c:if>
                        <c:if test="${not empty prop.bathrooms}"><div class="feature-badge"><i class="fa-solid fa-bath text-lg"></i> ${prop.bathrooms} Bathrooms</div></c:if>
                        <c:if test="${not empty prop.sqft}"><div class="feature-badge"><i class="fa-solid fa-vector-square text-lg"></i> ${prop.sqft} sqft</div></c:if>
                        <div class="feature-badge"><i class="fa-solid fa-tag text-lg"></i> ${listType}</div>
                    </div>
                    
                    <h3 class="text-2xl font-bold text-slate-800 mb-4 border-b border-gray-100 pb-3">Property Description</h3>
                    <p class="text-slate-600 leading-relaxed text-lg mb-6">
                        <c:choose><c:when test="${not empty prop.description}">${prop.description}</c:when><c:otherwise>No description provided.</c:otherwise></c:choose>
                    </p>
                    
                    <h4 class="text-xl font-bold text-slate-800 mb-4">Property Details</h4>
                    <div class="grid grid-cols-2 md:grid-cols-3 gap-4">
                        <c:if test="${not empty prop.bedrooms}"><div class="flex items-center gap-2 text-slate-600"><i class="fa-solid fa-bed text-emerald-500 bg-emerald-50 p-1 rounded-full"></i> ${prop.bedrooms} Bedrooms</div></c:if>
                        <c:if test="${not empty prop.bathrooms}"><div class="flex items-center gap-2 text-slate-600"><i class="fa-solid fa-bath text-emerald-500 bg-emerald-50 p-1 rounded-full"></i> ${prop.bathrooms} Bathrooms</div></c:if>
                        <c:if test="${not empty prop.sqft}"><div class="flex items-center gap-2 text-slate-600"><i class="fa-solid fa-vector-square text-emerald-500 bg-emerald-50 p-1 rounded-full"></i> ${prop.sqft} sqft</div></c:if>
                        <div class="flex items-center gap-2 text-slate-600"><i class="fa-solid fa-map-marker-alt text-emerald-500 bg-emerald-50 p-1 rounded-full"></i> ${prop.location}</div>
                        <div class="flex items-center gap-2 text-slate-600"><i class="fa-solid fa-tag text-emerald-500 bg-emerald-50 p-1 rounded-full"></i> ${listType}</div>
                        <div class="flex items-center gap-2 text-slate-600"><i class="fa-solid fa-home text-emerald-500 bg-emerald-50 p-1 rounded-full"></i> ${prop.propertyType}</div>
                    </div>
                </div>

                <!-- Reviews Section -->
                <div id="reviews" class="glass-card p-8 shadow-sm">
                    <div class="flex justify-between items-end border-b border-gray-100 pb-4 mb-6">
                        <div>
                            <h3 class="text-2xl font-bold text-slate-800">Property Reviews</h3>
                            <p class="text-slate-500 text-sm mt-1">Read feedback from buyers who viewed this property.</p>
                        </div>
                        <div class="flex items-center gap-1 bg-yellow-50 text-yellow-600 px-3 py-1 rounded-full text-sm font-bold">
                            <i class="fa-solid fa-star"></i> ${avgRating} (${reviews.size()} Reviews)
                        </div>
                    </div>
                    
                    <c:choose>
                        <c:when test="${not empty reviews}">
                            <c:forEach var="rev" items="${reviews}">
                            <div class="bg-slate-50 p-6 rounded-xl border border-slate-100 mb-4 hover:shadow-md transition-shadow">
                                <div class="flex items-center gap-4 mb-4">
                                    <c:choose>
                                        <c:when test="${not empty rev.profile_image_url}">
                                            <img src="${rev.profile_image_url}" style="width:48px;height:48px;border-radius:50%;object-fit:cover;border:2px solid #e2e8f0;" alt="${rev.first_name}">
                                        </c:when>
                                        <c:otherwise>
                                            <div class="w-12 h-12 rounded-full bg-gradient-to-br from-indigo-500 to-purple-500 text-white flex items-center justify-center font-bold text-lg shadow-sm">
                                                ${not empty rev.first_name ? rev.first_name.substring(0,1) : ''}${not empty rev.last_name ? rev.last_name.substring(0,1) : ''}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div>
                                        <h4 class="font-bold text-slate-800">${rev.first_name} <c:if test="${not empty rev.last_name}">${rev.last_name.substring(0,1)}.</c:if></h4>
                                        <div class="flex text-yellow-400 text-xs">
                                            <c:forEach begin="1" end="${rev.rating}"><i class="fa-solid fa-star"></i></c:forEach>
                                        </div>
                                    </div>
                                </div>
                                <p class="text-slate-600 italic">"${rev.review_text}"</p>
                            </div>
                            </c:forEach>
                        </c:when>
                        <c:otherwise>
                            <div class="text-slate-400 text-sm italic mb-6">No reviews yet. Be the first to leave one!</div>
                        </c:otherwise>
                    </c:choose>
                    
                    <!-- Submit Review Form -->
                    <c:if test="${param.reviewSuccess == 'true'}">
                        <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-4 text-sm font-medium">
                            <i class="fa-solid fa-circle-check mr-2"></i> Review submitted successfully!
                        </div>
                    </c:if>
                    <h4 class="font-bold text-slate-800 mb-3">Leave a Review</h4>
                    <c:choose>
                        <c:when test="${not empty sessionScope.userId}">
                            <form action="/submit-review" method="POST" id="property-review-form"
                                  class="bg-white p-1 rounded-xl border border-gray-200 shadow-sm focus-within:ring-2 ring-emerald-500/20 focus-within:border-emerald-500 transition-all">
                                <input type="hidden" name="user_id" value="${sessionScope.userId}">
                                <input type="hidden" name="target_property_id" value="${prop.propertyId}">
                                <input type="hidden" name="target_name" value="${prop.title}">
                                <input type="hidden" name="rating" id="prop-review-rating" value="0">
                                <textarea name="review_text" class="w-full p-4 outline-none border-none resize-none bg-transparent text-slate-700" rows="3" placeholder="Share your experience..." required></textarea>
                                <div class="flex justify-between items-center p-3 border-t border-gray-100 bg-gray-50/50 rounded-b-xl">
                                    <div class="flex gap-1 text-gray-300 text-lg" id="prop-star-row" style="cursor:pointer;">
                                        <i class="fa-solid fa-star prop-star" data-val="1"></i>
                                        <i class="fa-solid fa-star prop-star" data-val="2"></i>
                                        <i class="fa-solid fa-star prop-star" data-val="3"></i>
                                        <i class="fa-solid fa-star prop-star" data-val="4"></i>
                                        <i class="fa-solid fa-star prop-star" data-val="5"></i>
                                    </div>
                                    <button type="submit" class="btn btn-primary px-6 py-2 rounded-lg text-sm bg-emerald-500 hover:bg-emerald-600 text-white font-semibold transition-all shadow-sm">
                                        Post Review
                                    </button>
                                </div>
                            </form>
                            <script>
                            (function(){
                                var stars = document.querySelectorAll('.prop-star');
                                var ratingInput = document.getElementById('prop-review-rating');
                                stars.forEach(function(star){
                                    star.addEventListener('mouseenter', function(){
                                        var v = parseInt(this.getAttribute('data-val'));
                                        stars.forEach(function(s){ s.style.color = parseInt(s.getAttribute('data-val')) <= v ? '#fbbf24' : '#d1d5db'; });
                                    });
                                    star.addEventListener('mouseleave', function(){
                                        var cur = parseInt(ratingInput.value);
                                        stars.forEach(function(s){ s.style.color = parseInt(s.getAttribute('data-val')) <= cur ? '#eab308' : '#d1d5db'; });
                                    });
                                    star.addEventListener('click', function(){
                                        var v = parseInt(this.getAttribute('data-val'));
                                        ratingInput.value = v;
                                        stars.forEach(function(s){ s.style.color = parseInt(s.getAttribute('data-val')) <= v ? '#eab308' : '#d1d5db'; });
                                    });
                                });
                                document.getElementById('property-review-form').addEventListener('submit', function(e){
                                    if(parseInt(ratingInput.value) < 1){
                                        e.preventDefault();
                                        document.getElementById('prop-star-row').style.outline = '2px solid #ef4444';
                                        document.getElementById('prop-star-row').style.borderRadius = '4px';
                                        alert('Please select a star rating before submitting.');
                                    }
                                });
                            })();
                            </script>
                        </c:when>
                        <c:otherwise>
                            <div class="bg-slate-50 p-6 rounded-xl border border-slate-200 text-center shadow-inner">
                                <p class="text-slate-600 mb-4 font-medium">Have you toured this property? Let others know your thoughts by leaving a verified review!</p>
                                <div class="flex justify-center gap-4">
                                    <a href="/login?redirect=${currentUrl}" class="bg-slate-800 hover:bg-emerald-500 text-white px-6 py-2 rounded-lg font-semibold transition-colors shadow-sm text-sm">Log In</a>
                                    <a href="/register?redirect=${currentUrl}" class="bg-emerald-50 text-emerald-600 border border-emerald-200 hover:bg-emerald-500 hover:text-white hover:border-emerald-500 px-6 py-2 rounded-lg font-semibold transition-colors shadow-sm text-sm">Create Account</a>
                                </div>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

            <!-- Right Column: Sticky Booking Widget -->
            <div class="w-full lg:w-1/3 static lg:sticky top-28">
                <div class="glass-card p-6 border-t-4 border-t-emerald-500 shadow-xl relative overflow-visible">
                    <div class="absolute top-0 right-0 p-4 opacity-5 pointer-events-none">
                        <i class="fa-solid fa-calendar-check text-8xl"></i>
                    </div>
                    <h3 class="text-2xl font-bold text-slate-800 mb-1">Book a Viewing</h3>
                    <p class="text-slate-500 text-sm mb-6 pb-4 border-b border-gray-100">Schedule your physical property viewing tour.</p>

                    <%-- ── SELLER blocked message ── --%>
                    <c:if test="${sessionScope.userRole == 'seller'}">
                        <div style="background:rgba(245,158,11,0.08);border:1.5px solid rgba(245,158,11,0.3);border-radius:12px;padding:20px;text-align:center;">
                            <i class="fa-solid fa-ban" style="color:#f59e0b;font-size:2rem;margin-bottom:10px;display:block;"></i>
                            <p style="color:#92400e;font-weight:700;font-size:0.95rem;margin-bottom:6px;">Sellers Cannot Book Viewings</p>
                            <p style="color:#b45309;font-size:0.82rem;margin-bottom:14px;">As a seller, you manage listings and respond to booking requests from buyers.</p>
                            <a href="/seller-dashboard?section=bookings" style="display:inline-block;background:#0f172a;color:white;padding:9px 20px;border-radius:9px;font-weight:700;font-size:0.85rem;text-decoration:none;">
                                <i class="fa-solid fa-calendar-check"></i> View My Booking Requests
                            </a>
                        </div>
                    </c:if>

                    <%-- ── Booking success/error messages ── --%>
                    <c:if test="${sessionScope.userRole != 'seller'}">
                        <c:if test="${param.booked == 'success'}">
                            <div class="bg-emerald-50 border border-emerald-200 text-emerald-700 px-4 py-3 rounded-xl mb-4 text-sm font-medium">
                                <i class="fa-solid fa-circle-check mr-2"></i> Appointment requested! Check your bookings for status.
                            </div>
                        </c:if>
                        <c:if test="${param.error == 'booking_failed'}">
                            <div class="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-xl mb-4 text-sm">
                                <i class="fa-solid fa-circle-xmark mr-2"></i> Booking failed. Please try again.
                            </div>
                        </c:if>
                        <c:if test="${param.error == 'missing_booking_info'}">
                            <div class="bg-red-50 border border-red-200 text-red-600 px-4 py-3 rounded-xl mb-4 text-sm">
                                <i class="fa-solid fa-circle-exclamation mr-2"></i> Please select both a date and time.
                            </div>
                        </c:if>

                    <form action="/book-appointment" method="POST" class="flex flex-col gap-5" id="booking-form" novalidate onsubmit="document.getElementById('book-submit-btn').innerHTML='<span>Requesting...</span>';document.getElementById('book-submit-btn').style.opacity='0.8';">
                        <input type="hidden" name="property_id" value="${prop.propertyId}">
                        <input type="hidden" name="viewing_type" value="physical">

                        <div class="grid grid-cols-2 gap-4">

                            <%-- ── Date: visible styled native input ── --%>
                            <div>
                                <label style="display:block;font-size:0.82rem;font-weight:700;color:#475569;margin-bottom:6px;">Date</label>
                                <input type="date" name="booking_date" id="booking_date"
                                       style="display:block;width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;background:#f8fafc;color:#334155;font-family:'Outfit',sans-serif;font-size:0.88rem;font-weight:500;min-height:44px;cursor:pointer;box-sizing:border-box;outline:none;color-scheme:dark;transition:border-color 0.2s,box-shadow 0.2s;"
                                       onfocus="this.style.borderColor='#10b981';this.style.boxShadow='0 0 0 3px rgba(16,185,129,0.1)';"
                                       onblur="this.style.borderColor=this.value?'#10b981':'#e2e8f0';this.style.boxShadow=this.value?'0 0 0 3px rgba(16,185,129,0.1)':'none';">
                            </div>

                            <%-- ── Time: native styled select ── --%>
                            <div>
                                <label style="display:block;font-size:0.82rem;font-weight:700;color:#475569;margin-bottom:6px;">Time</label>
                                <select name="booking_time" id="booking_time_select" data-ph-done="1"
                                        style="display:block;width:100%;padding:10px 14px;border:1.5px solid #e2e8f0;border-radius:10px;background:#f8fafc;color:#334155;font-family:'Outfit',sans-serif;font-size:0.88rem;font-weight:500;min-height:44px;cursor:pointer;box-sizing:border-box;outline:none;appearance:auto;transition:border-color 0.2s,box-shadow 0.2s;"
                                        onfocus="this.style.borderColor='#10b981';this.style.boxShadow='0 0 0 3px rgba(16,185,129,0.1)';"
                                        onblur="this.style.borderColor=this.value?'#10b981':'#e2e8f0';this.style.boxShadow=this.value?'0 0 0 3px rgba(16,185,129,0.1)':'none';">
                                    <option value="">Select time...</option>
                                    <option value="09:00:00">09:00 AM</option>
                                    <option value="09:30:00">09:30 AM</option>
                                    <option value="10:00:00">10:00 AM</option>
                                    <option value="10:30:00">10:30 AM</option>
                                    <option value="11:00:00">11:00 AM</option>
                                    <option value="11:30:00">11:30 AM</option>
                                    <option value="12:00:00">12:00 PM</option>
                                    <option value="12:30:00">12:30 PM</option>
                                    <option value="13:00:00">01:00 PM</option>
                                    <option value="13:30:00">01:30 PM</option>
                                    <option value="14:00:00">02:00 PM</option>
                                    <option value="14:30:00">02:30 PM</option>
                                    <option value="15:00:00">03:00 PM</option>
                                    <option value="15:30:00">03:30 PM</option>
                                    <option value="16:00:00">04:00 PM</option>
                                    <option value="16:30:00">04:30 PM</option>
                                    <option value="17:00:00">05:00 PM</option>
                                    <option value="17:30:00">05:30 PM</option>
                                    <option value="18:00:00">06:00 PM</option>
                                </select>
                            </div>
                        </div><!-- end grid -->

                        <div class="mt-2">
                        <c:choose>
                            <c:when test="${not empty sessionScope.userId}">
                                <button type="submit" id="book-submit-btn"
                                        class="w-full py-4 bg-slate-800 hover:bg-emerald-500 text-white font-bold rounded-xl shadow-lg hover:shadow-emerald-500/30 transition-all flex justify-center items-center gap-2 group border-none">
                                    <span>Request Appointment</span>
                                    <i class="fa-solid fa-arrow-right group-hover:translate-x-1 transition-transform"></i>
                                </button>
                            </c:when>
                            <c:otherwise>
                                <div class="flex flex-col gap-3">
                                    <a href="/login?redirect=${currentUrl}" class="w-full py-4 bg-slate-800 hover:bg-emerald-500 text-white font-bold rounded-xl transition-all flex justify-center items-center text-center shadow-sm">
                                        <i class="fa-solid fa-right-to-bracket mr-2"></i> Log In to Book
                                    </a>
                                    <a href="/register?redirect=${currentUrl}" class="w-full py-3 bg-emerald-50 border border-emerald-200 hover:bg-emerald-500 text-emerald-600 hover:text-white font-semibold rounded-xl transition-all flex justify-center items-center text-center text-sm">
                                        <i class="fa-solid fa-user-plus mr-2"></i> Create Account
                                    </a>
                                </div>
                            </c:otherwise>
                        </c:choose>
                        </div>
                    </form>

                    <%-- ── Save to Favourites ── --%>
                    <c:if test="${sessionScope.userRole == 'buyer' || sessionScope.userRole == 'both'}">
                        <div style="margin-top:16px;border-top:1px solid #f1f5f9;padding-top:16px;">
                            <c:choose>
                                <c:when test="${isSaved || param.saved == 'true'}">
                                    <div style="display:flex;align-items:center;justify-content:center;gap:8px;padding:12px;background:rgba(16,185,129,0.08);border:1px solid rgba(16,185,129,0.25);border-radius:12px;color:#065f46;font-weight:600;font-size:0.88rem;">
                                        <i class="fa-solid fa-heart" style="color:#10b981;"></i> Saved to your Favourites!
                                        <a href="/buyer-dashboard?section=saved" style="color:#059669;margin-left:6px;font-size:0.78rem;text-decoration:underline;">View Saved</a>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <form action="/buyer-dashboard/save-favourite" method="POST">
                                        <input type="hidden" name="property_id" value="${prop.propertyId}">
                                        <button type="submit" style="width:100%;padding:12px;background:transparent;border:1.5px solid rgba(239,68,68,0.35);border-radius:12px;color:#ef4444;font-weight:600;font-size:0.88rem;cursor:pointer;display:flex;align-items:center;justify-content:center;gap:8px;transition:all 0.2s;"
                                            onmouseover="this.style.background='rgba(239,68,68,0.06)'" onmouseout="this.style.background='transparent'">
                                            <i class="fa-regular fa-heart"></i> Save to Favourites
                                        </button>
                                    </form>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </c:if>

                    <style>
                        /* Override webkit date input buttons to match our theme */
                        #booking_date::-webkit-calendar-picker-indicator{cursor:pointer;opacity:0.6;filter:invert(0.3);}
                        #booking_date::-webkit-calendar-picker-indicator:hover{opacity:1;}
                        #booking_time_select option { background: #1e293b; color: #cbd5e1; }
                    </style>
                    <script>

                    /* ── form validation ── */
                    (function(){
                        var form=document.getElementById('booking-form');
                        if(!form)return;
                        form.addEventListener('submit',function(e){
                            if(!document.getElementById('booking_date').value){
                                e.preventDefault();
                                document.getElementById('booking_date').style.borderColor='#ef4444';
                                return;
                            }
                            if(!document.getElementById('booking_time_select').value){
                                e.preventDefault();
                                document.getElementById('booking_time_select').style.borderColor='#ef4444';
                                document.getElementById('booking_time_select').style.boxShadow='0 0 0 3px rgba(239,68,68,0.15)';
                                return;
                            }
                        });
                    })();
                    </script>
                    </c:if><%-- end non-seller block --%>


                    <!-- Listed By Section -->
                    <div class="mt-8 pt-6 border-t border-gray-100">
                        <p class="text-xs font-semibold uppercase text-slate-400 mb-4 tracking-wider">Listed By</p>
                        <div class="flex items-center gap-4 group cursor-pointer">
                            <div class="w-14 h-14 rounded-full bg-emerald-100 text-emerald-600 flex items-center justify-center font-bold text-xl shadow-sm group-hover:scale-105 transition-transform">
                                ${ownerName.substring(0,1)}
                            </div>
                            <div>
                                <strong class="text-slate-800 group-hover:text-emerald-600 transition-colors">${ownerName}</strong>
                                <div class="flex items-center gap-1 text-xs text-slate-500 mt-1">
                                    <i class="fa-solid fa-certificate text-emerald-500 text-[10px]"></i> Verified Seller
                                </div>
                            </div>
                            <button onclick="document.getElementById('messageModal').classList.remove('hidden')" class="ml-auto w-10 h-10 rounded-full border border-gray-200 flex items-center justify-center text-slate-400 group-hover:bg-emerald-50 group-hover:text-emerald-500 group-hover:border-emerald-200 transition-all">
                                <i class="fa-regular fa-envelope"></i>
                            </button>
                        </div>
                    </div>
                </div>
            </div>
            
        </div>
    </main>

    <!-- Message Modal -->
    <div id="messageModal" class="hidden fixed inset-0 z-[200] flex items-center justify-center p-4 bg-slate-900/60 backdrop-blur-sm">
        <div class="bg-white rounded-2xl shadow-2xl w-full max-w-lg overflow-hidden animate-in fade-in zoom-in duration-300">
            <div class="p-6 border-b flex justify-between items-center bg-slate-50">
                <h3 class="text-xl font-bold text-slate-800">Message to ${ownerName}</h3>
                <button onclick="document.getElementById('messageModal').classList.add('hidden')" class="text-slate-400 hover:text-slate-600"><i class="fa-solid fa-xmark text-xl"></i></button>
            </div>
            <form action="/send-agent-inquiry" method="POST" class="p-8">
                <input type="hidden" name="agentId" value="${prop.ownerId}">
                <input type="hidden" name="propertyId" value="${prop.propertyId}">
                <input type="hidden" name="fromProperty" value="true">
                <div class="mb-8">
                    <label class="block text-sm font-bold text-slate-700 mb-2">Your Message</label>
                    <textarea name="message" rows="5" class="w-full p-4 bg-slate-50 border border-slate-200 rounded-xl outline-none focus:ring-2 focus:ring-emerald-500 text-slate-600" placeholder="Hi ${ownerName}, I'm interested in..." required></textarea>
                </div>
                <button type="submit" class="w-full bg-emerald-500 text-white py-4 rounded-xl font-bold hover:bg-emerald-600 transition-all shadow-lg shadow-emerald-500/30">Send Message Now</button>
            </form>
        </div>
    </div>
    
    <!-- Success/Error Notifications -->
    <c:if test="${param.message_sent == 'true'}">
        <div class="fixed bottom-8 right-8 bg-emerald-600 text-white px-6 py-4 rounded-2xl shadow-2xl flex items-center gap-3 animate-bounce z-[200]">
            <i class="fa-solid fa-circle-check text-2xl"></i>
            <div>
                <p class="font-bold">Message Sent!</p>
                <p class="text-sm opacity-90">${ownerName} will get back to you soon.</p>
            </div>
        </div>
    </c:if>

</body>
<script>
// ─── Property Image Carousel ───
(function(){
    var slides = document.querySelectorAll('.carousel-slide');
    var thumbs = document.querySelectorAll('.carousel-thumb');
    var counter = document.getElementById('carousel-counter');
    var current = 0;
    var total = slides.length;
    var autoTimer = null;

    if (total <= 1) return;

    function showSlide(idx) {
        slides.forEach(function(s, i) {
            s.style.opacity = i === idx ? '1' : '0';
        });
        thumbs.forEach(function(t, i) {
            t.style.borderColor = i === idx ? '#10b981' : 'transparent';
        });
        if (counter) counter.textContent = idx + 1;
        current = idx;
    }

    window.carouselNext = function() {
        showSlide((current + 1) % total);
        resetAuto();
    };
    window.carouselPrev = function() {
        showSlide((current - 1 + total) % total);
        resetAuto();
    };
    window.carouselGoTo = function(idx) {
        showSlide(idx);
        resetAuto();
    };

    function startAuto() {
        autoTimer = setInterval(function() {
            showSlide((current + 1) % total);
        }, 4000);
    }
    function resetAuto() {
        clearInterval(autoTimer);
        startAuto();
    }
    startAuto();
})();
</script>
<script src="/js/global-select.js"></script>
</html>

