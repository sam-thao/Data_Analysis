--- Practice Complex SQL Queries
--- Kaggle Dataset - 120 years of Olympic history: athletes and results

--- 6. Identify the sport which was played in all summer olympics.
--- find total num of summer olmypic games
--- find for each soprt, how many games where they played in
--- compare 1 & 2

WITH t1 AS --29 total games
(	
	SELECT COUNT(DISTINCT games) AS total_games
	FROM athlete_events
	WHERE season = 'Summer'
),
t2 AS --1896 through 2016
(
	SELECT DISTINCT games, sport
	FROM athlete_events
	WHERE season = 'Summer'
),
t3 AS 
(
	SELECT sport, COUNT(1) AS no_of_games
	FROM t2
	GROUP BY sport
)
SELECT * --52 sports, but you'll need to find the ones for 29 games per sport
FROM t3
JOIN t1 ON t1.total_games = t3.no_of_games; -- 5 sports with 29 games

--- Fetch the top 5 athletes who have won the most gold medals.

WITH t1 AS
(
	SELECT name, COUNT(1) AS total_metals -- -- COUNT(1) the query selects the name column and uses COUNT(1) to calculate the total number of rows (medals) for each athlete's name. 
	FROM athlete_events
	WHERE medal = 'Gold'
	GROUP BY name
),
t2 AS
(
	SELECT *, DENSE_RANK() OVER (ORDER BY total_metals DESC) AS rnk
	FROM t1
)
SELECT *
FROM t2
WHERE rnk <= 5
ORDER BY rnk ASC; --ranking by counting metals, not skipping order

--- 14. List down total gold, silver and bronze medals won by each country.
--- Problem Statement: Write a SQL query to list down the  total gold, silver and bronze medals won by each country.

SELECT nr.region AS country, medal, count(1) AS total_medals
FROM athlete_events ae
JOIN	noc_regions nr
ON nr.NOC = ae.NOC
WHERE Medal <> 'NA'
GROUP BY nr.region, Medal
ORDER BY country

-- USA won 2638 gold, 1641 silver, & 1358 bronze

SELECT
    country,
    ISNULL([Gold], 0) AS gold,
    ISNULL([Silver], 0) AS silver,
    ISNULL([Bronze], 0) AS bronze
FROM (
    SELECT
        nr.region AS country,
        medal,
        COUNT(1) AS total_medals
    FROM athlete_events ae
    JOIN noc_regions nr 
	ON nr.noc = ae.noc
    WHERE medal <> 'NA'
    GROUP BY nr.region, medal
) AS SourceTable
PIVOT (
    SUM(total_medals)
    FOR medal IN ([Bronze], [Gold], [Silver])
) AS PivotTable
ORDER BY gold DESC, silver DESC, bronze DESC;

--- Identify which country won the most gold, most silver and most bronze medals in each olympic games.
--- Problem Statement: Write SQL query to display for each Olympic Games, which country won the highest gold, silver and bronze medals.

WITH temp AS (
    SELECT
        SUBSTRING(games, 1, CHARINDEX(' - ', games) - 1) AS games,
        SUBSTRING(games, CHARINDEX(' - ', games) + 3, LEN(games)) AS country,
        ISNULL([Gold], 0) AS gold,
        ISNULL([Silver], 0) AS silver,
        ISNULL([Bronze], 0) AS bronze
    FROM (
        SELECT
            CONCAT(games, ' - ', nr.region) AS games,
            medal,
            COUNT(1) AS total_medals
        FROM athlete_events ae
        JOIN noc_regions nr 
		ON nr.noc = ae.noc
        WHERE medal <> 'NA'
        GROUP BY games, nr.region, medal
    ) AS SourceTable
    PIVOT (
        SUM(total_medals)
        FOR medal IN ([Bronze], [Gold], [Silver])
    ) AS PivotTable
)
SELECT DISTINCT
    games,
    CONCAT(FIRST_VALUE(country) OVER (PARTITION BY games ORDER BY gold DESC), ' - ', FIRST_VALUE(gold) OVER (PARTITION BY games ORDER BY gold DESC)) AS Max_Gold,
    CONCAT(FIRST_VALUE(country) OVER (PARTITION BY games ORDER BY silver DESC), ' - ', FIRST_VALUE(silver) OVER (PARTITION BY games ORDER BY silver DESC)) AS Max_Silver,
    CONCAT(FIRST_VALUE(country) OVER (PARTITION BY games ORDER BY bronze DESC), ' - ', FIRST_VALUE(bronze) OVER (PARTITION BY games ORDER BY bronze DESC)) AS Max_Bronze
FROM temp
ORDER BY games;

-- usa 139 in 2016 gold summer games