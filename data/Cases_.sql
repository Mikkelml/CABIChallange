/* først skal der bygges en tabel med korrekt data types
1. Ikke alle er korrekte i forhold til hvad der oftes findes optimalt

2. I denne tabel kan jeg dog se case_id er af type Int som oftest er anvendt som ID*/
CREATE TABLE cases (
    case_id Int NOT NULL PRIMARY KEY,
    client_id Text,
    market  Text,
	creation_date Date,
	status Text,
	case_value Int,
	assigned_to Text
);

/* For at se om tabellen er korrekt bygget*/
select * from cases

/* For at load csv filen ind i tabllen
Raw*/
COPY cases (case_id, client_id, market, creation_date, status, case_value, assigned_to)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/cases.csv'
DELIMITER ','
CSV HEADER;

/* Check om daten er korrekt loadet*/
select * from cases


/* Starter stille ud med at undersøge denne specifikke tabel*/
-- Der har været cases i alle 8 lande og der er tre distinct users under assigned_to
select DISTINCT(market) from cases
select DISTINCT(assigned_to) from cases


-- Her kan vi se at vi altså vinder et flertal af casesne, men der dog stadig er 18 åbne cases.
SELECT status, COUNT(*) AS total
FROM cases
GROUP BY status;
-- Procent dele af cases der er vundet(1 er vundet)
SELECT 
    ROUND(100.0 * SUM(CASE WHEN status='Won' THEN 1 ELSE 0 END)/COUNT(*),2) AS win_rate_pct
FROM cases;

-- Hvor mange cases der er vundet, tabt eller åben i de forskellige lande
SELECT market, status, COUNT(*) AS total
FROM cases
GROUP BY market, status
ORDER BY market;

-- Her ser vi hvordan de enkelte user præstere, altså hvor mange de har vundet, tabt og stadig har åbent
SELECT assigned_to, status, COUNT(*) AS total
FROM cases
GROUP BY assigned_to, status
ORDER BY assigned_to;


-- Case 1050 er den summere dyreste case
SELECT case_id, SUM(case_value) as case_total_value
FROM cases
GROUP BY case_id
ORDER BY case_total_value desc


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
