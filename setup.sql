-- Hike Tracker schema (SQLite)
PRAGMA foreign_keys = ON;

CREATE TABLE park (
    park_id   INTEGER PRIMARY KEY,
    name      TEXT NOT NULL,
    state     TEXT,
    park_type TEXT CHECK (park_type IN ('national park', 'state park', 'national forest',
                                        'national monument', 'recreation area', 'other'))
);

CREATE TABLE trail (
    trail_id          INTEGER PRIMARY KEY,
    park_id           INTEGER NOT NULL,
    name              TEXT NOT NULL,
    length_miles      REAL,
    elevation_gain_ft INTEGER,
    difficulty        TEXT CHECK (difficulty IN ('easy', 'moderate', 'hard', 'strenuous')),
    route_type        TEXT CHECK (route_type IN ('loop', 'out-and-back', 'point-to-point')),
    FOREIGN KEY (park_id) REFERENCES park(park_id)
);

CREATE TABLE hike (
    hike_id          INTEGER PRIMARY KEY,
    trail_id         INTEGER NOT NULL,
    hike_date        DATE NOT NULL,
    duration_minutes INTEGER,
    weather          TEXT,
    notes            TEXT,
    FOREIGN KEY (trail_id) REFERENCES trail(trail_id)
);

CREATE TABLE sighting (
    sighting_id INTEGER PRIMARY KEY,
    hike_id     INTEGER NOT NULL,
    species     TEXT NOT NULL,
    count       INTEGER DEFAULT 1,
    FOREIGN KEY (hike_id) REFERENCES hike(hike_id)
);

CREATE TABLE hiker (
    hiker_id  INTEGER PRIMARY KEY,
    name      TEXT NOT NULL,
    email     TEXT,
    home_city TEXT
);

CREATE TABLE hike_participant (
    hike_id  INTEGER NOT NULL,
    hiker_id INTEGER NOT NULL,
    rating   INTEGER CHECK (rating BETWEEN 1 AND 5),
    PRIMARY KEY (hike_id, hiker_id),
    FOREIGN KEY (hike_id) REFERENCES hike(hike_id),
    FOREIGN KEY (hiker_id) REFERENCES hiker(hiker_id)
);

CREATE TABLE gear (
    gear_id       INTEGER PRIMARY KEY,
    owner_id      INTEGER NOT NULL,
    name          TEXT NOT NULL,
    category      TEXT CHECK (category IN ('pack', 'footwear', 'clothing', 'rain gear', 'shelter',
                                           'sleep', 'navigation', 'water', 'lighting', 'safety',
                                           'cooking', 'trekking poles')),
    brand         TEXT,
    weight_oz     REAL,
    purchase_date DATE,
    FOREIGN KEY (owner_id) REFERENCES hiker(hiker_id)
);

CREATE TABLE hike_gear (
    hike_id INTEGER NOT NULL,
    gear_id INTEGER NOT NULL,
    PRIMARY KEY (hike_id, gear_id),
    FOREIGN KEY (hike_id) REFERENCES hike(hike_id),
    FOREIGN KEY (gear_id) REFERENCES gear(gear_id)
);