/* 
First build the tabel with correct data types
- not all data types are optimal for the puporse. 
*/
CREATE TABLE clients (
    client_id TEXT NOT NULL PRIMARY KEY,
    client_name TEXT,
    market  TEXT,
	start_date date,
	is_active bool
);

-- Check whether the tabel is correctly build
select * from clients

-- To loade the given table into Postgres
-- Raw
COPY clients (client_id, client_name, market, start_date, is_active)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/clients.csv'
DELIMITER ','
CSV HEADER;

-- Check if it is correctly loaded
select * from clients



/* 
Just some small introduction qureys to get started
12 different clients in eight different contires
*/
select DISTINCT(market) from clients

-- no duplicates
SELECT client_id, client_name, COUNT(*)
FROM clients
GROUP BY client_id, client_name
HAVING COUNT(*) > 1;


