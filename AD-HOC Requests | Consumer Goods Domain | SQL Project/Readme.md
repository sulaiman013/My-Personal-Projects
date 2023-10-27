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
