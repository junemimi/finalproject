-- genres

CREATE TABLE one_nf AS
SELECT
    id,
    REPLACE(REPLACE(REPLACE(REPLACE(genres, ']', ''), '[', ''), '"', ''), '''', '') AS cleaned_genres
FROM
    artists;

CREATE TABLE final_one AS
SELECT *, trim(value) AS value
FROM one_nf,
	json_each(' [" ' || replace(cleaned_genres, ',', ' ","') || ' "] ')
WHERE value <> ' ';
-- remove all extra [,] characters
UPDATE final_one
SET value = REPLACE(value, '[', '');
UPDATE final_one
SET value = REPLACE(value, ']', '');
UPDATE final_one
SET value = REPLACE(value, '''', '');

CREATE TABLE final_one_nf AS
SELECT id, value AS genre
FROM final_one;

DROP TABLE final_one;
DROP TABLE one_nf;


-- names table
CREATE TABLE splitting_artists AS
SELECT
    id_artists AS id,
    REPLACE(REPLACE(REPLACE(REPLACE(artists, ']', ''), '[', ''), '"', ''), '''', '') AS cleaned_artists
FROM
    tracks;

CREATE TABLE separate AS
WITH recursive splits AS (
  SELECT 
    substr(cleaned_artists, 1, instr(cleaned_artists, ',') - 1) AS split_artists,
    substr(cleaned_artists, instr(cleaned_artists, ',') + 3) AS remaining_artists,
	id
  FROM splitting_artists
  
  UNION ALL
  
  SELECT 
    substr(remaining_artists, 1, instr(remaining_artists, ',') - 1),
    substr(remaining_artists, instr(remaining_artists, ',') + 3),
	id
  FROM splits
  WHERE remaining_artists <> ''
)
SELECT id AS identification, split_artists
FROM splits;
DELETE FROM separate WHERE split_artists = '';


CREATE TABLE new AS
SELECT DISTINCT *, trim(identification) AS value
FROM separate,
	json_each(' [" ' || replace(identification, ',', ' ","') || ' "] ')
WHERE value <> ' ';

CREATE TABLE unique_artists AS
SELECT DISTINCT value AS identification, split_artists
FROM new;

DROP TABLE new;
DROP TABLE separate;
DROP TABLE splitting_artists;

-- clarifying column and table names
ALTER TABLE genres
RENAME COLUMN id TO artist_id;

ALTER TABLE artists
RENAME COLUMN id TO artist_id;

ALTER TABLE tracks
RENAME COLUMN id TO track_id;

ALTER TABLE unique_artists
RENAME COLUMN split_artists TO name;

ALTER TABLE unique_artists
RENAME COLUMN identification TO artist_id;

ALTER TABLE artists
DROP COLUMN genres;

ALTER TABLE artists
RENAME TO artist_stats;

ALTER TABLE unique_artists
RENAME TO artists;

ALTER TABLE genres
RENAME TO artist_genres;

-- eliminating partial dependencies
CREATE TABLE identification AS
SELECT
id_artists AS artist_id,
REPLACE(REPLACE(REPLACE(REPLACE(track_id, ']', ''), '[', ''), '"', ''), '''', '') AS track_id
FROM
    tracks;

ALTER TABLE tracks
DROP COLUMN artists;

ALTER TABLE tracks
DROP COLUMN id_artists;

CREATE TABLE tracks AS
SELECT
  track_id AS track_id,
  name AS name
FROM track_stats;

-- eliminating transitive dependencies
CREATE TABLE track_observations AS
SELECT
  track_id AS track_id,
  danceability AS danceability,
  energy AS energy,
  speechiness AS speechiness,
  acousticness AS acousticness,
  instrumentalness AS instrumentalness,
  liveness AS liveness,
  valence AS valence
FROM track_stats;

ALTER TABLE track_stats
DROP COLUMN danceability;

ALTER TABLE track_stats
DROP COLUMN energy;

ALTER TABLE track_stats
DROP COLUMN speechiness;

ALTER TABLE track_stats
DROP COLUMN acousticness;

ALTER TABLE track_stats
DROP COLUMN instrumentalness;

ALTER TABLE track_stats
DROP COLUMN liveness;

ALTER TABLE track_stats
DROP COLUMN valence;

ALTER TABLE track_stats
DROP COLUMN name;