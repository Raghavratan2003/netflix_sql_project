CREATE TABLE netflix
(
	show_id VARCHAR(6),
	type VARCHAR(10),
	title VARCHAR(150),
	director VARCHAR(208),
	casts VARCHAR(1000),
	country VARCHAR(150),
	date_added VARCHAR(50),
	release_year INT,
	rating VARCHAR(10),
	duration VARCHAR(15),
	listed_in VARCHAR(100),
	description VARCHAR(250)
);
SELECT * FROM netflix;

/* Q1. Count the number of Movies vs TV Shows */

SELECT type, COUNT(*) as total_content FROM netflix
GROUP BY type

/* Q2. Find the most common rating for movies and TV shows */

SELECT type, rating 
FROM
(
	SELECT type, rating, COUNT(*), RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS RANKING
	FROM netflix
	GROUP BY 1, 2
) AS t1
WHERE ranking =1

/*Q3. List all movies released in a specific year (e.g., 2020)*/

SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	release_year = 2020

/* Q4. Find the top 5 countries with the most content on Netflix */

SELECT country, COUNT(type)--COUNT(show_id)
FROM netflix
GROUP BY country
ORDER BY 2 DESC

--5. Identify the longest movie

SELECT * FROM netflix
WHERE type = 'Movie' AND duration is not NULL
ORDER BY duration DESC
LIMIT 1


--6. Find content added in the last 5 years

select *,  yo/365
from
(
SELECT show_id, date_added ,CURRENT_DATE - TO_DATE(date_added, 'Month DD, YYYY') AS yo
FROM netflix
) as rry
-- where 2025 - EXTRACT(YEAR FROM converted) = 5
WHERE yo = 5
order by yo asc


SELECT show_id, date_added
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
order by date_added ;




--7. Find all the movies/TV shows by director 'Rajiv Chilaka'!

SELECT *
FROM netflix
where director = 'Rajiv Chilaka'



--8. List all TV shows with more than 5 seasons

SELECT *
FROM
(
	SELECT TITLE,DURATION, CAST(LEFT(DURATION,1) AS INTEGER) as season
	FROM netflix
	where type LIKE 'TV%'
) AS RRY
WHERE season > 5


SELECT TITLE,DURATION, CAST(LEFT(DURATION,1) AS INTEGER) as season
FROM netflix
where type LIKE 'TV%'
AND CAST(LEFT(DURATION,1) AS INTEGER) > 5





--9. Count the number of content items in each genre

SELECT UNNEST((STRING_TO_ARRAY(listed_in, ','))) AS Genre,
count(listed_in) as number_of_content
FROM netflix
Group by 1 
Order by number_of_content desc



--10. List all movies that are documentaries

SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'


--11. Find all content without a director

SELECT * FROM netflix
WHERE director is NULL


--12. Find how many movies actor 'Salman Khan' appeared in last 10 years!

SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10


--13. Find the top 10 actors who have appeared in the highest number of movies produced in India.

SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) AS Actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%INDIA'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10


/*14.Categorize the content based on the presence of the keywords 'kill' and 'violence' in 
the description field. Label content containing these keywords as 'Bad' and all other 
content as 'Good'. Count how many items fall into each category. */

WITH new_table
AS
(
SELECT
*,
	CASE
	WHEN
		description ILIKE '%kill%' 
		OR
		description ILIKE '%violence%'
		THEN 'Bad_Content'
		ELSE 'Good_Content'
	END category
FROM netflix
)
SELECT 
	category,
	COUNT(*) AS total_content
FROM new_table
GROUP BY 1