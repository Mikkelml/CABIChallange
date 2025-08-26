----------------------------------------------------------------*2*--------------------------------------------------------------------


----------------------------*2.1*------------------------------
/*Client insights
- Client Lifetime Value (CLTV) Segmentation - Calculate a simplified CLTV (sum of 'Won' case values) ->
for each client and segment clients into high, medium, and low CLTV groups.

*/
-- De 5 mest vindene clients, hvor c100 er clineten med højeste value (19200)
SELECT client_id, SUM(case_value) AS cltv
FROM cases
WHERE status = 'Won'
GROUP BY client_id
ORDER BY cltv desc
limit 5;

-- Samme som oven for, men her segmenteres de efter kategori 
SELECT client_id, client_name, SUM(case_value) AS cltv,
    CASE 
        WHEN SUM(case_value) >= 7000 THEN 'High'
        WHEN SUM(case_value) BETWEEN 4000 AND 6999 THEN 'Medium'
        ELSE 'Low'
    END AS cltv_segment
FROM cases
INNER JOIN clients
USING(client_id)
WHERE status = 'Won'
GROUP BY client_id, client_name
ORDER BY cltv DESC;



----------------------------*2.2*------------------------------
/* Her laver jeg et view af det statment over og derefter ganger jeg med dem der har den akumuleret højeste værdi med x antal procent.
Hav i Mente det her er en ekstremt simplifiseret måde.
*/
WITH client_cltv AS (
    SELECT client_id, client_name, SUM(case_value) AS cltv,
        CASE 
            WHEN SUM(case_value) >= 7000 THEN 'High'
            WHEN SUM(case_value) BETWEEN 4000 AND 6999 THEN 'Medium'
            ELSE 'Low'
        END AS cltv_segment
    FROM cases
    INNER JOIN clients USING(client_id)
    WHERE status = 'Won'
    GROUP BY client_id, client_name
)

SELECT 
    client_id, 
    client_name, 
    cltv, 
    cltv_segment,
    CASE 
        WHEN cltv_segment = 'High' THEN cltv * 1.10
        WHEN cltv_segment = 'Medium' THEN cltv * 1.05
        WHEN cltv_segment = 'Low' THEN cltv * 1.02
    END AS predicted_cltv
FROM client_cltv
ORDER BY cltv DESC;

