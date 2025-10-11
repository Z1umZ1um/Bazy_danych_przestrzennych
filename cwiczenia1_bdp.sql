--1.Utwórz now¹ bazê danych nazywaj¹c j¹ firma.
--CREATE DATABASE firma;
--USE firma;

--2.Dodaj schemat o nazwie ksiegowosc. 
--CREATE SCHEMA ksiegowosc;

--3.Tworzenie tabel
--PRACOWNICY
--CREATE TABLE ksiegowosc.pracownicy (
--    id_pracownika INT PRIMARY KEY IDENTITY(1,1),  
--    imie NVARCHAR(50) NOT NULL,                  
--    nazwisko NVARCHAR(50) NOT NULL,            
--    adres NVARCHAR(255),                          
--    telefon NVARCHAR(15)
--);
--GODZINY
--CREATE TABLE ksiegowosc.godziny (
--	id_godziny INT PRIMARY KEY IDENTITY(1,1),
--	data DATE NOT NULL,
--	liczba_godzin INT NOT NULL,
--	id_pracownika INT,
--	FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika) -- klucz obcy, ³¹czyy z tabela pracowanict 
--);
--PENSJA
--CREATE TABLE ksiegowosc.pensja (
--	id_pensji INT PRIMARY KEY IDENTITY(1,1),
--	stanowisko NVARCHAR(50) NOT NULL,
--	kwota DECIMAL(10,2)
--);

--PREMIA 
--CREATE TABLE ksiegowosc.premia (
--	id_premii INT PRIMARY KEY IDENTITY(1,1),
--	rodzaj NVARCHAR(50) NOT NULL,
--	kwota DECIMAL(10,2)
--);

--WYNAGRODZENIE 
--CREATE TABLE ksiegowosc.wynagrodzenie (
--	id_wynagrodzenia INT PRIMARY KEY IDENTITY(1,1),
--	data DATE NOT NULL,
--	id_pracownika INT NOT NULL,
--	id_godziny INT,
--	id_pensji INT,
--	id_premii INT, 
--	FOREIGN KEY (id_pracownika) REFERENCES ksiegowosc.pracownicy(id_pracownika),
--	FOREIGN KEY (id_godziny) REFERENCES ksiegowosc.godziny(id_godziny),
--	FOREIGN KEY (id_pensji) REFERENCES ksiegowosc.pensja(id_pensji),
--	FOREIGN KEY (id_premii) REFERENCES ksiegowosc.premia(id_premii)
--);

--KOMENTAZRE (W SQL Server nie dzia³a COMMENT)
-- PRACOWNICY
--EXEC sp_addextendedproperty 
--    @name = N'MS_Description', 
--    @value = N'tabela zawiera dane o pracownikach', 
--    @level0type = N'SCHEMA', @level0name = 'ksiegowosc',
--    @level1type = N'TABLE',  @level1name = 'pracownicy';

---- GODZINY
--EXEC sp_addextendedproperty 
--    @name = N'MS_Description', 
--    @value = N'tabela zawiera liczby godziny przepracowanych przez pracownikow', 
--    @level0type = N'SCHEMA', @level0name = 'ksiegowosc',
--    @level1type = N'TABLE',  @level1name = 'godziny';

---- PENSJA
--EXEC sp_addextendedproperty 
--    @name = N'MS_Description', 
--    @value = N'Tabela zawiera informacje o pensjach', 
--    @level0type = N'SCHEMA', @level0name = 'ksiegowosc',
--    @level1type = N'TABLE',  @level1name = 'pensja';

---- PREMIA
--EXEC sp_addextendedproperty 
--    @name = N'MS_Description', 
--    @value = N'Tabela zawiera informacje o premiach', 
--    @level0type = N'SCHEMA', @level0name = 'ksiegowosc',
--    @level1type = N'TABLE',  @level1name = 'premia';

---- WYNAGRODZENIE
--EXEC sp_addextendedproperty 
--    @name = N'MS_Description', 
--    @value = N'Tabela ³¹czy pensje premie i godziny w wynagrodzeniu pracownika.', 
--    @level0type = N'SCHEMA', @level0name = 'ksiegowosc',
--    @level1type = N'TABLE',  @level1name = 'wynagrodzenie';

--5. Wykonaj nastêpuj¹ce zapytania:
--a) Wyœwietl tylko id pracownika oraz jego nazwisko.
--SELECT id_pracownika, nazwisko FROM ksiegowosc.pracownicy;

--b) Wyœwietl id pracowników, których p³aca jest wiêksza ni¿ 1000.
--wszyscy maja powyzej 1000 wiec zmieni³am na 5000 
--SELECT pr.id_pracownika, p.kwota FROM ksiegowosc.pensja p 
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pensji = p.id_pensji
--JOIN ksiegowosc.pracownicy pr ON pr.id_pracownika = w.id_pracownika
--WHERE p.kwota > 5000

--c) Wyœwietl id pracowników nieposiadaj¹cych premii, których p³aca jest wiêksza ni¿ 2000.
--SELECT pr.id_pracownika
--FROM ksiegowosc.wynagrodzenie w
--JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
--JOIN ksiegowosc.pracownicy pr ON w.id_pracownika = pr.id_pracownika
--LEFT JOIN ksiegowosc.premia pa ON w.id_premii = pa.id_premii
--WHERE pa.id_premii IS NULL
--  AND p.kwota > 2000;

--d) Wyœwietl pracowników, których pierwsza litera imienia zaczyna siê na literê ‘J’.
--SELECT *
--FROM ksiegowosc.pracownicy
--WHERE imie LIKE 'J%'; --% dowolna ilosc znaków

