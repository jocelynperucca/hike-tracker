# Hike Tracker Results

Model: `gpt-4o`

## 1. Who has gone on the most hikes?

### zero_shot

```sql
SELECT h.name, COUNT(hp.hike_id) AS hike_count
FROM hiker h
JOIN hike_participant hp ON h.hiker_id = hp.hiker_id
GROUP BY h.hiker_id
ORDER BY hike_count DESC
LIMIT 1;
```

**Rows:** `[('Maya Chen', 8)]`

**Answer:** Maya Chen has gone on the most hikes, with a total of 8 hikes. It looks like she's quite the hiking enthusiast!

### single_domain_double_shot

```sql
SELECT hp.hiker_id, h.name, COUNT(*) AS hike_count
FROM hike_participant hp
JOIN hiker h ON hp.hiker_id = h.hiker_id
GROUP BY hp.hiker_id
ORDER BY hike_count DESC
LIMIT 1;
```

**Rows:** `[(1, 'Maya Chen', 8)]`

**Answer:** Maya Chen has gone on the most hikes, with a total of 8 hikes under her belt!

### cross_domain

```sql
SELECT h.name, COUNT(hp.hike_id) AS hike_count
FROM hiker h
JOIN hike_participant hp ON h.hiker_id = hp.hiker_id
GROUP BY h.hiker_id
ORDER BY hike_count DESC
LIMIT 1;
```

**Rows:** `[('Maya Chen', 8)]`

**Answer:** Based on the data, Maya Chen has gone on the most hikes, participating in 8 hikes. Happy trails!

---

## 2. Which trails in Zion are rated strenuous?

### zero_shot

```sql
SELECT t.name
FROM trail t
JOIN park p ON t.park_id = p.park_id
WHERE p.name = 'Zion' AND t.difficulty = 'strenuous';
```

**Rows:** `[]`

**Answer:** It looks like there are no trails in Zion that are currently rated as strenuous according to the data we have. Feel free to explore other trail options or check back later for updates!

### single_domain_double_shot

```sql
SELECT t.trail_id, t.name
FROM trail t
JOIN park p ON t.park_id = p.park_id
WHERE p.name = 'Zion' AND t.difficulty = 'strenuous';
```

**Rows:** `[]`

**Answer:** It looks like there are currently no trails rated as strenuous in Zion according to the data. Let me know if there's anything else you need help with!

### cross_domain

```sql
SELECT t.trail_id, t.name
FROM trail t
JOIN park p ON t.park_id = p.park_id
WHERE p.name = 'Zion' AND t.difficulty = 'strenuous';
```

**Rows:** `[]`

**Answer:** Unfortunately, there are currently no trails rated as strenuous in Zion according to the available data. If you have any other questions about hiking in Zion, feel free to ask!

---

## 3. What is the average rating for each park?

### zero_shot

```sql
SELECT p.name AS park_name, AVG(hp.rating) AS average_rating
FROM park p
JOIN trail t ON p.park_id = t.park_id
JOIN hike h ON t.trail_id = h.trail_id
JOIN hike_participant hp ON h.hike_id = hp.hike_id
GROUP BY p.park_id;
```

**Rows:** `[('Zion National Park', 4.25), ('Arches National Park', 4.6), ('Bryce Canyon National Park', 4.5), ('Uinta-Wasatch-Cache National Forest', 3.9166666666666665), ('Timpanogos Cave National Monument', 3.0)]`

**Answer:** Here are the average ratings for each park: Zion National Park has an average rating of 4.25, Arches National Park is rated at 4.6, Bryce Canyon National Park comes in at 4.5, Uinta-Wasatch-Cache National Forest has an average of 3.92, and Timpanogos Cave National Monument has a rating of 3.0.

### single_domain_double_shot

```sql
SELECT p.park_id, p.name, AVG(hp.rating) AS average_rating
FROM park p
JOIN trail t ON p.park_id = t.park_id
JOIN hike h ON t.trail_id = h.trail_id
JOIN hike_participant hp ON h.hike_id = hp.hike_id
GROUP BY p.park_id, p.name;
```

