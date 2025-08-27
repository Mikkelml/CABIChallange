/* 
First build the tabel with correct data types
- not all data types are optimal for the puporse. 
- For this table I can see that case_id is of type int which is usally used for keys
*/
CREATE TABLE cases (
    case_id Int NOT NULL PRIMARY KEY,
    client_id Text,
    market  Text,
	creation_date Date,
	status Text,
	case_value Int,
	assigned_to Text
);

-- Check whether the tabel is correctly build
select * from cases

-- To loade the given table into Postgres
COPY cases (case_id, client_id, market, creation_date, status, case_value, assigned_to)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/cases.csv'
DELIMITER ','
CSV HEADER;

-- Check if it is correctly loaded
select * from cases

/*
Just some small introduction qureys to get started
Cases has been conducted in all countries, and there is three distinct users under assigned_to
*/
select DISTINCT(market) from cases
select DISTINCT(assigned_to) from cases


-- It is clearly visible that most cases are won, however still have 18 open cases
SELECT status, COUNT(*) AS total
FROM cases
GROUP BY status;

-- percentage of won cases
SELECT 
    ROUND(100.0 * SUM(CASE WHEN status='Won' THEN 1 ELSE 0 END)/COUNT(*),2) AS win_rate_pct
FROM cases;

-- The amount of cases that is won, lost, or is still open in each country
SELECT market, status, COUNT(*) AS total
FROM cases
GROUP BY market, status
ORDER BY market;

-- Inshights into won, lost, or open pr user -> we will get into that in the tasks
SELECT assigned_to, status, COUNT(*) AS total
FROM cases
GROUP BY assigned_to, status
ORDER BY assigned_to;


-- Case 1050 is the sum most expensive case -> we will get into that in the tasks
SELECT case_id, SUM(case_value) as case_total_value
FROM cases
GROUP BY case_id
ORDER BY case_total_value desc



---------------------------------------------*These will be presented in task 2*-----------------------------

-- De 5 mest vindene clients, hvor c100 er clineten med højeste value (19200)
SELECT client_id, SUM(case_value) AS cltv
FROM cases
WHERE status = 'Won'
GROUP BY client_id
ORDER BY cltv desc
limit 5;

-- Samme som oven for, men her segmenteres de efter kategori 
SELECT client_id, SUM(case_value) AS cltv,
    CASE 
        WHEN SUM(case_value) >= 7000 THEN 'High'
        WHEN SUM(case_value) BETWEEN 4000 AND 6999 THEN 'Medium'
        ELSE 'Low'
    END AS cltv_segment
FROM cases
WHERE status = 'Won'
GROUP BY client_id
ORDER BY cltv DESC;