--e) Wyœwietl pracowników, których nazwisko zawiera literê ‘n’ oraz imiê koñczy siê na literê ‘a’.
--SELECT *
--FROM ksiegowosc.pracownicy
--WHERE imie LIKE 'J%a'; --% dowolna ilosc znaków

--f) Wyœwietl imiê i nazwisko pracowników oraz liczbê ich nadgodzin, przyjmuj¹c, i¿ standardowy czas pracy to 160 h miesiêcznie.
--SELECT p.imie, p.nazwisko, (g.liczba_godzin - 160)
--FROM ksiegowosc.pracownicy p 
--JOIN ksiegowosc.godziny g ON g.id_pracownika = p.id_pracownika
--WHERE g.liczba_godzin > 160

--g) Wyœwietl imiê i nazwisko pracowników, których pensja zawiera siê w przedziale 1500 – 3000 PLN.
--SELECT pr.imie, pr.nazwisko, p.kwota 
--FROM ksiegowosc.wynagrodzenie w
--JOIN ksiegowosc.pracownicy pr ON w.id_pracownika = pr.id_pracownika
--JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
--WHERE p.kwota BETWEEN 1500 AND 3000;

--h) Wyœwietl imiê i nazwisko pracowników, którzy pracowali w nadgodzinach i nie otrzymali premii.
--SELECT pr.imie, pr.nazwisko
--FROM ksiegowosc.pracownicy pr
--JOIN ksiegowosc.godziny g ON g.id_pracownika = pr.id_pracownika
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = pr.id_pracownika
--LEFT JOIN ksiegowosc.premia pa ON pa.id_premii = w.id_premii -- wymusza zeby wiersze bez premii tez sie pojawi³y!
--WHERE g.liczba_godzin > 160 AND pa.id_premii IS NULL;


--i) Uszereguj pracowników wed³ug pensji.
--SELECT pr.imie, pr.nazwisko, p.kwota
--FROM ksiegowosc.pracownicy pr
--JOIN ksiegowosc.wynagrodzenie w ON pr.id_pracownika = w.id_pracownika
--JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
--ORDER BY p.kwota DESC

--j) Uszereguj pracowników wed³ug pensji i premii malej¹co.
--SELECT pr.imie, pr.nazwisko, p.kwota AS pensja, pa.kwota AS premia
--FROM ksiegowosc.pracownicy pr
--JOIN ksiegowosc.wynagrodzenie w ON pr.id_pracownika = w.id_pracownika
--JOIN ksiegowosc.pensja p ON w.id_pensji = p.id_pensji
--JOIN ksiegowosc.premia pa ON pa.id_premii = w.id_premii
--ORDER BY p.kwota DESC, pa.kwota DESC;


--k) Zlicz i pogrupuj pracowników wed³ug pola ‘stanowisko’.
--SELECT pa.stanowisko, COUNT(*) AS liczba_pracownikow
--FROM ksiegowosc.pracownicy p
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
--JOIN ksiegowosc.pensja pa ON pa.id_pensji = w.id_pensji
--GROUP BY pa.stanowisko;

--l) Policz œredni¹, minimaln¹ i maksymaln¹ p³acê dla stanowiska ‘kierownik’ (je¿eli takiego nie masz, to przyjmij
--dowolne inne).
--SELECT 
--    pa.stanowisko,
--	  COUNT(*) AS liczba_pracownikow,
--    AVG(pa.kwota) AS srednia_pensja,
--    MIN(pa.kwota) AS minimalna_pensja,
--    MAX(pa.kwota) AS maksymalna_pensja
--FROM ksiegowosc.pracownicy p
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
--JOIN ksiegowosc.pensja pa ON pa.id_pensji = w.id_pensji
--WHERE pa.stanowisko = 'Administrator'
--GROUP BY pa.stanowisko

----m) Policz sumê wszystkich wynagrodzeñ.
--SELECT SUM(pr.kwota + pe.kwota)
--FROM ksiegowosc.pracownicy p
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
--JOIN ksiegowosc.pensja pe ON pe.id_pensji = w.id_pensji
--JOIN ksiegowosc.premia pr ON pr.id_premii = w.id_premii

--f) Policz sumê wynagrodzeñ w ramach danego stanowiska.
--SELECT SUM(pr.kwota + pe.kwota)
--FROM ksiegowosc.pracownicy p
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
--JOIN ksiegowosc.pensja pe ON pe.id_pensji = w.id_pensji
--JOIN ksiegowosc.premia pr ON pr.id_premii = w.id_premii
--GROUP BY pe.stanowisko

--g) Wyznacz liczbê premii przyznanych dla pracowników danego stanowiska.
--SELECT 
--    pe.stanowisko,
--    COUNT(w.id_premii) AS liczba_premii
--FROM ksiegowosc.wynagrodzenie w
--JOIN ksiegowosc.pensja pe ON w.id_pensji = pe.id_pensji
--JOIN ksiegowosc.premia pr ON w.id_premii = pr.id_premii
--GROUP BY pe.stanowisko;


--h) Usuñ wszystkich pracowników maj¹cych pensjê mniejsz¹ ni¿ 1200 z³.
--DELETE p
--FROM ksiegowosc.pracownicy p
--JOIN ksiegowosc.wynagrodzenie w ON w.id_pracownika = p.id_pracownika
--JOIN ksiegowosc.pensja pen ON w.id_pensji = pen.id_pensji
--WHERE pen.kwota < 1200;
