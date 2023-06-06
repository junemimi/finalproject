-- Query 1
-- Look at tracks with popularity over 80 that have been released 
-- Since the beginning of 2020

SELECT tracks.name, track_stats.release_date
FROM track_stats
JOIN tracks ON track_stats.track_id = tracks.track_id
WHERE track_stats.popularity > 85
AND track_stats.release_date >= '2020-01-01' ;