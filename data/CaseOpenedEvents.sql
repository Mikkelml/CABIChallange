/* først skal der bygges en tabel med korrekt data types
1. Ikke alle er korrekte i forhold til hvad der oftes findes optimalt

2. I denne tabel kan jeg dog se case_id er af type Int som oftest er anvendt som ID*/
CREATE TABLE CaseOpenedEvents (
    id Int NOT NULL PRIMARY KEY,
    case_id int,
    occurred_at  Date
);

/* For at se om tabellen er korrekt bygget*/
select * from CaseOpenedEvents

/* For at load csv filen ind i tabllen
Raw*/
COPY CaseOpenedEvents (id, case_id, occurred_at)
FROM '/Users/mikkelpedersen/Desktop/bi-challenge/data/case_opened_events.csv'
DELIMITER ','
CSV HEADER;

/* Check om daten er korrekt loadet*/
select * from CaseOpenedEvents



/* Starter stille ud med at undersøge denne specifikke tabel*/