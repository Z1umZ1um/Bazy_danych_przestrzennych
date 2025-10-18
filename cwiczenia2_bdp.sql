--CREATE DATABASE cwiczenia2;
--CREATE EXTENSION postgis;
--==================================================================================
-- CREATE TABLE buildings (
-- 	id SERIAL PRIMARY KEY, --id INT PRIMARY KEY
-- 	name TEXT, 
-- 	geom GEOMETRY
-- );
-- CREATE TABLE roads (
-- 	id SERIAL PRIMARY KEY, --id INT PRIMARY KEY
-- 	name TEXT, 
-- 	geom GEOMETRY
-- );
-- CREATE TABLE poi (
-- 	id SERIAL PRIMARY KEY, --id INT PRIMARY KEY
-- 	name TEXT, 
-- 	geom GEOMETRY
-- );
--select * from buildings
--===================================================================================
-- INSERT INTO poi (name, geom)
-- VALUES 
-- ('K', ST_GeomFromText('POINT(6 9.5)')),
-- ('J', ST_GeomFromText('POINT(6.5 6)')),
-- ('I', ST_GeomFromText('POINT(9.5 6)')),
-- ('G', ST_GeomFromText('POINT(1 3.5)')),
-- ('H', ST_GeomFromText('POINT(5.5 1.5)'));
-- SELECT * FROM poi --geometria jest w binarnym
-- INSERT INTO roads (name, geom)
-- VALUES
-- ('RoadX', ST_GeomFromText('LINESTRING(0 4.5, 12 4.5)')),
-- ('RoadY', ST_GeomFromText('LINESTRING(7.5 0, 7.5 10.5)'));
-- SELECT * FROM roads
-- INSERT INTO buildings (name, geom)
-- VALUES 
-- ('BuildingA', ST_GeomFromText('POLYGON((8 4, 10.5 4, 10.5 1.5, 8 1.5, 8 4))')),
-- ('BuildingB', ST_GeomFromText('POLYGON((4 7, 6 7, 6 5, 4 5, 4 7))')),
-- ('BuildingC', ST_GeomFromText('POLYGON((3 8, 5 8, 5 6, 3 6, 3 8))')),
-- ('BuildingD', ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))')),
-- ('BuildingF', ST_GeomFromText('POLYGON((1 2, 2 2, 2 1, 1 1, 1 2))')); -- na koncu musi byc pierwsza wsp. zeby sie zamykało!
-- SELECT * FROM buildings
--===================================================================================
-- INSERT INTO buildings (name, geom)
-- VALUES 
-- ('BuildingD', ST_GeomFromText('POLYGON((9 9, 10 9, 10 8, 9 8, 9 9))'));

-- a. Wyznacz całkowitą długość dróg w analizowanym mieście. 
SELECT SUM(ST_Length(geom)) AS suma_dlugosci
FROM roads;

-- b. Wypisz geometrię (WKT), pole powierzchni oraz obwód poligonu reprezentującego
-- budynek o nazwie BuildingA.
--WKT czytelna dla człowieka
SELECT 
    ST_AsText(geom) AS wkt_geometria,
    ST_Area(geom) AS pole,
    ST_Perimeter(geom) AS obwod
FROM buildings
WHERE name = 'BuildingB';

-- c. Wypisz nazwy i pola powierzchni wszystkich poligonów w warstwie budynki.
-- Wyniki posortuj alfabetycznie.
SELECT 
	name,
    ST_Area(geom) AS pole
FROM buildings
ORDER BY name;

-- d. Wypisz nazwy i obwody 2 budynków o największej powierzchni.
SELECT 
	name,
	ST_Perimeter(geom) AS obwod
FROM buildings
ORDER BY ST_Area(geom) DESC
LIMIT 2;

-- e. Wyznacz najkrótszą odległość między budynkiem BuildingC a punktem K.
SELECT 
    ST_Distance(
        (SELECT geom FROM buildings WHERE name = 'BuildingC'),
        (SELECT geom FROM poi WHERE name = 'K')
    ) AS distance;

-- f. Wypisz pole powierzchni tej części budynku BuildingC, która znajduje się w odległości
-- większej niż 0.5 od budynku BuildingB.
SELECT ST_Area(
    ST_Difference(
        (SELECT geom FROM buildings WHERE name='BuildingC'), ST_Buffer((SELECT geom FROM buildings WHERE name='BuildingB'), 0.5))
) AS pow_poza_buforem;


-- g. Wybierz te budynki, których centroid (ST_Centroid) znajduje się powyżej drogi
-- o nazwie RoadX.
SELECT b.name
FROM buildings b
JOIN roads r ON r.name='RoadX' --wypelnia wszedzie tylko RoadX
WHERE ST_Y(ST_Centroid(b.geom)) > St_Y(ST_Centroid(r.geom));


-- h. Oblicz pole powierzchni tych części budynku BuildingC i poligonu o współrzędnych
-- (4 7, 6 7, 6 8, 4 8, 4 7), które nie są wspólne dla tych dwóch obiektów.
--ST_Difference roznica ST_SymDifference części NIE wspolne
SELECT ST_Area(
    ST_SymDifference(
        (SELECT geom FROM buildings WHERE name = 'BuildingC'), ST_GeomFromText('POLYGON((4 7, 6 7, 6 8, 4 8, 4 7))'))
) AS pole_nie_wspolne;
