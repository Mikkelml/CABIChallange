/* 
First build the tabel with correct data types
- not all data types are optimal for the puporse. 
- For this table I can see that case_id is of type int which is usally used for keys
-For this table I can see that case_id is of type int which is usally used for keys
*/
CREATE TABLE CaseLostEvents (
    id Int NOT NULL PRIMARY KEY,
    case_id int,
    occurred_at  Date
);

-- Check whether the tabel is correctly build
select * from CaseLostEvents

-- To loade the given table into Postgres
-- Raw
COPY CaseLostEvents (id, case_id, occurred_at)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/case_lost_events.csv'
DELIMITER ','
CSV HEADER;

-- Check whether the tabel is correctly loaded
select * from CaseLostEvents