**Rows:** `[(1, 'Zion National Park', 4.25), (2, 'Arches National Park', 4.6), (3, 'Bryce Canyon National Park', 4.5), (4, 'Uinta-Wasatch-Cache National Forest', 3.9166666666666665), (6, 'Timpanogos Cave National Monument', 3.0)]`

**Answer:** Here's the average rating for each park based on the data: Zion National Park has an average rating of 4.25, Arches National Park is rated 4.6, Bryce Canyon National Park has a 4.5, Uinta-Wasatch-Cache National Forest comes in at 3.92, and Timpanogos Cave National Monument has an average rating of 3.0.

### cross_domain

```sql
SELECT p.park_id, p.name, AVG(hp.rating) AS average_rating
FROM park p
JOIN trail t ON p.park_id = t.park_id
JOIN hike h ON t.trail_id = h.trail_id
JOIN hike_participant hp ON h.hike_id = hp.hike_id
GROUP BY p.park_id, p.name;
```

**Rows:** `[(1, 'Zion National Park', 4.25), (2, 'Arches National Park', 4.6), (3, 'Bryce Canyon National Park', 4.5), (4, 'Uinta-Wasatch-Cache National Forest', 3.9166666666666665), (6, 'Timpanogos Cave National Monument', 3.0)]`

**Answer:** Based on the data, Arches National Park has the highest average rating of 4.6, followed closely by Bryce Canyon National Park with a rating of 4.5. Zion National Park also has a commendable average rating of 4.25. Uinta-Wasatch-Cache National Forest and Timpanogos Cave National Monument have average ratings of 3.92 and 3.0, respectively.

---

## 4. Which hikes happened in the rain?

### zero_shot

```sql
SELECT hike.hike_id, hike.trail_id, hike.hike_date, hike.duration_minutes, hike.weather, hike.notes
FROM hike
WHERE weather LIKE '%rain%';
```

**Rows:** `[(5, 3, '2026-03-22', 70, 'light rain', 'Easy recovery hike after Angels Landing'), (14, 9, '2026-10-03', 125, 'rainy and muddy', 'Fall colors were peaking')]`

**Answer:** Two hikes happened in the rain: one on March 22, 2026, with light rain, and another on October 3, 2026, which was rainy and muddy. Enjoy your hikes, rain or shine!

### single_domain_double_shot

```sql
SELECT h.hike_id, h.hike_date, h.weather
FROM hike h
WHERE h.weather = 'rain';
```

**Rows:** `[]`

**Answer:** It looks like no hikes happened in the rain, as the database returned no results for hikes with 'rain' as the weather condition. Stay dry and happy hiking!

### cross_domain

```sql
SELECT h.hike_id, h.trail_id, h.hike_date, h.duration_minutes, h.weather, h.notes
FROM hike h
WHERE h.weather LIKE '%rain%';
```

**Rows:** `[(5, 3, '2026-03-22', 70, 'light rain', 'Easy recovery hike after Angels Landing'), (14, 9, '2026-10-03', 125, 'rainy and muddy', 'Fall colors were peaking')]`

**Answer:** Two hikes happened in the rain: one on March 22, 2026, with light rain, and another on October 3, 2026, which was rainy and muddy. Enjoy those rainy day adventures!

---

## 5. Did anyone bring rain gear on a rainy hike?

### zero_shot

```sql
SELECT DISTINCT hiker.name
FROM hike
JOIN hike_gear ON hike.hike_id = hike_gear.hike_id
JOIN gear ON hike_gear.gear_id = gear.gear_id
JOIN hiker ON gear.owner_id = hiker.hiker_id
WHERE hike.weather LIKE '%rain%'
  AND gear.category = 'rain gear';
```

**Rows:** `[('Maya Chen',)]`

**Answer:** Yes, Maya Chen brought rain gear on the rainy hike. Hope that helped!

### single_domain_double_shot

```sql
SELECT DISTINCT h.name
FROM hike_gear hg
JOIN gear g ON hg.gear_id = g.gear_id
JOIN hike h ON hg.hike_id = h.hike_id
WHERE g.category = 'rain gear' AND h.weather LIKE '%rain%';
```

**Error:** `no such column: h.name`

### cross_domain

