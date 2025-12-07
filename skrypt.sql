-- zad 2 
--"C:\Program Files\PostgreSQL\17\bin\raster2pgsql.exe" -I -C -M "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\cwiczenie8\ras250_gb\ras250_gb\data\NY.tif" "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\cwiczenie8\ras250_gb\ras250_gb\data\SD.tif" public.ras250 | "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cw8_bdp
--bierzemy tylko dwa kafelki NY i SD
ALTER TABLE public.ras250 RENAME TO uk_250k;

SELECT COUNT(*) FROM public.uk_250k;

-- zad 3
CREATE TABLE public.uk_250k_mosaic AS
SELECT ST_Union(rast) AS rast
FROM public.uk_250k;
--eksport w qgis


-- zad 5
--za pomoca pliku sql eksportowanego z qgisa


-- zad 6 
CREATE TABLE public.uk_lake_district AS
SELECT
    rid,
    ST_Clip(rast, g.wkb_geometry) AS rast
FROM
    public.uk_250k r
JOIN
    public.granice_parkow g
ON
    ST_Intersects(r.rast, g.wkb_geometry)
WHERE
    g.id = 1;
-- zad 7 
-- ekport w qgis

-- zad 8
--zaladowanie danych
--"C:\Program Files\PostgreSQL\17\bin\raster2pgsql.exe" -I -C -M "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\cwiczenie8\1_B04.jp2" public.B04 | "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cw8_bdp
--"C:\Program Files\PostgreSQL\17\bin\raster2pgsql.exe" -I -C -M "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\cwiczenie8\2_B04.jp2" public.B04 | "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cw8_bdp
-- zrobienie mozaiki B04
CREATE TABLE public.B04_mosaic AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM public.B04
    UNION ALL
    SELECT rast FROM public.B04_2
) AS all_rasters;
--zaladowanie danych
--"C:\Program Files\PostgreSQL\17\bin\raster2pgsql.exe" -I -C -M "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\cwiczenie8\1_B08.jp2" public.B08 | "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cw8_bdp
--"C:\Program Files\PostgreSQL\17\bin\raster2pgsql.exe" -I -C -M "C:\Users\Daria\Desktop\wylew.exe\semestr 5\bazy_danych_przestrzennych\cwiczenie8\2_B08.jp2" public.B08 | "C:\Program Files\PostgreSQL\17\bin\psql.exe" -U postgres -d cw8_bdp
-- zrobienie mozaiki B08
CREATE TABLE public.B08_mosaic AS
SELECT ST_Union(rast) AS rast
FROM (
    SELECT rast FROM public.B08
    UNION ALL
    SELECT rast FROM public.B08_1
) AS all_rasters;

-- zad 9
DROP TABLE IF EXISTS ndvi;

CREATE TABLE ndvi AS
SELECT 
    ST_MapAlgebra(
        b08.rast,
        b04.rast,
        '([rast1] - [rast2]) / NULLIF(([rast1] + [rast2]), 0)',
        '32BF'
    ) AS rast
FROM B08_mosaic b08
CROSS JOIN B04_mosaic b04;

-- ekport przez qgis


