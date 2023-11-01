# Maven Fuzzy Factory Database Overview

Maven Fuzzy Factory is an eCommerce retailer that specializes in SITUATION products. As a new eCommerce Database Analyst for the company, your role involves working closely with the CEO, the Head of Marketing, and the Website Manager to steer the business by analyzing and optimizing marketing channels, website performance, and product portfolio using SQL.

## Introduction

In your role as an eCommerce Database Analyst at Maven Fuzzy Factory, you are responsible for extracting and analyzing data from the company's database to understand and communicate the story of its growth over the first eight months of operation. The CEO is due to present company performance metrics to the board, and this is an opportunity to showcase the company's analytical capabilities. This report will help you effectively communicate the growth story to the board and highlight your role as the data expert for the company.

## Midterm Project

### Project Overview

Maven Fuzzy Factory has been operational for approximately eight months, and your CEO needs to present company performance metrics to the board in the upcoming week. As the eCommerce Database Analyst, your primary responsibility is to extract and analyze data from the company's database to quantify the company's growth during this period and effectively communicate this growth story to the board.

### Data Analysis Goals

1. **Quantify Growth**: Use SQL to extract and analyze website traffic and performance data from the Maven Fuzzy Factory database to measure the company's growth over the first eight months of operation.

2. **Create a Compelling Story**: Present the data in a way that tells the story of how the company achieved this growth, demonstrating your analytical capabilities.

## Email from Cindy (November 27, 2012)

> Good morning,
> I need some help preparing a presentation for the board meeting next week.
> The board would like to have a better understanding of our growth story over our first 8 months. This will also be a good excuse to show off our analytical capabilities a bit.
> -Cindy

Cindy, the CEO, has reached out to you on November 27, 2012, requesting your assistance in preparing a presentation for the board meeting. The board's primary interest is gaining insights into the company's growth story during the initial eight months of operation. This presentation is also an opportunity to showcase the analytical capabilities of the company.

Now, you are tasked with leveraging your expertise in SQL to extract, analyze, and effectively communicate the company's growth story to the board. The next sections of your report will delve into the details of the data analysis and presentation.

## Data Information

The Maven Fuzzy Factory database consists of six tables, each serving a specific purpose. These tables are as follows:

1. **website_sessions**
   - Fields:
     - `website_session_id` (BIGINT UNSIGNED)
     - `created_at` (DATETIME)
     - `user_id` (BIGINT UNSIGNED)
     - `is_repeat_session` (SMALLINT UNSIGNED)
     - `utm_source` (VARCHAR)
     - `utm_campaign` (VARCHAR)
     - `utm_content` (VARCHAR)
     - `device_type` (VARCHAR)
     - `http_referer` (VARCHAR)
   - Primary Key: `website_session_id`

2. **website_pageviews**
   - Fields:
     - `website_pageview_id` (BIGINT UNSIGNED)
     - `created_at` (DATETIME)
     - `website_session_id` (BIGINT UNSIGNED)
     - `pageview_url` (VARCHAR)
   - Primary Key: `website_pageview_id`

3. **products**
   - Fields:
     - `product_id` (BIGINT UNSIGNED)
     - `created_at` (DATETIME)
     - `product_name` (VARCHAR)
   - Primary Key: `product_id`

4. **orders**
   - Fields:
     - `order_id` (BIGINT UNSIGNED)
     - `created_at` (DATETIME)
     - `website_session_id` (BIGINT UNSIGNED)
     - `user_id` (BIGINT UNSIGNED)
     - `primary_product_id` (SMALLINT UNSIGNED)
     - `items_purchased` (SMALLINT UNSIGNED)
     - `price_usd` (DECIMAL)
     - `cogs_usd` (DECIMAL)
   - Primary Key: `order_id`

5. **order_items**
   - Fields:
     - `order_item_id` (BIGINT UNSIGNED)
     - `created_at` (DATETIME)
     - `order_id` (BIGINT UNSIGNED)
     - `product_id` (SMALLINT UNSIGNED)
     - `is_primary_item` (SMALLINT UNSIGNED)
     - `price_usd` (DECIMAL)
     - `cogs_usd` (DECIMAL)
   - Primary Key: `order_item_id`

6. **order_item_refunds**
   - Fields:
     - `order_item_refund_id` (BIGINT UNSIGNED)
     - `created_at` (DATETIME)
     - `order_item_id` (BIGINT UNSIGNED)
     - `order_id` (BIGINT UNSIGNED)
     - `refund_amount_usd` (DECIMAL)
   - Primary Key: `order_item_refund_id`

These tables hold crucial data that will enable you to quantify the company's growth, optimize marketing channels, and measure website performance. In the upcoming sections, you will explore how to extract and analyze this data to create a compelling growth story for Maven Fuzzy Factory's presentation to the board.