```sql
SELECT DISTINCT hp.hiker_id
FROM hike_participant hp
JOIN hike h ON hp.hike_id = h.hike_id
JOIN hike_gear hg ON h.hike_id = hg.hike_id
JOIN gear g ON hg.gear_id = g.gear_id
WHERE h.weather LIKE '%rain%'
AND g.category = 'rain gear';
```

**Rows:** `[(1,), (2,), (4,), (3,)]`

**Answer:** Yes, several people were prepared for the rain with their gear! Hikers with IDs 1, 2, 3, and 4 brought rain gear on the rainy hike.

---

## 6. Whose gear went on a hike they didn't go on?

### zero_shot

```sql
SELECT g.owner_id, g.name
FROM hike_gear hg
JOIN gear g ON hg.gear_id = g.gear_id
LEFT JOIN hike_participant hp ON hg.hike_id = hp.hike_id AND g.owner_id = hp.hiker_id
WHERE hp.hiker_id IS NULL;
```

**Rows:** `[(4, 'Nano Puff jacket'), (5, 'Helium rain jacket'), (5, 'Bear spray')]`

**Answer:** It looks like gear belonging to two people went on hikes they didn't join. A "Nano Puff jacket" owned by someone with the ID 4, and both a "Helium rain jacket" and "Bear spray" owned by someone with the ID 5, were taken on hikes without their owners.

### single_domain_double_shot

```sql
SELECT g.owner_id, h.name
FROM gear g
JOIN hike_gear hg ON g.gear_id = hg.gear_id
JOIN hike h ON hg.hike_id = h.hike_id
LEFT JOIN hike_participant hp ON h.hike_id = hp.hike_id AND g.owner_id = hp.hiker_id
WHERE hp.hiker_id IS NULL;
```

**Error:** `no such column: h.name`

### cross_domain

```sql
SELECT DISTINCT g.owner_id, g.name
FROM gear g
JOIN hike_gear hg ON g.gear_id = hg.gear_id
LEFT JOIN hike_participant hp ON hg.hike_id = hp.hike_id AND g.owner_id = hp.hiker_id
WHERE hp.hiker_id IS NULL;
```

**Rows:** `[(4, 'Nano Puff jacket'), (5, 'Helium rain jacket'), (5, 'Bear spray')]`

**Answer:** It looks like there were a few items that went on a hike without their owners! The "Nano Puff jacket" belonged to owner 4, while both the "Helium rain jacket" and "Bear spray" were owned by owner 5.

---

## 7. Did anyone see a bear, and did they have bear spray?

### zero_shot

```sql
SELECT 
    h.name AS hiker_name, 
    s.species, 
    g.name AS gear_name
FROM 
    sighting s
JOIN 
    hike h ON s.hike_id = h.hike_id
JOIN 
    hike_participant hp ON h.hike_id = hp.hike_id
JOIN 
    hiker hiker ON hp.hiker_id = hiker.hiker_id
JOIN 
    hike_gear hg ON h.hike_id = hg.hike_id
JOIN 
    gear g ON hg.gear_id = g.gear_id
WHERE 
    s.species = 'bear' AND 
    g.name LIKE '%bear spray%';
```

**Error:** `no such column: h.name`

### single_domain_double_shot

```sql
SELECT DISTINCT s.hiker_id
FROM sighting s
JOIN hike_participant hp ON s.hike_id = hp.hike_id
JOIN gear g ON hp.hiker_id = g.owner_id
WHERE s.species = 'bear' AND g.name = 'bear spray';
```

**Error:** `no such column: s.hiker_id`

### cross_domain

```sql
SELECT h.name, s.sighting_id, g.name AS gear_name
FROM hiker h
JOIN hike_participant hp ON h.hiker_id = hp.hiker_id
JOIN hike hi ON hp.hike_id = hi.hike_id
JOIN sighting s ON hi.hike_id = s.hike_id
LEFT JOIN hike_gear hg ON hi.hike_id = hg.hike_id
LEFT JOIN gear g ON hg.gear_id = g.gear_id AND g.name = 'bear spray'
WHERE s.species = 'bear';
```

**Rows:** `[]`

**Answer:** No one reported seeing a bear, or if they did, they did not have bear spray with them.

---

## 8. What gear has never been used on a hike?

### zero_shot

