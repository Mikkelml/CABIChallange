----------------------------------------------------------------*4*--------------------------------------------------------------------

----------------------------*4.1*------------------------------

-- Agent (User) insights

-- Konsturer en tabel der indholder de information jeg finder relevant for opgaven
SELECT case_id Int NOT NULL PRIMARY KEY, assigned_to, market, case_value, status,
CaseOpenedEvents.occurred_at as open_at,
CaseWonEvents.occurred_at as won_at,
CaseLostEvents.occurred_at as lost_at,
SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END) as won_cases,
SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END) as lost_cases,
SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) as open_cases
INTO AgentInsights
FROM cases
INNER JOIN CaseOpenedEvents
USING(case_id)
LEFT JOIN CaseLostEvents
USING(case_ID)
LEFT JOIN CaseWonEvents
USING(case_id)
GROUP BY case_id, assigned_to, market, case_value, status,
open_at, won_at, lost_at


-- for at se om tabellen er korrekt konstureret
select * from AgentInsights


-- time to resolve cases
SELECT 
    case_id, assigned_to, market, case_value,
    status,open_at, won_at, lost_at,
    CASE 
        WHEN status = 'Won' AND won_at IS NOT NULL THEN 
            (won_at - open_at)
        WHEN status = 'Lost' AND lost_at IS NOT NULL THEN 
            (lost_at - open_at)
        WHEN status = 'Open' THEN 
            (CURRENT_DATE - open_at)
        ELSE NULL
    END::int as duration,
	CASE 
		WHEN status = 'Open' THEN 1 ELSE 0 END as OpenYesNo,
	won_cases, lost_cases, open_cases
FROM AgentInsights


/*
Det her er svaret til 4.1

Genbrugt fra tidligere, men viser 

Gennemsnitlige tid pr agent/user og deres win_rate for cases der er won eller lost
User_2 bliver for denne opgave vurderet som den bedste da han har næst højeste win rate, men 10 dage mindre gennemsnitligt end 
*/
SELECT 
    assigned_to,
	ROUND((SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as win_rate_percent,
    AVG(
        CASE 
            WHEN status = 'Won' AND won_at IS NOT NULL THEN (won_at - open_at)
            WHEN status = 'Lost' AND lost_at IS NOT NULL THEN (lost_at - open_at)
        END
    )::int AS avg_duration_days
FROM AgentInsights
GROUP BY assigned_to
ORDER BY avg_duration_days ASC;






----------------------------*4.2*------------------------------
/* Agent Performance Over Time - Analyze how agent performance (win rate, resolution time) changes over time. Are there trends or patterns?

- her kan vi se hvilke user/agent der performer bedst og værst
- User_1 har flest vundet cases, men har dog også en mere end de andre
- User_1 har også flest åbne cases 

- Man kan dog også antage at User_1 bruger længere tid på sine cases da personen stadig har 33% open


Fortætter under
*/

select assigned_to, sum(open_cases) as open,
sum(won_cases) as won, sum(lost_cases) as lost,
sum(open_cases+won_cases+lost_cases) as total_cases,
-- Det her er genbrugt fra tidligere
    ROUND((SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as win_rate_percent, /* ::decimal er for at sikre decimal tal*/
    ROUND((SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as loss_rate_percent,
    ROUND((SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as open_rate_percent
FROM AgentInsights
group by assigned_to
order by won desc 




/*- Agent Performance Over Time - Analyze how agent performance (win rate, resolution time) changes over time. Are there trends or patterns?
Her har jeg fået lidt hjælp af CLuade - fortsat

Agenterne bruger alle tre mest tid i måned 04 hvor i mod alle agenterne bruge kortest tid efter nytår(måned 01) på at løs casesne

User_1 og User_3 løser begge 0 cases i måned 01 hvor i mod User_2 formår at tabe 1 case på fem dage i samme måned
*/

SELECT
    assigned_to,
    DATE_TRUNC('month', COALESCE(won_at, lost_at, open_at))::Date AS period,
    COUNT(*) AS total_cases,
    SUM(won_cases) AS wc,
    SUM(lost_cases) AS lc,
    SUM(open_cases) AS oc,
    ROUND(100.0 * SUM(won_cases) / NULLIF(SUM(won_cases + lost_cases), 0), 2) AS win_rate_pct,
    AVG(
        CASE 
            WHEN status = 'Won' THEN DATE_PART('day', won_at::timestamp - open_at::timestamp)
            WHEN status = 'Lost' THEN DATE_PART('day', lost_at::timestamp - open_at::timestamp)
            ELSE NULL
        END
	) AS avg_resolution_days
FROM AgentInsights
where status in ('Won','Lost')
GROUP BY assigned_to, DATE_TRUNC('month', COALESCE(won_at, lost_at, open_at))
ORDER BY avg_resolution_days desc, win_rate_pct;

