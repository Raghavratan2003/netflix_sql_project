# NETFLIX movies and TV Shows Data Analysis using SQL
![NETFLIX LOGO](https://github.com/Raghavratan2003/netflix_sql_project/blob/main/pngwing.com%20(11).png)
## Overview
This project involves a comprehensive analysis of Netflix's movies and TV shows data using SQL. The goal is to extract valuable insights and answer various business questions based on the dataset. The following README provides a detailed account of the project's objectives, business problems, solutions, findings, and conclusions.

## Objectives

- Analyze the distribution of content types (movies vs TV shows).
- Identify the most common ratings for movies and TV shows.
- List and analyze content based on release years, countries, and durations.
- Explore and categorize content based on specific criteria and keywords.

## Dataset

The data for this project is sourced from the Kaggle dataset:

- **Dataset Link:** [Movies Dataset](https://www.kaggle.com/datasets/shivamb/netflix-shows?resource=download)

## Schema

```sql
DROP TABLE IF EXISTS netflix;
CREATE TABLE netflix
(
    show_id      VARCHAR(5),
    type         VARCHAR(10),
    title        VARCHAR(250),
    director     VARCHAR(550),
    casts        VARCHAR(1050),
    country      VARCHAR(550),
    date_added   VARCHAR(55),
    release_year INT,
    rating       VARCHAR(15),
    duration     VARCHAR(15),
    listed_in    VARCHAR(250),
    description  VARCHAR(550)
);
```

## Business Problems and Solutions

### 1. Count the Number of Movies vs TV Shows
```sql
SELECT type, COUNT(*) as total_content FROM netflix
GROUP BY type
```

**Objective:** Determine the distribution of content types on Netflix.

### 2. Find the Most Common Rating for Movies and TV Shows
```sql
  SELECT type, rating 
FROM
(
	SELECT type, rating, COUNT(*), RANK() OVER(PARTITION BY type ORDER BY COUNT(*) DESC) AS RANKING
	FROM netflix
	GROUP BY 1, 2
) AS t1
WHERE ranking =1
```

**Objective:** Identify the most frequently occurring rating for each type of content.

### 3. List All Movies Released in a Specific Year (e.g., 2020)
```sql
  SELECT * FROM netflix
WHERE
	type = 'Movie'
	AND
	release_year = 2020
```

 **Objective:** Retrieve all movies released in a specific year.

### 4. Find the Top 5 Countries with the Most Content on Netflix
```sql
  SELECT country, COUNT(type)--COUNT(show_id)
FROM netflix
GROUP BY country
ORDER BY 2 DESC
```

**Objective:** Identify the top 5 countries with the highest number of content items.

### 5. Identify the Longest Movie
```sql
  SELECT * FROM netflix
WHERE type = 'Movie' AND duration is not NULL
ORDER BY duration DESC
LIMIT 1
```

**Objective:** Find the movie with the longest duration.

### 6. Find Content Added in the Last 5 Years
```sql
  SELECT *,  year_wanted/365
FROM
(
SELECT show_id, date_added ,CURRENT_DATE - TO_DATE(date_added, 'Month DD, YYYY') AS year_wanted
FROM netflix
) AS rry
-- where 2025 - EXTRACT(YEAR FROM converted) = 5
WHERE year_wanted = 5
order by year_wanted asc;


SELECT title, show_id, date_added
FROM netflix
WHERE TO_DATE(date_added, 'Month DD, YYYY') >= CURRENT_DATE - INTERVAL '5 years'
ORDER BY date_added ;
```

**Objective:** Retrieve content added to Netflix in the last 5 years.

### 7. Find All Movies/TV Shows by Director 'Rajiv Chilaka'
```sql
  SELECT *
FROM netflix
where director = 'Rajiv Chilaka'
```

**Objective:** List all content directed by 'Rajiv Chilaka'.

### 8. List All TV Shows with More Than 5 Seasons

```sql
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
```

### 9. Count the Number of Content Items in Each Genre

```sql
  SELECT UNNEST((STRING_TO_ARRAY(listed_in, ','))) AS Genre,
count(listed_in) as number_of_content
FROM netflix
Group by 1 
Order by number_of_content desc
```

**Objective:** Calculate and rank years by the average number of content releases by India.

### 10. List All Movies that are Documentaries

```sql
  SELECT * FROM netflix
WHERE
	listed_in ILIKE '%documentaries%'
```

**Objective:** Retrieve all movies classified as documentaries.

### 11. Find All Content Without a Director

```sql
SELECT * FROM netflix
WHERE director is NULL
```


**Objective:** List content that does not have a director.

### 12. Find How Many Movies Actor 'Salman Khan' Appeared in the Last 10 Years

```sql
  SELECT * FROM netflix
WHERE casts ILIKE '%Salman Khan%'
AND
release_year > EXTRACT(YEAR FROM CURRENT_DATE) - 10
```

**Objective:** Count the number of movies featuring 'Salman Khan' in the last 10 years.

### 13. Find the Top 10 Actors Who Have Appeared in the Highest Number of Movies Produced in India

```sql
  SELECT
UNNEST(STRING_TO_ARRAY(casts,',')) AS Actors,
COUNT(*) AS total_content
FROM netflix
WHERE country ILIKE '%INDIA'
GROUP BY 1
ORDER BY 2 DESC
LIMIT 10
```

**Objective:** Identify the top 10 actors with the most appearances in Indian-produced movies.

### 14. Categorize Content Based on the Presence of 'Kill' and 'Violence' Keywords

```sql
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
```
**Objective:** Categorize content as 'Bad' if it contains 'kill' or 'violence' and 'Good' otherwise. Count the number of items in each category.

## Findings and Conclusion

- **Content Distribution:** The dataset contains a diverse range of movies and TV shows with varying ratings and genres.
- **Common Ratings:** Insights into the most common ratings provide an understanding of the content's target audience.
- **Geographical Insights:** The top countries and the average content releases by India highlight regional content distribution.
- **Content Categorization:** Categorizing content based on specific keywords helps in understanding the nature of content available on Netflix.

This analysis provides a comprehensive view of Netflix's content and can help inform content strategy and decision-making.
