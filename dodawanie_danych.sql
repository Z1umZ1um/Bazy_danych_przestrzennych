INSERT INTO ksiegowosc.pracownicy (imie, nazwisko, adres, telefon) VALUES
('Jan','Kowalski','ul. S³oneczna 1, Warszawa','500111222'),
('Anna','Nowak','ul. Leœna 3, Kraków','500333444'),
('Piotr','Wiœniewski','ul. Polna 7, Gdañsk','500555666'),
('Katarzyna','Wójcik','ul. Ogrodowa 2, Wroc³aw','500777888'),
('Micha³','Kaczmarek','ul. Piêkna 5, Poznañ','500999000'),
('Ewa','Zieliñska','ul. Jesionowa 4, £ódŸ','501111222'),
('Tomasz','Sikora','ul. Klonowa 6, Lublin','501333444'),
('Magdalena','Duda','ul. Ró¿ana 8, Katowice','501555666'),
('Adam','Kubiak','ul. Brzozowa 10, Bia³ystok','501777888'),
('Joanna','Lewandowska','ul. Lipowa 12, Szczecin','501999000');

INSERT INTO ksiegowosc.godziny (data, liczba_godzin, id_pracownika) VALUES
('2025-10-01', 8, 1),
('2025-10-01', 7, 2),
('2025-10-01', 9, 3),
('2025-10-01', 8, 4),
('2025-10-01', 6, 5),
('2025-10-01', 8, 6),
('2025-10-01', 7, 7),
('2025-10-01', 8, 8),
('2025-10-01', 9, 9),
('2025-10-01', 8, 10);

INSERT INTO ksiegowosc.pensja (stanowisko, kwota) VALUES
('Programista', 8000.00),
('Ksiêgowa', 5500.00),
('Menad¿er', 10000.00),
('Sprzedawca', 4000.00),
('Magazynier', 3500.00),
('Administrator', 6000.00),
('Projektant', 7000.00),
('Specjalista HR', 5000.00),
('Dyrektor', 15000.00),
('Asystent', 3000.00);

INSERT INTO ksiegowosc.premia (rodzaj, kwota) VALUES
('Roczna', 2000.00),
('Okolicznoœciowa', 500.00),
('Za wydajnoœæ', 800.00),
('Œwi¹teczna', 600.00),
('Specjalna', 1000.00),
('Motywacyjna', 1200.00),
('Premia zespo³owa', 900.00),
('Jednorazowa', 400.00),
('Nagroda', 1500.00),
('Uznaniowa', 700.00);

INSERT INTO ksiegowosc.wynagrodzenie (data, id_pracownika, id_godziny, id_pensji, id_premii) VALUES
('2025-10-01', 1, 1, 1, 1),
('2025-10-01', 2, 2, 2, 2),
('2025-10-01', 3, 3, 3, 3),
('2025-10-01', 4, 4, 4, 4),
('2025-10-01', 5, 5, 5, 5),
('2025-10-01', 6, 6, 6, 6),
('2025-10-01', 7, 7, 7, 7),
('2025-10-01', 8, 8, 8, 8),
('2025-10-01', 9, 9, 9, 9),
('2025-10-01', 10, 10, 10, 10);

