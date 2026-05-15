-- ============================================================
-- PropertyHub - Seed Data (MySQL Compatible)
-- ============================================================

-- Demo Users (admin, buyer, sellers)
INSERT IGNORE INTO Users (user_id, first_name, last_name, email, password_hash, role, phone, profile_image_url) VALUES
(1, 'System',  'Admin',    'admin@propertyhub.lk',   'admin123',   'admin',  NULL,          NULL),
(2, 'John',    'Buyer',    'john@example.com',        'buyer123',   'buyer',  NULL,          NULL),
(3, 'Dilani',  'Seller',   'dilani@seller.com',       'dilani123',  'seller', NULL,          'https://images.unsplash.com/photo-1580489944761-15a19d654956?w=800&auto=format&fit=crop&q=80'),
(4, 'Sarah',   'Jenkins',  'sarah@propertyhub.lk',   'sarah123',   'seller', '0771234567',  'https://images.unsplash.com/photo-1573496359142-b8d87734a5a2?w=800&auto=format&fit=crop&q=80'),
(5, 'Michael', 'Fernando', 'michael@propertyhub.lk', 'michael123', 'seller', '0719876543',  'https://images.unsplash.com/photo-1560250097-0b93528c311a?w=800&auto=format&fit=crop&q=80');

-- Fix AUTO_INCREMENT after manual inserts (MySQL syntax)
ALTER TABLE Users AUTO_INCREMENT = 10;

-- Demo Properties
INSERT IGNORE INTO Properties (property_id, owner_id, title, description, property_type, listing_type, price, location, bedrooms, bathrooms, sqft, status) VALUES
(1, 3, 'Modern Luxury Villa',     'A stunning, newly constructed modern luxury villa in the heart of Colombo 07.',  'house',      'sale', 85000000.00,  'Colombo 07',    4, 3, 3200, 'available'),
(2, 3, 'Skyline Penthouse',       'Premium penthouse with panoramic views of Nawala.',                               'apartment',  'sale', 120000000.00, 'Nawala',         3, 3, 2500, 'available'),
(3, 3, 'Cozy Family House',       'Spacious family house in serene Kandy surroundings.',                             'house',      'sale', 45000000.00,  'Kandy',          5, 2, 2800, 'available'),
(4, 4, 'Oceanfront Condo',        'Luxurious oceanfront condo with breathtaking views.',                             'apartment',  'sale', 150000000.00, 'Mount Lavinia',  2, 2, 1500, 'available'),
(5, 5, 'Suburban Townhouse',      'Perfect for a small family, located in a quiet neighborhood.',                    'house',      'rent', 120000.00,    'Malabe',         3, 2, 1800, 'available'),
(6, 4, 'Downtown Loft',           'Chic loft in the city center, exposed brick walls.',                              'apartment',  'rent', 150000.00,    'Colombo 03',     1, 1, 900,  'available'),
(7, 5, 'Beachside Villa',         'Stunning villa right on the beach, perfect for vacation rental.',                 'house',      'sale', 220000000.00, 'Negombo',        5, 4, 4000, 'available'),
(8, 3, 'Commercial Plaza Space',  'Prime retail space in a busy commercial district.',                               'commercial', 'rent', 350000.00,    'Colombo 04',     0, 2, 2500, 'available');

-- Fix AUTO_INCREMENT after manual inserts
ALTER TABLE Properties AUTO_INCREMENT = 20;

-- Property Images (primary image per property)
INSERT IGNORE INTO Property_Images (property_id, image_url, is_primary) VALUES
(1, 'https://images.unsplash.com/photo-1600596542815-ffad4c1539a9?w=800&auto=format&fit=crop&q=80', TRUE),
(2, 'https://images.unsplash.com/photo-1512917774080-9991f1c4c750?w=800&auto=format&fit=crop&q=80', TRUE),
(3, 'https://images.unsplash.com/photo-1600607687939-ce8a6c25118c?w=800&auto=format&fit=crop&q=80', TRUE),
(4, 'https://images.unsplash.com/photo-1499793983690-e29da59ef1c2?w=800&auto=format&fit=crop&q=80', TRUE),
(5, 'https://images.unsplash.com/photo-1583608205776-bfd35f0d9f83?w=800&auto=format&fit=crop&q=80', TRUE),
(6, 'https://images.unsplash.com/photo-1502672260266-1c1e52408427?w=800&auto=format&fit=crop&q=80', TRUE),
(7, 'https://images.unsplash.com/photo-1510798831971-661eb04b3739?w=800&auto=format&fit=crop&q=80', TRUE),
(8, 'https://images.unsplash.com/photo-1497366216548-37526070297c?w=800&auto=format&fit=crop&q=80', TRUE);

-- Demo Reviews (agents)
INSERT IGNORE INTO Reviews (reviewer_id, target_agent_id, rating, review_text, status) VALUES
(2, 3, 5, 'Dilani was amazing to work with! Highly recommend.', 'approved'),
(2, 4, 4, 'Sarah helped me find exactly what I was looking for.', 'approved');