```sql
SELECT g.* 
FROM gear g
LEFT JOIN hike_gear hg ON g.gear_id = hg.gear_id
WHERE hg.hike_id IS NULL;
```

**Rows:** `[(13, 5, 'Atmos AG 65 backpack', 'pack', 'Osprey', 74.0, '2022-06-15'), (15, 4, 'PocketRocket stove', 'cooking', 'MSR', 2.6, '2026-01-10')]`

**Answer:** The gear that has never been used on a hike includes the "Atmos AG 65 backpack" by Osprey and the "PocketRocket stove" by MSR. Happy exploring when you do decide to use them!

### single_domain_double_shot

```sql
SELECT g.gear_id, g.name
FROM gear g
LEFT JOIN hike_gear hg ON g.gear_id = hg.gear_id
WHERE hg.hike_id IS NULL;
```

**Rows:** `[(13, 'Atmos AG 65 backpack'), (15, 'PocketRocket stove')]`

**Answer:** It looks like the "Atmos AG 65 backpack" and the "PocketRocket stove" have never been used on a hike. Maybe they're waiting for their first adventure!

### cross_domain

```sql
SELECT g.gear_id, g.name
FROM gear g
LEFT JOIN hike_gear hg ON g.gear_id = hg.gear_id
WHERE hg.hike_id IS NULL;
```

**Rows:** `[(13, 'Atmos AG 65 backpack'), (15, 'PocketRocket stove')]`

**Answer:** It looks like the "Atmos AG 65 backpack" and the "PocketRocket stove" have never been used on a hike. Happy hiking planning!

---

## 9. What is the hardest trail?

### zero_shot

```sql
SELECT name FROM trail WHERE difficulty = 'strenuous';
```

**Rows:** `[('Angels Landing',), ('Fairyland Loop',), ('Mount Timpanogos (Timpooneke to Aspen Grove)',)]`

**Answer:** The hardest trails you might want to explore are Angels Landing, Fairyland Loop, and Mount Timpanogos (Timpooneke to Aspen Grove). Each of these offers a strenuous adventure!

### single_domain_double_shot

```sql
SELECT t.trail_id, t.name
FROM trail t
WHERE t.difficulty = 'strenuous';
```

**Rows:** `[(1, 'Angels Landing'), (7, 'Fairyland Loop'), (8, 'Mount Timpanogos (Timpooneke to Aspen Grove)')]`

**Answer:** Based on our data, some of the hardest trails are Angels Landing, Fairyland Loop, and Mount Timpanogos (Timpooneke to Aspen Grove). Enjoy the challenge and stay safe!

### cross_domain

```sql
SELECT t.trail_id, t.name
FROM trail t
WHERE t.difficulty = 'hard';
```

**Rows:** `[(2, 'The Narrows (Bottom Up)'), (5, 'Devils Garden Primitive Loop'), (10, 'Y Mountain Trail')]`

**Answer:** The hardest trails you might want to check out are "The Narrows (Bottom Up)," "Devils Garden Primitive Loop," and "Y Mountain Trail." Happy hiking!

---

## 10. Which trail has nobody hiked yet?

### zero_shot

```sql
SELECT trail_id, name FROM trail
WHERE trail_id NOT IN (
    SELECT trail_id FROM hike
);
```

**Rows:** `[(11, 'Petrified Dunes')]`

**Answer:** Nobody has hiked the "Petrified Dunes" trail yet. It sounds like an exciting adventure waiting for you!

### single_domain_double_shot

```sql
SELECT t.trail_id, t.name
FROM trail t
LEFT JOIN hike h ON t.trail_id = h.trail_id
WHERE h.hike_id IS NULL;
```

**Rows:** `[(11, 'Petrified Dunes')]`

**Answer:** It looks like the 'Petrified Dunes' trail (trail_id 11) hasn't been hiked yet. It could be a great opportunity to explore something new!

### cross_domain

```sql
SELECT t.trail_id, t.name
FROM trail t
LEFT JOIN hike h ON t.trail_id = h.trail_id
WHERE h.hike_id IS NULL;
```

**Rows:** `[(11, 'Petrified Dunes')]`

**Answer:** The trail that nobody has hiked yet is the "Petrified Dunes." Happy exploring if you decide to be the first!

---

