---APP STORE DATA PROJECT

--- Identifying Stakeholders
--- Aspiring app developer who needs data driven insights to decide what type of app to build.
--- What app categories are most popular?
--- What price should I set?
--- How can I maximize user ratings?

--- EDA

--- Check the number of unique apps in both tables
--- Both shows 7197 unique IDs
--- No missing data

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM AppleStore$

SELECT COUNT(DISTINCT id) AS UniqueAppIDs
FROM appleStore_description$

--- check for any missing values in key fields
--- 0 missing values on both

SELECT COUNT(*) AS MissingValues
FROM AppleStore$
WHERE track_name IS NULL OR user_rating IS NULL OR prime_genre IS NULL

SELECT COUNT(*) AS MissingValues
FROM appleStore_description$
WHERE app_desc IS NULL

--- Find out the number of apps per genre
--- Games, Entertainment, & Education are Top 3

SELECT prime_genre, COUNT(*) AS NumApps
FROM AppleStore$
GROUP BY prime_genre
ORDER BY NumApps DESC

--- Get an overview of the apps ratings
--- Avg rating is 3.5

SELECT MIN(user_rating) AS MinRating, MAX(user_rating) AS MaxRating, AVG(user_rating) AS AvgRating
FROM AppleStore$

--- FINDING THE INSIGHTS

--- Determine whether paid apps have higher ratings than free apps
--- Rating of paid apps is slightly higher, 3.720 vs 3.376

SELECT 
    CASE 
        WHEN price > 0 THEN 'Paid'
        ELSE 'Free'
    END AS App_Type,
    AVG(user_rating) AS Avg_Rating
FROM AppleStore$
GROUP BY 
    CASE 
        WHEN price > 0 THEN 'Paid'
        ELSE 'Free'
    END;

--- Check if apps with more supported languages have higher ratings
--- The more language the app has, the rating goes up slightly

SELECT
	CASE
		WHEN lang_num < 10 THEN '<10 languages'
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
		ELSE '>30 languages'
	END AS language_bucket,
	AVG(user_rating) AS Avg_Rating
FROM AppleStore$
GROUP BY
	CASE
		WHEN lang_num < 10 THEN '<10 languages'
		WHEN lang_num BETWEEN 10 AND 30 THEN '10-30 languages'
		ELSE '>30 languages'
	END
ORDER BY Avg_Rating DESC

--- Check genres with low ratings
--- Catalogs, Finance, Book have the lowest average rating
--- There is opportunity to create a app in these genre

SELECT TOP 10 prime_genre, AVG(user_rating) AS Avg_Rating
FROM AppleStore$
GROUP BY prime_genre
ORDER BY Avg_Rating	 

--- Check if there is correlation between the legth of the app description and the user rating
--- The longer the description the higher the rating

SELECT
	CASE
		WHEN LEN(b.app_desc) < 500 THEN 'Short'
		WHEN LEN(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
		ELSE 'Long'
	END AS description_length_bucket,
	AVG(a.user_rating) AS Average_Rating
FROM AppleStore$ a
JOIN appleStore_description$ b
ON a.id = b.id
GROUP BY 
	CASE
			WHEN LEN(b.app_desc) < 500 THEN 'Short'
			WHEN LEN(b.app_desc) BETWEEN 500 AND 1000 THEN 'Medium'
			ELSE 'Long'
		END
ORDER BY Average_Rating DESC

--- Check the top-rated apps for each genre
--- We see all the APPs with the highest rating count by genre
--- Defines the order for ranking, where apps with higher user_rating and rating_count_tot values get a higher rank
--- Insight for stakeholder to check these apps as the top performing ones, the dev should try to emulate

SELECT prime_genre, track_name, user_rating
FROM (
					SELECT 
						prime_genre, 
						track_name, 
						user_rating,
						RANK() OVER(PARTITION BY prime_genre ORDER BY user_rating DESC, rating_count_tot DESC) AS Rank
					FROM AppleStore$
					) AS a
WHERE a.Rank = 1

--- FINALIZE RECOMMENDATIONS

--- Paid apps have better ratings
--- Language supporting, 10 and 30 have better ratings
--- Finance and book apps have lower ratings
--- Longer description have better ratings
--- We should aim for 3.5 avg rating or better
--- Games and Entertainment have higher competition 