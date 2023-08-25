# Airbnb data Outlier Detection & EDA using SQL
## Introduction

The way people experience cities around the world has been completely transformed by Airbnb in the fields of contemporary travel and hospitality. Airbnb provides a variety of lodging options, ranging from comfortable private rooms to roomy entire apartments, as an online marketplace that connects hosts with travelers. The European Booking Dataset, a thorough compilation of information from nine renowned cities—Amsterdam, Athens, Barcelona, Berlin, Budapest, Lisbon, Paris, Rome, and Vienna—is the subject of this project. The dataset has undergone meticulous curation and cleaning, making it a useful tool for analysis and insight.

This project's main goals are to perform exploratory data analysis (EDA), identify outliers in the dataset, and determine any possible causal links between outliers and guest satisfaction.  In order to identify patterns, trends, and elements that affect visitors' overall experiences, we will combine data from various cities and Airbnb stays. We use SQL queries within the Snowflake environment to accomplish this, allowing us to quickly process and analyze large amounts of data.

## Dataset Overview

The dataset comprises several key variables that shed light on different dimensions of Airbnb stays. These variables include:

- **City**: The name of the city in which the Airbnb stay is located.
- **Price**: The price of the Airbnb stay.
- **Day**: Indicates whether the stay falls on a weekday or weekend.
- **Room Type**: The type of Airbnb accommodation, such as an entire apartment, private room, or shared room.
- **Shared Room**: Indicates whether the room is shared by multiple guests.
- **Private Room**: Indicates the availability of a private room within the accommodation.
- **Person Capacity**: The maximum number of individuals the accommodation can host.
- **Superhost**: A binary indicator of whether the host is classified as a superhost.
- **Multiple Rooms**: Indicates if the Airbnb offers multiple rooms (2-4 rooms).
- **Business**: A binary indicator of whether the accommodation offers more than four listings, potentially suggesting a business-oriented host.
- **Cleaningness Rating**: A rating reflecting the cleanliness of the place, as provided by guests.
- **Guest Satisfaction**: The satisfaction score left by guests after their stay.
- **Bedrooms**: The number of bedrooms available in the facility.
- **City Center (km)**: The distance from the accommodation to the city center.
- **Metro Distance (km)**: The distance from the accommodation to the nearest metro service.
- **Attraction Index**: An index measuring the proximity of attractions to the accommodation.
- **Normalized Attraction Index**: A normalized version of the attraction index.
- **Restaurant Index**: An index measuring the proximity of restaurants to the accommodation.
- **Normalized Restaurant Index**: A normalized version of the restaurant index.

## Project Goals

1. **Exploratory Data Analysis (EDA)**: Before delving into outlier detection and causal relationship establishment, it's crucial to understand the data. Through visualization and statistical analysis, we'll uncover insights such as price distributions, room type preferences, and location-based trends.

2. **Outlier Detection**: Identifying outliers can provide valuable insights into unusual occurrences or exceptional cases within the dataset. By applying appropriate techniques, we can pinpoint instances that deviate significantly from the norm, potentially shedding light on hidden factors affecting guest satisfaction.

3. **Causal Relationship with Guest Satisfaction**: Establishing causal relationships involves examining factors that might influence guest satisfaction scores. Through rigorous analysis, we'll explore correlations and potentially infer causal links between variables such as cleanliness ratings, distance to city center, and room types.

