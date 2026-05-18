<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>All Properties | PropertyHub</title>
    <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap" rel="stylesheet">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="/css/styles.css">
    <script src="https://cdn.tailwindcss.com"></script>
</head>
<body class="bg-slate-50 text-slate-800 font-['Outfit'] antialiased">
    <!-- Navigation -->
    <header class="navbar bg-white shadow-sm sticky top-0 z-50">
        <div class="logo">
            <a href="/" style="text-decoration:none; color:inherit;">
                <i class="fa-solid fa-house-chimney-window"></i> Property<span>Hub</span>
            </a>
        </div>
        <nav class="nav-links">
            <a href="/">Home</a>
            <a href="/property/listing" class="active">Properties</a>
            <a href="/agents">Sellers</a>
        </nav>
        <div class="nav-actions" style="display:flex; gap:10px; align-items:center;">
            <c:choose>
                <c:when test="${not empty sessionScope.userId}">
                    <c:if test="${sessionScope.userRole == 'buyer' || sessionScope.userRole == 'both'}">
                        <a href="/buyer-dashboard" class="btn btn-outline" style="text-decoration:none;"><i class="fa-solid fa-user"></i> Dashboard</a>
                    </c:if>
                    <c:if test="${sessionScope.userRole == 'seller'}">
                        <a href="/seller-dashboard" class="btn btn-outline" style="text-decoration:none;"><i class="fa-solid fa-building"></i> Dashboard</a>
                    </c:if>
                    <a href="/logout" style="color:#ef4444; font-size:0.9rem; text-decoration:none;"><i class="fa-solid fa-right-from-bracket"></i> Logout</a>
                </c:when>
                <c:otherwise>
                    <a href="/login" class="btn btn-outline" style="text-decoration:none;">Log In</a>
                    <a href="/register" class="btn btn-primary" style="text-decoration:none;">Sign Up</a>
                </c:otherwise>
            </c:choose>
        </div>
    </header>

    <!-- Page Header & Filters -->
    <section class="bg-slate-900 py-16 text-white text-center">
        <div class="container mx-auto px-4">
            <h1 class="text-4xl md:text-5xl font-bold mb-4">Explore Properties</h1>
            <p class="text-slate-300 text-lg mb-8">Discover the perfect property that matches your criteria.</p>
            
            <div id="filter-container" class="inline-block bg-slate-800/50 backdrop-blur-md p-6 rounded-2xl border border-slate-700 shadow-xl text-left">
                <h3 class="text-emerald-400 font-bold mb-3 flex items-center gap-2"><i class="fa-solid fa-filter"></i> Active Filters</h3>
                <div class="flex flex-wrap gap-4 text-sm font-medium">
                    <span class="bg-slate-900 px-4 py-2 rounded-lg border border-slate-700">
                        <i class="fa-solid fa-location-dot text-slate-400 mr-2"></i> 
                        <%= request.getAttribute("location") != null && !request.getAttribute("location").toString().isEmpty() ? request.getAttribute("location") : "All Locations" %>
                    </span>
                    <span class="bg-slate-900 px-4 py-2 rounded-lg border border-slate-700">
                        <i class="fa-solid fa-house text-slate-400 mr-2"></i> 
                        <%= request.getAttribute("propertyType") != null && !request.getAttribute("propertyType").toString().isEmpty() ? request.getAttribute("propertyType").toString().substring(0,1).toUpperCase() + request.getAttribute("propertyType").toString().substring(1) : "Any Type" %>
                    </span>
                    <span class="bg-slate-900 px-4 py-2 rounded-lg border border-slate-700">
                        <i class="fa-solid fa-tag text-slate-400 mr-2"></i> 
                        <%= request.getAttribute("minPrice") != null && !request.getAttribute("minPrice").toString().isEmpty() ? request.getAttribute("minPrice") + " LKR" : "No Min" %> - 
                        <%= request.getAttribute("maxPrice") != null && !request.getAttribute("maxPrice").toString().isEmpty() ? request.getAttribute("maxPrice") + " LKR" : "No Max" %>
                    </span>
                </div>
                <div class="mt-4 text-center">
                    <button id="changeSearchBtn" class="text-emerald-400 hover:text-emerald-300 text-sm font-bold transition-colors underline cursor-pointer bg-transparent border-none">Change Search Criteria</button>
                </div>
            </div>
        </div>
    </section>

    <!-- Properties Grid -->
    <section class="section py-16" id="grid-container">
        <div class="container mx-auto px-4 max-w-7xl">
            <div class="property-grid">
                <c:choose>
                    <c:when test="${not empty properties}">
                        <c:forEach var="prop" items="${properties}">
                            <div class="property-card" onclick="window.location.href='/property-detail?id=${prop.property_id}'" style="cursor: pointer;">
                                <div class="property-img">
                                    <img src="${prop.img}" alt="${prop.title}">
                                    <span class="property-badge" style="${prop.badgeColor}">${prop.badge}</span>
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
                                            <button class="favorite-btn" style="position:absolute;top:10px;right:10px;" onclick="event.stopPropagation(); window.location.href='/login?redirect=/property/listing'" title="Login to save"><i class="fa-regular fa-heart"></i></button>
                                        </c:otherwise>
                                    </c:choose>
                                </div>
                                <div class="property-content">
                                    <div class="property-price">${prop.priceStr}</div>
                                    <h3 class="property-title">${prop.title}</h3>
                                    <p class="property-location"><i class="fa-solid fa-location-dot"></i> ${prop.location}</p>
                                    <div class="property-features">
                                        <span><i class="fa-solid fa-bed"></i> ${prop.beds} Beds</span>
                                        <span><i class="fa-solid fa-bath"></i> ${prop.baths} Baths</span>
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
                        <div class="col-span-full text-center py-12 bg-white rounded-xl shadow-sm border border-slate-100">
                            <i class="fa-solid fa-magnifying-glass text-4xl text-slate-300 mb-4"></i>
                            <h3 class="text-xl font-bold text-slate-700">No Properties Found</h3>
                            <p class="text-slate-500 mt-2">Try adjusting your filters to see more results.</p>
                            <a href="/property/listing" class="mt-4 inline-block text-emerald-500 font-semibold hover:underline">Clear Filters</a>
                        </div>
                    </c:otherwise>
                </c:choose>
            </div>
        </div>
    </section>

    <!-- Footer -->
    <footer class="footer bg-slate-900 text-white py-12">
        <div class="container mx-auto px-4 text-center">
            <h3 class="text-2xl font-bold mb-4">Property<span class="text-emerald-500">Hub</span></h3>
            <p class="text-slate-400 mb-6">Your premium real estate destination.</p>
            <p class="text-slate-500 text-sm">&copy; 2026 PropertyHub. All rights reserved.</p>
        </div>
    </footer>

    <!-- AJAX Search Modal -->
    <div id="searchModal" class="fixed inset-0 z-[9999] flex items-center justify-center hidden opacity-0 transition-opacity duration-300">
        <!-- Backdrop -->
        <div class="absolute inset-0 bg-slate-900/80 backdrop-blur-sm" onclick="closeSearchModal()"></div>
        
        <!-- Modal Content -->
        <div class="relative bg-slate-800 rounded-2xl shadow-2xl border border-slate-700 w-full max-w-3xl m-4 transform scale-95 transition-transform duration-300" id="searchModalContent">
            <div class="flex justify-between items-center p-6 border-b border-slate-700">
                <h2 class="text-2xl font-bold text-white flex items-center gap-2"><i class="fa-solid fa-magnifying-glass text-emerald-500"></i> Update Search Criteria</h2>
                <button onclick="closeSearchModal()" class="text-slate-400 hover:text-white transition-colors text-xl">
                    <i class="fa-solid fa-xmark"></i>
                </button>
            </div>
            
            <form id="ajaxSearchForm" onsubmit="handleAjaxSearch(event)" class="p-6">
                <div class="grid grid-cols-1 md:grid-cols-2 gap-6 mb-8">
                    <!-- Location -->
                    <div>
                        <label class="block text-slate-300 text-sm font-semibold mb-2">Location</label>
                        <div class="relative">
                            <i class="fa-solid fa-location-dot absolute left-4 top-3.5 text-slate-400"></i>
                            <input type="text" name="location" value="${location}" placeholder="City, Neighborhood, etc." 
                                   class="w-full bg-slate-900 border border-slate-700 text-white rounded-lg pl-11 pr-4 py-3 focus:outline-none focus:border-emerald-500 focus:ring-1 focus:ring-emerald-500 transition-all">
                        </div>
                    </div>
                    
                    <!-- Property Type -->
                    <div>
                        <label class="block text-slate-300 text-sm font-semibold mb-2">Property Type</label>
                        <div class="relative">
                            <i class="fa-solid fa-house absolute left-4 top-3.5 text-slate-400"></i>
                            <select name="propertyType" class="w-full bg-slate-900 border border-slate-700 text-white rounded-lg pl-11 pr-4 py-3 appearance-none focus:outline-none focus:border-emerald-500 transition-all cursor-pointer">
                                <option value="" ${empty propertyType ? 'selected' : ''}>All Types</option>
                                <option value="house" ${propertyType == 'house' ? 'selected' : ''}>House</option>
                                <option value="apartment" ${propertyType == 'apartment' ? 'selected' : ''}>Apartment</option>
                                <option value="land" ${propertyType == 'land' ? 'selected' : ''}>Land</option>
                                <option value="commercial" ${propertyType == 'commercial' ? 'selected' : ''}>Commercial</option>
                            </select>
                            <i class="fa-solid fa-chevron-down absolute right-4 top-4 text-slate-400 pointer-events-none text-xs"></i>
                        </div>
                    </div>

                    <!-- Listing Type -->
                    <div>
                        <label class="block text-slate-300 text-sm font-semibold mb-2">Listing Type</label>
                        <div class="relative">
                            <i class="fa-solid fa-tags absolute left-4 top-3.5 text-slate-400"></i>
                            <select name="listingType" class="w-full bg-slate-900 border border-slate-700 text-white rounded-lg pl-11 pr-4 py-3 appearance-none focus:outline-none focus:border-emerald-500 transition-all cursor-pointer">
                                <option value="" ${empty listingType ? 'selected' : ''}>Any</option>
                                <option value="sale" ${listingType == 'sale' ? 'selected' : ''}>For Sale</option>
                                <option value="rent" ${listingType == 'rent' ? 'selected' : ''}>For Rent</option>
                            </select>
                            <i class="fa-solid fa-chevron-down absolute right-4 top-4 text-slate-400 pointer-events-none text-xs"></i>
                        </div>
                    </div>
                    
                    <!-- Price Range -->
                    <div>
                        <label class="block text-slate-300 text-sm font-semibold mb-2">Price Range (LKR)</label>
                        <div class="flex items-center gap-3">
                            <input type="number" name="minPrice" value="${minPrice}" placeholder="Min" 
                                   class="w-full bg-slate-900 border border-slate-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-emerald-500 transition-all">
                            <span class="text-slate-500">-</span>
                            <input type="number" name="maxPrice" value="${maxPrice}" placeholder="Max" 
                                   class="w-full bg-slate-900 border border-slate-700 text-white rounded-lg px-4 py-3 focus:outline-none focus:border-emerald-500 transition-all">
                        </div>
                    </div>

                    <!-- Min Bedrooms -->
                    <div>
                        <label class="block text-slate-300 text-sm font-semibold mb-2">Min Bedrooms</label>
                        <div class="relative">
                            <i class="fa-solid fa-bed absolute left-4 top-3.5 text-slate-400"></i>
                            <select name="minBeds" class="w-full bg-slate-900 border border-slate-700 text-white rounded-lg pl-11 pr-4 py-3 appearance-none focus:outline-none focus:border-emerald-500 transition-all cursor-pointer">
                                <option value="" ${empty minBeds ? 'selected' : ''}>Any</option>
                                <option value="1" ${minBeds == '1' ? 'selected' : ''}>1+</option>
                                <option value="2" ${minBeds == '2' ? 'selected' : ''}>2+</option>
                                <option value="3" ${minBeds == '3' ? 'selected' : ''}>3+</option>
                                <option value="4" ${minBeds == '4' ? 'selected' : ''}>4+</option>
                                <option value="5" ${minBeds == '5' ? 'selected' : ''}>5+</option>
                            </select>
                            <i class="fa-solid fa-chevron-down absolute right-4 top-4 text-slate-400 pointer-events-none text-xs"></i>
                        </div>
                    </div>
                </div>
                
                <div class="flex justify-end gap-3 pt-6 border-t border-slate-700">
                    <button type="button" onclick="closeSearchModal()" class="px-6 py-3 rounded-lg font-semibold text-slate-300 bg-transparent hover:bg-slate-700 transition-colors">
                        Cancel
                    </button>
                    <button type="submit" id="searchSubmitBtn" class="px-8 py-3 rounded-lg font-bold text-white shadow-lg transition-all" style="background: linear-gradient(135deg, #10b981, #059669);">
                        <i class="fa-solid fa-search mr-2"></i> Apply Filters
                    </button>
                </div>
            </form>
        </div>
    </div>

    <!-- AJAX Script -->
    <script>
        const modal = document.getElementById('searchModal');
        const modalContent = document.getElementById('searchModalContent');

        function openSearchModal() {
            modal.classList.remove('hidden');
            setTimeout(() => {
                modal.classList.remove('opacity-0');
                modalContent.classList.remove('scale-95');
            }, 10);
            document.body.style.overflow = 'hidden';
        }

        function closeSearchModal() {
            modal.classList.add('opacity-0');
            modalContent.classList.add('scale-95');
            setTimeout(() => {
                modal.classList.add('hidden');
                document.body.style.overflow = '';
            }, 300);
        }

        // Use event delegation so the button still works after AJAX replaces filter-container innerHTML
        document.addEventListener('click', function(e) {
            if (e.target && (e.target.id === 'changeSearchBtn' || e.target.closest('#changeSearchBtn'))) {
                openSearchModal();
            }
        });

        async function handleAjaxSearch(event) {
            event.preventDefault();
            
            const form = event.target;
            const btn = document.getElementById('searchSubmitBtn');
            const originalBtnHtml = btn.innerHTML;
            
            btn.innerHTML = '<i class="fa-solid fa-spinner fa-spin mr-2"></i> Searching...';
            btn.disabled = true;
            btn.style.opacity = '0.8';

            const gridContainer = document.getElementById('grid-container');
            gridContainer.style.opacity = '0.5';
            gridContainer.style.pointerEvents = 'none';

            try {
                const formData = new FormData(form);
                const searchParams = new URLSearchParams(formData);
                const fetchUrl = '/property/listing?' + searchParams.toString();

                const response = await fetch(fetchUrl);
                if (!response.ok) throw new Error('Network response was not ok');
                
                const htmlText = await response.text();
                const parser = new DOMParser();
                const doc = parser.parseFromString(htmlText, 'text/html');
                
                const newFilters = doc.getElementById('filter-container');
                const newGrid = doc.getElementById('grid-container');
                
                if (newFilters && newGrid) {
                    document.getElementById('filter-container').innerHTML = newFilters.innerHTML;
                    document.getElementById('grid-container').innerHTML = newGrid.innerHTML;
                    window.history.pushState({}, '', fetchUrl);
                } else {
                    console.error('Could not find required elements in the response.');
                }
            } catch (error) {
                console.error('AJAX Search Error:', error);
                alert('Failed to update results. Please try again.');
            } finally {
                btn.innerHTML = originalBtnHtml;
                btn.disabled = false;
                btn.style.opacity = '1';
                gridContainer.style.opacity = '1';
                gridContainer.style.pointerEvents = 'auto';
                closeSearchModal();
            }
        }
    </script>
</body>
</html>
