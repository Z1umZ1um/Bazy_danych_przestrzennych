--============ZADANIE1============

CREATE TABLE obiekty (
    id SERIAL PRIMARY KEY,
    nazwa TEXT,
    geom GEOMETRY(Geometry, 0) 
);

-- obiekt1
INSERT INTO obiekty (nazwa, geom)
VALUES (
	'obiekt1',
	ST_GeomFromText('COMPOUNDCURVE(
	(0 1, 1 1),
	CIRCULARSTRING(1 1, 2 0, 3 1),
    CIRCULARSTRING(3 1, 4 2, 5 1),
	(5 1, 6 1)
	)', 0)
);

--obiekt2
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt2',
    ST_Difference(
        ST_MakePolygon(
            ST_CurveToLine(
                ST_GeomFromText('COMPOUNDCURVE(
                    (10 6, 14 6),
                    CIRCULARSTRING(14 6, 16 4, 14 2),
                    CIRCULARSTRING(14 2, 12 0, 10 2),
                    (10 2, 10 6)
                )', 0)
            )
        ),
        ST_Buffer(ST_MakePoint(12,2), 1)
    )
);

--obiekt 3
INSERT INTO obiekty (nazwa, geom)
VALUES (
 	'obiekt3',
	 St_GeomFromText('POLYGON((7 15, 10 17, 12 13, 7 15))',0)
 	
 );

INSERT INTO obiekty (nazwa, geom)
VALUES (
	'obiekt4',
	ST_GeomFromText('LINESTRING(20 20, 25 25, 27 24, 25 22, 26 21, 22 19, 20.5 19.5)', 0)
)

--obiekt5
--trzeba zmienic kolumne geom bo nie obsluguje typu multipoint
ALTER TABLE obiekty
ALTER COLUMN geom TYPE geometry(GeometryZ, 0)
USING ST_Force3D(geom);

INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt5',
    ST_GeomFromText('MULTIPOINT Z((38 32 234),(30 32 234))', 0)
);

--obiekt6
--teraz stuktura tabli jest zmieniona i musimy dodac Z do kazdego punktu!
INSERT INTO obiekty (nazwa, geom)
VALUES (
    'obiekt6',
    ST_GeomFromText(
        'GEOMETRYCOLLECTION Z(
            POINT Z(4 2 0),
            LINESTRING Z(1 1 0, 3 2 0)
        )',
        0
    )
);
--nie pokazuje sie ale wierze ze tam jest XD

--============ZADANIE2============
-- 2. Wyznacz pole powierzchni bufora o wielkości 5 jednostek, który został utworzony wokół
-- najkrótszej linii łączącej obiekt 3 i 4.
SELECT 
ST_Area(
	ST_Buffer(
		ST_ShortestLine(o3.geom, o4.geom),5)
)
FROM obiekty o3, obiekty o4
WHERE o3.nazwa='obiekt3' AND o4.nazwa='obiekt4';
--180.89525577144164

--============ZADANIE3============
-- 3. Zamień obiekt4 na poligon. Jaki warunek musi być spełniony, aby można było wykonać to
-- zadanie? Zapewnij te warunki.

--aby mozna było utowrzyć poligon linia musi być zamknieta
UPDATE obiekty
SET geom = ST_AddPoint(geom, ST_StartPoint(geom))
WHERE nazwa = 'obiekt4';
--to dodaje ostatni punkt w miejscu odtatniego punktu 
--można też wpisać go ręcznie

--zamiana na poligon
UPDATE obiekty
SET geom = ST_MakePolygon(geom)
WHERE nazwa = 'obiekt4';


--============ZADANIE4============
-- 4. W tabeli obiekty, jako obiekt7 zapisz obiekt 
-- złożony z obiektu 3 i obiektu 4.
INSERT INTO obiekty (nazwa, geom)
SELECT 
    'obiekt7',
    ST_Union(o3.geom, o4.geom) --łączy oba obiekty
FROM obiekty o3, obiekty o4
WHERE o3.nazwa = 'obiekt3'
  AND o4.nazwa = 'obiekt4'


--============ZADANIE5============
-- 5. Wyznacz pole powierzchni wszystkich buforów o wielkości 5 jednostek, które zostały utworzone
-- wokół obiektów nie zawierających łuków.
SELECT 
	SUM(ST_Area(ST_Buffer(geom, 5))) AS suma_pol
FROM obiekty
WHERE NOT ST_HasArc(geom);
-- 1161.8275733124506



