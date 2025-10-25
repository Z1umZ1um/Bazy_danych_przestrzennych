-- dodwanie danych do tabeli 
-- "C:\Program Files\PostgreSQL\18\bin\shp2pgsql.exe" -W "CP1250" -I -s 4326 "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\shapefiles\T2019_KAR_POI_TABLE.shp" public.poi2019 > "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\shapefiles\2019_poi.sql"
-- "C:\Program Files\PostgreSQL\18\bin\psql.exe" -U postgres -d KAR_GERMANY -v ON_ERROR_STOP=1 -f "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\shapefiles\2019_poi.sql"
-- powstałe tabele:
-- buildings2018
-- buildings2019
-- po2018
-- poi2019
-- streets2019


-- 1. Znajdź budynki, które zostały wybudowane lub wyremontowane na przestrzeni roku (zmiana
-- pomiędzy 2018 a 2019).
SELECT b19.*
FROM buildings2019 b19
LEFT JOIN buildings2018 b18 ON ST_Equals(b19.geom, b18.geom)
WHERE b18.geom IS NULL

-- 2. Znajdź ile nowych POI pojawiło się w promieniu 500 m od wyremontowanych lub
-- wybudowanych budynków, które znalezione zostały w zadaniu 1. Policz je wg ich kategorii.
-- SELECT p19.*
-- FROM poi2019 p19
-- LEFT JOIN poi2018 p18 ON ST_Equals(p19.geom, p18.geom)
-- WHERE p18.geom IS NULL

SELECT  nowe_punkty.type, COUNT(*) AS liczba_punktow
FROM (
	SELECT p19.*
	FROM poi2019 p19
	LEFT JOIN poi2018 p18 ON ST_Equals(p19.geom, p18.geom)
	WHERE p18.geom IS NULL
) AS nowe_punkty
JOIN (
	SELECT b19.*
	FROM buildings2019 b19
	LEFT JOIN buildings2018 b18 ON ST_Equals(b19.geom, b18.geom)
	WHERE b18.geom IS NULL
) AS nowe_budynki
ON ST_DWithin(nowe_punkty.geom, nowe_budynki.geom, 500) --punkty w promieniu
GROUP BY nowe_punkty.type

-- 3. Utwórz nową tabelę o nazwie ‘streets_reprojected’, która zawierać będzie dane z tabeli
-- T2019_KAR_STREETS przetransformowane do układu współrzędnych DHDN.Berlin/Cassini.
-- SELECT * FROM streets2019
CREATE TABLE streets_reprojected AS
SELECT gid,
  link_id,
  st_name,
  ref_in_id,
  nref_in_id,
  func_class,
  speed_cat,
  fr_speed_l,
  to_speed_l,
  dir_travel,
  ST_Transform(geom, 3068) AS geom
FROM streets2019
-- SELECT * FROM streets_reprojected

-- 4. Stwórz tabelę o nazwie ‘input_points’ i dodaj do niej dwa rekordy o geometrii punktowej.
-- Użyj następujących współrzędnych:
-- X Y
-- 8.36093 49.03174
-- 8.39876 49.00644
CREATE TABLE input_points (
    id SERIAL PRIMARY KEY,
    geom GEOMETRY(Point, 4326)
);
INSERT INTO input_points (geom)
VALUES 
    (ST_SetSRID(ST_MakePoint(8.36093, 49.03174), 4326)),
    (ST_SetSRID(ST_MakePoint(8.39876, 49.00644), 4326));
-- SELECT * FROM input_points

-- 5. Zaktualizuj dane w tabeli ‘input_points’ tak, aby punkty te były w układzie współrzędnych
-- Krok 1: Przekształć geometrię
UPDATE input_points
SET geom = ST_Transform(geom, 3068);
-- Trzeba zmienić SRID 4326 na 3068
-- ALTER TABLE input_points
-- ALTER COLUMN geom TYPE geometry(Point, 3068)
-- USING ST_Transform(geom, 3068);

-- 6. Znajdź wszystkie skrzyżowania, które znajdują się w odległości 200 m od linii zbudowanej
-- z punktów w tabeli ‘input_points’. Wykorzystaj tabelę T2019_STREET_NODE. Dokonaj
-- reprojekcji geometrii, aby była zgodna z resztą tabel.
SELECT * FROM street_node2019
--sprawdzenie geometrii 
SELECT ST_SRID(geom) AS srid, COUNT(*)
FROM street_node2019
GROUP BY ST_SRID(geom); --SRID 4326
-- Trzeba zmienić SRID 4326 na 3068
ALTER TABLE street_node2019
ALTER COLUMN geom TYPE geometry(Point, 3068)
USING ST_Transform(geom, 3068);
--zmiana na 3068 bo input_points sa w 3068
UPDATE street_node2019
SET geom = ST_Transform(geom, 3068);
--ZADANIE 6
WITH linia AS (
  SELECT ST_MakeLine(ARRAY_AGG(geom ORDER BY id)) AS geom
  FROM input_points
)--tworzenie lini 

SELECT s.*
FROM street_node2019 s
JOIN linia l ON ST_DWithin(s.geom, l.geom, 200);


-- 7. Policz jak wiele sklepów sportowych (‘Sporting Goods Store’ - tabela POIs) znajduje się
-- w odległości 300 m od parków (LAND_USE_A).
SELECT COUNT(*) AS liczba_sklepow
FROM poi2019 p
JOIN land_use2019 l ON ST_DWithin(p.geom, l.geom, 300)
WHERE p.type = 'Sporting Goods Store';


-- 8. Znajdź punkty przecięcia torów kolejowych (RAILWAYS) z ciekami (WATER_LINES). Zapisz
-- znalezioną geometrię do osobnej tabeli o nazwie ‘T2019_KAR_BRIDGES’.
CREATE TABLE T2019_KAR_BRIDGES AS
SELECT ST_Intersection(r.geom, w.geom) AS geom --wyznaczy punkt intereskcji
FROM railways2019 r
JOIN water_lines2019 w 
ON ST_Intersects(r.geom, w.geom)
-- SELECT * FROM T2019_KAR_BRIDGES




