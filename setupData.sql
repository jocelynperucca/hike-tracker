-- Hike Tracker sample data (SQLite)
PRAGMA foreign_keys = ON;

-- PARKS
INSERT INTO park (park_id, name, state, park_type) VALUES
(1, 'Zion National Park', 'UT', 'national park'),
(2, 'Arches National Park', 'UT', 'national park'),
(3, 'Bryce Canyon National Park', 'UT', 'national park'),
(4, 'Uinta-Wasatch-Cache National Forest', 'UT', 'national forest'),
(5, 'Snow Canyon State Park', 'UT', 'state park'),
(6, 'Timpanogos Cave National Monument', 'UT', 'national monument');

-- TRAILS
INSERT INTO trail (trail_id, park_id, name, length_miles, elevation_gain_ft, difficulty, route_type) VALUES
(1,  1, 'Angels Landing', 5.4, 1488, 'strenuous', 'out-and-back'),
(2,  1, 'The Narrows (Bottom Up)', 9.4, 400, 'hard', 'out-and-back'),
(3,  1, 'Riverside Walk', 2.2, 57, 'easy', 'out-and-back'),
(4,  2, 'Delicate Arch', 3.2, 629, 'moderate', 'out-and-back'),
(5,  2, 'Devils Garden Primitive Loop', 7.9, 1085, 'hard', 'loop'),
(6,  3, 'Navajo Loop and Queens Garden', 2.9, 625, 'moderate', 'loop'),
(7,  3, 'Fairyland Loop', 8.0, 1716, 'strenuous', 'loop'),
(8,  4, 'Mount Timpanogos (Timpooneke to Aspen Grove)', 14.0, 4400, 'strenuous', 'point-to-point'),
(9,  4, 'Stewart Falls', 3.4, 534, 'moderate', 'out-and-back'),
(10, 4, 'Y Mountain Trail', 2.2, 1074, 'hard', 'out-and-back'),
(11, 5, 'Petrified Dunes', 1.5, 150, 'easy', 'out-and-back'),
(12, 6, 'Timpanogos Cave Trail', 3.0, 1092, 'moderate', 'out-and-back'),
(13, 4, 'Fifth Water Hot Springs', 4.5, 600, 'moderate', 'out-and-back');

-- HIKERS
INSERT INTO hiker (hiker_id, name, email, home_city) VALUES
(1, 'Maya Chen', 'maya.chen@example.com', 'Provo'),
(2, 'Jake Thompson', 'jake.t@example.com', 'Orem'),
(3, 'Priya Patel', 'priya.patel@example.com', 'Salt Lake City'),
(4, 'Sam Rivera', 'sam.rivera@example.com', 'Provo'),
(5, 'Emma Larsen', 'emma.larsen@example.com', 'St. George'),
(6, 'Noah Kim', 'noah.kim@example.com', 'Lehi');

-- HIKES
INSERT INTO hike (hike_id, trail_id, hike_date, duration_minutes, weather, notes) VALUES
(1,  9,  '2025-06-14', 120, 'sunny, 78°F', 'Waterfall was flowing strong'),
(2,  10, '2025-09-06', 95,  'clear', 'Sunrise hike before class'),
(3,  4,  '2025-10-18', 110, 'windy and cold', 'Crowded at sunset, hiked down with headlamps'),
(4,  1,  '2026-03-21', 260, 'partly cloudy', 'Needed a permit; chains section was busy'),
(5,  3,  '2026-03-22', 70,  'light rain', 'Easy recovery hike after Angels Landing'),
(6,  6,  '2026-05-02', 105, 'snow flurries, 35°F', 'Wall Street section was closed'),
(7,  2,  '2026-06-20', 380, 'hot, 95°F', 'Water was knee to waist deep'),
(8,  8,  '2026-07-18', 600, 'afternoon thunderstorms', 'Waited out lightning below the saddle'),
(9,  12, '2026-07-25', 150, 'sunny', 'Cave tour was worth it'),
(10, 5,  '2026-08-08', 280, 'drizzle in the morning, then clear', 'Some scrambling on the primitive section'),
(11, 13, '2026-08-30', 140, 'showers', 'Soaked in the hot springs'),
(12, 7,  '2026-09-12', 270, 'clear, 60°F', 'Barely saw anyone all day'),
(13, 10, '2026-09-27', 85,  'overcast', 'Second time on this trail'),
(14, 9,  '2026-10-03', 125, 'rainy and muddy', 'Fall colors were peaking');

