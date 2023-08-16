-- Console Games Sales
-- You are an analytics consultant helping a console games company conduct market research.
-- You have been supplied a dataset consisting of two files:


SELECT *
FROM ConsoleDates

SELECT *
FROM [P9-ConsoleGames]

-- Calculate what percent of global sales were made in North America
-- Percent is 49.32% 

SELECT (SUM(NA_Sales) / (SUM(NA_Sales) + SUM(EU_Sales) + SUM(JP_Sales) + SUM(Other_Sales))) * 100 AS PercentNASales
FROM [P9-ConsoleGames]

-- Extract a view of the console game titles ordered by platform name in ascending order and year of relase in descending order
-- Klax Platform 2600 and year 1989

SELECT Name, Platform, Year
FROM [P9-ConsoleGames]
WHERE Platform IS NOT NULL
ORDER BY Platform ASC, YEAR DESC	

-- For each game title extract the first four letters of the publisher's name

SELECT LEFT(Publisher, 4) AS PublisherAbbrev
FROM [P9-ConsoleGames]

-- Display all console platforms which were  either just before Black Friday or just before Christmas 
-- There are 6 Platforms

SELECT  DISTINCT CD.FirstRetailAvailability,CG.Platform
FROM [P9-ConsoleGames] CG
LEFT JOIN ConsoleDates CD
ON CG.Platform = CD.Platform
WHERE (MONTH(CD.FirstRetailAvailability) = 11 AND DAY(CD.FirstRetailAvailability) >= 20 )
OR (MONTH(CD.FirstRetailAvailability) = 12 AND DAY(CD.FirstRetailAvailability) > = 24)

-- Order the platforms by their longevity in ascending order, where the platform which was availbale for the longest at the bottom
-- The Platform with the longest running time is the NES

SELECT CG.Platform, MIN(CD.FirstRetailAvailability) AS FirstRealityAvailabilty, MAX(CD.Discontinued) AS Discontinued,
DATEDIFF(DAY, MIN(CD.FirstRetailAvailability), MAX(CD.Discontinued)) AS Longevity
FROM [P9-ConsoleGames] CG
LEFT JOIN ConsoleDates CD
ON CG.Platform = CD.Platform
WHERE (CD.FirstRetailAvailability IS NOT NULL AND CD.Discontinued IS NOT NULL)
GROUP BY CG.Platform
ORDER BY Longevity DESC

-- Demonstrate how to deal with the Game_Year column if the client wants to convert it to different data type
-- Always back up your data
-- Create a new column 

ALTER TABLE ConsoleDates
ADD Game_Year SMALLDATETIME ;


-- if we wanted to update the Game_Year 
UPDATE ConsoleDates
SET Game_Year = CAST (Game_Year AS datetime)

-- Dropping my column
ALTER TABLE ConsoleDates
DROP COLUMN Game_Year;

-- Provide recommendations on how to deal with missing data in the file

-- One way I would deal with missing data is seeing which columns are null and filtering them out using not null
-- Always documenting my filters
-- Sometimes it is best to leave data in the query, it might alter the data
-- Using summary funcations like Count missing null data