## Database Creation & Bulk Insertion
```sql
-- Create a new database named "TOURISM"
-- If it already exists, it will be replaced
CREATE OR REPLACE DATABASE TOURISM;

-- Switch to the newly created database
USE DATABASE TOURISM;

-- Create a new schema named "EUROPE" within the database
CREATE SCHEMA EUROPE;

-- Switch to the newly created schema
USE SCHEMA EUROPE;

-- Create a table named "AIRBNB" to store the Airbnb data
-- Define the columns and their data types
CREATE OR REPLACE TABLE AIRBNB (
    CITY VARCHAR(20),
    PRICE NUMBER(10, 4),
    DAY VARCHAR(8),
    ROOM_TYPE VARCHAR(20),
    SHARED_ROOM BOOLEAN,
    PRIVATE_ROOM BOOLEAN,
    PERSON_CAPACITY NUMBER(3, 0),
    SUPERHOST BOOLEAN,
    MULTIPLE_ROOMS NUMBER(1, 0),
    BUSINESS NUMBER(1, 0),
    CLEANINGNESS_RATING NUMBER(10, 4),
    GUEST_SATISFACTION NUMBER(3, 0),
    BEDROOMS NUMBER(3, 0),
    CITY_CENTER_KM NUMBER(8, 4),
    METRO_DISTANCE_KM NUMBER(8, 4),
    ATTRACTION_INDEX NUMBER(8, 4),
    NORMALSED_ATTACTION_INDEX NUMBER(8, 4),
    RESTAURANT_INDEX NUMBER(8, 4),
    NORMALISED_RESTAURANT_INDEX NUMBER(8, 4)
);

-- Create a file format named "csv_format" for CSV files
-- Define the field delimiter, field optionally enclosed by double quotes,
-- and skip the header row
CREATE OR REPLACE FILE FORMAT csv_format
    TYPE = 'csv'
    COMPRESSION = 'none'
    FIELD_DELIMITER = ','
    FIELD_OPTIONALLY_ENCLOSED_BY = '\042'
    SKIP_HEADER = 1;

-- Show a sample of the data in the "AIRBNB" table
SELECT * FROM AIRBNB LIMIT 5;
```
### Result:
| CITY      | PRICE    | DAY     | ROOM_TYPE    | SHARED_ROOM | PRIVATE_ROOM | PERSON_CAPACITY | SUPERHOST | MULTIPLE_ROOMS | BUSINESS | CLEANINGNESS_RATING | GUEST_SATISFACTION | BEDROOMS | CITY_CENTER_KM | METRO_DISTANCE_KM | ATTRACTION_INDEX | NORMALSED_ATTACTION_INDEX | RESTAURANT_INDEX | NORMALISED_RESTAURANT_INDEX |
|-----------|----------|---------|--------------|-------------|--------------|-----------------|-----------|----------------|----------|---------------------|--------------------|----------|----------------|-------------------|------------------|---------------------------|------------------|-----------------------------|
| Amsterdam | 194.0337 | Weekday | Private room | FALSE       | TRUE         | 2               | FALSE     | 1              | 0        | 10                  | 93                 | 1        | 5.023          | 2.5394            | 78.6904          | 4.1667                    | 98.2539          | 6.8465                      |
| Amsterdam | 344.2458 | Weekday | Private room | FALSE       | TRUE         | 4               | FALSE     | 0              | 0        | 8                   | 85                 | 1        | 0.4884         | 0.2394            | 631.1764         | 33.4212                   | 837.2808         | 58.3429                     |
| Amsterdam | 264.1014 | Weekday | Private room | FALSE       | TRUE         | 2               | FALSE     | 0              | 1        | 9                   | 87                 | 1        | 5.7483         | 3.6516            | 75.2759          | 3.9859                    | 95.387           | 6.6467                      |
| Amsterdam | 433.5294 | Weekday | Private room | FALSE       | TRUE         | 4               | FALSE     | 0              | 1        | 9                   | 90                 | 2        | 0.3849         | 0.4399            | 493.2725         | 26.1191                   | 875.0331         | 60.9736                     |
| Amsterdam | 485.5529 | Weekday | Private room | FALSE       | TRUE         | 2               | TRUE      | 0              | 0        | 10                  | 98                 | 1        | 0.5447         | 0.3187            | 552.8303         | 29.2727                   | 815.3057         | 56.8117                     |

In order to complete several important tasks, this script first switches to the new database, "TOURISM," or creates a new one if one already exists. A schema called "EUROPE" is created in the "TOURISM" database, and the context changes to this schema. A table called "AIRBNB" is then created with columns that correspond to dataset variables and are each defined with the appropriate data types. In addition, a file format called "csv_format" is created for CSV files that specifies the field delimiter, permits optional double-quote enclosure, and instructs the skip-header-row option. Finally, a sample of the data from the "AIRBNB" table is shown, providing a preliminary look at the dataset's organization. This script, which is written in Markdown and provides step-by-step explanations, is prepared to be added to your GitHub repository or portfolio website.

## Exploratory Data Analysis
Query 1: Count total records in the dataset
Returns the number of records in the dataset (41,714).
```sql
/* Exploratory Data Analysis (EDA) */

-- Count the number of records in the dataset
SELECT COUNT(*) AS "NUMBER OF RECORDS" FROM AIRBNB; -- Total records: 41,714
```
Query 2: Count unique cities in the dataset
Calculates the number of unique cities in the dataset (9 cities).
```sql
-- Count the number of unique/distinct cities in the European dataset
SELECT COUNT(DISTINCT CITY) AS "NUMBER OF UNIQUE CITY"
FROM AIRBNB; -- Total unique cities: 9
```
Query 3: List distinct city names
Displays the unique names of cities present in the dataset.
```sql
-- List distinct city names
SELECT DISTINCT CITY AS "CITY NAMES"
FROM AIRBNB;
```
| CITY NAMES |
|------------|
| Amsterdam  |
| Athens     |
| Barcelona  |
| Berlin     |
| Budapest   |
| Lisbon     |
| Paris      |
| Vienna     |
| Rome       |

