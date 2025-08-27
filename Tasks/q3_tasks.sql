
----------------------------------------------------------------*3*--------------------------------------------------------------------
-- Market insights opgave
----------------------------*3.1*------------------------------

-- Starting out by creating a view that contains all the information I find relevant from other tabels
CREATE OR REPLACE VIEW MarketView AS
SELECT 
    c.case_id,
    c.client_id,
    cl.client_name AS name,
    c.status,
    c.case_value AS value,
    c.assigned_to,
    c.market,
    co.id AS case_open_id,
    co.occurred_at AS occurred_at_case_open
FROM cases c
INNER JOIN clients cl USING (client_id)
INNER JOIN CaseOpenedEvents co USING (case_id);


-- Test the view and see if it as wished
SELECT * FROM markettable

/*
Market analysis for each country.
Belgium is the country with the highest win rate, however also most cases. Furthermore, Belgium does also have most cases open
Belgium also creates most akumulated value
Netherlands has the highest loss rate
Italy hase the lowest akumulated value, however they have 10% higher win rate than Netherlands
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

