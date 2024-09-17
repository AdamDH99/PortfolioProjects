--Project Overview
--Project Title: Analysis of European City Listings
--Project Description:

--This project involves analyzing a dataset containing information about various city listings across nine famous European cities: 
--Amsterdam, Athens, Barcelona, Berlin, Budapest, Lisbon, Paris, Rome, and Vienna. 
--The dataset, divided into two CSV files, provides detailed information about the price and characteristics of city listings, 
--including room types, cleanliness ratings, and various indices related to city attractions and restaurants.

--The goal of this project is to explore the dataset, verify data integrity, 
--and perform various analyses to uncover trends, patterns, 
--and insights that can assist in understanding the differences between city listings and their characteristics. 
--The analyses will include basic statistics, comparisons, 
--and advanced data manipulation to provide a comprehensive overview of the city listings.

--Files Provided:
--City_Overview.csv: Contains general information about city listings, including prices, room types, and cleanliness ratings.
--Index_Ratings.csv: Contains detailed indices related to attractions and restaurants in each city.

---------------
--Sample Queries to Check CSV Integrity 

--1. Check Data in CSVs

--1.1. Count the Number of Records 

SELECT COUNT(*) AS Total_Records -- Query: Count the total number of records in the Index Ratings CSV
FROM index_ratings;

--1.2. Validate Unique Cities

SELECT COUNT(DISTINCT City) AS Unique_Cities -- Query: Count the number of unique cities in the City Overview CSV
FROM city_overview;

--1.3. Check for Null Values in Critical Columns

SELECT -- Query: Count the number of null values in critical columns
    COUNT(*) - COUNT(City) AS Null_Cities, 
    COUNT(*) - COUNT(Price) AS Null_Prices,
    COUNT(*) - COUNT(Day) AS Null_Days
FROM City_Overview;


---

--2. Check Data in Index Ratings CSV

--2.1. Count the Number of Records

SELECT COUNT(*) AS Total_Records -- Query: Count the total number of records in the Index Ratings CSV
FROM Index_Ratings;

--2.2. Validate Unique Cities

SELECT COUNT(DISTINCT City) AS Unique_Cities -- Query: Count the number of unique cities in the Index Ratings CSV
FROM Index_Ratings;

--2.3. Check for Null Values in Critical Columns

SELECT				-- Query: Count the number of null values in critical columns
	COUNT(*) - COUNT(City) AS Null_Cities,
	COUNT(*) - COUNT(Attraction_Index) AS Null_Attraction_Index,
	COUNT(*) - COUNT(Restraunt_Index) AS Null_Restaurant_Index
FROM Index_Ratings;



--1. Basic Queries

--1.1. Average Price by City

SELECT City, AVG(Price) AS Average_Price -- Query: Average price of listings in each city
FROM City_Overview
GROUP BY City;

--Amsterdam has the highest average price at €573.11.
--Paris follows with an average price of €392.53.
--Barcelona has an average price of €293.75.
--Berlin and Vienna have similar average prices at €244.58 and €241.58 respectively.
--Lisbon has an average price of €238.21.
--Rome has an average price of €205.39.
--Budapest has an average price of €176.51.
--Athens has the lowest average price at €151.74.
----

--1.2. Total Number of Listings by Room Type

SELECT Room_Type, COUNT(*) AS Total_Listings -- Query: Count the total number of listings for each room type
FROM City_Overview
GROUP BY Room_Type;


--The data shows that "Entire home/apt" is by far the most common room type, 
--accounting for the majority of the listings with 28,264 entries. This is followed by "Private room" with 13,134 listings, 
--which still represents a significant portion of the market. 
--"Shared room" is the least common, with only 316 listings, indicating that it is the least preferred or available option 
--among the room types. This distribution suggests a strong preference among users for more private accommodations.

--2. String and Numerical Functions

--2.1. Calculate Price Range

SELECT MIN(Price) AS Min_Price, MAX(Price) AS Max_Price -- Query: Find the minimum and maximum price across all listings
FROM City_Overview;

--The results of the query show that the price range of listings in the dataset spans from a minimum of 34.78 to a maximum of 18,545.45. 
--The difference between the highest and lowest prices is 18,510.67, showcasing a substantial range in pricing. 
--This indicates that the most expensive listing is approximately 53,222% higher than the least expensive one, 
--highlighting the broad diversity in accommodation pricing within the dataset.
---

