### Medallion Architecture in Microsoft Fabric

![Lakehouse](https://yourpath/lakehouse.png) Raw Lakehouse → ![Warehouse](https://yourpath/warehouse.png) Warehouse → ![Power BI](https://yourpath/powerbi.png) Power BI

```mermaid
graph LR
Data_Sources -->|Data Pipeline| Raw_LH[Raw Lakehouse]
Raw_LH -->|Dataflows Gen2| Transformed_LH[Transformed Lakehouse]
Transformed_LH -->|Dataflows Gen2| Curated_EDW[Curated Warehouse]
Curated_EDW -->|Direct Lake| PowerBI[Power BI Reports]






















Download Data from here: https://codebasics.io/challenge/codebasics-resume-project-challenge/7

## Introduction

Welcome to the Atliq Hardwares! In the fast-paced world of consumer goods, where data-driven decisions are paramount, Atliq Hardwares, an industry leader in computer hardware production, has recognized the need for quick and informed decision-making. To meet this demand, they are expanding their data analytics team with the goal of hiring junior data analysts who possess both technical expertise and essential soft skills.

### About Atliq Hardwares

Atliq Hardwares is not just a fictitious company; it's an imaginative representation of a successful computer hardware producer with a strong presence in India and abroad. Their dedication to innovation and excellence has propelled them to the forefront of the industry. However, they acknowledge that having the right data and insights at their fingertips is critical to maintaining their competitive edge.

### The Challenge

To find the ideal candidates who can excel in both technical competence and soft skills, Tony Sharma, the Director of Data Analytics at Atliq Hardwares, has devised a SQL challenge. This challenge is designed to assess the abilities of potential junior data analysts and evaluate their suitability for the dynamic and data-centric environment at Atliq Hardwares.

### What to Expect

In this documentation, you will find a series of SQL tasks that simulate real-world data analysis scenarios. These tasks will test your SQL skills, problem-solving capabilities, and your ability to communicate your findings effectively. We encourage you to approach this challenge with enthusiasm and professionalism, as it represents an opportunity to showcase your talents and potentially join a forward-thinking team at Atliq Hardwares.

# Data Information

The "Atliq Hardware DB" database consists of six tables, each containing essential data for analysis. These tables provide valuable insights into customer data, product information, sales, costs, and more.

## dim_customer

- **customer_code:** A unique identification code for each customer.
- **customer:** Names of customers.
- **platform:** The means of selling products, such as "Brick & Mortar" or "E-Commerce."
- **channel:** Distribution methods, including "Retailers," "Direct," and "Distributors."
- **market:** Countries in which customers are located.
- **region:** Categorizes countries into geographic regions like "APAC," "EU," "NA," and "LATAM."
- **sub_zone:** Further categorizes regions into sub-regions.

## dim_product

- **product_code:** Unique identification codes for each product.
- **division:** Categorizes products into groups like "P & A," "N & S," and "PC."
- **segment:** Further categorizes products within the division.
- **category:** Classifies products into specific subcategories within the segment.
- **product:** Names of individual products.
- **variant:** Classifies products according to their features and characteristics.

## fact_gross_price

- **product_code:** Unique identification codes for each product.
- **fiscal_year:** Fiscal period for product sale (covering 2020 and 2021).
- **gross_price:** The initial selling price of a product before deductions or taxes.

## fact_manufacturing_cost

- **product_code:** Unique identification codes for each product.
- **cost_year:** Fiscal year of product manufacturing.
- **manufacturing_cost:** Total cost incurred for product production, including raw materials, labor, and overhead expenses.

## fact_pre_invoice_deductions

- **customer_code:** Unique identification codes for each customer.
- **fiscal_year:** Fiscal period of product sale.
- **pre_invoice_discount_pct:** Percentage of pre-invoice deductions for each product.

## fact_sales_monthly

- **date:** Date of product sale in monthly format (for 2020 and 2021).
- **product_code:** Unique identification codes for each product.
- **customer_code:** Unique identification codes for each customer.
- **sold_quantity:** Number of product units sold.
- **fiscal_year:** Fiscal period of product sale.

These tables collectively form the foundation for data analysis, enabling Atliq Hardwares to make data-informed decisions and drive business success in the consumer goods domain.

## Requests

### Request No.1
Retrieve the list of markets in which the customer "Atliq Exclusive" operates its business in the APAC region.

### MySQL Query
![req1](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/0bd5399c-7203-451f-bbc0-d139d4e4fd18)

### Query Explanation
1. We are using the SELECT statement to fetch data from the dim_customer table.
2. The DISTINCT keyword ensures that we only receive unique market names.
3. In the WHERE clause, we specify two conditions:
4. customer = "Atliq Exclusive" to filter records where the customer name is "Atliq Exclusive."
5. region = "APAC" to further narrow down the results to the APAC region.
6. The ORDER BY clause is used to sort the results in alphabetical order based on the "market" column.

### Answer
The query returns the following list of markets where "Atliq Exclusive" operates in the APAC region:

| market      |
|-------------|
| Australia   |
| Bangladesh  |
| India       |
| Indonesia   |
| Japan       |
| Newzealand  |
| Philiphines |
| South Korea |

The results show the distinct markets within the APAC region where the customer "Atliq Exclusive" conducts its business operations. These markets include Australia, Bangladesh, India, Indonesia, Japan, New Zealand, Philippines, and South Korea. This information can be valuable for understanding the geographic reach of the customer within the APAC region.

### Request No.2
What is the percentage of unique product increase in 2021 vs. 2020? The
final output contains these fields,
unique_products_2020
unique_products_2021
percentage_chg

### MySQL Query
![req2](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/39ce83e4-32dc-45af-82fc-dd261fee014e)

### Query Explanation

1. We start by creating two common table expressions (CTEs), cte1 and cte2.
2. In cte1, we count the number of distinct product codes for the fiscal year 2020 from the fact_sales_monthly table.
3. In cte2, we count the number of distinct product codes for the fiscal year 2021 from the same table.
4. The main query then selects values from both CTEs and calculates the percentage change between 2021 and 2020.
5. The percentage change is calculated as (unique_products_2021 - unique_products_2020) / unique_products_2020 * 100 and rounded to two decimal places.

### Answer
| unique_products_2020 | unique_products_2021 | percentage_chg |
|----------------------|----------------------|----------------|
| 245                  | 334                  | 36.33          |

The results indicate that between 2020 and 2021, there was a 36.33% increase in the number of unique products. This percentage change represents the growth in the variety of products offered over the two years.

### Request No.3
Provide a report with all the unique product counts for each segment and
sort them in descending order of product counts. The final output contains
2 fields,
segment
product_count

### MySQL Query
![req3](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/0b71b5a5-a974-45b2-8101-b19ebe7941a6)

### Query Explanation

1. The query begins with the SELECT statement to retrieve data from the dim_product table.
2. It calculates the count of distinct product codes (product_code) for each segment.
3. The GROUP BY clause groups the results by the segment column, which categorizes products into different segments.
4. Finally, the ORDER BY clause sorts the results in descending order based on the product_count, which represents the number of unique products in each segment.

### Answer
| segment     | product_count |
|-------------|---------------|
| Notebook    | 129           |
| Accessories | 116           |
| Peripherals | 84            |
| Desktop     | 32            |
| Storage     | 27            |
| Networking  | 9             |

The report provides a breakdown of the count of unique products within each segment. It is sorted in descending order based on the product counts, which means that the segment "Notebook" has the highest count with 129 unique products, followed by "Accessories" with 116 unique products. This information is valuable for understanding the diversity of products within each segment and can aid in product management and decision-making processes.

### Request No.4
Follow-up: Which segment had the most increase in unique products in
2021 vs 2020? The final output contains these fields,
segment
product_count_2020
product_count_2021
difference

### MySQL Query
![req4](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/223d2772-7db3-452f-b7e2-4a5bec4831dd)

### Query Explanation

1. This query begins by joining the dim_product and fact_sales_monthly tables using the INNER JOIN clause based on the product_code column.
2. It uses conditional aggregation with the CASE statements to count the number of distinct products for each segment in both 2020 and 2021.
3. The result is grouped by the segment column to calculate the difference in unique products between 2021 and 2020.
4. Finally, the results are ordered in descending order of the calculated difference.

### Answer
| Segment     | product_count_2020 | product_count_2021 | difference |
|-------------|--------------------|--------------------|------------|
| Accessories | 69                 | 103                | 34         |
| Notebook    | 92                 | 108                | 16         |
| Peripherals | 59                 | 75                 | 16         |
| Desktop     | 7                  | 22                 | 15         |
| Storage     | 12                 | 17                 | 5          |
| Networking  | 6                  | 9                  | 3          |

The report reveals the difference in the count of unique products for each segment between 2021 and 2020. "Accessories" experienced the most significant increase with 34 additional unique products in 2021 compared to 2020. This information is valuable for understanding product growth within different segments and can guide product development and marketing strategies.

### Request No.5
Get the products that have the highest and lowest manufacturing costs.
The final output should contain these fields,
product_code
product
manufacturing_cost

### MySQL Query
![req5](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/d9fded24-f10c-4390-a94a-9dce73182053)

### Query Explanation

1. This query retrieves product information from the dim_product table and manufacturing cost data from the fact_manufacturing_cost table.
2. It uses two separate queries, one for the highest manufacturing cost and one for the lowest manufacturing cost.
3. In each subquery, it joins the dim_product and fact_manufacturing_cost tables based on the product_code column.
4. It uses conditional filtering to select products with the highest manufacturing cost in the first subquery and the lowest manufacturing cost in the second subquery.

### Answer
| product_code | product               | manufacturing_cost |
|--------------|-----------------------|--------------------|
|  A6120110206 | AQ HOME Allin1 Gen 2  | 240.5364           |
| A2118150101  | AQ Master wired x1 Ms | 0.8920             |

The query provides the products with both the highest and lowest manufacturing costs.
i. The product with the highest manufacturing cost is "AQ HOME Allin1 Gen 2" with a cost of 240.5364.
ii. The product with the lowest manufacturing cost is "AQ Master wired x1 Ms" with a cost of 0.8920.

### Request No.6
Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage

### MySQL Query
![req6](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/e0500746-6b92-4029-bdb7-35b8d1a2f88b)

### Query Explanation

1. This query uses common table expressions (CTEs) to break down the process into two parts.
2. cte1 joins the dim_customer and fact_pre_invoice_deductions tables to gather data on customer codes, names, markets, fiscal years, and pre-invoice discount percentages.
3. cte2 filters the data from cte1 to select records for the fiscal year 2021 in the Indian market. It also rounds the pre-invoice discount percentage to two decimal places.
4. The final query selects the customer code, customer name, and the rounded average discount percentage, and then sorts the results in descending order based on the average discount percentage. It limits the output to the top 5 customers.

### Answer
| customer_code | customer | average_discount_percentage |
|---------------|----------|-----------------------------|
| 90002009      | Flipkart | 30.83                       |
| 90002006      | Viveks   | 30.38                       |
| 90002003      | Ezone    | 30.28                       |
| 90002002      | Croma    | 30.25                       |
| 90002016      | Amazon   | 29.33                       |

The report lists the top 5 customers in the Indian market for the fiscal year 2021 who received the highest average pre-invoice discount percentages. Flipkart received the highest average discount of 30.83%, followed by Viveks, Ezone, Croma, and Amazon. This information is crucial for evaluating customer relationships and discount strategies in the Indian market.

### Request No.7
Get the complete report of the Gross sales amount for the customer “Atliq
Exclusive” for each month. This analysis helps to get an idea of low and
high-performing months and take strategic decisions.
The final report contains these columns:
Month
Year
Gross sales Amount

### MySQL Query
![req7](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/21601db6-2bae-41b6-a14b-c1dad694c5a4)

### Query Explanation

1. This query involves two common table expressions (CTEs) to consolidate data from the dim_customer, fact_sales_monthly, and fact_gross_price tables.
2. cte1 combines customer information with monthly sales data, including sold quantities.
3. cte2 further combines the data from cte1 with gross price information for products.
4. The main query calculates the gross sales amount by multiplying the gross price with the sold quantity and then sums it up for each month. The results are rounded to two decimal places and represented in millions of dollars.
5. The query filters the results for the customer "Atliq Exclusive" and groups the data by month and fiscal year.

### Answer
| Month     | Year | Gross Sales Amount (in Millions $) |
|-----------|------|------------------------------------|
| September | 2020 | 9.09                               |
| October   | 2020 | 10.38                              |
| November  | 2020 | 15.23                              |
| December  | 2020 | 9.76                               |
| January   | 2020 | 9.58                               |
| February  | 2020 | 8.08                               |
| March     | 2020 | 0.77                               |
| April     | 2020 | 0.80                               |
| May       | 2020 | 1.59                               |
| June      | 2020 | 3.43                               |
| July      | 2020 | 5.15                               |
| August    | 2020 | 5.64                               |
| September | 2021 | 19.53                              |
| October   | 2021 | 21.02                              |
| November  | 2021 | 32.25                              |
| December  | 2021 | 20.41                              |
| January   | 2021 | 19.57                              |
| February  | 2021 | 15.99                              |
| March     | 2021 | 19.15                              |
| April     | 2021 | 11.48                              |
| May       | 2021 | 19.20                              |
| June      | 2021 | 15.46                              |
| July      | 2021 | 19.04                              |
| August    | 2021 | 11.32                              |

The report presents the gross sales amounts for the customer "Atliq Exclusive" for each month in 2020 and 2021. It provides insights into the performance of the customer over these months, helping to identify low and high-performing periods. This information can be used to make strategic decisions related to sales, marketing, and inventory management.

### Request No.8
In which quarter of 2020, got the maximum total_sold_quantity? The final
output contains these fields sorted by the total_sold_quantity,
Quarter
total_sold_quantity

### MySQL Query
![req8](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/6ae68803-c4a6-4d48-ba47-7e439f76a655)

### Query Explanation

1. This query categorizes sales data into quarters based on the date range of each quarter.
2. It uses a CASE statement to assign a quarter number (1, 2, 3, or 4) to each record, depending on the date within that quarter.
3. The query calculates the total sold quantity for each quarter.
4. It filters the results for the fiscal year 2020.
5. The results are then grouped by quarters and sorted in descending order of total sold quantity.


### Answer
| Quarters | Total Sold Quantity |
|----------|---------------------|
| 1        | 7005619             |
| 2        | 6649642             |
| 4        | 5042541             |
| 3        | 2075087             |

The report shows that in the year 2020, the maximum total sold quantity occurred in the first quarter (Q1), with a total of 7,005,619 units sold. This information is valuable for identifying the highest-performing quarter and can assist in making decisions related to inventory management, marketing, and sales strategies.

### Request No.9
Which channel helped to bring more gross sales in the fiscal year 2021
and the percentage of contribution? The final output contains these fields,
channel
gross_sales_mln
percentage

### MySQL Query
![req9](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/f9738e43-eb0b-4c8e-875e-ed9442f27180)

### Query Explanation

1. This query uses common table expressions (CTEs) to join data from the dim_customer, fact_sales_monthly, and fact_gross_price tables to calculate gross sales for each channel in the fiscal year 2021.
2. cte1 combines channel information with monthly sales data, including sold quantities.
3. cte2 further combines the data from cte1 with gross price information for products.
4. cte3 calculates the total gross sales in millions of dollars for each channel in the fiscal year 2021.
5. The final query calculates the percentage contribution of each channel to the total gross sales in the fiscal year 2021.


### Answer
| Channel     | Gross Sales (In Millions $) | Percentage Contribution |
|-------------|-----------------------------|-------------------------|
| Retailer    | 1924.2                      | 73.22                   |
| Direct      | 406.7                       | 15.48                   |
| Distributor | 297.2                       | 11.31                   |

The report reveals that in the fiscal year 2021, the "Retailer" channel contributed the most to gross sales, with a total of $1,924.2 million in sales. This channel accounts for 73.22% of the total gross sales in the fiscal year. The "Direct" channel contributed $406.7 million (15.48%), while the "Distributor" channel contributed $297.2 million (11.31%). This information is essential for understanding which sales channels are most effective and where to focus sales and marketing efforts.

### Request No.10
Get the Top 3 products in each division that have a high
total_sold_quantity in the fiscal_year 2021? The final output contains these
fields,
division
product_code
product
total_sold_quantity
rank_order

### MySQL Query
![req10](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/4b0b7f42-d35b-48af-b842-4d0f282d8d18)


### Query Explanation

1. This query uses a common table expression (CTE) cte1 to combine product information with total sold quantities from the dim_product and fact_sales_monthly tables.
2. The CTE filters the data for the fiscal year 2021 and groups it by division, product code, and product name.
3. The main query assigns a rank to each product within its division based on the total sold quantity in descending order.
4. The query selects the top 3 products in each division by filtering for products with a ranking of 1, 2, or 3.


### Answer
| Division | product_code | product             | total_quantity_sold | ranking |
|----------|--------------|---------------------|---------------------|---------|
| N & S    | A6720160103  | AQ Pen Drive 2 IN 1 | 701373              | 1       |
| N & S    | A6818160202  | AQ Pen Drive DRC    | 688003              | 2       |
| N & S    | A6819160203  | AQ Pen Drive DRC    | 676245              | 3       |
| P & A    | A2319150302  | AQ Gamers Ms        | 428498              | 1       |
| P & A    | A2520150501  | AQ Maxima Ms        | 419865              | 2       |
| P & A    | A2520150504  | AQ Maxima Ms        | 419471              | 3       |
| PC       | A4218110202  | AQ Digit            | 17434               | 1       |
| PC       | A4319110306  | AQ Velocity         | 17280               | 2       |
| PC       | A4218110208  | AQ Digit            | 17275               | 3       |

The report lists the top 3 products with the highest total quantity sold in each division for the fiscal year 2021. This information is useful for identifying the best-performing products within each product division. It can help in making decisions related to inventory management, marketing, and product development.


## Project Summary

In the course of this project, we delved into a comprehensive analysis of Atliq Hardwares, an imaginary leading computer hardware producer in India with a global presence. The goal of this project was to gain valuable insights into the company's data, aiding the decision-making process and better understanding the performance of different aspects of the business. Here's what we've uncovered:

1. **Customer and Market Insights**: We explored the `dim_customer` table to understand the company's customer base and geographic reach. By extracting data related to markets, regions, and customer channels, we were able to discern critical information about the company's clientele. For instance, we identified the markets in which "Atliq Exclusive" operates in the APAC region, providing a clearer picture of the company's market presence.

2. **Product Analysis**: The `dim_product` table provided insights into the diverse product range offered by Atliq Hardwares. By examining product attributes like division, segment, and category, we gained a comprehensive view of the products in the company's portfolio.

3. **Sales and Revenue**: To evaluate the company's sales and revenue performance, we looked at the `fact_sales_monthly` and `fact_gross_price` tables. Analyzing sales quantities and gross prices allowed us to calculate gross sales amounts and examine how different channels contributed to sales in the fiscal year 2021.

4. **Manufacturing Costs**: We delved into the `fact_manufacturing_cost` table to explore the cost incurred in the production of each product. This analysis was crucial for understanding the financial aspects of product manufacturing.

5. **Pre-Invoice Deductions**: The `fact_pre_invoice_deductions` table was a valuable resource for examining pre-invoice deductions and their impact on product pricing. We were able to identify the top customers who received high pre-invoice discounts in the fiscal year 2021.

6. **Time-Series Sales Analysis**: Using data from `fact_sales_monthly`, we conducted time-series analysis to understand monthly sales patterns, particularly for "Atliq Exclusive." This analysis allowed us to identify high and low-performing months, which can inform strategic decisions.

7. **Quarterly Performance**: We segmented sales data into quarters and identified which quarter of 2020 had the maximum total_sold_quantity. This information is vital for understanding seasonality and making informed decisions regarding stock management and marketing strategies.

8. **Top-Performing Products**: We identified the top 3 products in each product division that had the highest total_sold_quantity in the fiscal year 2021. This insight can guide inventory management and product development efforts.

In summary, this project has equipped Atliq Hardwares with a wealth of data-driven insights to make informed decisions and enhance various aspects of their business. From understanding customer markets to analyzing product performance, sales patterns, and cost structures, the company can use these findings to refine strategies, optimize operations, and ultimately drive growth and success in the highly competitive computer hardware industry. These analytical tools and techniques provide a foundation for ongoing data-driven decision-making and strategic planning within the organization.
