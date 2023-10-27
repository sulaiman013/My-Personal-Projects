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

