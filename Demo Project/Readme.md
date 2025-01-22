### Report: Top 5 Customers with Highest Average Pre-Invoice Discount Percentage (India, FY 2021)

The following table lists the top 5 customers in the Indian market who received the highest average **pre-invoice discount percentage** during the fiscal year 2021.

| **Customer Code** | **Customer** | **Average Discount Percentage** |
|--------------------|--------------|----------------------------------|
| 90002009          | Flipkart     | 30.83%                          |
| 90002006          | Viveks       | 30.38%                          |
| 90002003          | Ezone        | 30.28%                          |
| 90002002          | Croma        | 30.25%                          |
| 90002016          | Amazon       | 29.33%                          |

### Query Used

```sql
WITH indian_customer AS (
    SELECT customer_code, customer
    FROM dim_customer
    WHERE market = "India"
),
tbl_discount_2021 AS (		
    SELECT customer_code, pre_invoice_discount_pct
    FROM fact_pre_invoice_deductions
    WHERE fiscal_year = 2021
),
tbl_cleaned AS (
    SELECT a.customer_code, a.customer, b.pre_invoice_discount_pct
    FROM indian_customer AS a
    JOIN tbl_discount_2021 AS b ON a.customer_code = b.customer_code
), 
tbl_avg_discount AS (
    SELECT customer_code, customer, pre_invoice_discount_pct
    FROM tbl_cleaned
    ORDER BY pre_invoice_discount_pct DESC
    LIMIT 5
)
SELECT * FROM tbl_avg_discount;
```

### Key Observations

- **Flipkart** topped the list with an average discount percentage of **30.83%**.
- The range of discounts among the top 5 customers is fairly close, with **Amazon** at **29.33%**, just slightly behind **Croma**.
