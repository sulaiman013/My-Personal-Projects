-- Getting count of all the data's from transaction table
SELECT count(*) FROM sales.transactions;

-- Getting all the data's from transaction table where I specified the market_code as Mark001
SELECT * FROM sales.transactions 
where market_code = "Mark001";

-- Getting how many observations are there with market_code = Mark001
SELECT count(*) FROM sales.transactions 
where market_code = "Mark001";

-- Getting the data's those have currency = USD
SELECT * FROM sales.transactions 
where currency = "USD";

-- Getting the data from transaction table (1st 10 rows)
SELECT * FROM sales.transactions limit 10;

-- Getting the data from date table (1st 10 rows)
SELECT * FROM sales.date limit 10;

-- INNER Joining transactions table and date table where order_date in transaction table is similar to (equal to) date 
-- in date table
select sales.transactions.*, sales.date.* 
from sales.transactions 
INNER JOIN sales.date 
on sales.transactions.order_date = sales.date.date;

-- INNER Joining transactions table and date table where order_date in transaction table is similar to (equal to) date 
-- in date table and filtering by year = 2020
select sales.transactions.*, sales.date.* 
from sales.transactions 
INNER JOIN sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = 2020;

-- INNER Joining transactions table and date table where order_date in transaction table is similar to (equal to) date 
-- in date table, filtering by year = 2020 and calculating sum of sales_amount in transaction table
select sum(sales.transactions.sales_amount) 
from sales.transactions 
INNER JOIN sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = 2020;

-- INNER Joining transactions table and date table where order_date in transaction table is similar to (equal to) date 
-- in date table, filtering by year = 2019 and calculating sum of sales_amount in transaction table
select sum(sales.transactions.sales_amount) 
from sales.transactions 
INNER JOIN sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = 2019;

-- INNER Joining transactions table and date table where order_date in transaction table is similar to (equal to) date 
-- in date table, filtering by year = 2019 and market_code = Mark001 and then calculating sum of sales_amount in 
-- transaction table
select sum(sales.transactions.sales_amount) 
from sales.transactions 
INNER JOIN sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = 2019 and sales.transactions.market_code = "Mark001";

-- INNER Joining transactions table and date table where order_date in transaction table is similar to (equal to) date 
-- in date table, filtering by year = 2020 and market_code = Mark001 and then calculating sum of sales_amount in 
-- transaction table
select sum(sales.transactions.sales_amount) 
from sales.transactions 
INNER JOIN sales.date 
on sales.transactions.order_date = sales.date.date
where sales.date.year = 2020 and sales.transactions.market_code = "Mark001";

-- Getting distinct product_code data's from transactions table where market_code = Mark001
select distinct product_code
from sales.transactions
where market_code = "Mark001";

-- Calculating count of distinct product_code data's and renaming it as "Number of Different Products" from transactions 
-- table where market_code = Mark001
select count(distinct product_code) as "Number of Different Products"
from sales.transactions
where market_code = "Mark001";

-- Finding data's from transactions table where sales_amount = -1
select * from sales.transactions
where sales_amount = -1;

-- Finding data's from transactions table where sales_amount <= 0
select * from sales.transactions
where sales_amount <= 0;

-- Calculating count of data's from transactions table where sales_amount <= 0
select count(*) from sales.transactions
where sales_amount <= 0;

-- Getting the distinct currencies from transaction tables
select distinct(transactions.currency) 
from sales.transactions;

-- Two different INR one is 'INR\r' and the problematic one is 'INR'
select count(*) from sales.transactions
where transactions.currency = 'INR\r';

select count(*) from sales.transactions
where transactions.currency = 'INR';

select * from sales.transactions
where transactions.currency = 'USD' or transactions.currency = 'USD\r';

select * from sales.transactions INNER JOIN sales.products
on sales.products.product_code = sales.transactions.product_code;




