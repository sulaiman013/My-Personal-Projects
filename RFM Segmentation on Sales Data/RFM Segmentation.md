# Exploratory Data Analysis and RFM Segmentation using Snowflake SQL

This repository contains SQL queries for Exploratory Data Analysis (EDA) and RFM (Recency, Frequency, Monetary) Segmentation on a sales dataset using Snowflake. The dataset contains information about sales transactions, and the queries analyze various aspects of the data.

## Table of Contents

- [Creating the Database](#creating-the-database)
- [Unique Values](#unique-values)
- [Exploratory Data Analysis](#exploratory-data-analysis)
  - [Grouping Sales by Product Line](#grouping-sales-by-product-line)
  - [Total Revenue by Year](#total-revenue-by-year)
  - [Revenue by Deal Size](#revenue-by-deal-size)
- [Additional Analyses](#additional-analyses)
  - [City with Highest Sales in a Specific Country](#city-with-highest-sales-in-a-specific-country)
  - [Best Selling Product in the United States](#best-selling-product-in-the-united-states)
  - [Best Month for Sales in a Specific Year](#best-month-for-sales-in-a-specific-year)
  - [Product Sales in a Specific Month](#product-sales-in-a-specific-month)
- [RFM Segmentation](#rfm-segmentation)
  - [Calculating RFM Scores](#calculating-rfm-scores)
  - [RFM Segmentation Categories](#rfm-segmentation-categories)
  - [Customer Segmentation](#customer-segmentation)

## Creating the Database

```sql
-- Creating the Database
CREATE DATABASE SALES;
USE DATABASE SALES;
-- Creating the table
CREATE OR REPLACE TABLE SALES_SAMPLE_DATA (
    ORDERNUMBER NUMBER (8, 0),
    QUANTITYORDERED NUMBER (8,2),
    PRICEEACH NUMBER (8,2),
    ORDERLINENUMBER NUMBER (3, 0),
    SALES NUMBER (8,2),
    ORDERDATE VARCHAR (16),
    STATUS VARCHAR (16),
    QTR_ID NUMBER (1,0),
    MONTH_ID NUMBER (2,0),
    YEAR_ID NUMBER (4,0),
    PRODUCTLINE VARCHAR (32),
    MSRP NUMBER (8,0),
    PRODUCTCODE VARCHAR (16),
    CUSTOMERNAME VARCHAR (32),
    PHONE VARCHAR (16),
    ADDRESSLINE1 VARCHAR (64),
    ADDRESSLINE2 VARCHAR (64),
    CITY VARCHAR (16),
    STATE VARCHAR (16),
    POSTALCODE VARCHAR (16),
    COUNTRY VARCHAR (24),
    TERRITORY VARCHAR (24),
    CONTACTLASTNAME VARCHAR (16),
    CONTACTFIRSTNAME VARCHAR (16),
    DEALSIZE VARCHAR (10) 
);

--Inspecting Data
SELECT * FROM SALES_SAMPLE_DATA LIMIT 10;
```
### Results:
| ORDERNUMBER | QUANTITYORDERED | PRICEEACH | ORDERLINENUMBER | SALES    | ORDERDATE | STATUS  | QTR_ID | MONTH_ID | YEAR_ID | PRODUCTLINE | MSRP | PRODUCTCODE | CUSTOMERNAME             | PHONE            | ADDRESSLINE1                  | ADDRESSLINE2  | CITY   | STATE  | POSTALCODE | COUNTRY  | TERRITORY | CONTACTLASTNAME | CONTACTFIRSTNAME | DEALSIZE |
|-------------|-----------------|-----------|-----------------|----------|-----------|---------|--------|----------|---------|-------------|------|-------------|--------------------------|------------------|-------------------------------|---------------|--------|--------|------------|----------|-----------|-----------------|------------------|----------|
| 10,107      | 30              | 95.7      | 2               | 2,871    | 24/2/03   | Shipped | 1      | 2        | 2003    | Motorcycles | 95   | S10_1678    | Land of Toys Inc.        | 2125557818       | 897 Long Airport Avenue       | NYC           | NY     | 10022  | USA        | NA       | Yu        | Kwai            | Small            |          |
| 10,121      | 34              | 81.35     | 5               | 2,765.9  | 7/5/03    | Shipped | 2      | 5        | 2003    | Motorcycles | 95   | S10_1678    | Reims Collectables       | 26.47.1555       | 59 rue de l'Abbaye            | Reims         | 51100  | France | EMEA       | Henriot  | Paul      | Small           |                  |          |
| 10,134      | 41              | 94.74     | 2               | 3,884.34 | 1/7/03    | Shipped | 3      | 7        | 2003    | Motorcycles | 95   | S10_1678    | Lyon Souveniers          | +33 1 46 62 7555 | 27 rue du Colonel Pierre Avia | Paris         | 75508  | France | EMEA       | Da Cunha | Daniel    | Medium          |                  |          |
| 10,145      | 45              | 83.26     | 6               | 3,746.7  | 25/8/03   | Shipped | 3      | 8        | 2003    | Motorcycles | 95   | S10_1678    | Toys4GrownUps.com        | 6265557265       | 78934 Hillside Dr.            | Pasadena      | CA     | 90003  | USA        | NA       | Young     | Julie           | Medium           |          |
| 10,159      | 49              | 100       | 14              | 5,205.27 | 10/10/03  | Shipped | 4      | 10       | 2003    | Motorcycles | 95   | S10_1678    | Corporate Gift Ideas Co. | 6505551386       | 7734 Strong St.               | San Francisco | CA     | USA    | NA         | Brown    | Julie     | Medium          |                  |          |
| 10,168      | 36              | 96.66     | 1               | 3,479.76 | 28/10/03  | Shipped | 4      | 10       | 2003    | Motorcycles | 95   | S10_1678    | Technics Stores Inc.     | 6505556809       | 9408 Furth Circle             | Burlingame    | CA     | 94217  | USA        | NA       | Hirano    | Juri            | Medium           |          |
| 10,180      | 29              | 86.13     | 9               | 2,497.77 | 11/11/03  | Shipped | 4      | 11       | 2003    | Motorcycles | 95   | S10_1678    | Daedalus Designs Imports | 20.16.1555       | 184, chausse de Tournai       | Lille         | 59000  | France | EMEA       | Rance    | Martine   | Small           |                  |          |
| 10,188      | 48              | 100       | 1               | 5,512.32 | 18/11/03  | Shipped | 4      | 11       | 2003    | Motorcycles | 95   | S10_1678    | Herkku Gifts             | +47 2267 3215    | Drammen 121, PR 744 Sentrum   | Bergen        | N 5804 | Norway | EMEA       | Oeztan   | Veysel    | Medium          |                  |          |
| 10,201      | 22              | 98.57     | 2               | 2,168.54 | 1/12/03   | Shipped | 4      | 12       | 2003    | Motorcycles | 95   | S10_1678    | Mini Wheels Co.          | 6505555787       | 5557 North Pendale Street     | San Francisco | CA     | USA    | NA         | Murphy   | Julie     | Small           |                  |          |
| 10,211      | 41              | 100       | 14              | 4,708.44 | 15/1/04   | Shipped | 1      | 1        | 2004    | Motorcycles | 95   | S10_1678    | Auto Canal Petit         | (1) 47.55.6555   | 25, rue Lauriston             | Paris         | 75016  | France | EMEA       | Perrier  | Dominique | Medium          |                  |          |

## Unique Values
```sql
select distinct status from SALES_SAMPLE_DATA;
```
### Results:
| STATUS     |
|------------|
| Shipped    |
| Disputed   |
| In Process |
| Cancelled  |
| On Hold    |
| Resolved   |
```sql
select distinct year_id from SALES_SAMPLE_DATA;
```
### Results:
| YEAR_ID |
|---------|
| 2003    |
| 2004    |
| 2005    |
```sql
select distinct PRODUCTLINE from SALES_SAMPLE_DATA;
```
### Results:
| PRODUCTLINE      |
|------------------|
| Motorcycles      |
| Classic Cars     |
| Trucks and Buses |
| Vintage Cars     |
| Planes           |
| Ships            |
| Trains           |
```sql
select distinct COUNTRY from SALES_SAMPLE_DATA;
```
### Results:
| COUNTRY     |
|-------------|
| USA         |
| France      |
| Norway      |
| Finland     |
| Austria     |
| UK          |
| Spain       |
| Singapore   |
| Japan       |
| Italy       |
| Sweden      |
| Denmark     |
| Belgium     |
| Philippines |
| Germany     |
| Switzerland |
| Ireland     |
| Australia   |
| Canada      |
```sql
select distinct DEALSIZE from SALES_SAMPLE_DATA;
```
### Results:
| DEALSIZE |
|----------|
| Small    |
| Medium   |
| Large    |
```sql
select distinct TERRITORY from SALES_SAMPLE_DATA;
```
### Results:
| TERRITORY |
|-----------|
| NA        |
| EMEA      |
| APAC      |
| Japan     |

## Exploratory Data Analysis
Using SQL queries, a thorough analysis of the sales dataset was carried out in this exploratory data analysis (EDA). Beginning with the distribution of sales across various product lines, the analysis highlighted significant information, including order numbers, line numbers, and actual sales values for a chosen subset of data points. Insightful metrics like total revenue and the number of orders connected to each product line were also revealed by aggregating the dataset by product line. The analysis also included a focus on yearly revenue and the distribution of sales among various deal sizes in order to comprehend the sales dynamics over time. 

The investigation delved into specific questions as part of the supplemental analyses.  For instance, the city with the highest sales within a certain nation (such as the UK) was found. The analysis also identified the top-grossing product in the United States and followed its performance over a range of years and product categories. The analysis then focused on identifying the best sales month within a given year, revealing the amount of money made and how frequently orders were placed during that time. Notably, the analysis of sales for November in a particular year revealed that Classic Cars emerged as the top revenue-generating product line.

This EDA project served as an example of how SQL queries can offer insightful information about the various aspects of a dataset, resulting in a better comprehension of sales patterns, product performance, and consumer behavior. The outcomes demonstrated areas for strategic decision-making, allowing data-driven methodologies to improve business outcomes.

### Grouping Sales by Product Line
```sql
-- Let's start by examining the first 10 rows of the dataset to get an initial overview.
-- We're selecting specific columns such as ORDERNUMBER, ORDERLINENUMBER, PRODUCTLINE, SALES, and more.
SELECT ORDERNUMBER, ORDERLINENUMBER, PRODUCTLINE, SALES, *  
FROM SALES_SAMPLE_DATA
ORDER BY 1, 2
LIMIT 10;
```
### Results:

``` sql
-- Grouping sales by product line to understand the distribution of sales across different product categories.
-- We're calculating the total revenue and the number of orders for each product line.
select PRODUCTLINE, ROUND(sum(sales),0) AS Revenue, COUNT(DISTINCT ORDERNUMBER) AS NO_OF_ORDERS
from SALES_SAMPLE_DATA
group by PRODUCTLINE
order by 3 desc;
```
### Results:


``` sql
-- Analyzing sales revenue by year to identify trends or changes over time.
select YEAR_ID, sum(sales) Revenue
from SALES_SAMPLE_DATA
group by YEAR_ID
order by 2 desc;
```
### Results:


``` sql
-- Investigating sales revenue by deal size to understand the impact of deal sizes on revenue.
select  DEALSIZE,  sum(sales) Revenue
from SALES_SAMPLE_DATA
group by DEALSIZE
order by 2 desc;
```
### Results:


``` sql
-- Identifying the city with the highest sales in a specific country (e.g., 'UK').
select city, sum (sales) Revenue
from SALES_SAMPLE_DATA
where country = 'UK'
group by city
order by 2 desc;
```
### Results:


```sql
-- Determining the best-selling product in the United States.
select country, YEAR_ID, PRODUCTLINE, sum(sales) Revenue
from SALES_SAMPLE_DATA
where country = 'USA'
group by  country, YEAR_ID, PRODUCTLINE
order by 4 desc;
```
### Results:


```sql
-- Finding the best month for sales in a specific year (e.g., 2004) and calculating revenue and frequency.
select  MONTH_ID, sum(sales) Revenue, count(ORDERNUMBER) Frequency
from SALES_SAMPLE_DATA
where YEAR_ID = 2004
group by  MONTH_ID
order by 2 desc;
```
### Results:


```sql
-- Identifying the top-selling product line in a specific month (e.g., November 2004).
select  MONTH_ID, PRODUCTLINE, sum(sales) Revenue, count(ORDERNUMBER)
from SALES_SAMPLE_DATA
where YEAR_ID = 2004 and MONTH_ID = 11
group by  MONTH_ID, PRODUCTLINE
order by 3 desc;
```
### Results:


