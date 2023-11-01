/*
MIDTERM PROJECT:
Maven Fuzzy Factory has been live for ~8 months, and your CEO is due to present company
performance metrics to the board next week. You’ll be the one tasked with preparing relevant
metrics to show the company’s promising growth.

Use SQL to:
Extract and analyze website traffic and performance data from the Maven Fuzzy Factory
database to quantify the company’s growth, and to tell the story of how you have been
able to generate that growth.
As an Analyst, the first part of your job is extracting and analyzing the data, and the next
part of your job is effectively communicating the story to your stakeholders. 
*/

/* November 27, 2012
Good morning,
I need some help preparing a presentation for the board
meeting next week.
The board would like to have a better understanding of our
growth story over our first 8 months. This will also be a
good excuse to show off our analytical capabilities a bit.
-Cindy
*/

USE mavenfuzzyfactory;

/* REQUEST 1
Gsearch seems to be the biggest driver of our business. Could you pull monthly trends for gsearch sessions
and orders so that we can showcase the growth there? 
*/

select year(a.created_at) as year, month(a.created_at) as month,
count(DISTINCT a.website_session_id) as sessions,
count(DISTINCT b.order_id) as orders,
round(count(DISTINCT b.order_id)/count(DISTINCT a.website_session_id)*100,2) as conv_rate
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2012-11-27'
AND a.utm_source = 'gsearch'
GROUP BY 1,2;

/* REQUEST 2
Next, it would be great to see a similar monthly trend for Gsearch, but this time splitting out nonbrand and
brand campaigns separately. I am wondering if brand is picking up at all. If so, this is a good story to tell. 
*/

select year(a.created_at) as year, month(a.created_at) as month,
count(DISTINCT case when a.utm_campaign = 'nonbrand' then a.website_session_id else null end) as non_brand_sessions,
count(DISTINCT case when a.utm_campaign = 'nonbrand' then b.order_id else null end) as non_brand_orders,
count(DISTINCT case when a.utm_campaign = 'brand' then a.website_session_id else null end) as brand_sessions,
count(DISTINCT case when a.utm_campaign = 'brand' then b.order_id else null end) as brand_orders
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2012-11-27'
AND a.utm_source = 'gsearch'
GROUP BY 1,2;

/* REQUEST 3
While we’re on Gsearch, could you dive into nonbrand, and pull monthly sessions and orders split by device type? 
I want to flex our analytical muscles a little and show the board we really know our traffic sources.
*/

select year(a.created_at) as year, month(a.created_at) as month,
count(DISTINCT a.website_session_id) as sessions,
count(DISTINCT b.order_id) as orders,
count(DISTINCT case when a.device_type = 'mobile' then a.website_session_id else null end) as mobile_sessions,
count(DISTINCT case when a.device_type = 'desktop' then a.website_session_id else null end) as desktop_sessions,
count(DISTINCT case when a.device_type = 'mobile' then b.order_id else null end) as mobile_orders,
count(DISTINCT case when a.device_type = 'desktop' then b.order_id else null end) as desktop_orders
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2012-11-27'
AND a.utm_source = 'gsearch'
AND a.utm_campaign = 'nonbrand'
GROUP BY 1,2;

/* REQUEST 4
I’m worried that one of our more pessimistic board members may be concerned about the large % of traffic from Gsearch. 
Can you pull monthly trends for Gsearch, alongside monthly trends for each of our other channels?
*/
-- first, finding the various utm sources and referers to see the traffic we're getting
select distinct utm_source, utm_campaign, http_referer
from website_sessions
where created_at < '2012-11-27';

select year(a.created_at) as year, month(a.created_at) as month,
count(DISTINCT case when a.utm_source = 'gsearch' then a.website_session_id else null end) as gsearch_paid_sessions,
count(DISTINCT case when a.utm_source = 'bsearch' then a.website_session_id else null end) as bsearch_paid_sessions,
count(DISTINCT case when a.utm_source is null AND a.http_referer is NOT null then a.website_session_id else null end) as organic_search_sessions,
count(DISTINCT case when a.utm_source is null AND a.http_referer is null then a.website_session_id else null end) as direct_type_in_sessions
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2012-11-27'
GROUP BY 1,2;

