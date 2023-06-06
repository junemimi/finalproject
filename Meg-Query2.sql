-- Query 2 
-- Compare followers to popularity for artists who have a 
-- popularity rating above 80 
SELECT artist_stats.popularity, artist_stats.followers
FROM artist_stats
WHERE artist_stats.popularity >80;