--2.2. Find Average Distance from City Center

SELECT AVG(City_Center_km) AS Avg_Distance -- Query: Calculate the average distance from the city center
FROM City_Overview;

--The result of the query indicates that the average distance from the city center for the listings in the dataset is approximately 2.68 km. 
--This suggests that, on average, the properties are relatively close to the city center, 
--which can be a crucial factor for travelers prioritizing proximity to central locations. 
--This insight helps gauge how centrally located the accommodations are across the dataset.


--3. Find the average guest satisfaction rating

SELECT AVG(Guest_Satisfaction) AS Avg_Guest_Satisfaction
FROM City_Overview
WHERE Guest_Satisfaction IS NOT NULL;

--The result shows that the average guest satisfaction rating across all listings is 93. 
--This suggests that, on average, guests have rated their experiences very positively, as the score is close to the upper limit 
--It indicates a generally high level of satisfaction with the properties listed in the dataset.

--4.1. Combine City Overview with Index Ratings

-- Query: Show one listing per city with the highest Attraction Index and Restaurant Index
SELECT CO.City, MAX(CO.Price) AS Max_Price, MAX(IR.Attraction_Index) AS Attraction_Index, MAX(IR.Restraunt_Index) AS Restraunt_Index
FROM City_Overview CO
JOIN Index_Ratings IR
ON CO.City = IR.City
GROUP BY CO.City;

--The query reveals the highest values for price, Attraction Index, and Restaurant Index for each city.

--Athens tops the list with the highest price (€18,545.45), reflecting a significant premium on accommodations there. 
--It also has the highest Attraction Index (2654.09) and Restaurant Index (6696.16), 
--indicating a strong appeal and vibrant dining scene.

--Barcelona shows a high price (€6,943.70) and substantial indexes for both attraction (2934.13) and restaurants (4552.36), 
--suggesting a rich array of experiences and amenities.

--Berlin and Budapest have the lowest values for both indexes and price, 
--highlighting more budget-friendly options and potentially fewer high-end attractions and dining experiences.

--Paris and Rome have competitive pricing with moderate to high index values, 
--suggesting well-established attractions and dining options.

--Overall, cities like Athens and Barcelona stand out for their high attraction and restaurant indexes, 
--while cities like Berlin and Budapest offer lower prices with correspondingly lower index values.


-- SubQuery: Find cities where the highest price is above the average price of all cities
SELECT City, Max_Price
FROM (
    SELECT CO.City, MAX(CO.Price) AS Max_Price
    FROM City_Overview CO
    JOIN Index_Ratings IR
    ON CO.City = IR.City
    GROUP BY CO.City
) AS City_Max_Prices
WHERE Max_Price > (
    SELECT AVG(Max_Price)
    FROM (
        SELECT MAX(CO.Price) AS Max_Price
        FROM City_Overview CO
        JOIN Index_Ratings IR
        ON CO.City = IR.City
        GROUP BY CO.City
    ) AS Average_Prices
);


--High-End Pricing in Major Cities: Paris, Athens, and Vienna stand out with significantly high maximum listing prices 
--compared to other cities. This indicates that these cities have a few premium properties with notably higher rates.

--Market Premium: The fact that these cities have the highest prices 
--suggests that they may offer luxury or high-demand listings that drive up prices. 
--This could be due to factors such as high demand, prime locations, or luxury accommodations.

--Price Comparison: Compared to other cities, these cities have higher maximum prices, 
--suggesting they might cater to a higher-end market segment or have unique attributes that justify their premium pricing.

---------------------------------------------------------------------
-- Query: Create a temporary table to store unique city metrics
CREATE TABLE #Unique_City_Metrics (
    City NVARCHAR(255),
    Cleanliness_Rating FLOAT,
    Attraction_Index FLOAT,
    Rank INT
);

-- Query: Insert unique city data into the temporary table with ranking
INSERT INTO #Unique_City_Metrics (City, Cleanliness_Rating, Attraction_Index, Rank)
SELECT CO.City, CO.Cleanliness_Rating, IR.Attraction_Index,
       ROW_NUMBER() OVER (ORDER BY CO.Cleanliness_Rating DESC, IR.Attraction_Index DESC) AS Rank
