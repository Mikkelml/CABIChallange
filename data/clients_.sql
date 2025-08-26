/* først skal der bygges en tabel med korrekt data types
1. Ikke alle er korrekte i forhold til hvad der oftes findes optimalt*/
CREATE TABLE clients (
    client_id TEXT NOT NULL PRIMARY KEY,
    client_name TEXT,
    market  TEXT,
	start_date date,
	is_active bool
);

/* For at se om tabellen er korrekt bygget*/
select * from clients

/* For at load csv filen ind i tabllen
Raw*/
COPY clients (client_id, client_name, market, start_date, is_active)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/clients.csv'
DELIMITER ','
CSV HEADER;

-- Check om daten er korrekt loadet
select * from clients



/* Starter stille ud med at undersøge denne specifikke tabel
Der er 12 clients i 8 lande som alle er aktive
*/
select DISTINCT(market) from clients

-- Ser ikke ud til der er nogle duplicates
SELECT client_id, client_name, COUNT(*)
FROM clients
GROUP BY client_id, client_name
HAVING COUNT(*) > 1;


