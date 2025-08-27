/* 
First build the tabel with correct data types
- not all data types are optimal for the puporse. 
- For this table I can see that case_id is of type int which is usally used for keys
-For this table I can see that case_id is of type int which is usally used for keys
*/
CREATE TABLE CaseOpenedEvents (
    id Int NOT NULL PRIMARY KEY,
    case_id int,
    occurred_at  Date
);

-- Check whether the tabel is correctly build
select * from CaseOpenedEvents

-- To loade the given table into Postgres
-- Raw
COPY CaseOpenedEvents (id, case_id, occurred_at)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/case_opened_events.csv'
DELIMITER ','
CSV HEADER;

-- Check whether the tabel is correctly loaded
select * from CaseOpenedEvents
