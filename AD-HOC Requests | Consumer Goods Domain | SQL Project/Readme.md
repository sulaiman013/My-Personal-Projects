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

