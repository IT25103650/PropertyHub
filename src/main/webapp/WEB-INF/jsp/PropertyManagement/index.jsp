<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>PropertyHub | Premium Real Estate Portal</title>
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
</head>
<body>

    <!-- Navigation -->
    <header class="navbar">
        <div class="logo">
            <i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span>
        </div>
        <nav class="nav-links">
            <a href="#home" class="active">Home</a>
            <a href="#properties">Properties</a>
            <a href="#agents">Sellers</a>
            <a href="#reviews">Reviews</a>
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
                    <a href="/login" class="btn btn-outline flex items-center justify-center font-semibold" style="text-decoration: none;">Log In</a>
                    <a href="/register" class="btn btn-primary flex items-center justify-center font-semibold" style="text-decoration: none;">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- Hero Section -->
    <section id="home" class="hero">
        <div class="hero-content">
            <span class="badge">Premium Real Estate</span>
            <h1>Find Your Dream Property With <span>PropertyHub</span></h1>
            <p>Discover a wide range of luxurious properties tailored to your lifestyle. Book a physical viewing today.</p>
            
            <!-- Property Search Bar -->
            <form action="/property/listing" method="GET" class="search-bar">
                <div class="search-input">
                    <i class="fa-solid fa-location-dot"></i>
                    <input type="text" name="location" placeholder="Location (e.g., Colombo, Kandy)">
                </div>
                <div class="search-input cs-wrap" id="cs-proptype" style="min-width: 180px; position: relative; cursor: pointer;" onclick="toggleCS('cs-proptype')">
                    <i class="fa-solid fa-house text-emerald-500" style="position:absolute;left:14px;top:50%;transform:translateY(-50%);pointer-events:none;"></i>
                    <input type="hidden" name="propertyType" id="cs-proptype-val" value="">
                    <span class="cs-label" style="display:flex;align-items:center;justify-content:space-between;width:100%;height:100%;padding:10px 14px 10px 36px;font-size:0.88rem;font-weight:500;color:#334155;cursor:pointer;user-select:none;">
                        <span class="cs-text">Property Type</span>
                        <i class="fa-solid fa-chevron-down cs-chev" style="font-size:0.7rem;color:#94a3b8;transition:transform 0.22s;"></i>
                    </span>
                    <div class="cs-panel" style="display:none;position:fixed;z-index:99999;background:#1e293b;border:1px solid rgba(255,255,255,0.08);border-radius:12px;box-shadow:0 16px 48px rgba(0,0,0,0.35);overflow:hidden;min-width:180px;">
                        <div class="cs-opt" data-val="" onclick="pickCS('cs-proptype',this);event.stopPropagation();">All Types</div>
                        <div class="cs-opt" data-val="house" onclick="pickCS('cs-proptype',this);event.stopPropagation();">House</div>
                        <div class="cs-opt" data-val="apartment" onclick="pickCS('cs-proptype',this);event.stopPropagation();">Apartment</div>
                        <div class="cs-opt" data-val="land" onclick="pickCS('cs-proptype',this);event.stopPropagation();">Land</div>
                        <div class="cs-opt" data-val="commercial" onclick="pickCS('cs-proptype',this);event.stopPropagation();">Commercial</div>
                    </div>
                </div>
                <div class="search-input relative w-full md:w-auto" style="min-width: 150px; padding: 0;">
                    <input type="checkbox" id="priceToggleCheckbox" class="peer hidden">
                    <label for="priceToggleCheckbox" class="flex items-center justify-between w-full h-full text-slate-700 bg-transparent select-none cursor-pointer" style="padding: 10px 20px;">
                        <span><i class="fa-solid fa-tags text-emerald-500 mr-2"></i> Price</span>
                        <i class="fa-solid fa-chevron-down text-xs ml-2"></i>
                    </label>
                    <!-- Popover Menu via CSS -->
                    <div class="absolute top-full mt-2 left-0 w-80 bg-white shadow-xl rounded-xl p-5 z-50 hidden peer-checked:block border border-gray-100 cursor-default" style="min-width: 320px;">
                        <div class="flex justify-between items-center mb-4">
                            <span class="text-sm font-bold text-slate-700">Enter Price Budget</span>
                        </div>
                        <div class="flex gap-2 mb-2 items-center">
                            <input type="number" name="minPrice" class="w-1/2 p-2 border border-gray-200 rounded-md text-sm outline-none focus:border-emerald-500" placeholder="Min (LKR)" min="0">
                            <div class="text-gray-400 font-bold">-</div>
                            <input type="number" name="maxPrice" class="w-1/2 p-2 border border-gray-200 rounded-md text-sm outline-none focus:border-emerald-500" placeholder="Max (LKR)" min="0">
                        </div>
                        <p class="text-xs text-gray-400 italic">Enter min and/or max price in LKR</p>
                    </div>
                </div>
                <button type="submit" class="btn btn-primary search-btn"><i class="fa-solid fa-magnifying-glass"></i> Search</button>
            </form>
        </div>
    </section>

    <!-- Featured Properties Section -->
    <section id="properties" class="section bg-light">
        <div class="container">
            <div class="section-header text-center">
                <h2>Featured Properties</h2>
                <p>Explore our handpicked selection of premium real estate</p>
            </div>
            
            <div class="property-grid">
                <c:choose>
                    <c:when test="${not empty featuredProperties}">
                        <c:forEach var="prop" items="${featuredProperties}">
                            <div class="property-card" onclick="window.location.href='/property-detail?id=${prop.property_id}'" style="cursor: pointer;">
                                <div class="property-img">
                                    <img src="${prop.img}" alt="${prop.title}">
                                    <span class="property-badge">${prop.listing_type eq 'rent' ? 'For Rent' : 'For Sale'}</span>
                                    <c:choose>
                                        <c:when test="${not empty sessionScope.userId}">
                                            <c:choose>
                                                <c:when test="${prop.isSaved}">
                                                    <a href="/buyer-dashboard/remove-favourite?id=${prop.property_id}" class="favorite-btn" style="position:absolute;top:10px;right:10px;color:#ef4444;" onclick="event.stopPropagation()" title="Remove from Favourites"><i class="fa-solid fa-heart"></i></a>
                                                </c:when>
                                                <c:otherwise>
                                                    <form action="/buyer-dashboard/save-favourite" method="POST" style="position:absolute;top:10px;right:10px;margin:0;">
                                                        <input type="hidden" name="property_id" value="${prop.property_id}">
                                                        <button type="submit" class="favorite-btn" onclick="event.stopPropagation()" title="Save to Favourites"><i class="fa-regular fa-heart"></i></button>
                                                    </form>
                                                </c:otherwise>
                                            </c:choose>
                                        </c:when>
                                        <c:otherwise>
                                            <button class="favorite-btn" style="position:absolute;top:10px;right:10px;" onclick="event.stopPropagation(); window.location.href='/login?redirect=/'" title="Login to save"><i class="fa-regular fa-heart"></i></button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="property-content">
                                    <div class="property-price">${prop.priceStr}</div>
                                    <h3 class="property-title">${prop.title}</h3>
                                    <p class="property-location"><i class="fa-solid fa-location-dot"></i> ${prop.location}</p>
                                    <div class="property-features">
                                        <span><i class="fa-solid fa-bed"></i> ${prop.bedrooms} Beds</span>
                                        <span><i class="fa-solid fa-bath"></i> ${prop.bathrooms} Baths</span>
                                        <span><i class="fa-solid fa-vector-square"></i> ${prop.sqft} sqft</span>
                                    </div>
                                    <div class="property-footer">
                                        <span class="seller-info"><i class="fa-solid fa-user-tie"></i> ${prop.agent}</span>
                                        <button class="btn btn-primary btn-sm" onclick="event.stopPropagation(); window.location.href='/property-detail?id=${prop.property_id}'">View Details</button>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <div class="col-span-full text-center py-12">
                            <p>No featured properties available.</p>
                        </div>
                    </c:otherwise>
                </c:choose>