/* REQUEST 5
I’d like to tell the story of our website performance improvements over the course of the first 8 months. 
Could you pull session to order conversion rates, by month? 
*/

select year(a.created_at) as year, month(a.created_at) as month,
count(DISTINCT a.website_session_id) as sessions,
count(DISTINCT b.order_id) as orders,
round(count(DISTINCT b.order_id)/count(DISTINCT a.website_session_id)*100,2) as conv_rate
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2012-11-27'
GROUP BY 1,2;

/* REQUEST 6
For the gsearch lander test, please estimate the revenue that test earned us (Hint: Look at the increase in CVR
from the test (Jun 19 – Jul 28), and use nonbrand sessions and revenue since then to calculate incremental value)
*/

-- first entry id of lander-1
select min(website_pageview_id) as first_test_pv
FROM website_pageviews
where pageview_url = '/lander-1';
-- 23504 is the answer

with
cte1 as (SELECT
	a.website_session_id, 
    MIN(a.website_pageview_id) AS min_pageview_id
FROM website_pageviews a
	INNER JOIN website_sessions b
		ON b.website_session_id = a.website_session_id
		AND b.created_at < '2012-07-28' -- prescribed by the assignment
		AND a.website_pageview_id >= 23504 -- first page_view
        AND utm_source = 'gsearch'
        AND utm_campaign = 'nonbrand'
GROUP BY 
	a.website_session_id),
cte2 as(SELECT 
	a.website_session_id, 
    b.pageview_url AS landing_page
FROM cte1 a
	LEFT JOIN website_pageviews b
		ON b.website_pageview_id = a.min_pageview_id
WHERE b.pageview_url IN ('/home','/lander-1')),
cte3 as (SELECT
	a.website_session_id, 
    a.landing_page, 
    b.order_id AS order_id
FROM cte2 a
LEFT JOIN orders b
	ON b.website_session_id = a.website_session_id)
SELECT landing_page, 
    COUNT(DISTINCT website_session_id) AS sessions, 
    COUNT(DISTINCT order_id) AS orders,
    round((COUNT(DISTINCT order_id)/COUNT(DISTINCT website_session_id)*100),2) AS conv_rate
FROM cte3
GROUP BY 1;

-- finding the most recent pageview for gsearch nonbrand where the traffic was sent to /home
SELECT 
	MAX(a.website_session_id) AS most_recent_gsearch_nonbrand_home_pageview 
FROM website_sessions a
	LEFT JOIN website_pageviews b
		ON b.website_session_id = a.website_session_id
WHERE utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand'
    AND pageview_url = '/home'
    AND a.created_at < '2012-11-27';
-- 17145
SELECT 
	COUNT(website_session_id) AS sessions_since_test
FROM website_sessions
WHERE created_at < '2012-11-27'
	AND website_session_id > 17145 -- last /home session
	AND utm_source = 'gsearch'
	AND utm_campaign = 'nonbrand';    

-- 22,972 website sessions since the test

-- X .0087 incremental conversion = 202 incremental orders since 7/29
	-- roughly 4 months, so roughly 50 extra orders per month. Not bad!

/* REQUEST 7
For the landing page test you analyzed previously, it would be great to show a full conversion funnel from each
of the two pages to orders. You can use the same time period you analyzed last time (Jun 19 – Jul 28).
*/
create TEMPORARY table funnel
with
cte1 as (SELECT
	a.website_session_id, 
    b.pageview_url, 
    CASE WHEN pageview_url = '/home' THEN 1 ELSE 0 END AS homepage,
    CASE WHEN pageview_url = '/lander-1' THEN 1 ELSE 0 END AS custom_lander,
    CASE WHEN pageview_url = '/products' THEN 1 ELSE 0 END AS products_page,
    CASE WHEN pageview_url = '/the-original-mr-fuzzy' THEN 1 ELSE 0 END AS mrfuzzy_page, 
    CASE WHEN pageview_url = '/cart' THEN 1 ELSE 0 END AS cart_page,
    CASE WHEN pageview_url = '/shipping' THEN 1 ELSE 0 END AS shipping_page,
    CASE WHEN pageview_url = '/billing' THEN 1 ELSE 0 END AS billing_page,
    CASE WHEN pageview_url = '/thank-you-for-your-order' THEN 1 ELSE 0 END AS thankyou_page
FROM website_sessions a
	LEFT JOIN website_pageviews b
		ON a.website_session_id = b.website_session_id
WHERE a.utm_source = 'gsearch' 
	AND a.utm_campaign = 'nonbrand' 
    AND a.created_at < '2012-07-28'
		AND a.created_at > '2012-06-19'
ORDER BY 
	a.website_session_id,
    b.created_at)
