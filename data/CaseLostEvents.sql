/* først skal der bygges en tabel med korrekt data types
1. Ikke alle er korrekte i forhold til hvad der oftes findes optimalt

2. I denne tabel kan jeg dog se case_id er af type Int som oftest er anvendt som ID*/
CREATE TABLE CaseLostEvents (
    id Int NOT NULL PRIMARY KEY,
    case_id int,
    occurred_at  Date
);

/* For at se om tabellen er korrekt bygget*/
select * from CaseLostEvents

/* For at load csv filen ind i tabllen
Raw*/
COPY CaseLostEvents (id, case_id, occurred_at)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/case_lost_events.csv'
DELIMITER ','
CSV HEADER;

/* Check om daten er korrekt loadet*/
select * from CaseLostEvents

/* Starter stille ud med at undersøge denne specifikke tabel*/