Query 4: Count bookings per city
Shows the number of bookings made in each city, ordered by booking counts.
```sql
-- Count the number of bookings in each city
SELECT CITY, COUNT(CITY) AS "NUMBER OF BOOKINGS"
FROM AIRBNB
GROUP BY CITY
ORDER BY 2 DESC;
```
| CITY      | NUMBER OF BOOKINGS |
|-----------|--------------------|
| Rome      | 9,027              |
| Paris     | 6,688              |
| Lisbon    | 5,763              |
| Athens    | 5,280              |
| Budapest  | 4,022              |
| Vienna    | 3,537              |
| Barcelona | 2,833              |
| Berlin    | 2,484              |
| Amsterdam | 2,080              |

Query 5: Calculate total booking revenue by city
Computes the total booking revenue generated for each city, ordered by revenue.
```sql
-- Calculate total booking revenue by city
SELECT CITY, ROUND(SUM(PRICE), 0) AS "TOTAL BOOKING REVENUE"
FROM AIRBNB
GROUP BY CITY
ORDER BY 2 DESC;
```
| CITY      | TOTAL BOOKING REVENUE |
|-----------|-----------------------|
| Paris     | 2,625,250             |
| Rome      | 1,854,073             |
| Lisbon    | 1,372,807             |
| Amsterdam | 1,192,075             |
| Vienna    | 854,477               |
| Barcelona | 832,204               |
| Athens    | 801,209               |
| Budapest  | 709,937               |
| Berlin    | 607,546               |

Query 6: Combine bookings and revenue by city
Presents the number of bookings and total revenue for each city, ordered by revenue.
```sql
-- Combine the results of number of bookings and total booking revenue by city
SELECT CITY, COUNT(CITY) AS "NUMBER OF BOOKINGS", ROUND(SUM(PRICE), 0) AS "TOTAL BOOKING REVENUE"
FROM AIRBNB
GROUP BY CITY
ORDER BY "TOTAL BOOKING REVENUE" DESC;
```
| CITY      | NUMBER OF BOOKINGS | TOTAL BOOKING REVENUE |
|-----------|--------------------|-----------------------|
| Paris     | 6,688              | 2,625,250             |
| Rome      | 9,027              | 1,854,073             |
| Lisbon    | 5,763              | 1,372,807             |
| Amsterdam | 2,080              | 1,192,075             |
| Vienna    | 3,537              | 854,477               |
| Barcelona | 2,833              | 832,204               |
| Athens    | 5,280              | 801,209               |
| Budapest  | 4,022              | 709,937               |
| Berlin    | 2,484              | 607,546               |

Query 7: List distinct room types
Displays the different types of rooms available in the dataset.
```sql
-- List distinct room types
SELECT DISTINCT ROOM_TYPE
FROM AIRBNB;
```
| ROOM_TYPE       |
|-----------------|
| Private room    |
| Entire home/apt |
| Shared room     |

Query 8: Analyze city and room type relationships
Explores potential causal links by comparing bookings, revenue, and average guest satisfaction scores for various city and room type combinations.
```sql
-- Explore potential causal relationships
-- Analyze bookings, revenue, and average guest satisfaction by city and room type
SELECT CITY, ROOM_TYPE, COUNT(CITY) AS "NUMBER OF BOOKINGS", ROUND(SUM(PRICE), 0) AS "TOTAL BOOKING REVENUE", ROUND(AVG(GUEST_SATISFACTION), 1) AS "AVERAGE GUEST SATISFACTION SCORE"
FROM AIRBNB
GROUP BY CITY, ROOM_TYPE
ORDER BY 4 DESC;
```
| CITY      | ROOM_TYPE       | NUMBER OF BOOKINGS | TOTAL BOOKING REVENUE | AVERAGE GUEST SATISFACTION SCORE |
|-----------|-----------------|--------------------|-----------------------|----------------------------------|
| Paris     | Entire home/apt | 5,067              | 2,154,021             | 92                               |
| Rome      | Entire home/apt | 5,561              | 1,339,001             | 93.5                             |
| Lisbon    | Entire home/apt | 3,878              | 1,095,519             | 91.6                             |
| Amsterdam | Entire home/apt | 1,126              | 827,271               | 95.4                             |
| Athens    | Entire home/apt | 4,872              | 755,548               | 95.2                             |
| Vienna    | Entire home/apt | 2,747              | 704,763               | 93.6                             |
| Budapest  | Entire home/apt | 3,589              | 662,433               | 94.7                             |
| Rome      | Private room    | 3,454              | 513,912               | 92.5                             |
| Barcelona | Private room    | 2,279              | 489,334               | 91.6                             |
| Paris     | Private room    | 1,527              | 456,907               | 92.3                             |
| Amsterdam | Private room    | 944                | 361,994               | 93.5                             |
| Barcelona | Entire home/apt | 542                | 341,382               | 89.2                             |
| Berlin    | Entire home/apt | 882                | 320,348               | 94                               |
| Berlin    | Private room    | 1,529              | 276,015               | 94.7                             |
| Lisbon    | Private room    | 1,811              | 269,662               | 90.2                             |
| Vienna    | Private room    | 774                | 147,390               | 94.2                             |
| Budapest  | Private room    | 419                | 45,729                | 93.2                             |
| Athens    | Private room    | 397                | 44,797                | 93.1                             |
| Paris     | Shared room     | 94                 | 14,321                | 92.1                             |
| Berlin    | Shared room     | 73                 | 11,183                | 90.2                             |
| Lisbon    | Shared room     | 74                 | 7,627                 | 85.1                             |
| Amsterdam | Shared room     | 10                 | 2,809                 | 92.8                             |
| Vienna    | Shared room     | 16                 | 2,324                 | 88.1                             |
| Budapest  | Shared room     | 14                 | 1,776                 | 97.6                             |
| Barcelona | Shared room     | 12                 | 1,489                 | 89.3                             |
| Rome      | Shared room     | 12                 | 1,161                 | 87.4                             |
| Athens    | Shared room     | 11                 | 865                   | 92.1                             |

