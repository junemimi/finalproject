-- Query 1
-- Look at tracks' names, id's, and loudness
-- and sorts all the tracks by loudness in descending order
SELECT tracks.track_id, tracks.name, track_stats.loudness
FROM tracks
JOIN track_stats ON tracks.track_id = track_stats.track_id
ORDER BY track_stats.loudness DESC;

-- Query 2
-- Look at tracks danceability and energy and find the sum of those two
-- for each track, and sorts the tracks in descending order by sum.
-- It finds the top 20 tracks.
SELECT tracks.name, track_observations.danceability, track_observations.energy,
       track_observations.danceability + track_observations.energy AS dance_energy_sum
FROM track_observations
JOIN tracks ON track_observations.track_id = tracks.track_id
ORDER BY dance_energy_sum DESC
LIMIT 20;
