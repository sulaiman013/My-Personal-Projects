# Cohort Analysis using Snowflake SQL Queries

In this analysis, we perform cohort analysis on different variables such as invoices, customers, and revenues using Snowflake SQL queries. We use a retail dataset and focus on various cohort-related metrics.
  The dataset is downloaded from kaggle.com ("https://www.kaggle.com/datasets/jihyeseo/online-retail-data-set-from-uci-ml-repo").

## Table of Contents
- [Introduction](#introduction)
- [Cohort Analysis on Order Level](#cohort-analysis-on-order-level)
- [Cohort Analysis/Customer Retention Analysis on Customer Level](#cohort-analysiscustomer-retention-analysis-on-customer-level)
- [Cohort Analysis on Customer Lifetime Value](#cohort-analysis-on-customer-lifetime-value)
- [Additional Scenarios](#additional-scenarios)
- [Verification](#verification)

## Introduction

The dataset used for this analysis is a retail dataset with information on invoices, customers, and revenues. We'll perform cohort analysis to gain insights into customer behavior, retention, and revenues over time.

## Cohort Analysis on Order Level

The first cohort analysis focuses on order-level cohort analysis. We calculate the number of invoices for each cohort of customers based on their first purchase month.

```sql
-- SQL query for order-level cohort analysis
CREATE DATABASE SALES;
USE DATABASE SALES;

CREATE SCHEMA COHORT_ANALYSIS;
USE SCHEMA COHORT_ANALYSIS;

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

-- Results of the query
  INVOICENO	STOCKCODE	DESCRIPTION	QUANTITY	INVOICEDATE	UNITPRICE	CUSTOMERID	COUNTRY
536365	85123A	WHITE HANGING HEART T-LIGHT HOLDER	6	1/12/10 8:26	2.55	17850	United Kingdom
536366	22633	HAND WARMER UNION JACK	6	1/12/10 8:28	1.85	17850	United Kingdom
536367	84879	ASSORTED COLOUR BIRD ORNAMENT	32	1/12/10 8:34	1.69	13047	United Kingdom
536368	22960	JAM MAKING SET WITH JARS	6	1/12/10 8:34	4.25	13047	United Kingdom
536369	21756	BATH BUILDING BLOCK WORD	3	1/12/10 8:35	5.95	13047	United Kingdom
-- ...
























  