Query 9: Explore weekend and private room relationships
Continues causal relationship exploration by analyzing bookings, revenue, and average guest satisfaction scores specifically for weekends and private rooms.
```sql
-- Analyze bookings, revenue, and average guest satisfaction for weekends and private rooms
SELECT CITY, COUNT(CITY) AS "NUMBER OF BOOKINGS", ROUND(SUM(PRICE), 0) AS "TOTAL BOOKING REVENUE", ROUND(AVG(GUEST_SATISFACTION), 1) AS "AVERAGE GUEST SATISFACTION SCORE"
FROM AIRBNB
WHERE DAY ILIKE '%end' AND ROOM_TYPE ILIKE 'pri%' -- Only for weekends and private rooms
GROUP BY CITY
ORDER BY 4 DESC;
```
| CITY      | NUMBER OF BOOKINGS | TOTAL BOOKING REVENUE | AVERAGE GUEST SATISFACTION SCORE |
|-----------|--------------------|-----------------------|----------------------------------|
| Berlin    | 754                | 139,445               | 94.7                             |
| Vienna    | 392                | 74,178                | 94.2                             |
| Amsterdam | 385                | 156,973               | 93.3                             |
| Athens    | 196                | 21,829                | 93.2                             |
| Budapest  | 203                | 23,616                | 93.2                             |
| Rome      | 1,723              | 262,759               | 92.5                             |
| Paris     | 769                | 228,027               | 92.3                             |
| Barcelona | 1,094              | 249,070               | 91.5                             |
| Lisbon    | 917                | 138,008               | 90.3                             |

## Outlier Detection and Removal
```sql
/* Outlier Detection and Data Cleaning */

-- Create or replace a view named "OUTLIER" to identify outliers in the dataset
-- Calculate the five-number summary and interquartile range (IQR)
-- Determine lower and upper hinges for outlier detection
-- Select rows where prices are outliers based on hinges
CREATE OR REPLACE VIEW OUTLIER AS
(
    WITH FIVE_NUMBER_SUMMARY AS
    -- Calculate the minimum, Q1, median, Q3, and maximum of the "PRICE" field
    SELECT 
        MIN(PRICE) AS MIN_ORDER_VALUE,
        PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY PRICE) AS Q1,
        PERCENTILE_CONT(0.50) WITHIN GROUP (ORDER BY PRICE) AS MEDIAN,
        PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY PRICE) AS Q3,
        MAX(PRICE) AS MAX_ORDER_VALUE,
        (PERCENTILE_CONT(0.75) WITHIN GROUP (ORDER BY PRICE) - PERCENTILE_CONT(0.25) WITHIN GROUP (ORDER BY PRICE)) AS IQR
    FROM AIRBNB
),
HINGES AS
    -- Calculate the lower and upper hinges for outlier detection
    SELECT (Q1 - 1.5 * IQR) AS LOWER_HINGE, (Q3 + 1.5 * IQR) AS UPPER_HINGE
    FROM FIVE_NUMBER_SUMMARY
    -- Select rows where prices are outliers based on hinges
    SELECT 
        *
    FROM AIRBNB
    WHERE PRICE < (SELECT LOWER_HINGE FROM HINGES) OR PRICE > (SELECT UPPER_HINGE FROM HINGES)
);

-- Count the number of outliers in the "PRICE" field
SELECT 
    COUNT (*) AS "NUMBER OF OUTLIERS IN PRICE FIELD" 
FROM OUTLIER
WHERE PRICE < (SELECT LOWER_HINGE FROM HINGES) OR PRICE > (SELECT UPPER_HINGE FROM HINGES); -- Total outliers: 2,891
```
This query creates a view called "OUTLIER" to identify and store outlier data based on the "PRICE" field. It calculates the five-number summary, interquartile range (IQR), and hinges for outlier detection. It then selects rows where prices are outside the hinges, indicating outliers.

