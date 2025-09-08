-- Who prefers energy drinks?
SELECT Gender, COUNT(Respondent_ID) AS Pref_count
FROM dim_repondents
GROUP BY Gender
ORDER BY Pref_count DESC;

-- Which age group prefers energy drink more?
SELECT age, COUNT(Respondent_ID) AS Pref_count
FROM dim_repondents
GROUP BY age;

-- What are the preferred ingredients of energy drinks among respondents?
SELECT Ingredients_expected , COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Ingredients_expected
ORDER BY Response_count DESC;

-- What packaging preferences do respondents have for energy drinks?
SELECT Packaging_preference, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Packaging_preference
ORDER BY Response_count DESC;

-- Who are the current market leaders?
SELECT Current_brands, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Current_brands
ORDER BY Response_count DESC;

-- What are the primary reasons consumers prefer those brands over ours?
SELECT Reasons_for_choosing_brands, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Reasons_for_choosing_brands
ORDER BY Response_count DESC;

-- Which marketing channel can be used to reach more customers?
SELECT Marketing_channels, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Marketing_channels
ORDER BY Response_count DESC;

-- What do people think about our brand? 
WITH HeardCounts AS (
    SELECT Heard_before, COUNT(Respondent_ID) AS Response_count
    FROM fact_survey_responses
    GROUP BY Heard_before
),
TriedCounts AS (
    SELECT Tried_before, COUNT(Respondent_ID) AS Response_count
    FROM fact_survey_responses
    WHERE Heard_before = 'Yes'
    GROUP BY Tried_before
),
TasteCounts AS (
    SELECT Taste_experience, COUNT(Respondent_ID) AS Response_count
    FROM fact_survey_responses
    WHERE Tried_before = 'Yes' AND Heard_before = 'Yes'
    GROUP BY Taste_experience
)
SELECT 'Heard_before' AS Category, Heard_before AS Value, Response_count
FROM HeardCounts
UNION ALL
SELECT 'Tried_before' AS Category, Tried_before AS Value, Response_count
FROM TriedCounts
UNION ALL
SELECT 'Taste_experience' AS Category, Taste_experience AS Value, Response_count
FROM TasteCounts
ORDER BY Category, Response_count DESC;

-- Which cities do we need to focus more on?
SELECT c.City, c.Tier, COUNT(r.Respondent_ID) AS Response_count,
ROUND((COUNT(r.Respondent_ID)/10000*100),1) AS Percent_Response
FROM dim_cities c
JOIN dim_repondents r 
ON c.City_ID = r.City_ID
GROUP BY c.City, c.Tier
ORDER BY Response_count DESC;

-- Where do respondents prefer to purchase energy drinks?
SELECT Purchase_location, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Purchase_location ORDER BY Response_count DESC;

-- What are the typical consumption situations for energy drinks among respondents?
SELECT Typical_consumption_situations, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Typical_consumption_situations ORDER BY Response_count DESC;

-- What factors influence respondents' purchase decisions, such as price 
-- range and limited edition packaging?
SELECT Limited_edition_packaging, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Limited_edition_packaging ORDER BY Response_count DESC;

SELECT Price_range, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses
GROUP BY Price_range ORDER BY Response_count DESC;

-- Who are the people those who consume our product CodeX?
SELECT DISTINCT d.Name, d.Age, d.Gender FROM dim_repondents d
JOIN fact_survey_responses f ON d.Respondent_ID = f.Respondent_ID
WHERE f.Tried_before = "Yes" AND f.Current_brands = "CodeX";

-- Which area of business should we focus more on our product development?
SELECT Reasons_for_choosing_brands, COUNT(Respondent_ID) AS Response_count
FROM fact_survey_responses WHERE Current_brands = "CodeX"
GROUP BY Reasons_for_choosing_brands ORDER BY Response_count DESC;



