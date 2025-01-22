Generate a report which contains the top 5 customers who received an
average high pre_invoice_discount_pct for the fiscal year 2021 and in the
Indian market. The final output contains these fields,
customer_code
customer
average_discount_percentage

Query:
with indian_customer as (
        select customer_code, customer
        from dim_customer
        where market = "India"
),
tbl_discount_2021 as (		
        select customer_code, pre_invoice_discount_pct
        from fact_pre_invoice_deductions
        where fiscal_year = 2021
),
tbl_cleaned as (
		select a.customer_code, a.customer, b.pre_invoice_discount_pct
        from indian_customer as a
        join tbl_discount_2021 as b on a.customer_code = b.customer_code
), 
tbl_avg_discount as (
		select customer_code, customer, pre_invoice_discount_pct
		from tbl_cleaned
        order by pre_invoice_discount_pct desc
        limit 5
)
select * from tbl_avg_discount;

| # customer_code | customer | pre_invoice_discount_pct |
|-----------------|----------|--------------------------|
| 90002009        | Flipkart | 0.3083                   |
| 90002006        | Viveks   | 0.3038                   |
| 90002003        | Ezone    | 0.3028                   |
| 90002002        | Croma    | 0.3025                   |
| 90002016        | Amazon   | 0.2933                   |