Also, counts the number of outliers present in the "PRICE" field using the "OUTLIER" view. The result indicates that there are 2,891 outliers.

```sql
-- Check outlier data statistics (minimum, average, maximum) grouped by room type
SELECT 
    ROOM_TYPE AS "ROOM TYPE",
    COUNT(*) AS "NO. OF Bookings", 
    ROUND(MIN(PRICE), 1) AS "MINIMUM OUTLIER PRICE VALUE",
    ROUND(MAX(PRICE), 1) AS "MAXIMUM OUTLIER PRICE VALUE",
    ROUND(AVG(PRICE), 1) AS "AVERAGE OUTLIER PRICE VALUE"
FROM OUTLIER
GROUP BY ROOM_TYPE;
```
| ROOM TYPE       | NO. OF Bookings | MINIMUM OUTLIER PRICE VALUE | MAXIMUM OUTLIER PRICE VALUE | AVERAGE OUTLIER PRICE VALUE |
|-----------------|-----------------|-----------------------------|-----------------------------|-----------------------------|
| Private room    | 353             | 528.2                       | 13,664.3                    | 822.8                       |
| Entire home/apt | 2,536           | 527.5                       | 18,545.5                    | 853.2                       |
| Shared room     | 2               | 556.2                       | 591.2                       | 573.7                       |

This query presents statistics (minimum, maximum, average) of outlier data grouped by room type. It reveals the range of outlier prices within different room types.

```sql
-- Compare outlier data statistics with the main dataset
-- Check minimum, average, and maximum prices grouped by room type
SELECT 
    ROOM_TYPE AS "ROOM TYPE",
    COUNT(*) AS "NO. OF Bookings", 
    ROUND(MIN(PRICE), 1) AS "MINIMUM PRICE VALUE",
    ROUND(MAX(PRICE), 1) AS "MAXIMUM PRICE VALUE",
    ROUND(AVG(PRICE), 1) AS "AVERAGE PRICE VALUE"
FROM AIRBNB
GROUP BY ROOM_TYPE; -- Notice the difference in average outlier price value vs. average price value
```
| ROOM TYPE       | NO. OF Bookings | MINIMUM PRICE VALUE | MAXIMUM PRICE VALUE | AVERAGE PRICE VALUE |
|-----------------|-----------------|---------------------|---------------------|---------------------|
| Private room    | 13,134          | 34.8                | 13,664.3            | 198.4               |
| Entire home/apt | 28,264          | 37.1                | 18,545.5            | 290.1               |
| Shared room     | 316             | 53.3                | 591.2               | 137.8               |

This query compares the statistics (minimum, maximum, average) of the main dataset with the outlier data, grouped by room type. It highlights the difference in average outlier price values compared to average price values.

```sql
-- Create a view named "CLEANED" by removing outliers
-- Apply similar outlier detection logic to filter out outliers
CREATE VIEW CLEANED AS
(
    WITH FIVE_NUMBER_SUMMARY AS
    -- Same calculation as before
    HINGES AS
        -- Same calculation as before
    -- Select rows where prices are within the hinges, effectively removing outliers
    SELECT * FROM AIRBNB
    WHERE PRICE > (SELECT LOWER_HINGE FROM HINGES) AND PRICE < (SELECT UPPER_HINGE FROM HINGES)
);

-- Count the number of records in the cleaned dataset
SELECT COUNT(*) FROM CLEANED;
```
This query creates a view called "CLEANED" by removing outliers using a similar approach as the "OUTLIER" view. It selects rows where prices fall within the hinges, effectively cleaning the data.

Also, counts the number of records in the cleaned dataset using the "CLEANED" view. There are 38,823 observations.

```sql
-- Check statistics of cleaned data (minimum, average, maximum) grouped by room type
SELECT 
    ROOM_TYPE AS "ROOM TYPE",
    COUNT(*) AS "NO. OF Bookings", 
    ROUND(MIN(PRICE), 1) AS "MINIMUM PRICE VALUE",
    ROUND(MAX(PRICE), 1) AS "MAXIMUM PRICE VALUE",
    ROUND(AVG(PRICE), 1) AS "AVERAGE PRICE VALUE"
FROM CLEANED
GROUP BY ROOM_TYPE;
```
| ROOM TYPE       | NO. OF Bookings | MINIMUM PRICE VALUE | MAXIMUM PRICE VALUE | AVERAGE PRICE VALUE |
|-----------------|-----------------|---------------------|---------------------|---------------------|
| Private room    | 12,781          | 34.8                | 527.1               | 181.2               |
| Entire home/apt | 25,728          | 37.1                | 527.3               | 234.6               |
| Shared room     | 314             | 53.3                | 479.2               | 135.1               |

