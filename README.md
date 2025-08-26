# bi-challenge

## Scenario
You are a Senior Business Intelligence Analyst tasked with providing in-depth insights into client, market, agent, and case performance using SQL.

You have been provided with five datasets: clients.csv, cases.csv, case_won_events.csv, case_lost_events.csv, and case_opened_events.csv.

Your goal is to develop SQL queries that extract actionable intelligence to drive strategic decisions.

For each objective it's expected that you deliver simple notes about the result and a query to verify your findings.

Fell free to include graphs.

You must use the PostgreSQL dialect.

Don't hesitate to reach out if questions arise.

## Analysis Objectives (SQL Queries):
### Case insights
- Case Resolution Time - Measure the time it takes to resolve cases.
- Maximum case cost - Calculate the maximum a case must cost to run.

### Client insights
- Client Lifetime Value (CLTV) Segmentation - Calculate a simplified CLTV (sum of 'Won' case values) for each client and segment clients into high, medium, and low CLTV groups.
- Predictive Client Value - Develop a SQL query that attempts to predict a client's future case value (e.g., based on historical averages or trends). This can be a simplified prediction.

### Market insights
- Market trends - Calculate market trends, based on open, won and lost cases for each market.

### Agent (User) insights
- Agent Efficiency and Effectiveness - Analyze agent performance by considering both efficiency (time to resolve cases) and effectiveness (win rate) and identify high-performing agents.
- Agent Performance Over Time - Analyze how agent performance (win rate, resolution time) changes over time. Are there trends or patterns?
