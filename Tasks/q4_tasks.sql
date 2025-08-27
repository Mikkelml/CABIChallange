----------------------------------------------------------------*4*--------------------------------------------------------------------

----------------------------*4.1*------------------------------
-- Agent (User) insights
CREATE VIEW AgentInsights as (
SELECT case_id, assigned_to, market, case_value, status,
CaseOpenedEvents.occurred_at as open_at,
CaseWonEvents.occurred_at as won_at,
CaseLostEvents.occurred_at as lost_at,
SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END) as won_cases,
SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END) as lost_cases,
SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END) as open_cases
FROM cases
INNER JOIN CaseOpenedEvents
USING(case_id)
LEFT JOIN CaseLostEvents
USING(case_ID)
LEFT JOIN CaseWonEvents
USING(case_id)
GROUP BY case_id, assigned_to, market, case_value, status,
open_at, won_at, lost_at
)


-- To verify if the view is correctly created
select * from AgentInsights


-- time to resolve cases with relevant information
SELECT 
    case_id, assigned_to,
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
Correct answear to 4.1
Same code as right above, but more specified 

Average time spent pr. agent/user and their respective win_rate for ONLY the cases which are won or lost
User_2 is for this task picked as the best performing due to cmbined information of second highest win rate, while spending 10 days less on avagaer resolving them
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

- Show here are the best and worst perforing user/agent 
- User_1 has most won cases with the highest wing rate, however also one more total case
- user_3 has the worst win rate percent however it is important to remember from the task above that user_3 also has the second highest avg duration to resolve.
- It must be assumed that user_1 spends more time on the cases because the person still have 33% open cases -> validated by the task above.
*/

select assigned_to, sum(open_cases) as open,
sum(won_cases) as won, sum(lost_cases) as lost,
sum(open_cases+won_cases+lost_cases) as total_cases,
-- reused from earlier
    ROUND((SUM(CASE WHEN status = 'Won' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as win_rate_percent, /* ::decimal er for at sikre decimal tal*/
    ROUND((SUM(CASE WHEN status = 'Lost' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as loss_rate_percent,
    ROUND((SUM(CASE WHEN status = 'Open' THEN 1 ELSE 0 END)::decimal / COUNT(*)) * 100, 1) as open_rate_percent
FROM AgentInsights
group by assigned_to
order by won desc 

--Continues below


/*- Agent Performance Over Time - Analyze how agent performance (win rate, resolution time) changes over time. Are there trends or patterns?

Agenterne bruger alle tre mest tid i måned 04 hvor i mod alle agenterne bruge kortest tid efter nytår(måned 01) på at løs casesne

User_1 og User_3 løser begge 0 cases i måned 01 hvor i mod User_2 formår at tabe 1 case på fem dage i samme måned
*/

SELECT
    assigned_to,
    DATE_TRUNC('month', COALESCE(won_at, lost_at, open_at))::Date AS period,
    COUNT(*) AS total_cases,
    SUM(won_cases) AS wc,
    SUM(lost_cases) AS lc,
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
ORDER BY assigned_to ASC, period;