This query presents statistics (minimum, maximum, average) of the cleaned data grouped by room type. It shows the revised range of prices after outliers have been removed.

### Summary:
On the Airbnb dataset, the provided SQL queries carry out data cleansing and outlier detection. To find outliers in the "PRICE" field, a view called "OUTLIER" is initially created. This is accomplished by computing the interquartile range (IQR), hinges for outlier detection, and a five-number summary. The view effectively captures outliers by capturing rows with prices outside the hinges. 2,891 outliers are discovered to exist. The range of outlier prices for each type of room is then revealed through an analysis of outlier data statistics based on room types.

Another query computes statistics grouped by room types to compare the outlier statistics with the main dataset. This demonstrates the variation between the average outlier price values and the average dataset price values. Then, outliers are eliminated to produce a view called "CLEANED."  A cleaned dataset is produced by applying similar outlier detection logic to retain only the rows within the hinges. The count of records in the cleaned dataset is 38,823. Following the removal of outliers, the statistics of the cleaned data, grouped by room types, display the revised price ranges. These procedures offer a thorough method for identifying and handling outliers in the Airbnb dataset, resulting in more precise analyses and insights.

## Weekend-Weekday Comparative Analysis
```sql
/* Analysis of Booking Prices by Day Type */

-- Select booking statistics based on day type
SELECT 
    DAY AS DAY_TYPE,                             -- Select the day type (weekday or weekend)
    ROUND(AVG(PRICE), 0) AS AVERAGE_PRICE,       -- Calculate average booking price and round
    ROUND(MIN(PRICE), 1) AS MINIMUM_BOOKING_PRICE, -- Calculate minimum booking price and round
    ROUND(MAX(PRICE), 1) AS MAXIMUM_BOOKING_PRICE, -- Calculate maximum booking price and round
    ROUND(SUM(PRICE), 0) AS "TOTAL BOOKING PRICE", -- Calculate total booking price and round
    COUNT(ROOM_TYPE) AS NUMBER_OF_BOOKING         -- Count the number of bookings for each day type
FROM CLEANED                                       -- Use the cleaned dataset
GROUP BY DAY                                       -- Group the results by day type (weekday or weekend)
ORDER BY "TOTAL BOOKING PRICE" DESC;                -- Order the results by total booking price in descending order
```
| DAY_TYPE | AVERAGE_PRICE | MINIMUM_BOOKING_PRICE | MAXIMUM_BOOKING_PRICE | TOTAL BOOKING PRICE | NUMBER_OF_BOOKING |
|----------|---------------|-----------------------|-----------------------|---------------------|-------------------|
| Weekend  | 219           | 34.8                  | 527.1                 | 4,230,451           | 19,318            |
| Weekday  | 213           | 37.1                  | 527.3                 | 4,163,749           | 19,505            |

This SQL query focuses on analyzing booking prices based on the type of day (weekday or weekend) in the cleaned dataset. It calculates various statistics for each day type, including the average, minimum, and maximum booking prices, as well as the total booking price and the number of bookings. The results are grouped by day type and ordered in descending order of total booking price.

This analysis provides insights into how booking prices vary between weekdays and weekends, offering a clear overview of the price distribution and potential patterns in the dataset.

## Causal Relationship with Guest Satisfaction Scores
Overall Guest Satisfaction Statistics: This query calculates the average, minimum, and maximum guest satisfaction scores in the cleaned dataset, providing insights into the overall satisfaction level.

```sql
/* Guest Satisfaction Analysis */

-- Query 1: Calculate overall guest satisfaction statistics
-- Calculate the average, minimum, and maximum guest satisfaction scores in the cleaned dataset
SELECT 
    ROUND(AVG(GUEST_SATISFACTION), 1) AS AVERAGE_GUEST_SATISFACTION_SCORE,
    ROUND(MIN(GUEST_SATISFACTION), 1) AS MINIMUM_GUEST_SATISFACTION_SCORE,
    ROUND(MAX(GUEST_SATISFACTION), 1) AS MAXIMUM_GUEST_SATISFACTION_SCORE
FROM CLEANED; -- Average: 93.0, Min: 20.0, Max: 100.0
```
| AVERAGE_GUEST_SATISFACTION_SCORE | MINIMUM_GUEST_SATISFACTION_SCORE | MAXIMUM_GUEST_SATISFACTION_SCORE |
|----------------------------------|----------------------------------|----------------------------------|
| 93.1                             | 20                               | 100                              |

