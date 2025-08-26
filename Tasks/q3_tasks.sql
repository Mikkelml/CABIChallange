
----------------------------------------------------------------*3*--------------------------------------------------------------------

----------------------------*3.1*------------------------------
/* Market insights opgave
Starter ud med at lave en tabel der indeholder den information fra de andre tabeller jeg finder brugbart*/

Create a new table 
SELECT case_id Int NOT NULL PRIMARY KEY, client_id, client_name as name,
status, case_value as value, assigned_to, cases.market,
CaseOpenedEvents.id as Case_Open_ID, 
CaseOpenedEvents.occurred_at as Occured_At_Case_Open
INTO MarketTable
FROM cases
INNER JOIN clients
USING(client_id)
INNER JOIN CaseOpenedEvents
USING(case_id)

-- Test tabel og se om den er som ønsket
SELECT * FROM markettable

/* Market analysis for hvert land.
Belgium med den højeste win rate, dog også fleste cases. Belgium har dog også flest cases open
Belgium generer ligeledes også mest værdi 
Netherlands med den højeste loss rate
Italy har den laveste generet værdi, dog har de 10% højere win rate end Netherlands

*/
SELECT 
    market,
    COUNT(*) as total_cases,
    SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END) as won_cases,
    SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END) as lost_cases,
    SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) as open_cases,
    ROUND((SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as win_rate_percent, /* ::decimal er for at sikre decimal tal*/
    ROUND((SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as loss_rate_percent,
    ROUND((SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as open_rate_percent,
	SUM(value) as sum_value
FROM markettable
GROUP BY market
ORDER BY win_rate_percent DESC;

