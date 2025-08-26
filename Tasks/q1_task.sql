----------------------------------------------------------------*1*--------------------------------------------------------------------
/*Case insights

----------------------------*1.1*------------------------------
- Case Resolution Time - Measure the time it takes to resolve cases.

Inden den her køres skal tabellen AgentInsights først konstureres -> Den findes under opgave 4.1
*/

SELECT 
    case_id, assigned_to,
    status,open_at, won_at, lost_at,
    CASE 
        WHEN status = 'Won' AND won_at IS NOT NULL THEN 
            (won_at - open_at)
        WHEN status = 'Lost' AND lost_at IS NOT NULL THEN 
            (lost_at - open_at)
        ELSE NULL
    END::int as resolution_time
FROM AgentInsights
WHERE status IN ('Won', 'Lost')
ORDER BY resolution_time DESC

-- Den gennemsnitlige tid for alle won eller lost cases er 38 dage - 1 måned og 8 dage
SELECT 
    AVG(
        CASE 
            WHEN status = 'Won' AND won_at IS NOT NULL THEN (won_at - open_at)
            WHEN status = 'Lost' AND lost_at IS NOT NULL THEN (lost_at - open_at)
            WHEN status = 'Open' THEN (CURRENT_DATE - open_at)
        END
    )::int AS avg_duration_days
FROM AgentInsights
WHERE status IN ('Won', 'Lost');

/*Gennemsnitlige tid pr agent/user
"user_1"	45
"user_3"	36
"user_2"	35
*/
SELECT 
    assigned_to,
    AVG(
        CASE 
            WHEN status = 'Won' AND won_at IS NOT NULL THEN (won_at - open_at)
            WHEN status = 'Lost' AND lost_at IS NOT NULL THEN (lost_at - open_at)
            WHEN status = 'Open' THEN (CURRENT_DATE - open_at)
        END
    )::int AS avg_duration_days
FROM AgentInsights
WHERE status IN ('Won', 'Lost')
GROUP BY assigned_to
ORDER BY avg_duration_days DESC;



----------------------------*1.2*------------------------------
/* Maximum case cost - Calculate the maximum a case must cost to run.
Den maximale pris for en case er 4700 og det er case 1050
*/
SELECT case_id, SUM(case_value) as case_total_value
FROM cases
GROUP BY case_id
ORDER BY case_total_value desc


