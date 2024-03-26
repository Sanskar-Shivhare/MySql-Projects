-- two datasets
SELECT 
    *
FROM
    matches;
    
SELECT 
    *
FROM
    deliveries;
-- Q1. WHAT ARE THE TOP 5 PLAYERS WITH THE MOST PLAYER OF THE MATCH AWARDS?
SELECT 
    player_of_match
FROM
    matches
GROUP BY player_of_match
ORDER BY COUNT(*) DESC
LIMIT 5;

-- Q2. HOW MANY MATCHES WERE WON BY EACH TEAM IN EACH SEASON?
SELECT 
    season, winner as team, COUNT(winner) AS number_of_winning
FROM
    matches
GROUP BY season , winner;

-- Q3. WHAT IS THE AVERAGE STRIKE RATE OF BATSMEN IN THE IPL DATASET?

with stats as (SELECT 
    AVG(strike_rate) AS average_strike_rate
FROM
    (SELECT 
        batsman,
            (SUM(batsman_runs) / COUNT(ball)) * 100 AS strike_rate
    FROM
        deliveries
    GROUP BY batsman) AS batsman_stats)

SELECT 
    ROUND(average_strike_rate, 2) AS average_strike_rate
FROM
    stats;
    
-- Q4. WHAT IS THE NUMBER OF MATCHES WON BY EACH TEAM BATTING FIRST VERSUS BATTING SECOND?

SELECT 
    batting_first, COUNT(*) AS matches_won
FROM
    (SELECT 
        CASE
                WHEN win_by_runs > 0 THEN team1
                ELSE team2
            END AS batting_first
    FROM
        matches
    WHERE
        winner != 'Tie') AS batting_first_teams
GROUP BY batting_first;

-- Q5. WHICH BATSMAN HAS THE HIGHEST STRIKE RATE (MINIMUM 200 RUNS SCORED)?
SELECT 
    batsman,
    ROUND(SUM(batsman_runs) / COUNT(ball) * 100, 2) AS strike_rate
FROM
    deliveries
WHERE
    extra_runs = 0
GROUP BY batsman
HAVING SUM(batsman_runs) >= 200
ORDER BY strike_rate DESC
LIMIT 1;

-- Q6. HOW MANY TIMES HAS EACH BATSMAN BEEN DISMISSED BY THE BOWLER 'MALINGA'?
SELECT 
    player_dismissed, COUNT(*) `number of out by SL Malinga`
FROM
    deliveries
WHERE
    bowler = 'SL Malinga'
        AND player_dismissed IS NOT NULL
GROUP BY player_dismissed;

-- Q7. WHAT IS THE AVERAGE PERCENTAGE OF BOUNDARIES (FOURS AND SIXES COMBINED) HIT BY EACH BATSMAN?
SELECT 
    batsman,
    ROUND(AVG(CASE
                WHEN batsman_runs = 4 OR batsman_runs = 6 THEN 1
                ELSE 0
            END) * 100,
            2) AS avg_boundary_percentage
FROM
    deliveries
GROUP BY batsman;

-- Q8. WHAT IS THE AVERAGE NUMBER OF BOUNDARIES HIT BY EACH TEAM IN EACH SEASON?
SELECT 
    season,
    batting_team,
    AVG(fours + sixes) AS average_boundaries
FROM
    (SELECT 
        season,
            match_id,
            batting_team,
            SUM(CASE
                WHEN batsman_runs = 4 THEN 1
                ELSE 0
            END) AS fours,
            SUM(CASE
                WHEN batsman_runs = 6 THEN 1
                ELSE 0
            END) AS sixes
    FROM
        deliveries, matches
    WHERE
        deliveries.match_id = matches.id
    GROUP BY season , match_id , batting_team) AS team_bounsaries
GROUP BY season , batting_team;

-- WHAT IS THE HIGHEST PARTNERSHIP (RUNS) FOR EACH TEAM IN EACH SEASON?
SELECT 
    season, batting_team, MAX(total_runs) AS highest_partnership
FROM
    (SELECT 
        season,
            batting_team,
            partnership,
            SUM(total_runs) AS total_runs
    FROM
        (SELECT 
        season,
            match_id,
            batting_team,
            over_no,
            SUM(batsman_runs) AS partnership,
            SUM(batsman_runs) + SUM(extra_runs) AS total_runs
    FROM
        deliveries, matches
    WHERE
        deliveries.match_id = matches.id
    GROUP BY season , match_id , batting_team , over_no) AS team_scores
    GROUP BY season , batting_team , partnership) AS highest_partnership
GROUP BY season , batting_team; 


-- Q10. HOW MANY EXTRAS (WIDES & NO-BALLS) WERE BOWLED BY EACH TEAM IN EACH MATCH?
SELECT 
    match_id,
    bowling_team,
    SUM(wide_runs + noball_runs) AS `extra runs of no balls and wide balls`
FROM
    deliveries
GROUP BY match_id , bowling_team;

-- Q11. WHICH BOWLER HAS THE BEST BOWLING FIGURES (MOST WICKETS TAKEN) IN A SINGLE MATCH?
SELECT 
    match_id, bowler, COUNT(player_dismissed) wickets_taken
FROM
    deliveries
GROUP BY match_id , bowler
HAVING wickets_taken > 0
ORDER BY wickets_taken DESC
LIMIT 1;

-- Q12. HOW MANY MATCHES RESULTED IN A WIN FOR EACH TEAM IN EACH CITY?
SELECT 
    city, winner, COUNT(*) AS number_of_wins
FROM
    matches
GROUP BY city , winner;

-- Q13. HOW MANY TIMES DID EACH TEAM WIN THE TOSS IN EACH SEASON?
SELECT 
    season, toss_winner, COUNT(*) AS number_of_toss_wins
FROM
    matches
GROUP BY season , toss_winner;

-- Q14. HOW MANY MATCHES DID EACH PLAYER WIN THE "PLAYER OF THE MATCH" AWARD?
SELECT 
    player_of_match, COUNT(*) AS count_of_match
FROM
    matches
GROUP BY player_of_match
ORDER BY count_of_match DESC;

-- Q15. WHAT IS THE AVERAGE NUMBER OF RUNS SCORED IN EACH OVER OF THE INNINGS IN EACH MATCH?
SELECT 
    match_id,
    inning,
    over_no,
    AVG(total_runs) avg_score_per_over
FROM
    deliveries
GROUP BY match_id , inning , over_no;

-- WHICH TEAM HAS THE HIGHEST TOTAL SCORE IN A SINGLE MATCH?
SELECT 
    match_id, batting_team, SUM(total_runs) `Total Score`
FROM
    deliveries
GROUP BY match_id , batting_team
ORDER BY `Total Score` DESC
LIMIT 1;

-- WHICH BATSMAN HAS SCORED THE MOST RUNS IN A SINGLE MATCH?
SELECT 
    match_id, batsman, SUM(batsman_runs) AS runs_scored
FROM
    deliveries
GROUP BY match_id , batsman
ORDER BY runs_scored DESC
LIMIT 1;