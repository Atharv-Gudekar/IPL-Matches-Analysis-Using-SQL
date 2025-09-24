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
