# Cohort Analysis using Snowflake SQL Queries

In this analysis, we perform cohort analysis on different variables such as invoices, customers, and revenues using Snowflake SQL queries. We use a retail dataset and focus on various cohort-related metrics.
  The dataset is downloaded from kaggle.com ("https://www.kaggle.com/datasets/jihyeseo/online-retail-data-set-from-uci-ml-repo").

## Table of Contents
- [Introduction](#introduction)
- [Cohort Analysis on Order Level](#cohort-analysis-on-order-level)
- [Cohort Analysis/Customer Retention Analysis on Customer Level](#cohort-analysiscustomer-retention-analysis-on-customer-level)
- [Cohort Analysis on Number of Revenue](#cohort-analysis-on-number-of-revenue)
- [Conclusion](#conclusion)

## Introduction

Cohort analysis is a powerful technique that allows us to gain a deeper understanding of customer behavior and business performance by organizing customers into groups based on a common characteristic or event. These groups, or cohorts, are usually formed based on the timing of a specific event, such as the customer's first purchase. By analyzing how cohorts of customers behave over time, we can identify trends, patterns, and potential areas for improvement in customer engagement and revenue generation.

The retail dataset we use in this analysis consists of various attributes such as `InvoiceNo`, `CustomerID`, `InvoiceDate`, `Quantity`, `UnitPrice`, and more. By leveraging this dataset and Snowflake's SQL capabilities, we aim to answer key questions related to customer behavior and business success. Our cohort analysis involves categorizing customers into cohorts based on their first purchase month, and then observing their subsequent activities over a predefined period.

## Purpose of Analysis

The overarching purpose of this project lies in leveraging cohort analysis across multiple dimensions: order level, customer level, and revenue analysis. Through these distinct but interconnected analyses, the project aims to uncover crucial insights that illuminate customer behavior, retention dynamics, and revenue patterns.

**Cohort Analysis on Order Level:** By categorizing customers into cohorts based on their initial purchase month, this analysis delves into understanding the distribution of invoices within these cohorts over subsequent months. This helps identify trends in transaction volumes, revealing whether certain cohorts exhibit sustained engagement or diminishing activity.

**Cohort Analysis on Customer Level:** Focusing on customer retention, this analysis tracks how cohorts evolve over time in terms of customer count. By observing how many customers remain active in each cohort, businesses can gauge the effectiveness of their retention strategies and pinpoint areas for improvement.

**Cohort Analysis on Number of Revenues:** Examining revenue generation, this analysis investigates how revenue changes across different cohorts over successive months. By analyzing revenue trends, businesses can identify cohorts that contribute significantly to revenue growth and those that require interventions to enhance their value.

Through these comprehensive analyses, businesses gain insights into customer lifetime value, retention dynamics, and revenue patterns. These insights pave the way for data-driven strategies that optimize engagement, retention, and revenue, ultimately fostering business growth and customer satisfaction.

## Cohort Analysis on Order Level

The first cohort analysis focuses on order-level cohort analysis. We calculate the number of invoices for each cohort of customers based on their first purchase month.

```sql
-- Create a new database named SALES
CREATE DATABASE SALES;

-- Switch to using the SALES database
USE DATABASE SALES;

-- Create a new schema named COHORT_ANALYSIS
CREATE SCHEMA COHORT_ANALYSIS;

-- Switch to using the COHORT_ANALYSIS schema
USE SCHEMA COHORT_ANALYSIS;

-- Create a table named RETAIL with various columns to store retail data
CREATE OR REPLACE TABLE RETAIL (
    InvoiceNo varchar (10),
    StockCode varchar(20),
    Description varchar(100),
    Quantity number(8,2),
    InvoiceDate varchar(25),
    UnitPrice number(8,2),
    CustomerID number (10),
    Country varchar(25)
);
SELECT * FROM RETAIL LIMIT 5;
```

### Results of the query
  | INVOICENO | STOCKCODE | DESCRIPTION                      | QUANTITY | INVOICEDATE     | UNITPRICE | CUSTOMERID | COUNTRY        |
|-----------|-----------|----------------------------------|----------|-----------------|-----------|------------|----------------|
| 536365    | 85123A    | WHITE HANGING HEART T-LIGHT HOLDER | 6        | 1/12/10 8:26    | 2.55      | 17850      | United Kingdom |
| 536366    | 22633     | HAND WARMER UNION JACK            | 6        | 1/12/10 8:28    | 1.85      | 17850      | United Kingdom |
| 536367    | 84879     | ASSORTED COLOUR BIRD ORNAMENT     | 32       | 1/12/10 8:34    | 1.69      | 13047      | United Kingdom |
| 536368    | 22960     | JAM MAKING SET WITH JARS          | 6        | 1/12/10 8:34    | 4.25      | 13047      | United Kingdom |
| 536369    | 21756     | BATH BUILDING BLOCK WORD          | 3        | 1/12/10 8:35    | 5.95      | 13047      | United Kingdom |

```sql
-- Cohort Analysis on Order Level

-- Step 1: Create a Common Table Expression (CTE) named CTE1 to prepare data
WITH CTE1 AS (
    SELECT 
        InvoiceNo, CUSTOMERID, 
        to_date(INVOICEDATE, 'DD/MM/YY HH24:MI') AS INVOICEDATE, 
        ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL
),

-- Step 2: Create CTE2 to calculate purchase and first purchase months
CTE2 AS (
    SELECT InvoiceNo, CUSTOMERID, INVOICEDATE, 
        DATE_TRUNC('MONTH', INVOICEDATE) AS PURCHASE_MONTH,
        DATE_TRUNC('MONTH', MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE)) AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),

-- Step 3: Create CTE3 to determine cohort months
CTE3 AS (
    SELECT InvoiceNo, FIRST_PURCHASE_MONTH,
        CONCAT('Month_', datediff('MONTH', FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH
    FROM CTE2
)

-- Step 4: Perform the final query to pivot and count invoices by cohort months
SELECT *
FROM CTE3
PIVOT (
    COUNT(InvoiceNo) FOR COHORT_MONTH IN (
        'Month_0', 'Month_1', 'Month_2', 'Month_3', 'Month_4', 'Month_5',
        'Month_6', 'Month_7', 'Month_8', 'Month_9', 'Month_10', 'Month_11', 'Month_12'
    )
)
ORDER BY FIRST_PURCHASE_MONTH;

```
### Results of the query
| FIRST_PURCHASE_MONTH | 'Month_0' | 'Month_1' | 'Month_2' | 'Month_3' | 'Month_4' | 'Month_5' | 'Month_6' | 'Month_7' | 'Month_8' | 'Month_9' | 'Month_10' | 'Month_11' | 'Month_12' |
|----------------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|------------|------------|------------|
| 2010-12-01           | 1,701     | 677       | 573       | 747       | 610       | 799       | 732       | 686       | 653       | 791       | 760        | 1,130      | 395        |
| 2011-01-01           | 545       | 148       | 181       | 148       | 233       | 195       | 176       | 172       | 184       | 233       | 277        | 89         | 0          |
| 2011-02-01           | 473       | 135       | 113       | 162       | 141       | 131       | 123       | 164       | 134       | 187       | 40         | 0          | 0          |
| 2011-03-01           | 542       | 122       | 176       | 149       | 141       | 121       | 157       | 160       | 220       | 45        | 0          | 0          | 0          |
| 2011-04-01           | 385       | 109       | 91        | 78        | 83        | 91        | 94        | 120       | 32        | 0         | 0          | 0          | 0          |
| 2011-05-01           | 365       | 93        | 63        | 70        | 93        | 87        | 113       | 34        | 0         | 0         | 0          | 0          | 0          |
| 2011-06-01           | 296       | 70        | 57        | 91        | 79        | 129       | 30        | 0         | 0         | 0         | 0          | 0          | 0          |
| 2011-07-01           | 235       | 50        | 59        | 55        | 82        | 25        | 0         | 0         | 0         | 0         | 0          | 0          | 0          |
| 2011-08-01           | 203       | 59        | 70        | 69        | 26        | 0         | 0         | 0         | 0         | 0         | 0          | 0          | 0          |
| 2011-09-01           | 379       | 126       | 157       | 41        | 0         | 0         | 0         | 0         | 0         | 0         | 0          | 0          | 0          |
| 2011-10-01           | 453       | 165       | 56        | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0          | 0          | 0          |
| 2011-11-01           | 425	     | 55        | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0          | 0          | 0          |
| 2011-12-01           | 45        | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0         | 0          | 0          | 0          |

## Order Level Cohort Analysis Table Explanation

- **FIRST_PURCHASE_MONTH:** This column indicates the month in which a cohort of customers made their first purchase.

- **'Month_0', 'Month_1', 'Month_2', ..., 'Month_12':** These columns represent the subsequent months following the customers' first purchase. For instance, 'Month_0' corresponds to the same month as the first purchase, 'Month_1' corresponds to the first month after the first purchase, 'Month_2' corresponds to the second month after the first purchase, and so forth.

- **Values in the Table:** The numbers in each cell of the table reflect the count of invoices (transactions) carried out by the customers within the specific cohort during the corresponding month. For instance, if there is a value of 1,701 in the first row under 'Month_0', it means that the cohort of customers who made their initial purchase in December 2010 conducted 1,701 invoices (transactions) within the same month.

The cohort analysis serves as a powerful tool for comprehending customer behavior over time. When observing the table, several observations can be made:

- **Cohort December 2010 ('Month_0'):** This cohort exhibited a substantial number of invoices (1,701) during their first month, which then gradually declined over the subsequent months.

- **Cohort January 2011 ('Month_0'):** This cohort initiated with 545 invoices in the first month, followed by a downward trend in the subsequent months.

- **Cohort February 2011 ('Month_0'):** In the initial month, this cohort recorded 473 invoices, displaying a pattern similar to that of the January cohort.

... and so forth for the other cohorts.

By thoroughly analyzing this cohort table, valuable insights into customer behavior can be uncovered. These insights encompass identifying patterns of repeat purchases, discerning shifts in retention rates over time, and recognizing which cohorts are more likely to generate higher transaction volumes. This collection of information can offer significant insights into business performance and aid in informed decision-making for devising effective customer engagement and marketing strategies.

## Cohort Analysis/Customer Retention Analysis on Customer Level

The following cohort analysis delves into customer-level retention analysis. In this analysis, we determine the count of distinct customers within each cohort, categorized by their first purchase month and subsequent months.

This type of cohort analysis offers insights into how well businesses are retaining their customer base over time, shedding light on customer loyalty and engagement patterns. By observing the changes in customer counts across different cohorts and months, businesses can better understand the effectiveness of their customer retention strategies and tailor their approaches accordingly.

By conducting this analysis, you can gain valuable insights into customer behavior, track changes in retention rates, and identify trends in customer loyalty. This information can guide decision-making processes related to customer engagement, marketing campaigns, and overall business strategies.

```sql
-- Cohort Analysis/Customer Retention Analysis on Customer Level

-- Step 1: Create a Common Table Expression (CTE) named CTE1 to prepare data
WITH CTE1 AS (
    SELECT 
        InvoiceNo, CUSTOMERID, 
        to_date(INVOICEDATE, 'DD/MM/YY HH24:MI') AS INVOICEDATE, 
        ROUND(QUANTITY * UNITPRICE, 2) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL
),

-- Step 2: Create CTE2 to calculate purchase and first purchase months
CTE2 AS (
    SELECT InvoiceNo, CUSTOMERID, INVOICEDATE, 
        DATE_TRUNC('MONTH', INVOICEDATE) AS PURCHASE_MONTH,
        DATE_TRUNC('MONTH', MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE)) AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),

-- Step 3: Create CTE3 to determine cohort months
CTE3 AS (
    SELECT CUSTOMERID, FIRST_PURCHASE_MONTH,
        CONCAT('Month_', datediff('MONTH', FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH
    FROM CTE2
)

-- Final Query: Count distinct customers in each cohort for subsequent months
SELECT FIRST_PURCHASE_MONTH as Cohort,
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_0', CUSTOMERID, NULL))) as "Month_0",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_1', CUSTOMERID, NULL))) as "Month_1",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_2', CUSTOMERID, NULL))) as "Month_2",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_3', CUSTOMERID, NULL))) as "Month_3",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_4', CUSTOMERID, NULL))) as "Month_4",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_5', CUSTOMERID, NULL))) as "Month_5",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_6', CUSTOMERID, NULL))) as "Month_6",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_7', CUSTOMERID, NULL))) as "Month_7",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_8', CUSTOMERID, NULL))) as "Month_8",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_9', CUSTOMERID, NULL))) as "Month_9",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_10', CUSTOMERID, NULL))) as "Month_10",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_11', CUSTOMERID, NULL))) as "Month_11",
    COUNT(DISTINCT(IFF(COHORT_MONTH='Month_12', CUSTOMERID, NULL))) as "Month_12"
FROM CTE3
GROUP BY FIRST_PURCHASE_MONTH
ORDER BY FIRST_PURCHASE_MONTH;
```
### Result of the query
| COHORT     | Month_0 | Month_1 | Month_2 | Month_3 | Month_4 | Month_5 | Month_6 | Month_7 | Month_8 | Month_9 | Month_10 | Month_11 | Month_12 |
|------------|---------|---------|---------|---------|---------|---------|---------|---------|---------|---------|----------|----------|----------|
| 2010-12-01 | 945     | 358     | 313     | 367     | 340     | 375     | 360     | 336     | 333     | 371     | 354      | 473      | 260      |
| 2011-01-01 | 419     | 100     | 118     | 101     | 138     | 126     | 109     | 108     | 129     | 145     | 152      | 63       | 0        |
| 2011-02-01 | 380     | 93      | 73      | 106     | 102     | 91      | 96      | 108     | 97      | 119     | 35       | 0        | 0        |
| 2011-03-01 | 437     | 84      | 111     | 96      | 102     | 77      | 114     | 105     | 126     | 37      | 0        | 0        | 0        |
| 2011-04-01 | 299     | 68      | 65      | 63      | 62      | 72      | 69      | 78      | 25      | 0       | 0        | 0        | 0        |
| 2011-05-01 | 278     | 66      | 48      | 48      | 60      | 68      | 74      | 27      | 0       | 0       | 0        | 0        | 0        |
| 2011-06-01 | 234     | 49      | 44      | 64      | 58      | 79      | 24      | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-07-01 | 191     | 40      | 39      | 43      | 51      | 22      | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-08-01 | 169     | 42      | 42      | 43      | 23      | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-09-01 | 298     | 89      | 98      | 35      | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-10-01 | 350     | 93      | 46      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-11-01 | 321     | 43      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |
| 2011-12-01 | 41      | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0       | 0        | 0        | 0        |

## Cohort Analysis/Customer Retention Analysis on Customer Level

The following table presents the results of a cohort analysis focusing on customer-level retention. This analysis calculates the count of distinct customers within each cohort based on their first purchase month and subsequent months.

### Interpretation of the Table

- **Cohort:** This column displays the cohort's first purchase month, indicating the period when customers made their initial purchases.

- **Month_0, Month_1, ..., Month_12:** These columns represent the subsequent months after the customers' first purchase. For instance, "Month_0" signifies the same month as the first purchase, "Month_1" refers to the first month following the first purchase, and so on.

- **Values in the Table:** The numbers in each cell represent the count of distinct customers who made purchases during the corresponding cohort month and subsequent months. For example, the value 945 under "Month_0" in the row corresponding to the cohort of December 2010 means that there were 945 distinct customers who made their first purchase during that month.

### Observations

- **Cohort of December 2010 (Month_0):** This cohort started with 945 customers in its first month, and the number decreased in subsequent months. For instance, the count in "Month_1" dropped to 358, and it continued to decrease over time.

- **Cohort of January 2011 (Month_0):** In this cohort, 419 customers made their first purchase in January 2011. The count decreased as the months progressed, showing a typical retention pattern.

- **Cohort of February 2011 (Month_0):** With 380 customers making their first purchase, this cohort experienced a similar retention trend as the previous cohorts.

- **... and so on for other cohorts.**

### Insights

By analyzing this cohort table, businesses can gain insights into customer retention patterns. For instance:

- Understanding the percentage of customers who remain active in subsequent months after their first purchase.
- Identifying cohorts that exhibit high or low retention rates.
- Adjusting marketing strategies and engagement initiatives based on cohort behavior.

This analysis provides valuable information for optimizing customer engagement, retention strategies, and marketing efforts, ultimately contributing to business growth and customer satisfaction.

## Cohort Analysis on Number of Revenue

Cohort Analysis on Number of Revenue examines how revenue generated by different customer cohorts changes over time. Cohorts are categorized by their first purchase month, and subsequent monthly revenue is calculated. The outcomes are typically showcased in a table, illustrating revenue generated by each cohort in each month. This analysis helps uncover trends like initial spending spikes, revenue declines, or consistent growth. The insights gained can shape strategies to retain declining cohorts or capitalize on successful ones. It's a valuable tool for revenue optimization, tailored marketing, and enhancing customer lifetime value based on revenue patterns across distinct cohorts.

```sql
-- Cohort Analysis on Number of Revenue

-- Creating a temporary table (CTE1) to calculate revenue from valid transactions
WITH CTE1 AS
(
    SELECT 
        CUSTOMERID,
        to_date(INVOICEDATE, 'DD/MM/YY HH24:MI') AS INVOICEDATE,
        ROUND(QUANTITY*UNITPRICE, 0) AS REVENUE
    FROM RETAIL
    WHERE CUSTOMERID IS NOT NULL
),

-- Creating CTE2 to calculate cohort-related metrics
CTE2 AS
(
    SELECT 
        CUSTOMERID, 
        INVOICEDATE, 
        DATE_TRUNC('MONTH', INVOICEDATE) AS PURCHASE_MONTH,
        DATE_TRUNC('MONTH', MIN(INVOICEDATE) OVER (PARTITION BY CUSTOMERID ORDER BY INVOICEDATE)) AS FIRST_PURCHASE_MONTH,
        REVENUE
    FROM CTE1
),

-- Creating CTE3 for further analysis
CTE3 AS
(
    SELECT 
        FIRST_PURCHASE_MONTH as Cohort,
        CONCAT('Month_', datediff('MONTH', FIRST_PURCHASE_MONTH, PURCHASE_MONTH)) AS COHORT_MONTH,
        REVENUE
    FROM CTE2
)

-- Generating the cohort analysis table with pivot and summing revenue for each cohort and month
SELECT *
FROM CTE3
PIVOT(
    SUM(REVENUE) 
    FOR COHORT_MONTH IN (
        'Month_0','Month_1','Month_2','Month_3','Month_4','Month_5',
        'Month_6','Month_7','Month_8','Month_9','Month_10','Month_11','Month_12'
    )
)
ORDER BY Cohort;
```

### Result of the query
| COHORT     | 'Month_0' | 'Month_1' | 'Month_2' | 'Month_3' | 'Month_4' | 'Month_5' | 'Month_6' | 'Month_7' | 'Month_8' | 'Month_9' | 'Month_10' | 'Month_11' | 'Month_12' |
|------------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|-----------|------------|------------|------------|
| 2010-12-01 | 66,676    | 25,436    | 25,398    | 32,723    | 24,483    | 33,929    | 34,524    | 24,225    | 22,651    | 40,927    | 55,317     | 53,117     | 18,593     |
| 2011-01-01 | 18,890    | 4,158     | 5,732     | 4,638     | 8,181     | 5,995     | 5,237     | 5,611     | 5,954     | 7,679     | 11,947     | 3,417      |            |
| 2011-02-01 | 17,899    | 3,783     | 6,407     | 6,048     | 2,141     | 3,212     | 4,218     | 5,130     | 6,637     | 7,497     | 2,033      |            |            |
| 2011-03-01 | 14,855    | 3,884     | 6,641     | 4,626     | 3,045     | 3,109     | 6,268     | 7,160     | 9,064     | 2,190     |            |            |            |
| 2011-04-01 | 9,721     | 3,012     | 2,944     | 2,041     | 2,101     | 1,798     | 2,185     | 3,608     | 460       |           |            |            |            |
| 2011-05-01 | 12,767    | 2,901     | 2,812     | 2,620     | 2,132     | 2,484     | 3,032     | 890       |           |           |            |            |            |
| 2011-06-01 | 9,303     | 2,560     | 1,198     | 2,225     | 3,465     | 6,772     | 650       |           |           |           |            |            |            |
| 2011-07-01 | -632      | 1,142     | 1,160     | 938       | 1,933     | 559       |           |           |           |           |            |            |            |
| 2011-08-01 | 4,994     | 62        | -783      | -2,036    | -707      |           |           |           |           |           |            |            |            |
| 2011-09-01 | 12,110    | 1,998     | 3,212     | 1,003     |           |           |           |           |           |           |            |            |            |
| 2011-10-01 | 9,670     | 3,682     | 2,202     |           |           |           |           |           |           |           |            |            |            |
| 2011-11-01 | 13,651    | 3,190     |           |           |           |           |           |           |           |           |            |            |            |
| 2011-12-01 | 10,046    |           |           |           |           |           |           |           |           |           |            |            |            |

## Cohort Analysis on Number of Revenue

- **Cohort:** The leftmost column represents the cohorts, segmented by the month in which customers made their first purchase.

- **Months (Columns):** The subsequent columns labeled 'Month_0' through 'Month_12' represent the months after the first purchase month, with 'Month_0' corresponding to the month of the first purchase, 'Month_1' corresponding to the first month after the first purchase, and so on.

- **Values:** The values in the table represent the total revenue generated by each cohort in the respective months.
  - For instance, the value 66,676 under 'Month_0' for the cohort starting in December 2010 indicates that customers from this cohort collectively generated a revenue of 66,676 units of currency in the month of their first purchase.
  - Similarly, the value 25,436 under 'Month_1' for the same cohort indicates that in the subsequent month, these customers generated a revenue of 25,436 units of currency.

- **Interpretation:**
  - The table provides insights into how revenue generated by different cohorts evolves over time.
  - It's evident that cohorts generally exhibit a decreasing trend in revenue over the months after their initial purchase, which is a common pattern in many businesses.
  - Some cohorts, such as the December 2010 cohort, exhibit a relatively higher initial revenue, which gradually tapers off over time.
  - Negative values in certain cells (like -632 under 'Month_0' for the July 2011 cohort) indicate a decline in revenue during those months compared to the initial month.

The table illustrates changing revenue patterns for different cohorts over the months after their first purchase, providing insights into customer behavior and revenue generation trends.

## Conclusion

Cohort analysis is a powerful methodology that enables businesses to gain valuable insights into customer behavior, retention rates, revenue trends, and overall business performance. By segmenting customers into cohorts based on their common characteristics or events, such as their first purchase month, businesses can uncover patterns and make informed decisions to optimize customer engagement, marketing strategies, and revenue generation.

In this analysis, we used Snowflake SQL queries to perform cohort analysis on a retail dataset. We focused on three aspects of cohort analysis: order level analysis, customer retention analysis, and revenue analysis.

### Order Level Analysis

We analyzed the number of invoices (transactions) for different customer cohorts in subsequent months after their initial purchase. This analysis provided insights into customer engagement patterns, repeat purchases, and overall transaction behavior over time.

### Customer Retention Analysis

By counting distinct customers in each cohort for subsequent months, we measured customer retention rates. This analysis allowed us to understand how well the business retains its customer base over time and identify trends in customer loyalty and engagement.

### Revenue Analysis

We examined how revenue generated by various cohorts changes over time. This analysis showcased revenue patterns, including initial spending spikes, revenue declines, or consistent growth, which can be used to tailor marketing efforts and enhance customer lifetime value.

In conclusion, cohort analysis serves as a critical tool for businesses to understand and respond effectively to customer behavior and revenue generation trends. By leveraging the insights gained from cohort analysis, businesses can make informed decisions, optimize their strategies, and ultimately achieve sustainable growth and success.






















  