-- WHO WENT ON EACH HIKE (rating 1-5)
INSERT INTO hike_participant (hike_id, hiker_id, rating) VALUES
(1, 1, 4), (1, 4, 5),
(2, 2, 3),
(3, 1, 5), (3, 3, 4), (3, 2, 5),
(4, 1, 5), (4, 2, 5), (4, 4, 4),
(5, 1, 3), (5, 2, 4), (5, 4, 3),
(6, 3, 4),
(7, 1, 5), (7, 3, 5),
(8, 2, 5), (8, 4, 4),
(9, 4, 3), (9, 3, 3),
(10, 1, 4), (10, 3, 5),
(11, 2, 4), (11, 4, 5), (11, 1, 4),
(12, 3, 5),
(13, 2, 3), (13, 4, 3),
(14, 1, 4), (14, 3, 3);

-- WILDLIFE SIGHTINGS
INSERT INTO sighting (sighting_id, hike_id, species, count) VALUES
(1,  1,  'mule deer', 3),
(2,  3,  'raven', 2),
(3,  4,  'California condor', 1),
(4,  4,  'chipmunk', 6),
(5,  6,  'pronghorn', 4),
(6,  7,  'mule deer', 2),
(7,  8,  'mountain goat', 5),
(8,  8,  'marmot', 2),
(9,  9,  'rattlesnake', 1),
(10, 10, 'collared lizard', 1),
(11, 11, 'moose', 1),
(12, 12, 'Steller''s jay', 2),
(13, 14, 'black bear', 1);

-- GEAR
INSERT INTO gear (gear_id, owner_id, name, category, brand, weight_oz, purchase_date) VALUES
(1,  1, 'Talon 22 daypack', 'pack', 'Osprey', 33.0, '2024-04-10'),
(2,  1, 'Speedgoat trail runners', 'footwear', 'Hoka', 20.6, '2025-05-01'),
(3,  1, 'Torrentshell rain jacket', 'rain gear', 'Patagonia', 14.1, '2025-03-15'),
(4,  2, 'Moab 3 hiking boots', 'footwear', 'Merrell', 36.0, '2023-08-20'),
(5,  2, 'Trail Pro trekking poles', 'trekking poles', 'REI Co-op', 19.0, '2024-09-01'),
(6,  2, 'eTrex 22x GPS', 'navigation', 'Garmin', 4.9, '2025-06-30'),
(7,  3, 'Squeeze water filter', 'water', 'Sawyer', 3.0, '2025-02-11'),
(8,  3, '32 oz water bottle', 'water', 'Hydro Flask', 15.2, '2023-12-25'),
(9,  3, 'Spot 400 headlamp', 'lighting', 'Black Diamond', 2.7, '2024-10-05'),
(10, 4, 'Ultralight first aid kit', 'safety', 'Adventure Medical Kits', 7.0, '2024-05-18'),
(11, 4, 'Nano Puff jacket', 'clothing', 'Patagonia', 11.9, '2025-11-02'),
(12, 5, 'Helium rain jacket', 'rain gear', 'Outdoor Research', 6.3, '2024-03-02'),
(13, 5, 'Atmos AG 65 backpack', 'pack', 'Osprey', 74.0, '2022-06-15'),
(14, 5, 'Bear spray', 'safety', 'Counter Assault', 10.2, '2025-07-01'),
(15, 4, 'PocketRocket stove', 'cooking', 'MSR', 2.6, '2026-01-10');

-- GEAR BROUGHT ON EACH HIKE
INSERT INTO hike_gear (hike_id, gear_id) VALUES
(1, 1), (1, 2), (1, 10),
(2, 4), (2, 6),
(3, 1), (3, 8), (3, 9),
(4, 1), (4, 2), (4, 4), (4, 5), (4, 10),
(5, 3), (5, 4),
(6, 8), (6, 11),
(7, 2), (7, 7), (7, 8),
(8, 4), (8, 5), (8, 6), (8, 10), (8, 12),
(9, 9), (9, 10),
(10, 1), (10, 3), (10, 7),
(11, 4), (11, 10), (11, 11),
(12, 7), (12, 8), (12, 9),
(13, 5),
(14, 1), (14, 3), (14, 14);