Guest Satisfaction by City: This query presents average, minimum, and maximum guest satisfaction scores grouped by city, ordered by average guest satisfaction. It reveals variations in guest satisfaction among different cities.
```sql
-- Query 2: Analyze guest satisfaction by city
-- Calculate average, minimum, and maximum guest satisfaction scores by city, ordered by average guest satisfaction
SELECT 
    CITY,
    ROUND(AVG(GUEST_SATISFACTION), 1) AS AVERAGE_GUEST_SATISFACTION_SCORE,
    ROUND(MIN(GUEST_SATISFACTION), 1) AS MINIMUM_GUEST_SATISFACTION_SCORE,
    ROUND(MAX(GUEST_SATISFACTION), 1) AS MAXIMUM_GUEST_SATISFACTION_SCORE
FROM CLEANED
GROUP BY CITY
ORDER BY AVERAGE_GUEST_SATISFACTION_SCORE DESC;
```
| CITY      | AVERAGE_GUEST_SATISFACTION_SCORE | MINIMUM_GUEST_SATISFACTION_SCORE | MAXIMUM_GUEST_SATISFACTION_SCORE |
|-----------|----------------------------------|----------------------------------|----------------------------------|
| Athens    | 95                               | 20                               | 100                              |
| Budapest  | 94.6                             | 20                               | 100                              |
| Berlin    | 94.3                             | 20                               | 100                              |
| Amsterdam | 94                               | 20                               | 100                              |
| Vienna    | 93.7                             | 20                               | 100                              |
| Rome      | 93.1                             | 20                               | 100                              |
| Paris     | 91.8                             | 20                               | 100                              |
| Barcelona | 91.3                             | 20                               | 100                              |
| Lisbon    | 91                               | 20                               | 100                              |

Factors Behind Guest Satisfaction: This query explores the factors contributing to the difference in average guest satisfaction scores across cities. It analyzes average cleanliness rating, price, attraction index, and distances to assess potential influencers of guest satisfaction.
```sql
-- Query 3: Explore factors behind the difference in average guest satisfaction scores
-- Analyze various factors' averages for cities with higher guest satisfaction
SELECT 
    CITY,
    ROUND(AVG(GUEST_SATISFACTION), 1) AS AVERAGE_GUEST_SATISFACTION_SCORE,
    ROUND(AVG(CLEANINGNESS_RATING), 2) AS AVERAGE_CLEANLINESS_RATING,
    ROUND(AVG(PRICE), 0) AS AVERAGE_PRICE,
    ROUND(AVG(NORMALSED_ATTACTION_INDEX), 1) AS AVERAGE_ATTRACTION_INDEX,
    ROUND(MAX(CITY_CENTER_KM), 1) AS AVERAGE_DISTANCE_FROM_CITY_CENTER,
    ROUND(MAX(METRO_DISTANCE_KM), 1) AS AVERAGE_DISTANCE_FROM_METRO
FROM CLEANED
GROUP BY CITY
ORDER BY AVERAGE_GUEST_SATISFACTION_SCORE DESC;
```
| CITY      | AVERAGE_GUEST_SATISFACTION_SCORE | AVERAGE_CLEANLINESS_RATING | AVERAGE_PRICE | AVERAGE_ATTRACTION_INDEX | AVERAGE_DISTANCE_FROM_CITY_CENTER | AVERAGE_DISTANCE_FROM_METRO |
|-----------|----------------------------------|----------------------------|---------------|--------------------------|-----------------------------------|-----------------------------|
| Athens    | 95                               | 9.64                       | 144           | 5.7                      | 6.2                               | 2                           |
| Budapest  | 94.6                             | 9.48                       | 167           | 12.6                     | 19.3                              | 11.7                        |
| Berlin    | 94.3                             | 9.46                       | 212           | 16.4                     | 25.3                              | 14.3                        |
| Amsterdam | 94                               | 9.48                       | 354           | 12.5                     | 11.2                              | 4.4                         |
| Vienna    | 93.7                             | 9.47                       | 222           | 8.7                      | 13.3                              | 5.2                         |
| Rome      | 93.1                             | 9.51                       | 197           | 10.3                     | 9.6                               | 4.1                         |
| Paris     | 91.8                             | 9.23                       | 299           | 17.2                     | 7.7                               | 1.2                         |
| Barcelona | 91.3                             | 9.3                        | 227           | 16.4                     | 8.4                               | 4                           |
| Lisbon    | 91                               | 9.36                       | 230           | 7.3                      | 9.6                               | 6.2                         |

Correlation with Attraction Index: This query calculates the correlation between guest satisfaction and attraction index, indicating the strength and direction of their association.
```sql
-- Correlation analysis of guest satisfaction
-- Calculate the correlation between guest satisfaction and attraction index
SELECT 
    ROUND(CORR(GUEST_SATISFACTION, NORMALSED_ATTACTION_INDEX), 2) AS "CORRELATION BET GUEST SATISFACTION AND ATTRACTION INDEX"
FROM CLEANED; -- Indicates not much association
```
| CORRELATION BET GUEST SATISFACTION AND ATTRACTION INDEX |
|---------------------------------------------------------|
| -0.04                                                   |