</div>
            <div class="text-center mt-4">
                <a href="/property/listing" class="btn btn-outline" style="margin-top: 30px; display: inline-block; text-decoration: none;">View All Properties <i class="fa-solid fa-arrow-right"></i></a>
            </div>
        </div>
    </section>

    <!-- Booking & Viewing Process Section -->
    <section id="booking-process" class="section">
        <div class="container">
            <div class="section-header text-center">
                <h2>Seamless Property Viewing</h2>
                <p>Our completely integrated booking system makes property viewing easier than ever.</p>
            </div>
            
            <div class="process-steps">
                <div class="step">
                    <div class="step-icon"><i class="fa-solid fa-magnifying-glass-location"></i></div>
                    <h3>1. Find Property</h3>
                    <p>Search through our extensive list of premium properties across the country.</p>
                </div>
                <div class="step">
                    <div class="step-icon"><i class="fa-solid fa-calendar-check"></i></div>
                    <h3>2. Book Appointment</h3>
                    <p>Schedule a physical viewing directly through our online booking system.</p>
                </div>
                <div class="step">
                    <div class="step-icon"><i class="fa-solid fa-house-user"></i></div>
                    <h3>3. Attend Viewing</h3>
                    <p>Meet with the seller or agent, view the property fully, and make your decision.</p>
                </div>
                <div class="step">
                    <div class="step-icon"><i class="fa-solid fa-handshake"></i></div>
                    <h3>4. Close Deal</h3>
                    <p>Finalize the purchase or rental agreement seamlessly.</p>
                </div>
            </div>
        </div>
    </section>

    <!-- Our Agents Section -->
    <section id="agents" class="section">
        <div class="container mx-auto px-4 max-w-6xl">
            <div class="section-header text-center mb-12">
                <h2 class="text-3xl font-bold text-slate-800">Meet Our Top Agents</h2>
                <p class="text-slate-500 mt-2">Connect with experienced professionals to find your perfect home.</p>
            </div>
            
            <div class="grid grid-cols-1 lg:grid-cols-2 gap-8">
                <c:forEach var="agent" items="${agentsList}">
                    <div class="bg-white rounded-xl shadow-sm border border-gray-100 overflow-hidden group hover:shadow-lg transition-all duration-300 flex flex-col sm:flex-row">
                        <div class="w-full sm:w-2/5 md:w-1/3 min-h-[200px] sm:min-h-full overflow-hidden relative">
                            <img src="${empty agent.profile_image_url ? 'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=800' : agent.profile_image_url}" alt="${agent.first_name} ${agent.last_name}" class="absolute inset-0 w-full h-full object-cover group-hover:scale-105 transition-transform duration-500">
                        </div>
                        <div class="w-full sm:w-3/5 md:w-2/3 p-6 flex flex-col justify-center text-left">
                            <h3 class="text-2xl font-bold text-slate-800 mb-1">${agent.first_name} ${agent.last_name}</h3>
                            <p class="text-emerald-600 font-medium text-sm mb-3">Real Estate Agent</p>
                            <div class="flex items-center gap-1 mb-6">
                                <c:forEach var="i" begin="1" end="5">
                                    <i class="fa-solid fa-star ${i <= agent.intRating ? 'text-yellow-400' : 'text-slate-200'}"></i>
                                </c:forEach>
                                <span class="text-slate-500 text-xs ml-1">(${agent.reviewCount} Reviews) - ${agent.avgRating}/5</span>
                            </div>
                            <div class="mt-auto">
                                <a href="/agents?id=${agent.user_id}" class="inline-block bg-slate-50 text-slate-700 hover:bg-emerald-500 hover:text-white px-6 py-2 rounded-lg font-semibold transition-colors border border-gray-200 hover:border-emerald-500">View Profile</a>
                            </div>
                        </div>
                    </div>
                </c:forEach>
            </div>
        </div>
    </section>

    <!-- Reviews Section -->
    <section id="reviews" class="section bg-light">
        <div class="container">
            <div class="section-header text-center">
                <h2>What Our Clients Say</h2>
                <p>Real feedback from our verified buyers and sellers.</p>
            </div>
            
            <div class="review-grid">
                <c:choose>
                    <c:when test="${not empty siteReviews}">
                        <c:forEach var="rev" items="${siteReviews}">
                            <div class="review-card">
                                <div class="review-stars">
                                    <c:forEach begin="1" end="5" var="i">
                                        <i class="fa-solid fa-star" style="color: ${i <= rev.rating ? '#fbbf24' : '#cbd5e1'};"></i>
                                    </c:forEach>
                                </div>
                                <p class="review-text">"${rev.review_text}"</p>
                                <div class="review-author">
                                    <c:choose>
                                        <c:when test="${not empty rev.profile_image_url}">
                                            <div class="author-avatar" style="background-image: url('${rev.profile_image_url}'); background-size: cover; background-position: center; border-radius: 50%; width: 40px; height: 40px; border: 2px solid #10b981;"></div>
                                        </c:when>
                                        <c:otherwise>
                                            <div class="author-avatar" style="background-color: var(--color-primary); color: white; display: flex; align-items: center; justify-content: center; font-weight: bold; border-radius: 50%; width: 40px; height: 40px;">
                                                ${rev.first_name.substring(0,1)}${not empty rev.last_name ? rev.last_name.substring(0,1) : ''}
                                            </div>
                                        </c:otherwise>
                                    </c:choose>
                                    <div class="author-info">
                                        <h4>${rev.first_name} ${not empty rev.last_name ? rev.last_name.substring(0,1) += '.' : ''}</h4>
                                        <span style="text-transform: capitalize;">Verified ${rev.role}</span>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </c:when>
                    <c:otherwise>
                        <p class="text-center text-slate-500 col-span-full">No reviews yet. Be the first to share your experience!</p>
                    </c:otherwise>
                </c:choose>
            </div>

            <!-- Leave a Review Form -->
            <div class="max-w-2xl mx-auto mt-16 bg-white p-8 rounded-2xl shadow-sm border border-gray-100">
                <h3 class="text-2xl font-bold text-slate-800 mb-6 text-center">Share Your Experience</h3>
                
                <c:if test="${param.site_review_submitted == 'true'}">
                    <div class="bg-emerald-50 text-emerald-700 px-4 py-3 rounded-xl mb-6 text-sm font-medium text-center border border-emerald-200">
                        <i class="fa-solid fa-circle-check mr-2"></i> Thank you! Your review has been submitted and is pending approval.
                    </div>
                </c:if>

                <c:choose>
                    <c:when test="${not empty sessionScope.userId}">
                        <form action="/submit-site-review" method="POST" id="site-review-form">
                            <div class="mb-4 text-center">
                                <label class="block text-sm font-bold text-slate-700 mb-2">Rating</label>
                                <div class="flex justify-center gap-2 text-2xl text-slate-200" id="site-star-row" style="cursor:pointer;">
                                    <i class="fa-solid fa-star site-star" data-val="1"></i>
                                    <i class="fa-solid fa-star site-star" data-val="2"></i>
                                    <i class="fa-solid fa-star site-star" data-val="3"></i>
                                    <i class="fa-solid fa-star site-star" data-val="4"></i>
                                    <i class="fa-solid fa-star site-star" data-val="5"></i>
                                </div>
                                <input type="hidden" name="rating" id="site-review-rating" value="0">
                            </div>
                            <div class="mb-6">
                                <label class="block text-sm font-bold text-slate-700 mb-2">Your Review</label>
                                <textarea name="reviewText" rows="4" class="w-full p-4 bg-slate-50 border border-slate-200 rounded-xl focus:ring-2 focus:ring-emerald-500 outline-none text-slate-600" placeholder="Tell us about your experience with PropertyHub..." required></textarea>
                            </div>
                            <button type="submit" class="w-full bg-slate-800 text-white py-3 rounded-xl font-bold hover:bg-slate-900 transition-all shadow-lg shadow-slate-200">Submit Review</button>
                        </form>
                        <script>
                        (function(){
                            var stars = document.querySelectorAll('.site-star');
                            var ratingInput = document.getElementById('site-review-rating');
                            stars.forEach(function(star){
                                star.addEventListener('mouseenter', function(){
                                    var v = parseInt(this.getAttribute('data-val'));
                                    stars.forEach(function(s){ s.style.color = parseInt(s.getAttribute('data-val')) <= v ? '#fbbf24' : '#e2e8f0'; });
                                });
                                star.addEventListener('mouseleave', function(){
                                    var cur = parseInt(ratingInput.value);
                                    stars.forEach(function(s){ s.style.color = parseInt(s.getAttribute('data-val')) <= cur ? '#eab308' : '#e2e8f0'; });
                                });
                                star.addEventListener('click', function(){
                                    var v = parseInt(this.getAttribute('data-val'));
                                    ratingInput.value = v;
                                    stars.forEach(function(s){ s.style.color = parseInt(s.getAttribute('data-val')) <= v ? '#eab308' : '#e2e8f0'; });
                                });
                            });
                            document.getElementById('site-review-form').addEventListener('submit', function(e){
                                if(parseInt(ratingInput.value) < 1){
                                    e.preventDefault();
                                    alert('Please select a star rating before submitting.');
                                }
                            });
                        })();
                        </script>
                    </c:when>
                    <c:otherwise>
                        <div class="text-center py-6">
                            <p class="text-slate-600 mb-6 font-medium">Please log in or create an account to share your experience with us.</p>
                            <div class="flex justify-center gap-4">
                                <a href="/login?redirect=/#reviews" class="bg-slate-800 hover:bg-emerald-500 text-white px-8 py-3 rounded-lg font-bold transition-colors shadow-sm">Log In</a>
                                <a href="/register?redirect=/#reviews" class="bg-emerald-50 border border-emerald-200 text-emerald-600 hover:bg-emerald-500 hover:text-white px-8 py-3 rounded-lg font-bold transition-colors shadow-sm">Sign Up</a>
                            </div>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer">
        <div class="container">
            <div class="footer-grid">
                <div class="footer-col">
                    <h3>Property<span>Hub</span></h3>
                    <p>The premium real estate listings portal connecting buyers, sellers, and agents seamlessly.</p>
                    <div class="social-links">
                        <a href="#"><i class="fa-brands fa-facebook-f"></i></a>
                        <a href="#"><i class="fa-brands fa-twitter"></i></a>
                        <a href="#"><i class="fa-brands fa-instagram"></i></a>
                        <a href="#"><i class="fa-brands fa-linkedin-in"></i></a>
                    </div>
                </div>
                <div class="footer-col">
                    <h4>Quick Links</h4>
                    <ul>
                        <li><a href="#home">Home</a></li>
                        <li><a href="#properties">Properties</a></li>
                        <li><a href="#agents">Agents</a></li>
                        <li><a href="#reviews">Reviews</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Portals</h4>
                    <ul>
                        <li><a href="/buyer-dashboard">Buyer Dashboard</a></li>
                        <li><a href="/seller-dashboard">Seller Dashboard</a></li>
                        <li><a href="/admin-dashboard">Admin Dashboard</a></li>
                    </ul>
                </div>
                <div class="footer-col">
                    <h4>Contact Us</h4>
                    <ul>
                        <li><i class="fa-solid fa-location-dot"></i> 123 Property Ave, Colombo, LK</li>
                        <li><i class="fa-solid fa-phone"></i> +94 112 345 678</li>
                        <li><i class="fa-solid fa-envelope"></i> info@propertyhub.lk</li>
                    </ul>
                </div>
            </div>
            <div class="footer-bottom">
                <p>&copy; 2026 PropertyHub. All rights reserved.</p>
            </div>
        </div>
    </footer>