FROM City_Overview CO
JOIN Index_Ratings IR
ON CO.City = IR.City
GROUP BY CO.City, CO.Cleanliness_Rating, IR.Attraction_Index;

-- Query: Select from the temporary table
SELECT *
FROM #Unique_City_Metrics
ORDER BY Rank;

-- Query: Drop the temporary table
DROP TABLE #Unique_City_Metrics;

--Rome appears prominently in the top 40 results, with multiple entries consistently showing the highest cleanliness rating of 10. 
--The highest attraction index values in these results are mostly associated with Rome, 
--indicating that Rome is a leading city in both cleanliness and attraction metrics among the top entries.

--Barcelona also features prominently, with several high-ranking entries. 
--While the cleanliness rating is uniform at 10, Barcelona shows a range of attraction index values, 
--indicating varied levels of attraction among listings. 
--The highest attraction index value for Barcelona in this set is 2934.13, 
--reflecting significant variation in how attractive different listings are.

--Paris and Lisbon make notable appearances but less frequently than Rome and Barcelona. 
--Paris, with the second-highest attraction index in the results (2056.55), and Lisbon, with values around 3031.84, 
--also indicate high cleanliness and attraction metrics.

--The query successfully ranks cities by attraction index, with Rome and Barcelona leading. 
--The variation in attraction index values among different cities and listings highlights the diverse appeal of these cities.

--The uniform cleanliness rating of 10 across these results suggests 
--that high cleanliness is a common factor in top-ranking listings, regardless of the attraction index.
--------------------------------------------------------------------------------------------


-- Create a stored procedure to get listings based on room type, ordered by price
CREATE PROCEDURE Get_Listings_By_Room_Type
    @RoomType NVARCHAR(50)
AS
BEGIN
    SELECT City, Price, Room_Type
    FROM City_Overview
    WHERE Room_Type = @RoomType
    ORDER BY Price DESC; -- Orders by price in descending order
END;

-- Execute the stored procedure for 'Private room'
EXEC Get_Listings_By_Room_Type 'Private room';

--Highest Prices: Vienna has the highest prices for private room listings, 
--with the most expensive listing at €13,664.31 and a second at €13,656.36.

--Amsterdam Listings: Amsterdam has multiple private room listings with prices ranging from €1,284.65 to €1,769.97. 
--This shows a consistent range of higher-end prices within this city.

--Paris Pricing: Paris features private room listings with prices between €1,343.32 and €1,952.42. 
--This indicates a broad price range for private rooms in Paris.

--Berlin and Rome Prices: Berlin's highest price for a private room is €2,319.34, while Rome's highest is €2,311.74. 
--These cities have lower maximum prices compared to Vienna.

--Repeated Listings: Amsterdam and Barcelona show multiple listings with identical prices, 
--indicating multiple properties within these cities at the same rate.

--Price Ranking: The highest-priced private rooms are concentrated in Vienna, 
--followed by Paris, with other cities such as Amsterdam, Berlin, and Rome having lower maximum prices in comparison.


-----------

-- Query: Calculate average ratings and total listings by city
SELECT City, AVG(Cleanliness_Rating) AS Avg_Cleanliness, COUNT(*) AS Total_Listings
FROM City_Overview
GROUP BY City;

--Uniform Cleanliness Ratings: All cities in the dataset have an average cleanliness rating of 9. 
--This uniform rating suggests that, despite differences in the number of listings, 
--cleanliness standards are consistently high across all cities. 
--This might imply that the rating system used is standardized and effectively measures cleanliness across various locations.

--Total Listings by City:
--Rome leads with the highest number of listings at 9,027, indicating it is a significant market 
--with a vast array of available properties.

--Paris follows with 6,688 listings, showing it is also a major hub with substantial property options.

--Lisbon and Athens have 5,763 and 5,280 listings respectively, 
--highlighting them as prominent cities with considerable property availability.
    
--Budapest and Vienna have 4,022 and 3,537 listings respectively, 
--indicating strong but slightly smaller markets compared to the leading cities.

--Barcelona and Berlin offer 2,833 and 2,484 listings respectively, reflecting a moderate number of properties available.

--Amsterdam has the fewest listings among the major cities with 2,080, suggesting a smaller market or less availability compared to other major cities.

--Analysis of Listings:
--High Listing Counts: The cities with the highest number of listings, 
--such as Rome and Paris, likely offer a more diverse range of property types and price points, 
--potentially attracting a broader audience.

