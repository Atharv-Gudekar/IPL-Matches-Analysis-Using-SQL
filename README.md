# 🏏 IPL Data Analysis using SQL

![](https://github.com/Atharv-Gudekar/IPL-Matches-Analysis-Using-SQL/blob/main/ipllogo.png)

## Overview
This project involves a comprehensive analysis of **Indian Premier League (IPL) matches and deliveries data** using SQL. The goal is to extract valuable insights and answer various cricket-related analytical questions based on the dataset.  
The following README provides a detailed account of the project's objectives, dataset, schema, **20 business problems with SQL solutions**, findings, and conclusions.

---

## Objectives

- Analyze batting and bowling performances across IPL seasons.  
- Identify consistent teams, players, and venues.  
- Explore match outcomes, strike rates, economy rates, and high-scoring games.  
- Provide clear, runnable MySQL queries for business-style problems.  

---

## Dataset

The data for this project is sourced from **Kaggle IPL dataset**:  

- **matches.csv** — match-level information (id, season, teams, winner, venue, date).  
- **deliveries.csv** — ball-by-ball data (match_id, inning, batting_team, bowler, batsman_runs, total_runs, dismissal_kind, etc.).

---

## Schema

```sql
CREATE TABLE matches (
    id INT PRIMARY KEY,
    season INT,
    city VARCHAR(50),
    date DATE,
    team1 VARCHAR(100),
    team2 VARCHAR(100),
    toss_winner VARCHAR(100),
    toss_decision VARCHAR(10),
    result VARCHAR(20),
    dl_applied INT,
    winner VARCHAR(100),
    win_by_runs INT,
    win_by_wickets INT,
    player_of_match VARCHAR(100),
    venue VARCHAR(100),
    umpire1 VARCHAR(100),
    umpire2 VARCHAR(100),
    umpire3 VARCHAR(100)
);

CREATE TABLE deliveries (
    match_id INT,
    inning INT,
    batting_team VARCHAR(100),
    bowling_team VARCHAR(100),
    over INT,
    ball INT,
    batsman VARCHAR(100),
    non_striker VARCHAR(100),
    bowler VARCHAR(100),
    is_super_over INT,
    wide_runs INT,
    bye_runs INT,
    legbye_runs INT,
    noball_runs INT,
    penalty_runs INT,
    batsman_runs INT,
    extra_runs INT,
    total_runs INT,
    player_dismissed VARCHAR(100),
    dismissal_kind VARCHAR(50),
    fielder VARCHAR(100)
);
Got it! I will give **all 20 queries in one single block** formatted for a README file. You can copy all of this at once and save as `README.md`.

---

````
# IPL SQL Analysis

## 1. Show the First 20 Matches
```sql
SELECT * 
FROM matches
LIMIT 20;
````

## 2. Top 10 Batsmen with the Most Sixes

```sql
SELECT batsman, COUNT(*) AS sixes
FROM deliveries
WHERE batsman_runs = 6
GROUP BY batsman
ORDER BY sixes DESC
LIMIT 10;
```

## 3. Top 10 Bowlers who Conceded the Most Runs

```sql
SELECT bowler, SUM(total_runs) AS runs_conceded
FROM deliveries
GROUP BY bowler
ORDER BY runs_conceded DESC
LIMIT 10;
```

## 4. Top 5 Matches with the Highest Total Runs

```sql
SELECT match_id, SUM(total_runs) AS total_runs
FROM deliveries
WHERE inning IN (1,2)
GROUP BY match_id
ORDER BY total_runs DESC
LIMIT 5;
```

## 5. Top 10 Venues with the Most Matches

```sql
SELECT venue, COUNT(*) AS total_matches
FROM matches
GROUP BY venue
ORDER BY total_matches DESC
LIMIT 10;
```

## 6. Season-wise Total Matches

```sql
SELECT season, COUNT(*) AS total_matches
FROM matches
GROUP BY season
ORDER BY season;
```

## 7. Top 10 Batsmen with the Highest Total Runs

```sql
SELECT batsman, SUM(batsman_runs) AS total_runs
FROM deliveries
GROUP BY batsman
ORDER BY total_runs DESC
LIMIT 10;
```

## 8. Top 10 Bowlers with the Most Wickets

```sql
SELECT bowler, COUNT(*) AS wickets
FROM deliveries
WHERE dismissal_kind IN (
    'bowled','caught','lbw','stumped','caught and bowled','hit wicket'
)
GROUP BY bowler
ORDER BY wickets DESC
LIMIT 10;
```

## 9. Top 5 Teams with the Most Wins

```sql
SELECT winner, COUNT(*) AS total_wins
FROM matches
WHERE winner IS NOT NULL
GROUP BY winner
ORDER BY total_wins DESC
LIMIT 5;
```

## 10. Top 10 Players with the Most "Player of the Match" Awards

```sql
SELECT player_of_match, COUNT(*) AS awards
FROM matches
GROUP BY player_of_match
ORDER BY awards DESC
LIMIT 10;
```

## 11. Top 10 Bowlers with the Best Economy (min 200 legal balls)

```sql
SELECT bowler,
       SUM(total_runs) * 6.0 / SUM(CASE WHEN wide_runs = 0 AND noball_runs = 0 THEN 1 ELSE 0 END) AS economy_rate
FROM deliveries
GROUP BY bowler
HAVING SUM(CASE WHEN wide_runs = 0 AND noball_runs = 0 THEN 1 ELSE 0 END) >= 200
ORDER BY economy_rate ASC
LIMIT 10;
```

## 12. Top 10 Batsmen with the Most Boundaries (4s + 6s)

```sql
SELECT batsman,
       SUM(CASE WHEN batsman_runs = 4 THEN 1 ELSE 0 END) +
       SUM(CASE WHEN batsman_runs = 6 THEN 1 ELSE 0 END) AS boundaries
FROM deliveries
GROUP BY batsman
ORDER BY boundaries DESC
LIMIT 10;
```

## 13. Top 10 Bowlers with the Most Dot Balls

```sql
SELECT bowler,
       SUM(CASE WHEN wide_runs = 0 AND noball_runs = 0 AND total_runs = 0 THEN 1 ELSE 0 END) AS dot_balls
FROM deliveries
GROUP BY bowler
ORDER BY dot_balls DESC
LIMIT 10;
```

## 14. Top 5 Batsmen with the Highest Individual Score in a Single Match

```sql
SELECT match_id, batsman, SUM(batsman_runs) AS runs_scored
FROM deliveries
GROUP BY match_id, batsman
ORDER BY runs_scored DESC
LIMIT 5;
```

## 15. Top 5 Team Innings with the Highest Score in a Single Match

```sql
SELECT match_id, batting_team, SUM(total_runs) AS team_runs
FROM deliveries
WHERE inning IN (1,2)
GROUP BY match_id, batting_team
ORDER BY team_runs DESC
LIMIT 5;
```

## 16. Winner of the Final Match Each Season

```sql
SELECT m.season, m.winner
FROM matches m
JOIN (
    SELECT season, MAX(date) AS final_date
    FROM matches
    GROUP BY season
) f ON m.season = f.season AND m.date = f.final_date;
```

## 17. Top 10 Batsmen with the Best Strike Rate (min 200 balls faced)

```sql
SELECT batsman,
       SUM(batsman_runs) * 100.0 / COUNT(*) AS strike_rate,
       COUNT(*) AS balls_faced
FROM deliveries
GROUP BY batsman
HAVING COUNT(*) >= 200
ORDER BY strike_rate DESC
LIMIT 10;
```

## 18. Top 10 Bowlers with the Best Bowling Average (min 200 balls)

```sql
SELECT bowler,
       SUM(total_runs) / NULLIF(SUM(CASE WHEN dismissal_kind IN 
           ('bowled','caught','lbw','stumped','caught and bowled','hit wicket') THEN 1 ELSE 0 END), 0) AS bowling_average
FROM deliveries
GROUP BY bowler
HAVING SUM(CASE WHEN wide_runs = 0 AND noball_runs = 0 THEN 1 ELSE 0 END) >= 200
   AND SUM(CASE WHEN dismissal_kind IN 
           ('bowled','caught','lbw','stumped','caught and bowled','hit wicket') THEN 1 ELSE 0 END) > 0
ORDER BY bowling_average ASC
LIMIT 10;
```

## 19. Team with the Most Wins in Each Season

```sql
SELECT season, winner, wins
FROM (
    SELECT season, winner, COUNT(*) AS wins,
           ROW_NUMBER() OVER (PARTITION BY season ORDER BY COUNT(*) DESC) AS rn
    FROM matches
    WHERE winner IS NOT NULL
    GROUP BY season, winner
) t
WHERE rn = 1
ORDER BY season;
```

## 20. Top 5 Matches with the Largest Win Margin by Runs

```sql
SELECT id, team1, team2, winner, win_by_runs
FROM matches
ORDER BY win_by_runs DESC
LIMIT 5;
```

## Findings and Conclusion

* **Batsmen Insights:** Top run scorers, six-hitters, and high strike rates were identified.
* **Bowling Insights:** Wicket-takers, economical bowlers, and dot-ball specialists were highlighted.
* **Match Insights:** High-scoring matches and most-played venues were revealed.
* **Team Insights:** Season champions, dominant teams, and largest win margins were analyzed.

This analysis demonstrates **SQL for sports analytics**, including joins, grouping, aggregation, window functions, and filtering.