<style>
.cs-opt { padding: 11px 18px; font-size: 0.86rem; font-family: 'Outfit', sans-serif; color: #cbd5e1; cursor: pointer; transition: background 0.15s, color 0.15s; border-bottom: 1px solid rgba(255,255,255,0.05); }
.cs-opt:last-child { border-bottom: none; }
.cs-opt:hover { background: rgba(255,255,255,0.07); color: #fff; }
.cs-opt.cs-sel { color: #10b981; font-weight: 600; background: rgba(16,185,129,0.1); }
.cs-wrap.cs-open .cs-chev { transform: rotate(180deg) !important; color: #10b981 !important; }
</style>
<script>
(function(){
    function closeAllCS(exceptId) {
        document.querySelectorAll('.cs-wrap.cs-open').forEach(function(w) {
            if (!exceptId || w.id !== exceptId) {
                w.classList.remove('cs-open');
                var p = w.querySelector('.cs-panel'); if(p) p.style.display='none';
            }
        });
    }
    window.toggleCS = function(id) {
        var w = document.getElementById(id);
        if (!w) return;
        if (w.classList.contains('cs-open')) { closeAllCS(); return; }
        closeAllCS(id);
        var label = w.querySelector('.cs-label');
        var panel = w.querySelector('.cs-panel');
        var rect  = label.getBoundingClientRect();
        panel.style.top   = (rect.bottom + 6) + 'px';
        panel.style.left  = rect.left + 'px';
        panel.style.width = rect.width + 'px';
        panel.style.display = 'block';
        w.classList.add('cs-open');
    };
    window.pickCS = function(id, opt) {
        var w = document.getElementById(id);
        w.querySelectorAll('.cs-opt').forEach(function(o){ o.classList.remove('cs-sel'); });
        opt.classList.add('cs-sel');
        var textEl = w.querySelector('.cs-text');
        if (textEl) textEl.textContent = opt.textContent;
        var hidden = w.querySelector('input[type=hidden]');
        if (hidden) hidden.value = opt.dataset.val;
        closeAllCS();
    };
    document.addEventListener('click', function(e) {
        if (!e.target.closest('.cs-wrap')) closeAllCS();
    });
})();
</script>
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
<script src="/js/global-select.js"></script>
</html>