--Low Listing Counts: Cities with fewer listings, like Amsterdam and Berlin, 
--might have a smaller property market or face higher demand relative to supply, 
--which could affect property availability and pricing.

--Cleanliness Consistency:
--Consistency Across Cities: The average cleanliness rating of 9 across all cities suggests that, 
--regardless of the number of listings or market size, properties are maintained to a high standard of cleanliness. 
--This could reflect effective property management practices or a standardized evaluation system.

--Modification of an earlier query so I can present the query as a line chart in powerbi--

SELECT City, Room_Type, AVG(Price) AS Average_Price 
FROM City_Overview 
GROUP BY City, Room_Type;

--Amsterdam:
--The city's "Entire home/apt" listings (€734.70) are significantly higher than all other categories. 
--This suggests Amsterdam might cater to a luxury or high-demand market, with a wide gap between shared rooms (€280.91) 
--and private rooms (€383.47). It's clear that privacy comes at a premium in this competitive city.

--Barcelona:
--The wide range in prices, from shared rooms (€124.07) to entire homes (€629.86), 
--indicates Barcelona's diverse accommodation market. The large difference suggests that tourists have varied options, 
--from budget stays to high-end properties, depending on their needs.

--Athens: 
--With "Shared rooms" at just €78.61 and "Entire homes" at €155.08, Athens is the most affordable city in the dataset. 
--This aligns with the city’s reputation for being a budget-friendly travel destination, 
--yet the prices suggest a modest offering in terms of high-end properties.

--Paris:
--As expected, Paris commands premium prices, particularly with "Entire homes" at €425.11. 
--The city's appeal as a global luxury destination is evident, 
--with private rooms (€299.22) also fetching higher prices compared to other cities. 
--Paris remains synonymous with upscale experiences.

--Budapest: 
--Known for its affordability, Budapest's low-cost offerings shine through. "Entire homes" (€184.57) and "Private rooms" (€109.14) 
--are some of the cheapest across the cities, making it an attractive destination for budget-conscious travelers.

--Rome & Lisbon:
--Both cities hover around the mid-range pricing for "Entire homes" (€240-282), 
--suggesting they cater to tourists looking for quality yet affordable stays. 
--Lisbon's slightly higher prices might reflect its growing popularity in recent years.

--Berlin: 
--With "Entire homes" (€363.21) and "Private rooms" (€180.52), 
--Berlin's pricing reflects its status as a major European city with balanced affordability. 
--It offers a wide range of accommodations, but prices show that privacy, even in a private room, 
--costs significantly more than shared rooms (€153.19).


USE [PortfolioProject];
GO
SELECT * FROM index_ratings;

--Rewriting earlier querys so the visualsation shows in POWERBI--

SELECT City, AVG(Guest_Satisfaction) AS Avg_Guest_Satisfaction
FROM City_Overview
WHERE Guest_Satisfaction IS NOT NULL
GROUP BY City;

---
SELECT City, Room_Type, Price 
FROM City_Overview 
ORDER BY Room_Type, Price DESC;

---
SELECT City, AVG(Cleanliness_Rating) AS Avg_Cleanliness, COUNT(*) AS Total_Listings 
FROM City_Overview 
GROUP BY City;

---
SELECT CO.City, MAX(CO.Price) AS Max_Price, MAX(IR.Attraction_Index) AS Attraction_Index, MAX(IR.Restraunt_Index) AS Restaurant_Index 
FROM City_Overview CO 
JOIN Index_Ratings IR ON CO.City = IR.City 
GROUP BY CO.City;
---

SELECT City, AVG(Attraction_Index) AS Avg_Attraction_Index 
FROM Index_Ratings 
GROUP BY City;
---
SELECT City, Max_Price 
FROM (
    SELECT CO.City, MAX(CO.Price) AS Max_Price
    FROM City_Overview CO
    JOIN Index_Ratings IR ON CO.City = IR.City 
    GROUP BY CO.City
) AS City_Max_Prices 
WHERE Max_Price > (
    SELECT AVG(Max_Price) 
    FROM (
        SELECT MAX(CO.Price) AS Max_Price
        FROM City_Overview CO 
        JOIN Index_Ratings IR ON CO.City = IR.City 
        GROUP BY CO.City
    ) AS Average_Prices
);