Correlation with Price and Cleanliness Rating: These queries compute the correlations between guest satisfaction and price, as well as guest satisfaction and cleanliness rating. They reveal the degree of association between guest satisfaction and these factors.
```sql
-- Calculate the correlation between guest satisfaction and price, and guest satisfaction and cleanliness rating
SELECT 
    ROUND(CORR(GUEST_SATISFACTION, PRICE), 2) AS "CORRELATION BET GUEST SATISFACTION AND PRICE",
    ROUND(CORR(GUEST_SATISFACTION, CLEANINGNESS_RATING), 2) AS "CORRELATION BET GUEST SATISFACTION AND CLEANINGNESS RATING"
FROM CLEANED; -- Price doesn't have a significant association, but cleanliness rating does have a moderate to strong positive association
```
| CORRELATION BET GUEST SATISFACTION AND PRICE | CORRELATION BET GUEST SATISFACTION AND CLEANINGNESS RATING |
|----------------------------------------------|------------------------------------------------------------|
| 0                                            | 0.69                                                       |

### Summary:
The provided SQL queries focus on establishing a causal relationship between guest satisfaction scores and various factors within the cleaned Airbnb dataset.

- **Overall Guest Satisfaction Statistics**: The average, minimum, and maximum guest satisfaction scores are calculated, resulting in an average satisfaction of 93.1, with a minimum of 20 and a maximum of 100.

- **Guest Satisfaction by City**: The average, minimum, and maximum guest satisfaction scores are grouped by city and ordered by average guest satisfaction. This analysis highlights variations in guest satisfaction among cities, with Athens, Budapest, and Berlin having the highest average scores.

- **Factors Behind Guest Satisfaction**: The query investigates the elements that affect how average guest satisfaction scores vary across cities. Analysis is done on a number of variables, including price, distance, attraction index, and average cleanliness rating. Higher guest satisfaction scores are found in Athens, Budapest, and Berlin, which also have moderate to high ratings for cleanliness, relatively low prices, and higher attraction indices.

- **Correlation with Attraction Index**: The correlation between guest satisfaction and attraction index is calculated, indicating a weak negative association (correlation coefficient: -0.04). This suggests that guest satisfaction is not substantially influenced by the attraction index.

- **Correlation with Price and Cleanliness Rating**: The correlations between guest satisfaction and price, as well as guest satisfaction and cleanliness rating, are determined. The correlation with price is negligible (correlation coefficient: 0), implying that price doesn't significantly impact guest satisfaction. However, the correlation with cleanliness rating is moderately strong and positive (correlation coefficient: 0.69), indicating that guest satisfaction tends to increase with higher cleanliness ratings.

In conclusion, the questions reveal information about the variables affecting guest satisfaction ratings. While factors like attraction index and price have a relatively small impact on customer satisfaction, cleanliness rating stands out as a significant factor. These results assist in highlighting important areas where hosts and Airbnb hosts can concentrate in order to improve guest experiences and general satisfaction.

## Conclusion:
In conclusion, the "Airbnb Data Analysis and Outlier Detection Project" has shed important light on various aspects of the Airbnb market by offering insightful analyses of the European booking dataset. We gained a thorough understanding of booking patterns, pricing trends, and the distribution of room types across various cities through extensive exploratory data analysis (EDA). We were able to identify potential research areas of interest thanks to this preliminary analysis.

Outlier detection, where we used statistical techniques to find and examine outliers in the dataset's price distribution, was a crucial component of this project. We were able to comprehend the extent of the outlier presence thanks to this process, which also resulted in the creation of a "CLEANED" dataset by eliminating the outliers. For a thorough analysis, the cleaned dataset better captures the underlying trends and patterns in the data.

We investigated factors that affect guest satisfaction scores as we dug deeper into the topic. When compared to other factors like attraction index and price, the correlation analysis showed that cleanliness ratings have a significant impact on guest satisfaction. This finding emphasizes how crucial it is to uphold strict standards for cleanliness in order to improve visitor satisfaction.

This project helps Airbnb hosts and stakeholders make wise decisions to increase guest satisfaction by presenting statistics and correlations. The knowledge gained from this analysis can be used to inform pricing decisions, emphasize the importance of cleanliness, and provide practical advice for enhancing the guest experience.

Overall, this project serves as an example of the value of data analysis in delivering practical knowledge for enhancing business operations and client satisfaction in the dynamic and cutthroat environment of the hospitality sector. This project is a useful tool for analysts and stakeholders in the Airbnb ecosystem because it combines exploratory analysis, outlier detection, and correlation assessments to create a strong foundation for data-driven decision-making.