SELECT
	website_session_id, 
    MAX(homepage) AS saw_homepage, 
    MAX(custom_lander) AS saw_custom_lander,
    MAX(products_page) AS product_made_it, 
    MAX(mrfuzzy_page) AS mrfuzzy_made_it, 
    MAX(cart_page) AS cart_made_it,
    MAX(shipping_page) AS shipping_made_it,
    MAX(billing_page) AS billing_made_it,
    MAX(thankyou_page) AS thankyou_made_it
    from cte1 
    GROUP BY 1;
    
    
--  overall numbers
SELECT
	CASE 
		WHEN saw_homepage = 1 THEN 'saw_homepage'
        WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
        ELSE 'ERROR 404!' 
	END AS segment, 
    COUNT(DISTINCT website_session_id) AS sessions,
    COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS to_products,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS to_mrfuzzy,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS to_cart,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS to_shipping,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS to_billing,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END) AS to_thankyou
from funnel
GROUP BY 1;


-- clickthrough rate
SELECT
	CASE 
		WHEN saw_homepage = 1 THEN 'saw_homepage'
        WHEN saw_custom_lander = 1 THEN 'saw_custom_lander'
        ELSE 'ERROR 404!' 
	END AS segment, 
    	COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT website_session_id) AS lander_click_rt,
    COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN product_made_it = 1 THEN website_session_id ELSE NULL END) AS products_click_rt,
    COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN mrfuzzy_made_it = 1 THEN website_session_id ELSE NULL END) AS mrfuzzy_click_rt,
    COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN cart_made_it = 1 THEN website_session_id ELSE NULL END) AS cart_click_rt,
    COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN shipping_made_it = 1 THEN website_session_id ELSE NULL END) AS shipping_click_rt,
    COUNT(DISTINCT CASE WHEN thankyou_made_it = 1 THEN website_session_id ELSE NULL END)/COUNT(DISTINCT CASE WHEN billing_made_it = 1 THEN website_session_id ELSE NULL END) AS billing_click_rt
FROM funnel
GROUP BY 1;


/* REQUEST 8
I’d love for you to quantify the impact of our billing test, as well. Please analyze the lift generated from the test
(Sep 10 – Nov 10), in terms of revenue per billing page session, and then pull the number of billing page sessions
for the past month to understand monthly impact.
*/

with 
cte1 as (SELECT 
	a.website_session_id, 
    a.pageview_url AS billing_version_seen, 
    b.order_id, 
    b.price_usd
FROM website_pageviews a
	LEFT JOIN orders b
		ON b.website_session_id = a.website_session_id
WHERE a.created_at > '2012-09-10' -- prescribed in assignment
	AND a.created_at < '2012-11-10' -- prescribed in assignment
    AND a.pageview_url IN ('/billing','/billing-2'))
SELECT
	billing_version_seen, 
    COUNT(DISTINCT website_session_id) AS sessions, 
    round(SUM(price_usd)/COUNT(DISTINCT website_session_id),2) AS revenue_per_billing_page_seen
    from cte1
    GROUP BY 1;

-- $22.83 revenue per billing page seen for the old version
-- $31.34 for the new version
-- LIFT: $8.51 per billing page view

SELECT 
	COUNT(website_session_id) AS billing_sessions_past_month
FROM website_pageviews 
WHERE pageview_url IN ('/billing','/billing-2') 
	AND created_at BETWEEN '2012-10-27' AND '2012-11-27'; -- past month

-- 1,194 billing sessions past month
-- LIFT: $8.51 per billing session
-- VALUE OF BILLING TEST: $10,160 over the past month

















































