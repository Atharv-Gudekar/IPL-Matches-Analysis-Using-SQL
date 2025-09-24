-- ===========================
-- Section A: Basic Queries
-- ===========================

-- Q1. Show the first 20 matches
SELECT * 
FROM matches
LIMIT 20;

-- Q2. Top 10 batsmen who hit the most sixes
SELECT batsman, COUNT(*) AS sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batsman
ORDER BY sixes DESC
LIMIT 10;

-- Q3. Top 10 bowlers who conceded the most runs
SELECT bowler, SUM(total_runs) AS runs_conceded
FROM deliveries
GROUP BY bowler
ORDER BY runs_conceded DESC
LIMIT 10;

-- Q4. Top 5 matches with the highest runs scored
SELECT match_id, SUM(total_runs) AS total_runs
FROM deliveries
GROUP BY match_id
ORDER BY total_runs DESC
LIMIT 5;

-- Q5. Top 10 venues with the most matches played
SELECT venue, COUNT(*) AS total_matches
FROM matches
GROUP BY venue
ORDER BY total_matches DESC
LIMIT 10;

-- ===========================
-- Section B: Intermediate Queries
-- ===========================

-- Q6. Total number of matches played in each season
SELECT season, COUNT(*) AS total_matches
FROM matches
GROUP BY season
ORDER BY season;

-- Q7. Top 10 batsmen with the highest total runs
SELECT batsman, SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batsman
ORDER BY total_runs DESC
LIMIT 10;

-- Q8. Top 10 bowlers with the most wickets
SELECT bowler, COUNT(*) AS wickets
FROM deliveries
WHERE dismissal_kind IN ('bowled','caught','lbw','stumped','caught and bowled','hit wicket')
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;

-- Q9. Top 5 teams with the most wins
SELECT winner, COUNT(*) AS total_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 5;

-- Q10. Top 10 players with the most “Player of the Match” awards
SELECT player_of_match, COUNT(*) AS awards
FROM matches
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;

-- ===========================
-- Section C: Deliveries Analysis
-- ===========================

-- Q11. Top 10 bowlers with the best economy rate (min 200 balls)
SELECT bowler,
       SUM(total_runs) / (COUNT(*) / 6) AS economy_rate
FROM deliveries
GROUP BY bowler
HAVING COUNT(*) >= 200
ORDER BY economy_rate ASC
LIMIT 10;

-- Q12. Top 10 batsmen with the most boundaries (4s + 6s)
SELECT batsman,
       SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END) +
       SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END) AS boundaries
FROM deliveries
GROUP BY batsman
ORDER BY boundaries DESC
LIMIT 10;

-- Q13. Top 10 bowlers who bowled the most dot balls
SELECT bowler, COUNT(*) AS dot_balls
FROM deliveries
WHERE total_runs = 0
GROUP BY bowler
ORDER BY dot_balls DESC
LIMIT 10;

-- Q14. Top 5 batsmen with the highest individual score in a single match
SELECT match_id, batsman, SUM(batsman_runs) AS runs_scored
FROM deliveries
GROUP BY match_id, batsman
ORDER BY runs_scored DESC
LIMIT 5;

-- Q15. Top 5 teams with the highest total score in a single match
SELECT d.match_id, m.team1, m.team2, SUM(d.total_runs) AS total_runs
FROM deliveries d
JOIN matches m ON d.match_id = m.id
GROUP BY d.match_id, m.team1, m.team2
ORDER BY total_runs DESC
LIMIT 5;

-- ===========================
-- Section D: Seasonal / Advanced
-- ===========================

-- Q16. Winner of the final match for each season
SELECT season, winner
FROM matches m
WHERE id IN (
    SELECT MAX(id)
    FROM matches
    GROUP BY season
);

-- Q17. Top 10 batsmen with the highest strike rate (min 200 balls)
SELECT batsman,
       SUM(batsman_runs) / COUNT(*) * 100 AS strike_rate
FROM deliveries
GROUP BY batsman
HAVING COUNT(*) >= 200
ORDER BY strike_rate DESC
LIMIT 10;

-- Q18. Top 10 bowlers with the best bowling average (min 200 balls)
SELECT bowler,
       SUM(total_runs) / COUNT(CASE WHEN dismissal_kind IN 
           ('bowled','caught','lbw','stumped','caught and bowled','hit wicket') 
           THEN 1 END) AS bowling_average
FROM deliveries
GROUP BY bowler
HAVING COUNT(*) >= 200
ORDER BY bowling_average ASC
LIMIT 10;

-- Q19. Team with the most wins in each season
SELECT season, winner, COUNT(*) AS wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY season, winner
ORDER BY season, wins DESC;

-- Q20. Top 5 matches with the largest win margin by runs
SELECT id, team1, team2, winner, win_by_runs
FROM matches
ORDER BY win_by_runs DESC
LIMIT 5;
