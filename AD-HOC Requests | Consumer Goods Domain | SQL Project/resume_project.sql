USE gdb023;

-- Answer to question no.1

SELECT 
  distinct market 
FROM 
  dim_customer 
where 
  customer = "Atliq Exclusive" 
  AND region = "APAC" 
order by 
  market;


-- Answer to question no.2

WITH cte1
     AS (SELECT fiscal_year,
                Count(DISTINCT product_code) AS unique_products_2020
         FROM   fact_sales_monthly
         WHERE  fiscal_year = 2020),
     cte2
     AS (SELECT fiscal_year,
                Count(DISTINCT product_code) AS unique_products_2021
         FROM   fact_sales_monthly
         WHERE  fiscal_year = 2021)
SELECT unique_products_2020,
       unique_products_2021,
       Round(( ( unique_products_2021 - unique_products_2020 ) /
               unique_products_2020 )
             * 100, 2) AS percentage_chg
FROM   cte1
       CROSS JOIN cte2; 


-- Answer to question no.3

SELECT segment,
       Count(DISTINCT product_code) AS product_count
FROM   dim_product
GROUP  BY segment
ORDER  BY product_count DESC; 

-- Answer to question no.4

SELECT
    p.segment,
    COUNT(DISTINCT CASE WHEN s.fiscal_year = 2020 THEN s.product_code END) AS product_count_2020,
    COUNT(DISTINCT CASE WHEN s.fiscal_year = 2021 THEN s.product_code END) AS product_count_2021,
    (COUNT(DISTINCT CASE WHEN s.fiscal_year = 2021 THEN s.product_code END) -
     COUNT(DISTINCT CASE WHEN s.fiscal_year = 2020 THEN s.product_code END)) AS difference
FROM
    dim_product p
INNER JOIN
    fact_sales_monthly s ON p.product_code = s.product_code
WHERE
    s.fiscal_year IN (2020, 2021)
GROUP BY
    p.segment
ORDER BY
    difference DESC;



-- Answer to question no.5

SELECT p.product_code,
       p.product,
       f.manufacturing_cost
FROM   dim_product p
       INNER JOIN fact_manufacturing_cost f
               ON p.product_code = f.product_code
WHERE  manufacturing_cost = (SELECT
       Max(manufacturing_cost) AS manufacturing_cost
                             FROM   fact_manufacturing_cost)
UNION
SELECT p.product_code,
       p.product,
       f.manufacturing_cost
FROM   dim_product p
       INNER JOIN fact_manufacturing_cost f
               ON p.product_code = f.product_code
WHERE  manufacturing_cost = (SELECT
       Min(manufacturing_cost) AS manufacturing_cost
                             FROM   fact_manufacturing_cost); 

-- Answer to question no.6

WITH cte1 AS
(
           SELECT     a.customer_code,
                      a.customer,
                      a.market,
                      b.fiscal_year,
                      b.pre_invoice_discount_pct
           FROM       dim_customer a
           INNER JOIN fact_pre_invoice_deductions b
           ON         a.customer_code = b.customer_code), cte2 AS
(
       SELECT customer_code,
              customer,
              market,
              fiscal_year,
              Round(pre_invoice_discount_pct*100,2) AS average_discount_percentage
       FROM   cte1
       WHERE  fiscal_year = 2021
       AND    market = "India")
SELECT   customer_code,
         customer,
         average_discount_percentage
FROM     cte2
ORDER BY average_discount_percentage DESC limit 5;

-- Answer to question no.7

WITH cte1
     AS (SELECT a.customer_code,
                a. customer,
                b.date,
                b.product_code,
                b.fiscal_year,
                b.sold_quantity
         FROM   dim_customer a
                INNER JOIN fact_sales_monthly b
                        ON a.customer_code = b.customer_code),
     cte2
     AS (SELECT a.customer_code,
                a.customer,
                a.date,
                a.product_code,
                a.fiscal_year,
                a.sold_quantity,
                b.gross_price
         FROM   cte1 a
                INNER JOIN fact_gross_price b
                        ON a.product_code = b.product_code)
SELECT Monthname(date)                                      AS Month,
       fiscal_year                                          AS Year,
       Round(Sum(gross_price * sold_quantity) / 1000000, 2) AS
       "Gross Sales Amount"
FROM   cte2
WHERE customer = "Atliq Exclusive"
GROUP  BY Monthname(date),
          fiscal_year; 

-- Answer to question no.8

SELECT CASE
         WHEN date BETWEEN '2019-09-01' AND '2019-11-01' THEN 1
         WHEN date BETWEEN '2019-12-01' AND '2020-02-01' THEN 2
         WHEN date BETWEEN '2020-03-01' AND '2020-05-01' THEN 3
         WHEN date BETWEEN '2020-06-01' AND '2020-08-01' THEN 4
       END                AS Quarters,
       Sum(sold_quantity) AS total_sold_quantity
FROM   fact_sales_monthly
WHERE  fiscal_year = 2020
GROUP  BY quarters
ORDER  BY total_sold_quantity DESC; 

-- Answer to question no.9

WITH cte1
     AS (SELECT a.channel,
                b.product_code,
                b.fiscal_year,
                b.sold_quantity
         FROM   dim_customer a
                INNER JOIN fact_sales_monthly b
                        ON a.customer_code = b.customer_code),
     cte2
     AS (SELECT a.channel,
                a.fiscal_year,
                a.sold_quantity,
                b.gross_price
         FROM   cte1 a
                INNER JOIN fact_gross_price b
                        ON a.product_code = b.product_code),
     cte3
     AS (SELECT channel,
                Round(Sum(sold_quantity * gross_price) / 1000000, 1) AS
                gross_sales_mln
         FROM   cte2
         WHERE  fiscal_year = 2021
         GROUP  BY channel)
SELECT channel,
       gross_sales_mln,
       Round(( gross_sales_mln / total_sales ) * 100,2) AS percentage
FROM   cte3,
       (SELECT Sum(gross_sales_mln) AS total_sales
        FROM   cte3) AS total
ORDER  BY gross_sales_mln DESC; 


-- Answer to question no.10

WITH cte1
     AS (SELECT a.division,
                a.product_code,
                a.product,
                Sum(b.sold_quantity) AS total_sold_quantity
         FROM   dim_product a
                INNER JOIN fact_sales_monthly b
                        ON a.product_code = b.product_code
         WHERE  b.fiscal_year = 2021
         GROUP  BY a.division,
                   a.product_code,
                   a.product)
SELECT *
FROM   (SELECT *,
               Rank()
                 OVER (
                   partition BY division
                   ORDER BY total_sold_quantity DESC) AS ranking
        FROM   cte1) AS ranked_data
WHERE  ranking <= 3; 











