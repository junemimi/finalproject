-- QUERY 2: Getting the top 10 tracks with the highest popularity
-- Select track id, name, and popularity from tracks and join track stats and track id table
-- Results will be ordered by popularity in descending order with a limit of 10 to represent top 10
SELECT t.track_id, t.name, ts.popularity
FROM tracks AS t
JOIN track_stats AS ts ON t.track_id = ts.track_id
ORDER BY ts.popularity DESC
LIMIT 10;
