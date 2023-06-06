-- QUERY 1: trying to find the ideal track length
-- find the names and duration (in milliseconds) of all tracks with popularity over 90 (out of 100)
-- sorted from shortest song length to longest
SELECT tracks.name, track_stats.duration_ms
FROM track_stats
JOIN tracks ON track_stats.track_id = tracks.track_id
WHERE track_stats.popularity > 90
ORDER BY track_stats.duration_ms ASC;

-- QUERY 2: comparing the trends in explicit content by year
-- find the count of clean and explicit songs released each year
-- sorted by year
SELECT
  CASE
    WHEN LENGTH(track_stats.release_date) == 4 THEN track_stats.release_date
	ELSE SUBSTR(track_stats.release_date, 1, 4)
  END AS year,
  SUM(CASE WHEN track_stats.explicit = 0 THEN 1 ELSE 0 END) AS clean_songs,
  SUM(CASE WHEN track_stats.explicit = 1 THEN 1 ELSE 0 END) AS explicit_songs
FROM track_stats
GROUP BY year
ORDER BY year;