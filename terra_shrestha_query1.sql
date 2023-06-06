-- QUERY 1: Finding track ID, name, and followers from artists with the max popularity number
-- Select track id, name, followers from tables and join tracks, identification, and artist_stats table based on the corresponding IDs
-- Filter results to retrieve artists with the maximum popularity number
SELECT t.track_id, t.name, artist_stats.followers
FROM tracks AS t
JOIN identification AS i ON t.track_id = i.track_id
JOIN artist_stats AS artist_stats ON i.artist_id = artist_stats.artist_id
WHERE artist_stats.popularity = (
    SELECT MAX(popularity)
    FROM artist_stats
);
