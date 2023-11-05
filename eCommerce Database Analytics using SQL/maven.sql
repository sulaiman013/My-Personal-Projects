USE mavenfuzzyfactory;

/*TRAFFIC SOURCE ANALYSIS
Traffic source analysis is about understanding where your customers are
coming from and which channels are driving the highest quality traffic

1. We use the utm parameters stored in the database to identify paid website sessions
2. From our session data, we can link to our order data to understand how much revenue our paid campaigns
are driving
*/
-- size of various traffic sources
-- which utm_content driving most sessions?

SELECT utm_content,
       Count(DISTINCT website_session_id) AS sessions
FROM   website_sessions
WHERE  website_session_id BETWEEN 1000 AND 2000
GROUP  BY utm_content
ORDER  BY sessions DESC;

/*
When businesses run paid marketing campaigns, they often obsess over performance and
measure everything; how much they spend, how well traffic converts to sales, etc.
Paid traffic is commonly tagged with tracking (UTM) parameters, which are appended to
URLs and allow us to tie website activity back to specific traffic sources and campaigns
*/
-- Can you show orders as well?
-- which utm_content driving most orders?

SELECT a.utm_content,
       Count(DISTINCT a.website_session_id) AS sessions,
       Count(DISTINCT b.order_id)           AS orders
FROM   website_sessions a
       LEFT JOIN orders b
              ON b.website_session_id = a.website_session_id
WHERE  a.website_session_id BETWEEN 1000 AND 2000
GROUP  BY a.utm_content
ORDER  BY sessions DESC;

-- add session-to-order conversion rate!

SELECT a.utm_content,
       Count(DISTINCT a.website_session_id)    AS sessions,
       Count(DISTINCT b.order_id)              AS orders,
       Round(( Count(DISTINCT b.order_id) / Count(DISTINCT
             a.website_session_id) ) * 100, 2) AS sess_ord_conv_rate
FROM   website_sessions a
       LEFT JOIN orders b
              ON b.website_session_id = a.website_session_id
WHERE  a.website_session_id BETWEEN 1000 AND 2000
GROUP  BY a.utm_content
ORDER  BY sessions DESC; 

/* April 12, 2012
Good morning,

We've been live for almost a month now and we're starting to generate sales. Can you help me understand where the bulk of our website 
sessions are coming from, through yesterday? (11/04/2012)
I'd like to see a breakdown by UTM source, campaign and referring domain if possible. Thanks!

-Cindy*/

select utm_content, utm_campaign, http_referer, count(DISTINCT website_session_id) as sessions
from website_sessions
where created_at < '2012-04-12'
GROUP BY utm_content, utm_campaign, http_referer
ORDER BY sessions DESC;


/* April 12, 2012
Great analysis!

Based on your findings, it seems like we should probably dig into gsearch nonbrand a bit deeper to
see what we can do to optimize there. I’ll loop in Tom tomorrow morning to get his thoughts on next steps.

-Cindy*/

/* April 14, 2012
Hi there,
Sounds like gsearch nonbrand is our major traffic source, but we need to understand if those sessions are driving sales.
Could you please calculate the conversion rate (CVR) from session to order? Based on what we're paying for clicks,
we’ll need a CVR of at least 4% to make the numbers work. If we're much lower, we’ll need to reduce bids. If we’re
higher, we can increase bids to drive more volume.

Thanks, Tom
*/

SELECT Count(DISTINCT a.website_session_id)    AS sessions,
       Count(DISTINCT b.order_id)              AS orders,
       Round(( Count(DISTINCT b.order_id) / Count(DISTINCT
             a.website_session_id) ) * 100, 2) AS CVR
FROM   website_sessions a
       LEFT JOIN orders b
              ON b.website_session_id = a.website_session_id
WHERE  a.created_at < '2012-04-14' 
and utm_source = "gsearch"
and utm_campaign = "nonbrand"
ORDER  BY 3 DESC; 

/* April 14, 2012
Hmm, looks like we’re below the 4% threshold we need
to make the economics work.
Based on this analysis, we’ll need to dial down our
search bids a bit. We're over-spending based on the
current conversion rate.
Nice work, your analysis just saved us some $$$!
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */

/*
BID OPTIMIZATION
Analyzing for bid optimization is about understanding the value of various
segments of paid traffic, so that you can optimize your marketing budget
*/
-- Trended Sessions

select year(created_at), week(created_at),
min(date(created_at)) as week_start,
count(DISTINCT website_session_id) as sessions
from website_sessions
where website_session_id BETWEEN 100000 AND 115000
GROUP BY 1,2;

-- Pivot table in SQL using ORDERS data

select primary_product_id,
count(DISTINCT case when items_purchased = 1 then order_id else null end) as count_single_item_orders,
count(DISTINCT case when items_purchased = 2 then order_id else null end) as count_two_item_orders
from orders 
where order_id between 31000 AND 32000
GROUP BY 1;

/* May 10, 2012

Hi there,
Based on your conversion rate analysis, we bid down
gsearch nonbrand on 2012-04-15.
Can you pull gsearch nonbrand trended session volume, by
week, to see if the bid changes have caused volume to drop
at all?
Thanks, Tom
*/

SELECT Min(Date(created_at))              AS week_start,
       Count(DISTINCT website_session_id) AS sessions
FROM   website_sessions
WHERE  created_at < '2012-05-10'
       AND utm_source = "gsearch"
       AND utm_campaign = "nonbrand"
GROUP  BY Yearweek(created_at); 
/*May 10, 2012

Hi there, great analysis!
Okay, based on this, it does look like gsearch nonbrand is
fairly sensitive to bid changes.
We want maximum volume, but don’t want to spend more
on ads than we can afford.
Let me think on this. I will likely follow up with some ideas.
Thanks, Tom
*/


/* May 11, 2012
Hi there,
I was trying to use our site on my mobile device the other
day, and the experience was not great.
Could you pull conversion rates from session to order, by
device type?
If desktop performance is better than on mobile we may be
able to bid up for desktop specifically to get more volume?
Thanks, Tom
*/

SELECT a.device_type,
Count(DISTINCT a.website_session_id)    AS sessions,
       Count(DISTINCT b.order_id)              AS orders,
       Round(( Count(DISTINCT b.order_id) / Count(DISTINCT
             a.website_session_id) ) * 100, 2) AS CVR
FROM   website_sessions a
       LEFT JOIN orders b
              ON b.website_session_id = a.website_session_id
WHERE  a.created_at < '2012-05-11' 
and utm_source = "gsearch"
and utm_campaign = "nonbrand"
GROUP BY 1
ORDER  BY 3 DESC; 

/* May 11, 2012
Great!
I'm going to increase our bids on desktop.
When we bid higher, we’ll rank higher in the auctions, so I
think your insights here should lead to a sales boost.
Well done!!
-Tom
*/

/* June 09, 2012
Hi there,
After your device-level analysis of conversion rates, we
realized desktop was doing well, so we bid our gsearch
nonbrand desktop campaigns up on 2012-05-19.
Could you pull weekly trends for both desktop and mobile
so we can see the impact on volume?
You can use 2012-04-15 until the bid change as a baseline.
Thanks, Tom
*/

SELECT 
min(date(created_at)) as week_start,
Count(DISTINCT case when device_type = "desktop" then website_session_id else null end) AS dtop_sessions,
Count(DISTINCT case when device_type = "mobile" then website_session_id else null end) AS mob_sessions
FROM   website_sessions 
WHERE  created_at>='2012-04-15' AND created_at < '2012-06-9' 
and utm_source = "gsearch"
and utm_campaign = "nonbrand"
GROUP BY yearweek(created_at);

/* June 09, 2012
Nice work digging into this!
It looks like mobile has been pretty flat or a little down, but
desktop is looking strong thanks to the bid changes we
made based on your previous conversion analysis.
Things are moving in the right direction!
Thanks, Tom
*/

-- Extra ANALYSIS
SELECT a.device_type,
min(date(a.created_at)) as week_start,
Count(DISTINCT a.website_session_id)    AS sessions,
       Count(DISTINCT b.order_id)              AS orders,
       Round(( Count(DISTINCT b.order_id) / Count(DISTINCT
             a.website_session_id) ) * 100, 2) AS CVR
FROM   website_sessions a
       LEFT JOIN orders b
              ON b.website_session_id = a.website_session_id
WHERE  a.created_at>='2012-04-15' AND a.created_at < '2012-06-9' 
and utm_source = "gsearch"
and utm_campaign = "nonbrand"
GROUP BY 1, yearweek(a.created_at);

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */

/*
ANALYZING TOP WEBSITE CONTENT
Website content analysis is about understanding which pages are seen the
most by your users, to identify where to focus on improving your business
*/

-- Let's take a look at website_pageviews table

select * from website_pageviews
where website_pageview_id < 1000;

-- Top-Content analysis [pages with most views]
select pageview_url,
count(DISTINCT website_pageview_id) as pageviews
from website_pageviews
where website_pageview_id < 1000
GROUP BY 1
ORDER BY 2 DESC;

-- Top ENTRY Pages
with
cte1 as(select website_session_id, min(website_pageview_id) as first_entry
from website_pageviews
where website_pageview_id < 1000
GROUP BY 1)
SELECT b.pageview_url, count(DISTINCT a.website_session_id ) as number_of_times_first_entered from cte1 a
left join website_pageviews b on a.first_entry = b.website_pageview_id
GROUP BY 1;

/* June 09, 2012
Hi there!
I’m Morgan, the new Website Manager.
Could you help me get my head around the site by pulling
the most-viewed website pages, ranked by session volume?
Thanks!
-Morgan
*/

select pageview_url,
count(DISTINCT website_pageview_id) as sessions
from website_pageviews
where created_at < '2012-06-09'
GROUP BY 1
ORDER BY 2 DESC;

/* June 09, 2012
Thank you!
It definitely seems like the homepage, the products page,
and the Mr. Fuzzy page get the bulk of our traffic.
I would like to understand traffic patterns more.
I’ll follow up soon with a request to look at entry pages.
Thanks!
-Morgan
*/

/* June 12, 2012
Hi there!
Would you be able to pull a list of the top entry pages? I
want to confirm where our users are hitting the site.
If you could pull all entry pages and rank them on entry
volume, that would be great.
Thanks!
-Morgan
*/

with
cte1 as(select website_session_id, min(website_pageview_id) as first_entry
from website_pageviews
where created_at < '2012-06-12'
GROUP BY 1)
SELECT b.pageview_url, count(DISTINCT a.website_session_id ) as number_of_times_first_entered from cte1 a
left join website_pageviews b on a.first_entry = b.website_pageview_id
GROUP BY 1;

/* June 12, 2012
Wow, looks like our traffic all comes in through the
homepage right now!
Seems pretty obvious where we should focus on making any
improvements ☺
I will likely have some follow up requests to look into
performance for the homepage – stay tuned!
Thanks,
-Morgan
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */

/*
LANDING PAGE PERFORMANCE & TESTING
Landing page analysis and testing is about understanding the performance of
your key landing pages and then testing to improve your results
*/

/*
Business Context: We want to see landing page performance for a certain time period
1. find the first website_pageview_id for relevant sessions
2. identify the landing page of each session
3. counting pageviews for each session, to identify "bounces"
4. summarizing the total sessions and bounced sessions, by Landing Pages
*/

WITH
-- first website_pageview_id for relevant sessions
cte1
AS (SELECT website_session_id,
           Min(website_pageview_id) AS first_entry
    FROM   website_pageviews
    WHERE  created_at BETWEEN '2014-01-01' AND '2014-02-01'
    GROUP  BY 1),
     -- identifying the landing page of each session
     cte2
     AS (SELECT a.website_session_id,
                b.pageview_url AS landing_page
         FROM   cte1 a
                LEFT JOIN website_pageviews b
                       ON a.first_entry = b.website_pageview_id),
     -- counting pageviews for each session, to identify "bounces"
     cte3
     AS (SELECT a.website_session_id,
                a.landing_page,
                Count(b.website_pageview_id) AS count_of_pages_viewed
         FROM   cte2 a
                LEFT JOIN website_pageviews b
                       ON b.website_session_id = a.website_session_id
         GROUP  BY 1,
                   2
         HAVING Count(b.website_pageview_id) = 1),
     -- merging all sessions and bounced sessions in a single table
     cte4
     AS (SELECT a.landing_page,
                a.website_session_id,
                b.website_session_id AS bounced_website_session_id
         FROM   cte2 a
                LEFT JOIN cte3 b
                       ON a.website_session_id = b.website_session_id
         ORDER  BY a.website_session_id)
-- summarizing the total sessions and bounced sessions, by Landing Pages
SELECT landing_page,
       Count(DISTINCT website_session_id)                           AS sessions,
       Count(DISTINCT bounced_website_session_id)                   AS
       bounced_sessions,
       Round(( Count(DISTINCT bounced_website_session_id) /
                     Count(DISTINCT website_session_id) ) * 100, 2) AS
       bounced_cvr
FROM   cte4
GROUP  BY 1
ORDER  BY bounced_cvr DESC; 


/* June 14, 2012
Hi there!
The other day you showed us that all of our traffic is landing
on the homepage right now. We should check how that
landing page is performing.
Can you pull bounce rates for traffic landing on the
homepage? I would like to see three numbers…Sessions,
Bounced Sessions, and % of Sessions which Bounced
(aka “Bounce Rate”).
Thanks!
-Morgan
*/

WITH
-- first website_pageview_id for relevant sessions
cte1
AS (SELECT website_session_id,
           Min(website_pageview_id) AS first_entry
    FROM   website_pageviews
    WHERE  created_at < '2012-06-14'
    GROUP  BY 1),
     -- identifying the landing page of each session
     cte2
     AS (SELECT a.website_session_id,
                b.pageview_url AS landing_page
         FROM   cte1 a
                LEFT JOIN website_pageviews b
                       ON a.first_entry = b.website_pageview_id),
     -- counting pageviews for each session, to identify "bounces"
     cte3
     AS (SELECT a.website_session_id,
                a.landing_page,
                Count(b.website_pageview_id) AS count_of_pages_viewed
         FROM   cte2 a
                LEFT JOIN website_pageviews b
                       ON b.website_session_id = a.website_session_id
         GROUP  BY 1,
                   2
         HAVING Count(b.website_pageview_id) = 1),
     -- merging all sessions and bounced sessions in a single table
     cte4
     AS (SELECT a.landing_page,
                a.website_session_id,
                b.website_session_id AS bounced_website_session_id
         FROM   cte2 a
                LEFT JOIN cte3 b
                       ON a.website_session_id = b.website_session_id
         ORDER  BY a.website_session_id)
-- summarizing the total sessions and bounced sessions, by Landing Pages
SELECT landing_page,
       Count(DISTINCT website_session_id)                           AS sessions,
       Count(DISTINCT bounced_website_session_id)                   AS
       bounced_sessions,
       Round(( Count(DISTINCT bounced_website_session_id) /
                     Count(DISTINCT website_session_id) ) * 100, 2) AS
       bounced_cvr
FROM   cte4
GROUP  BY 1
ORDER  BY bounced_cvr DESC; 

/* June 14, 2012
Ouch…almost a 60% bounce rate!
That’s pretty high from my experience, especially for paid
search, which should be high quality traffic.
I will put together a custom landing page for search, and set
up an experiment to see if the new page does better. I will
likely need your help analyzing the test once we get enough
data to judge performance.
Thanks, Morgan
*/

/* July 28, 2012
Hi there!
Based on your bounce rate analysis, we ran a new custom
landing page (/lander-1) in a 50/50 test against the
homepage (/home) for our gsearch nonbrand traffic.
Can you pull bounce rates for the two groups so we can
evaluate the new page? Make sure to just look at the time
period where /lander-1 was getting traffic, so that it is a fair
comparison.
Thanks, Morgan
*/

-- finding out the /lander-1 first view date
SELECT created_at,
       Min(website_pageview_id)
FROM   website_pageviews
WHERE  pageview_url = "/lander-1"
GROUP  BY 1
LIMIT  1; 

WITH
-- first website_pageview_id for relevant sessions
cte1
AS (SELECT a.website_session_id,
           Min(a.website_pageview_id) AS first_entry
    FROM   website_pageviews a
           INNER JOIN website_sessions b
                   ON b.website_session_id = a.website_session_id
                      AND b.created_at > '2012-06-19'
                      AND b.created_at < '2012-07-28'
                      -- start date got from prev query and msg date
                      AND b.utm_source = "gsearch"
                      -- instructed in the assignment
                      AND b.utm_campaign = "nonbrand"
    -- instructed in the assignment
    GROUP  BY 1),
     -- identifying the landing page of each session
     cte2
     AS (SELECT a.website_session_id,
                b.pageview_url AS landing_page
         FROM   cte1 a
                LEFT JOIN website_pageviews b
                       ON a.first_entry = b.website_pageview_id),
     -- counting pageviews for each session, to identify "bounces"
     cte3
     AS (SELECT a.website_session_id,
                a.landing_page,
                Count(b.website_pageview_id) AS count_of_pages_viewed
         FROM   cte2 a
                LEFT JOIN website_pageviews b
                       ON b.website_session_id = a.website_session_id
         GROUP  BY 1,
                   2
         HAVING Count(b.website_pageview_id) = 1),
     -- merging all sessions and bounced sessions in a single table
     cte4
     AS (SELECT a.landing_page,
                a.website_session_id,
                b.website_session_id AS bounced_website_session_id
         FROM   cte2 a
                LEFT JOIN cte3 b
                       ON a.website_session_id = b.website_session_id
         ORDER  BY a.website_session_id)
-- summarizing the total sessions and bounced sessions, by Landing Pages
SELECT landing_page,
       Count(DISTINCT website_session_id)                           AS sessions,
       Count(DISTINCT bounced_website_session_id)                   AS
       bounced_sessions,
       Round(( Count(DISTINCT bounced_website_session_id) /
                     Count(DISTINCT website_session_id) ) * 100, 2) AS
       bounce_rate
FROM   cte4
GROUP  BY 1
ORDER  BY bounce_rate DESC; 

/* July 28, 2012
Hey!
This is so great. It looks like the custom lander has a lower
bounce rate…success!
I will work with Tom to get campaigns updated so that all
nonbrand paid traffic is pointing to the new page.
In a few weeks, I would like you to take a look at trends to
make sure things have moved in the right direction.
Thanks, Morgan
*/

/* August 31, 2012
Hi there, 
Could you pull the volume of paid search nonbrand traffic
landing on /home and /lander-1, trended weekly since June
1st? I want to confirm the traffic is all routed correctly.
Could you also pull our overall paid search bounce rate
trended weekly? I want to make sure the lander change has
improved the overall picture.
Thanks!
*/

WITH
-- first website_pageview_id for relevant sessions
cte1
AS (SELECT a.website_session_id,
           Min(a.website_pageview_id) AS first_entry,
           a.created_at
    FROM   website_pageviews a
           INNER JOIN website_sessions b
                   ON b.website_session_id = a.website_session_id
                      AND a.created_at > '2012-06-01'
                      AND a.created_at < '2012-08-31'
                      -- instructed in the assignment
                      AND b.utm_source = "gsearch"
                      -- instructed in the assignment
                      AND b.utm_campaign = "nonbrand"
    -- instructed in the assignment
    GROUP  BY 1,
              3),
     -- identifying the landing page of each session
     cte2
     AS (SELECT a.website_session_id,
                a.first_entry,
                b.pageview_url AS landing_page,
                a.created_at
         FROM   cte1 a
                LEFT JOIN website_pageviews b
                       ON a.first_entry = b.website_pageview_id),
     -- counting pageviews for each session, to identify "bounces"
     cte3
     AS (SELECT a.website_session_id,
                a.first_entry,
                a.landing_page,
                Count(b.website_pageview_id) AS count_of_pages_viewed,
                a.created_at
         FROM   cte2 a
                LEFT JOIN website_pageviews b
                       ON b.website_session_id = a.website_session_id
         GROUP  BY 1,
                   2,
                   5)
-- summarizing the total sessions and bounced sessions, by Landing Pages
SELECT Min(Date(created_at))
       AS
       week_start,
       Round(( Count(DISTINCT CASE
                                WHEN count_of_pages_viewed = 1 THEN
                                website_session_id
                                ELSE NULL
                              END) / Count(DISTINCT website_session_id) ) * 100,
       2) AS
       bounce_rate,
       Count(DISTINCT CASE
                        WHEN landing_page = "/home" THEN website_session_id
                        ELSE NULL
                      END)
       AS home_sessions,
       Count(DISTINCT CASE
                        WHEN landing_page = "/lander-1" THEN website_session_id
                        ELSE NULL
                      END)
       AS lander1_sessions
FROM   cte3
GROUP  BY Yearweek(created_at); 

/* August 31, 2012
This is great. Thank you!
Looks like both pages were getting traffic for a while, and
then we fully switched over to the custom lander, as
intended. And it looks like our overall bounce rate has come
down over time…nice!
I am going to do a full deep dive into our site, and will follow
up with asks.
Thanks!
-Morgan
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */

/*
ANALYZING & TESTING CONVERSION FUNNELS:
Conversion funnel analysis is about understanding and optimizing each step of
your user’s experience on their journey toward purchasing your products
When we perform conversion funnel analysis, we will look at each step in our conversion
flow to see how many customers drop off and how many continue on at each step
*/

/*
Business Context:
1. we want to build a mini conversion funnel, from /lander-2 to /cart
2. we want to know how many people reach each step, and also dropoff rates
3. for simplicity of the demo, we are looking at /lander-2 traffic only
4. for simplicity of the demo, we are looking at customers who like mr fuzzy only
*/


/*
Step 1- select all pageviews for relevant sessions
step 2- identify each relevant pageview as the specific funnel step
step 3- create the session-level conversion funnel view 
step 4- aggregate the data to assess funnel performance.
*/

with
cte1 as (select a.website_session_id, b.pageview_url, b.created_at as pageview_created_at
, case when pageview_url = '/products' then 1 else 0 end as product_page
, case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page
, case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions a
left join website_pageviews b on a.website_session_id = b.website_session_id
where a.created_at between '2014-01-01' AND '2014-02-01'
AND b.pageview_url in ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
order by 1,3),
cte2 as (select website_session_id, max(product_page) as product_made_it,max(mrfuzzy_page) as mrfuzzy_made_it,max(cart_page) as cart_made_it
from cte1
GROUP BY 1)
select count(DISTINCT website_session_id) as sessions,
count(DISTINCT case when product_made_it = 1 then website_session_id else null end) as to_product,
count(DISTINCT case when mrfuzzy_made_it = 1 then website_session_id else null end) as to_mrfuzzy,
count(DISTINCT case when cart_made_it = 1 then website_session_id else null end) as to_cart
from cte2;
/*
The given MySQL queries are intended to analyze the conversion funnel performance for a specific business context. 
Here's a breakdown of the queries and their purpose:

Business Context:

The goal is to build a mini conversion funnel from the "/lander-2" page to the "/cart" page.
The analysis is limited to traffic on "/lander-2."
The analysis is further restricted to customers who like "Mr. Fuzzy."

Step 1: Select All Pageviews for Relevant Sessions (CTE1)
This part of the query creates a Common Table Expression (CTE) named "cte1" to select all relevant pageviews for the specified date range and URLs.
It joins two tables: "website_sessions" and "website_pageviews" based on the "website_session_id."
It filters the data for sessions created between '2014-01-01' and '2014-02-01' and specific pageview URLs: '/lander-2', 
'/products', '/the-original-mr-fuzzy', and '/cart.'
It assigns binary values (1 or 0) to each pageview URL, indicating whether the pageview matches the URLs of interest 
('/products', '/the-original-mr-fuzzy', '/cart'). The binary values are used to track if a session reached a specific page.

Step 2: Identify Each Relevant Pageview as a Funnel Step (CTE2)
In this step, another CTE named "cte2" is created.
It summarizes the information from "cte1" by grouping records by "website_session_id."
It calculates binary values for whether each session reached the '/products', '/the-original-mr-fuzzy', and '/cart' pages. 
These binary values represent if a session reached specific steps in the conversion funnel.

Step 3: Create the Session-Level Conversion Funnel View (Main Query)
The main query builds upon the information generated in CTE2.
It calculates the following session-level metrics for the given date range and URLs:
sessions: The total number of distinct website sessions that match the criteria.
to_product: The number of sessions that reached the '/products' page (first step of the funnel).
to_mrfuzzy: The number of sessions that reached the '/the-original-mr-fuzzy' page (second step of the funnel).
to_cart: The number of sessions that reached the '/cart' page (final step of the funnel).

Step 4: Aggregate the Data to Assess Funnel Performance
The main query calculates and presents the total counts for each funnel step.
These counts represent the number of sessions that progressed through each step of the funnel.
You can use these counts to assess the performance and drop-off rates at each step of the conversion funnel.

In summary, these MySQL queries help track and analyze the conversion funnel performance for the specified business context by identifying 
how many sessions progress through each step of the funnel and calculating drop-off rates. The data is aggregated for sessions matching 
the criteria, providing insights into the effectiveness of the funnel in converting visitors from the "/lander-2" page to the "/cart" 
page for customers who like "Mr. Fuzzy."
*/

with
cte1 as (select a.website_session_id, b.pageview_url, b.created_at as pageview_created_at
, case when pageview_url = '/products' then 1 else 0 end as product_page
, case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page
, case when pageview_url = '/cart' then 1 else 0 end as cart_page
from website_sessions a
left join website_pageviews b on a.website_session_id = b.website_session_id
where a.created_at between '2014-01-01' AND '2014-02-01'
AND b.pageview_url in ('/lander-2', '/products', '/the-original-mr-fuzzy', '/cart')
order by 1,3),
cte2 as (select website_session_id, max(product_page) as product_made_it,max(mrfuzzy_page) as mrfuzzy_made_it,max(cart_page) as cart_made_it
from cte1
GROUP BY 1)
select count(DISTINCT website_session_id) as sessions,
round((count(DISTINCT case when product_made_it = 1 then website_session_id else null end)/count(DISTINCT website_session_id))*100,2) as lander_clickthrough_rate,
round((count(DISTINCT case when mrfuzzy_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when product_made_it = 1 then website_session_id else null end))*100,2) as product_clickthrough_rate,
round((count(DISTINCT case when cart_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when mrfuzzy_made_it = 1 then website_session_id else null end))*100,2) as mrfuzzy_clickthrough_rate
from cte2;

/*
The given MySQL queries are designed to analyze the conversion funnel performance for a specific business context and provide 
click-through rates for different steps in the funnel. Here's a breakdown of the queries and their purpose:

1. **Business Context:**
   - The objective is to build a mini conversion funnel from "/lander-2" to "/cart."
   - The focus is on understanding how many people reach each step of the funnel and calculating click-through rates.
   - The analysis is limited to traffic on the "/lander-2" page.
   - The analysis is further restricted to customers who like "Mr. Fuzzy."

2. **Step 1: Select All Pageviews for Relevant Sessions (CTE1)**
   - In this section, a Common Table Expression (CTE) named "cte1" is created to select all relevant pageviews for the specified date range and URLs.
   - It joins two tables: "website_sessions" (aliased as 'a') and "website_pageviews" (aliased as 'b') based on the "website_session_id."
   - The data is filtered for sessions created between '2014-01-01' and '2014-02-01' and specific pageview URLs: '/lander-2', 
   '/products', '/the-original-mr-fuzzy', and '/cart.'
   - Binary values (1 or 0) are assigned for each pageview URL to determine if a pageview matches the URLs of interest 
   ('/products', '/the-original-mr-fuzzy', '/cart'). These binary values are used to track if a session reached a specific page.

3. **Step 2: Identify Each Relevant Pageview as a Funnel Step (CTE2)**
   - In this step, another CTE named "cte2" is created.
   - It summarizes the information from "cte1" by grouping records by "website_session_id."
   - It calculates binary values for whether each session reached the '/products', '/the-original-mr-fuzzy', and '/cart' pages. 
   These binary values represent if a session reached specific steps in the conversion funnel.

4. **Step 3: Create Session-Level Conversion Funnel View (Main Query)**
   - The main query builds upon the information generated in CTE2.
   - It calculates the following session-level metrics for the given date range and URLs:
     - `sessions`: The total number of distinct website sessions that match the criteria.
     - `lander_clickthrough_rate`: The click-through rate from '/lander-2' to '/products' (i.e., the percentage of sessions that reach 
     '/products' after visiting '/lander-2').
     - `product_clickthrough_rate`: The click-through rate from '/products' to '/the-original-mr-fuzzy' (i.e., the percentage of 
     sessions that reach '/the-original-mr-fuzzy' after visiting '/products'). It's calculated relative to the sessions that reached '/products'.
     - `mrfuzzy_clickthrough_rate`: The click-through rate from '/the-original-mr-fuzzy' to '/cart' (i.e., the percentage of sessions
     that reach '/cart' after visiting '/the-original-mr-fuzzy'). It's calculated relative to the sessions that reached '/the-original-mr-fuzzy'.

5. **Step 4: Calculate Click-Through Rates**
   - In this step, the main query calculates the click-through rates by dividing the count of sessions that successfully reach a step 
   by the count of sessions that reached the previous step (except for the 'lander_clickthrough_rate' which calculates relative to 
   all sessions).
   - The result is presented as percentages, rounded to two decimal places.

In summary, these MySQL queries help track and analyze the conversion funnel performance for the specified business context by 
calculating click-through rates for each step of the funnel. Click-through rates indicate how effective the funnel is in 
guiding users from one step to the next, providing valuable insights into the user journey and drop-off rates.
*/

/*Sept 5, 2012
Hi there!
I’d like to understand where we lose our gsearch visitors
between the new /lander-1 page and placing an order. Can
you build us a full conversion funnel, analyzing how many
customers make it to each step?
Start with /lander-1 and build the funnel all the way to our
thank you page. Please use data since August 5th
.
Thanks!
-Morgan
*/

with
cte1 as (select a.website_session_id, b.pageview_url, b.created_at as pageview_created_at
, case when pageview_url = '/products' then 1 else 0 end as product_page
, case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page
, case when pageview_url = '/cart' then 1 else 0 end as cart_page
, case when pageview_url = '/shipping' then 1 else 0 end as shipping_page
, case when pageview_url = '/billing' then 1 else 0 end as billing_page
, case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thanks_page
from website_sessions a
left join website_pageviews b on a.website_session_id = b.website_session_id
where a.created_at BETWEEN '2012-08-05' AND '2012-09-05'
AND utm_source = "gsearch"
AND utm_campaign = "nonbrand"
 AND b.pageview_url in ('/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
order by 1,3),
cte2 as (select website_session_id, 
max(product_page) as product_made_it,
max(mrfuzzy_page) as mrfuzzy_made_it,
max(cart_page) as cart_made_it,
max(shipping_page) as shipping_made_it,
max(billing_page) as billing_made_it,
max(thanks_page) as thanks_made_it
from cte1
GROUP BY 1)
select count(DISTINCT website_session_id) as sessions,
count(DISTINCT case when product_made_it = 1 then website_session_id else null end) as to_product,
count(DISTINCT case when mrfuzzy_made_it = 1 then website_session_id else null end) as to_mrfuzzy,
count(DISTINCT case when cart_made_it = 1 then website_session_id else null end) as to_cart,
count(DISTINCT case when shipping_made_it = 1 then website_session_id else null end) as to_shipping,
count(DISTINCT case when billing_made_it = 1 then website_session_id else null end) as to_billing,
count(DISTINCT case when thanks_made_it = 1 then website_session_id else null end) as to_thanks
from cte2;


with
cte1 as (select a.website_session_id, b.pageview_url, b.created_at as pageview_created_at
, case when pageview_url = '/products' then 1 else 0 end as product_page
, case when pageview_url = '/the-original-mr-fuzzy' then 1 else 0 end as mrfuzzy_page
, case when pageview_url = '/cart' then 1 else 0 end as cart_page
, case when pageview_url = '/shipping' then 1 else 0 end as shipping_page
, case when pageview_url = '/billing' then 1 else 0 end as billing_page
, case when pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thanks_page
from website_sessions a
left join website_pageviews b on a.website_session_id = b.website_session_id
where a.created_at BETWEEN '2012-08-05' AND '2012-09-05'
AND utm_source = "gsearch"
AND utm_campaign = "nonbrand"
AND b.pageview_url in ('/lander-1', '/products', '/the-original-mr-fuzzy', '/cart', '/shipping', '/billing', '/thank-you-for-your-order')
order by 1,3),
cte2 as (select website_session_id, 
max(product_page) as product_made_it,
max(mrfuzzy_page) as mrfuzzy_made_it,
max(cart_page) as cart_made_it,
max(shipping_page) as shipping_made_it,
max(billing_page) as billing_made_it,
max(thanks_page) as thanks_made_it
from cte1
GROUP BY 1)
select count(DISTINCT website_session_id) as sessions,
round((count(DISTINCT case when product_made_it = 1 then website_session_id else null end)/count(DISTINCT website_session_id)*100),2) as lander_clickthrough_rate,
round((count(DISTINCT case when mrfuzzy_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when product_made_it = 1 then website_session_id else null end)*100),2) as product_clickthrough_rate,
round((count(DISTINCT case when cart_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when mrfuzzy_made_it = 1 then website_session_id else null end)*100),2) as mrfuzzy_clickthrough_rate,
round((count(DISTINCT case when shipping_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when cart_made_it = 1 then website_session_id else null end)*100),2) as cart_clickthrough_rate,
round((count(DISTINCT case when billing_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when shipping_made_it = 1 then website_session_id else null end)*100),2) as shipping_clickthrough_rate,
round((count(DISTINCT case when thanks_made_it = 1 then website_session_id else null end)/
count(DISTINCT case when billing_made_it = 1 then website_session_id else null end)*100),2) as billing_clickthrough_rate
from cte2;
/*
**Morgan's Request:**
Morgan is interested in understanding the conversion funnel for visitors who arrive at their website 
through a Google search with the following criteria:
- utm_source = "gsearch"
- utm_campaign = "nonbrand"
Morgan would like to know how many visitors progress through each step of the conversion funnel, starting from the 
"/lander-1" page and ending at the "thank you" page. The data should be analyzed for the period from 
August 5, 2012, to September 5, 2012.

Query 1: Building the Conversion Funnel
This query creates a Common Table Expression (CTE) named cte1 to collect information about the website sessions 
and pageviews of the visitors from the specified date range who followed a specific path from "/lander-1" to 
"/thank-you-for-your-order". It also assigns binary values to different pages in the funnel.

Query 2: Aggregating Funnel Steps
The second query creates another CTE, cte2, that groups the data from cte1 by the website session and calculates 
whether each step in the funnel was completed. It uses the MAX function to determine if a page was 
visited in a session.

Query 3: Funnel Conversion Rates
The final query aggregates the data and calculates the conversion rates for each step in the funnel. It calculates 
the clickthrough rates for each step as a percentage of visitors who made it to the next step.

**Answer 1: Overall Numbers (Conversion Funnel)**

- Total Sessions: 4,493
- Visitors from Lander-1 to Product Page: 2,115
- Visitors from Product Page to Mr. Fuzzy Page: 1,567
- Visitors from Mr. Fuzzy Page to Cart Page: 683
- Visitors from Cart Page to Shipping Page: 455
- Visitors from Shipping Page to Billing Page: 361
- Visitors from Billing Page to Thank You Page: 158

**Answer 2: Clickthrough Percentage (Conversion Rates)**

- Lander-1 to Product Page Clickthrough Rate: 47.07%
- Product Page to Mr. Fuzzy Page Clickthrough Rate: 74.09%
- Mr. Fuzzy Page to Cart Page Clickthrough Rate: 43.59%
- Cart Page to Shipping Page Clickthrough Rate: 66.62%
- Shipping Page to Billing Page Clickthrough Rate: 79.34%
- Billing Page to Thank You Page Clickthrough Rate: 43.77%

These results provide insights into the conversion rates at each step of the funnel. For example, only 47.07% of 
visitors from "/lander-1" proceeded to the product page, and 43.77% of those who reached the billing page 
completed the conversion by reaching the thank you page.

These results provide Morgan with insights into the number of visitors at each step of the conversion funnel and 
the percentage of visitors who progress to the next step. Morgan can use this information 
to optimize their website's conversion process.

*/

/*
This analysis is really helpful!
Looks like we should focus on the lander, Mr. Fuzzy page,
and the billing page, which have the lowest click rates.
I have some ideas for the billing page that I think will make
customers more comfortable entering their credit card info.
I’ll test a new page soon and will ask for help analyzing
performance.
Thanks!
-Morgan
*/

/* November 10, 2012
Hello!
We tested an updated billing page based on your funnel
analysis. Can you take a look and see whether /billing-2 is
doing any better than the original /billing page?
We’re wondering what % of sessions on those pages end up
placing an order. FYI – we ran this test for all traffic, not just
for our search visitors.
Thanks!
-Morgan
*/

-- First, finding the starting point to frame the analysis
SELECT min(website_pageview_id) as first_entry 
from website_pageviews
where pageview_url = '/billing-2';
-- 53550 is the first entry pageview id

with
cte1 as (select a.website_session_id, a.pageview_url as billing_version_seen,
 b.order_id
from website_pageviews a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2012-11-10' -- time of assignment
AND a.website_pageview_id >= 53550 -- first pageview id
AND a.pageview_url in ('/billing', '/billing-2'))
select billing_version_seen,
count(DISTINCT website_session_id) as sessions,
count(DISTINCT order_id) as orders,
round((count(DISTINCT order_id)/count(DISTINCT website_session_id))*100,2) as billing_order_rt
from cte1
GROUP BY billing_version_seen;

/*
Morgan has requested an analysis of two billing pages, "/billing" and "/billing-2," to determine if the updated "/billing-2" 
page performs better in terms of order placement. The analysis is based on data for all traffic, not just search visitors. 
The goal is to calculate the percentage of sessions on each page that result in placing an order.

Here's the explanation of the SQL queries and the interpretation of the answers:

This query identifies the first entry pageview ID for the "/billing-2" page, which is used as the 
starting point for the analysis. In this case, the first entry pageview ID is 53550.

**Query: Analyzing Billing Page Performance**

- The query creates a Common Table Expression (CTE) named cte1, which joins data from website_pageviews and orders 
based on the website_session_id. It selects sessions where the pageview URL is either "/billing" or "/billing-2" and 
is within the specified date range and after the first entry pageview ID (53550).

- The main query then groups the data from cte1 by the "billing_version_seen," which represents 
the billing page version. It calculates the following:
  - `sessions`: The number of distinct website sessions that visited each billing page version.
  - `orders`: The number of distinct orders placed by visitors who viewed each billing page version.
  - `billing_order_rt`: The percentage of sessions that resulted in placing an order for each billing page version.

**Interpretation of the Results:**

- For the original "/billing" page, there were 657 sessions, and 300 orders were placed, resulting in a 
billing order rate of 45.66%. This means that 45.66% of sessions on the "/billing" page led to order placement.

- For the updated "/billing-2" page, there were 654 sessions, and 410 orders were placed, resulting in a 
higher billing order rate of 62.69%. This indicates that the updated "/billing-2" page performed better 
than the original "/billing" page, as it had a higher order placement rate.

Morgan can use this information to assess the impact of the billing page update and the effectiveness 
of the "/billing-2" page in encouraging order placements.
*/

/* November 10, 2012
This is so good to see!
Looks like the new version of the billing page is doing a
much better job converting customers…yes!!
I will get Engineering to roll this out to all of our customers
right away. Your insights just made us some major revenue.
Thanks so much!
-Morgan
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */

/*CHANNEL PORTFOLIO OPTIMIZATION
Analyzing a portfolio of marketing channels is about bidding efficiently and
using data to maximize the effectiveness of your marketing budget
*/

select a.utm_content, count(distinct a.website_session_id) as sessions,
count(DISTINCT b.order_id) as orders,
round((count(DISTINCT b.order_id)/count(distinct a.website_session_id))*100,2) as cvr
from website_sessions a 
left join orders b on b.website_session_id = a.website_session_id
where a.created_at between '2014-01-01' AND '2014-02-01'
GROUP BY 1
ORDER BY 2 DESC;

/*November 29, 2012
Hi there,
With gsearch doing well and the site performing better, we
launched a second paid search channel, bsearch, around
August 22.
Can you pull weekly trended session volume since then and
compare to gsearch nonbrand so I can get a sense for how
important this will be for the business?
Thanks, Tom
*/

select
min(DATE(created_at)) as week_start_date, 
count(DISTINCT case when utm_source = 'gsearch' then website_session_id else null end) as gsearch_sessions,
count(DISTINCT case when utm_source = 'bsearch' then website_session_id else null end) as bsearch_sessions
from website_sessions
where created_at between '2012-08-22' AND '2012-11-29'
AND utm_campaign = 'nonbrand'
GROUP BY yearweek(created_at);

/* November 29, 2012
Hi there,
This is very helpful to see. It looks like bsearch tends to get
roughly a third the traffic of gsearch. This is big enough that
we should really get to know the channel better.
I will follow up with some requests to understand channel
characteristics and conversion performance.
Thanks, Tom
*/

/* November 30, 2012
Hi there,
I’d like to learn more about the bsearch nonbrand campaign.
Could you please pull the percentage of traffic coming on
Mobile, and compare that to gsearch?
Feel free to dig around and share anything else you find
interesting. Aggregate data since August 22nd is great, no
need to show trending at this point.
Thanks, Tom
*/

select utm_source, 
count(DISTINCT website_session_id) as sessions, 
count(DISTINCT case when device_type = 'mobile' then website_session_id else null end) as mobile_sessions,
round((count(DISTINCT case when device_type = 'mobile' then website_session_id else null end)/count(DISTINCT website_session_id))*100,2) as pct_mobile
from website_sessions
WHERE created_at BETWEEN '2012-08-22' AND '2012-11-30'
AND utm_campaign = 'nonbrand'
GROUP BY 1;

select utm_source, 
count(DISTINCT website_session_id) as sessions, 
count(DISTINCT case when device_type = 'mobile' then website_session_id else null end) as mobile_sessions,
round((count(DISTINCT case when device_type = 'mobile' then website_session_id else null end)/count(DISTINCT website_session_id))*100,2) as pct_mobile,
count(DISTINCT website_session_id) - count(DISTINCT case when device_type = 'mobile' then website_session_id else null end) as desktop_sessions,
100 - round((count(DISTINCT case when device_type = 'mobile' then website_session_id else null end)/count(DISTINCT website_session_id))*100,2) as pct_desktop
from website_sessions
WHERE created_at BETWEEN '2012-08-22' AND '2012-11-30'
AND utm_campaign = 'nonbrand'
GROUP BY 1;

/* November 30, 2012
Wow, the desktop to mobile splits are very interesting. These
channels are quite different from a device standpoint.
Let’s keep this in mind as we continue to learn and optimize.
Now that we know these channels are pretty different, I’m
going to need your help digging in a bit more so that we can
get our bids right.
Thanks, and keep up the great work!
-Tom
*/

/* December 01, 2012
Hi there,
I’m wondering if bsearch nonbrand should have the same
bids as gsearch. Could you pull nonbrand conversion rates
from session to order for gsearch and bsearch, and slice the
data by device type?
Please analyze data from August 22 to September 18; we
ran a special pre-holiday campaign for gsearch starting on
September 19th, so the data after that isn’t fair game.
Thanks, Tom
*/

select a.utm_source, a.device_type, 
count(DISTINCT a.website_session_id) as sessions, 
count(DISTINCT b.order_id) as orders,
round((count(DISTINCT b.order_id)/count(DISTINCT a.website_session_id))*100,2) as cvr
from website_sessions a 
left join orders b on b.website_session_id = a.website_session_id
where a.created_at between '2012-08-22' AND '2012-09-18'
AND utm_campaign = 'nonbrand'
GROUP BY 1,2;

/* December 01, 2012
Thanks, this is good to see.
As I suspected, the channels don’t perform identically, so we
should differentiate our bids in order to optimize our overall
paid marketing budget.
I'll bid down bsearch based on its under-performance.
Great work!
-Tom
*/

/* December 22, 2012
Hi there,
Based on your last analysis, we bid down bsearch nonbrand on
December 2nd.
Can you pull weekly session volume for gsearch and bsearch
nonbrand, broken down by device, since November 4th?
If you can include a comparison metric to show bsearch as a
percent of gsearch for each device, that would be great too.
Thanks, Tom
*/

select 
min(date(created_at)) as week_start_date,
count(DISTINCT case when device_type = 'desktop' and utm_source = 'gsearch' then website_session_id else null end) as g_dtop_sessions,
count(DISTINCT case when device_type = 'desktop' and utm_source = 'bsearch' then website_session_id else null end) as b_dtop_sessions,
round((count(DISTINCT case when device_type = 'desktop' and utm_source = 'bsearch' then website_session_id else null end)/count(DISTINCT 
case when device_type = 'desktop' and utm_source = 'gsearch' then website_session_id else null end))*100,2) as b_pct_g_dtop,
count(DISTINCT case when device_type = 'mobile' and utm_source = 'gsearch' then website_session_id else null end) as g_mob_sessions,
count(DISTINCT case when device_type = 'mobile' and utm_source = 'bsearch' then website_session_id else null end) as b_mob_sessions,
round((count(DISTINCT case when device_type = 'mobile' and utm_source = 'bsearch' then website_session_id else null end)/count(DISTINCT 
case when device_type = 'mobile' and utm_source = 'gsearch' then website_session_id else null end))*100,2) as b_pct_g_mob
from website_sessions
where created_at BETWEEN '2012-11-04' AND '2012-12-22'
AND utm_campaign = 'nonbrand'
GROUP BY yearweek(created_at);

/* December 22, 2012
Hi there,
Thanks for pulling this together!
Looks like bsearch traffic dropped off a bit after the bid
down. Seems like gsearch was down too after Black Friday
and Cyber Monday, but bsearch dropped even more.
I think this is okay given the low conversion rate.
Thanks, Tom
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */


/*
ANALYZING DIRECT TRAFFIC
Analyzing your branded or direct traffic is about keeping a pulse on how well
your brand is doing with consumers, and how well your brand drives business
*/

select
	case 
		when http_referer is null then 'direct_type_in'
		when http_referer = 'https://www.gsearch.com' AND utm_source is null then 'gsearch_organic'
        when http_referer = 'https://www.bsearch.com' AND utm_source is null then 'bsearch_organic'
        else 'other'
        end as Traffics,
	count(DISTINCT website_session_id) as sessions
    from website_sessions
    where website_session_id between 100000 and 115000
    GROUP BY 1
    ORDER BY 2 desc;


/* December 23, 2012
Good morning,
A potential investor is asking if we’re building any
momentum with our brand or if we’ll need to keep relying
on paid traffic.
Could you pull organic search, direct type in, and paid
brand search sessions by month, and show those sessions
as a % of paid search nonbrand?
-Cindy
*/

select distinct utm_source, utm_campaign, http_referer
from website_sessions
where created_at < '2012-12-23';

select DISTINCT	
		case 
			when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
            when utm_campaign = 'nonbrand' then 'paid_nonbrand'
            when utm_campaign = 'brand' then 'paid_brand'
            when utm_source is null and http_referer is null then 'direct_type_in'
		end as channel_group,
        utm_source,
		utm_campaign,
        http_referer
	from website_sessions 
    where created_at < '2012-12-23';

with
cte1 as (select website_session_id, created_at,
		case 
			when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
            when utm_campaign = 'nonbrand' then 'paid_nonbrand'
            when utm_campaign = 'brand' then 'paid_brand'
            when utm_source is null and http_referer is null then 'direct_type_in'
		end as channel_group
	from website_sessions 
    where created_at < '2012-12-23')
select year(created_at) as yr,
month(created_at) as month,
count(DISTINCT case when channel_group = 'paid_nonbrand' then website_session_id else null end) as nonbrand,
count(DISTINCT case when channel_group = 'paid_brand' then website_session_id else null end) as nonbrand,
count(DISTINCT case when channel_group = 'paid_brand' then website_session_id else null end)/count(DISTINCT case when 
channel_group = 'paid_nonbrand' then website_session_id else null end) as brand_pct_of_nonbrand,
count(DISTINCT case when channel_group = 'direct_type_in' then website_session_id else null end) as direct,
count(DISTINCT case when channel_group = 'direct_type_in' then website_session_id else null end)/count(DISTINCT case when 
channel_group = 'paid_nonbrand' then website_session_id else null end) as direct_pct_of_nonbrand,
count(DISTINCT case when channel_group = 'organic_search' then website_session_id else null end) as organic,
count(DISTINCT case when channel_group = 'organic_search' then website_session_id else null end)/count(DISTINCT case when 
channel_group = 'paid_nonbrand' then website_session_id else null end) as organic_pct_of_nonbrand
from cte1
GROUP BY 1,2;

/* December 23, 2012
This is great to see!
Looks like not only are our brand, direct, and organic
volumes growing, but they are growing as a percentage
of our paid traffic volume.
Now this is a story I can sell to an investor!
-Cindy
*/


/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */


/*
ANALYZING SEASONALITY & BUSINESS PATTERNS
Analyzing business patterns is about generating insights to help you maximize
efficiency and anticipate future trends
*/

select 
	website_session_id, 
    created_at, 
    hour(created_at) as hr,
    weekday(created_at) as wkday,
    case 
		when weekday(created_at) = 0 then 'Monday'
        when weekday(created_at) = 1 then 'Tuesday'
        when weekday(created_at) = 2 then 'Wednesday'
        when weekday(created_at) = 3 then 'Thursday'
        when weekday(created_at) = 4 then 'Friday'
        when weekday(created_at) = 5 then 'Saturday'
        when weekday(created_at) = 6 then 'Sunday'
        else 'other_day'
	end as clean_weekday,
    quarter(created_at) as qtr,
    month(created_at) as month,
    date(created_at) as date,
    week(created_at) as wk

from website_sessions
where website_session_id between 150000 and 155000;


/* January 02, 2013
Good morning,
2012 was a great year for us. As we continue to grow, we
should take a look at 2012’s monthly and weekly volume
patterns, to see if we can find any seasonal trends we
should plan for in 2013.
If you can pull session volume and order volume, that
would be excellent.
Thanks,
-Cindy
*/

select year(a.created_at) as yr, 
month(a.created_at) as month,
count(DISTINCT a.website_session_id) as sessions,
count(DISTINCT b.order_id) as orders
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2013-01-01'
GROUP BY 1,2;

select min(date(a.created_at)) as week_start_date,
count(DISTINCT a.website_session_id) as sessions,
count(DISTINCT b.order_id) as orders
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at < '2013-01-01'
GROUP BY yearweek(a.created_at);

/* January 02, 2013
This is great to see.
Looks like we grew fairly steadily all year, and saw
significant volume around the holiday months (especially
the weeks of Black Friday and Cyber Monday).
We’ll want to keep this in mind in 2013 as we think about
customer support and inventory management.
Great analysis!
-Cindy
*/


/* January 05, 2013
Good morning,
We’re considering adding live chat support to the website
to improve our customer experience. Could you analyze
the average website session volume, by hour of day and
by day week, so that we can staff appropriately?
Let’s avoid the holiday time period and use a date range of
Sep 15 - Nov 15, 2013.
Thanks, Cindy
*/

with
cte1 as (
	select date(created_at) as created_date,
    weekday(created_at) as wkday,
    hour(created_at) as hr,
    count(DISTINCT website_session_id) as website_sessions
    
    from website_sessions
    where created_at between '2012-09-15' AND '2012-11-15'
    group by 1,2,3
)
select hr, 
round(avg(case when wkday = 0 then website_sessions else null end),1) as mon,
round(avg(case when wkday = 1 then website_sessions else null end),1) as tue,
round(avg(case when wkday = 2 then website_sessions else null end),1) as wed,
round(avg(case when wkday = 3 then website_sessions else null end),1) as thu,
round(avg(case when wkday = 4 then website_sessions else null end),1) as fri,
round(avg(case when wkday = 5 then website_sessions else null end),1) as sat,
round(avg(case when wkday = 6 then website_sessions else null end),1) as sun
from cte1
GROUP BY 1
order by 1;

/* January 05, 2013
Thanks, this is really helpful.
I’ve been speaking with support companies, and it
sounds like ~10 sessions per hour per employee staffed is
about right.
Looks like we can plan on one support staff around the
clock and then we should double up to two staff
members from 8am to 5pm Monday through Friday.
-Cindy
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */


/*
PRODUCT SALES ANALYSIS
Analyzing product sales helps you understand how each product contributes to
your business, and how product launches impact the overall portfolio
*/

select 
 primary_product_id,
 count(order_id) as orders,
 sum(price_usd) as revenue,
 sum(price_usd - cogs_usd) as margin,
 avg(price_usd) as average_revenue
 from orders 
 where order_id between 10000 and 11000
 group by 1
 order by 4 desc;

/* January 04, 2013
Good morning,
We’re about to launch a new product, and I’d like to do a
deep dive on our current flagship product.
Can you please pull monthly trends to date for number of
sales, total revenue, and total margin generated for the
business?
-Cindy
*/

select year(created_at) as year,
month(created_at) as month,
count(DISTINCT order_id) as number_of_sales,
sum(price_usd) as total_revenue,
sum(price_usd - cogs_usd) as total_margin
from orders
where created_at < '2013-01-04'
GROUP BY 1,2;

/* January 04, 2013
Excellent, thank you!
This will serve as great baseline data so that we can see
how our revenue and margin evolve as we roll out the
new product.
It’s also nice to see our growth pattern in general.
Thanks again,
-Cindy
*/

/* April 05, 2013 
Good morning,
We launched our second product back on January 6th. Can
you pull together some trended analysis?
I’d like to see monthly order volume, overall conversion
rates, revenue per session, and a breakdown of sales by
product, all for the time period since April 1, 2013.
Thanks,
-Cindy
*/

select 
	year(a.created_at) as year,
    month(a.created_at) as month,
    count(DISTINCT b.order_id) as orders,
    count(distinct b.order_id)/count(DISTINCT a.website_session_id) as cvr,
    round(sum(b.price_usd)/count(DISTINCT a.website_session_id),2) as revenue_sessions,
    count(distinct case when b.primary_product_id = 1 then order_id else null end) as product_one_orders,
    count(distinct case when b.primary_product_id = 2 then order_id else null end) as product_two_orders
from website_sessions a 
left join orders b on b.website_session_id = a.website_session_id
where a.created_at between '2012-04-01' AND '2013-04-05'
GROUP BY 1,2;
    
/* April 05, 2013
Thanks!
This confirms that our conversion rate and revenue per
session are improving over time, which is great.
I’m having a hard time understanding if the growth since
January is due to our new product launch or just a
continuation of our overall business improvements.
I’ll connect with Tom about digging into this some more.
-Cindy
*/

    
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */


/* PRODUCT LEVEL WEBSITE ANALYSIS
Product-focused website analysis is about learning how customers interact
with each of your products, and how well each product converts customers
*/    
    
select
		a.pageview_url,
        count(DISTINCT a.website_session_id) as sessions,
        count(DISTINCT b.order_id) as orders, 
        count(DISTINCT b.order_id)/count(DISTINCT a.website_session_id) as cvr
        from website_pageviews a
	left join orders b on b.website_session_id = a.website_session_id
    where a.created_at BETWEEN '2013-02-01' AND '2013-03-01'
    and a.pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')
    GROUP BY 1;
        
    
/* April 06, 2013
Hi there!
Now that we have a new product, I’m thinking about our
user path and conversion funnel. Let’s look at sessions which
hit the /products page and see where they went next.
Could you please pull clickthrough rates from /products
since the new product launch on January 6th 2013, by
product, and compare to the 3 months leading up to launch
as a baseline?
Thanks, Morgan
*/
    
-- assignment: product pathing analysis

/*
1: find the relevant /products pageviews with website_session_id
2: find the next pageview id that occurs after the product overview 
3: find the pageview_url associated with any applicable next pageview id
4: summarize the data and analyze the pre vs post periods
*/
    
-- step 1: finding the /products pageviews we care about
with
cte1 as (select website_session_id, 
website_pageview_id,
created_at,
case when created_at < '2013-01-06' then 'A. Pre_product_2'
     when created_at >= '2013-01-06' then 'B. Post_product_2'
	 else 'error 404! not found'
end as time_period
from website_pageviews
where created_at < '2013-04-06'
and created_at > '2012-10-06' -- start date; of 3 months before product 2 launch
and pageview_url = '/products'),
-- 2: find the next pageview id that occurs after the product overview 
cte2 as (select a.time_period, a.website_session_id, min(b.website_pageview_id) as min_next_pageview_id
from cte1 a
left join website_pageviews b
	on b.website_session_id = a.website_session_id
    and b.website_pageview_id > a.website_pageview_id
GROUP BY 1,2),
-- 3: find the pageview_url associated with any applicable next pageview id
cte3 as (select a.time_period, a.website_session_id,
b.pageview_url as next_pageview_url
from cte2 a 
left join website_pageviews b 
on b.website_pageview_id = a.min_next_pageview_id)
-- 4: summarize the data and analyze the pre vs post periods
select
time_period, count(DISTINCT website_session_id) as sessions,
count(distinct case when next_pageview_url is not null then website_session_id else null end) as w_next_pg,
count(distinct case when next_pageview_url is not null then website_session_id else null end)/count(DISTINCT 
website_session_id) as pct_w_next_pg,
count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end) as w_mrfuzzy,
count(distinct case when next_pageview_url = '/the-original-mr-fuzzy' then website_session_id else null end)/count(DISTINCT 
website_session_id) as pct_w_mrfuzzy,
count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end) as w_lovebear,
count(distinct case when next_pageview_url = '/the-forever-love-bear' then website_session_id else null end)/count(DISTINCT 
website_session_id) as pct_w_lovebear
from cte3
GROUP BY 1;

/* April 06, 2013
Great analysis!
Looks like the percent of /products pageviews that clicked to
Mr. Fuzzy has gone down since the launch of the Love Bear,
but the overall clickthrough rate has gone up, so it seems to
be generating additional product interest overall.
As a follow up, we should probably look at the conversion
funnels for each product individually.
Thanks!
-Morgan
*/


/* April 10, 2013
Hi there!
I’d like to look at our two products since January 6th and
analyze the conversion funnels from each product page to
conversion.
It would be great if you could produce a comparison between
the two conversion funnels, for all website traffic.
Thanks!
-Morgan
*/

-- step 1: select all pageviews for relevant sessions
-- step 2: figure out which pageview urls to look for
-- step 3: pull all pageviews and identify the funnel steps
-- step 4: create the session-level conversion funnel view
-- step 5: aggregate the data to assess funnel performance


-- step 1: select all pageviews for relevant sessions
create temporary table funnel
with
cte1 as (select website_session_id, 
website_pageview_id, pageview_url as product_page_seen
from website_pageviews
where created_at < '2013-04-10' -- date of assignment
and created_at > '2013-01-06' -- product 2 launch
and pageview_url in ('/the-original-mr-fuzzy', '/the-forever-love-bear')), 
-- step 2: figure out which pageview urls to look for    
cte2 as (select distinct pageview_url
    from cte1 a
    left join website_pageviews b 
    on b.website_session_id = a.website_session_id
    and b.website_pageview_id > a.website_pageview_id),
-- step 3: pull all pageviews and identify the funnel steps
cte3 as (select a.website_session_id, 
a.product_page_seen, 
case when b.pageview_url = '/cart' then 1 else 0 end as cart_page,
case when b.pageview_url = '/shipping' then 1 else 0 end as shipping_page,
case when b.pageview_url = '/billing-2' then 1 else 0 end as billing_page,
case when b.pageview_url = '/thank-you-for-your-order' then 1 else 0 end as thankyou_page
from cte1 a
left join website_pageviews b 
on b.website_session_id = a.website_session_id
and b.website_pageview_id > a.website_pageview_id
order by 
1, b.created_at)
-- step 4: create the session-level conversion funnel view
select website_session_id, 
case when product_page_seen = '/the-original-mr-fuzzy' then 'mrfuzzy'
when product_page_seen = '/the-forever-love-bear' then 'lovebear'
else 'error 404!'
end as product_seen,
max(cart_page) as cart_made_it,
max(shipping_page) as shipping_made_it,
max(billing_page) as billing_made_it,
max(thankyou_page) as thankyou_made_it
from cte3
GROUP BY 1,2;

-- step 5: aggregate the data to assess funnel performance
select * from funnel;

-- overall sessions per products
select product_seen, 
count(DISTINCT case when cart_made_it = 1 then website_session_id else null end) as to_cart,
count(DISTINCT case when shipping_made_it = 1 then website_session_id else null end) as to_shipping,
count(DISTINCT case when billing_made_it = 1 then website_session_id else null end) as to_billing,
count(DISTINCT case when thankyou_made_it = 1 then website_session_id else null end) as to_thankyou
from funnel
GROUP BY 1;

-- clickthrough rate
select product_seen, 
count(distinct website_session_id) as sessions,
count(DISTINCT case when cart_made_it = 1 then website_session_id else null end)/count(distinct 
website_session_id) as product_page_rt,
count(DISTINCT case when shipping_made_it = 1 then website_session_id else null end)/count(DISTINCT 
case when cart_made_it = 1 then website_session_id else null end) as cart_page_rt,
count(DISTINCT case when billing_made_it = 1 then website_session_id else null end)/count(DISTINCT 
case when shipping_made_it = 1 then website_session_id else null end) as shipping_page_rt,
count(DISTINCT case when thankyou_made_it = 1 then website_session_id else null end)/count(DISTINCT 
case when billing_made_it = 1 then website_session_id else null end) as billing_page_rt
from funnel
GROUP BY 1;

/* April 10, 2013
This is great to see!
We had found that adding a second product increased
overall CTR from the /products page, and this analysis shows
that the Love Bear has a better click rate to the /cart page
and comparable rates throughout the rest of the funnel.
Seems like the second product was a great addition for our
business. I wonder if we should add a third…
Thanks!
-Morgan
*/


/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */

/* CROSS-SELLING PRODUCTS
Cross-sell analysis is about understanding which products users are most
likely to purchase together, and offering smart product recommendations
*/

select 
a.primary_product_id,
b.product_id as cross_sell_product,
count(distinct a.order_id) as orders
from orders a
left join order_items b
on b.order_id = a.order_id
and b.is_primary_item = 0
where a.order_id between 10000 and 11000
group by 1,2;

select 
a.primary_product_id,
count(distinct a.order_id) as orders,
count(DISTINCT case when b.product_id = 1 then a.order_id else null end) as x_sell_prod1,
count(DISTINCT case when b.product_id = 2 then a.order_id else null end) as x_sell_prod2,
count(DISTINCT case when b.product_id = 3 then a.order_id else null end) as x_sell_prod3,
round(count(DISTINCT case when b.product_id = 1 then a.order_id else null end)/count(distinct a.order_id)*100,2) as x_sell_prod1_rt,
round(count(DISTINCT case when b.product_id = 2 then a.order_id else null end)/count(distinct a.order_id)*100,2) as x_sell_prod2_rt,
round(count(DISTINCT case when b.product_id = 3 then a.order_id else null end)/count(distinct a.order_id)*100,2) as x_sell_prod3_rt
from orders a
left join order_items b
on b.order_id = a.order_id
and b.is_primary_item = 0
where a.order_id between 10000 and 11000
group by 1;


/* November 22, 2013
Good morning,
On September 25th we started giving customers the option
to add a 2nd product while on the /cart page. Morgan says
this has been positive, but I’d like your take on it.
Could you please compare the month before vs the month
after the change? I’d like to see CTR from the /cart page,
Avg Products per Order, AOV, and overall revenue per
/cart page view.
Thanks, Cindy
*/

-- assignment cross sell analysis

/*
1: Identify the relevant /cart page views and their sessions
2: see which of those /cart sessions clicked through to the shipping page
3: find the orders associated with the /cart sessions. Analyze products purchased, AOV
4: aggregate and analyze a summary of our findings
*/

-- Identify the relevant /cart page views and their sessions
with
cte1 as (select case when created_at < '2013-09-25' then 'pre_cross_sell'
		when created_at >= '2013-09-25' then 'post_cross_sell'
        else 'others' end as time_period,
website_session_id as cart_session_id,
website_pageview_id as cart_pageview_id
from website_pageviews
where created_at between '2013-08-25' AND '2013-10-25'
	and pageview_url = '/cart'),
-- see which of those /cart sessions clicked through to the shipping page
cte2 as (select time_period, cart_session_id, min(b.website_pageview_id) as pv_id_after_cart
    from cte1 a 
    left join website_pageviews b 
    on b.website_session_id = a.cart_session_id
    and b.website_pageview_id > a.cart_pageview_id
group by 1,2
having min(b.website_pageview_id) is not null),
-- find the orders associated with the /cart sessions. Analyze products purchased, AOV
cte3 as (select time_period, cart_session_id, order_id, items_purchased, price_usd
from cte1 a 
inner join orders b 
	on a.cart_session_id = b.website_session_id),
    
cte4 as (select a.time_period, a.cart_session_id, 
case when b.cart_session_id is null then 0 else 1 end as clicked_to_another_page,
case when c.order_id is null then 0 else 1 end as placed_order,
c.items_purchased,
c.price_usd
from cte1 a
	left join cte2 b
    on a.cart_session_id = b.cart_session_id
    left join cte3 c
    on a.cart_session_id = c.cart_session_id
ORDER BY 2)
-- aggregate and analyze a summary of our findings
select time_period, 
count(DISTINCT cart_session_id) as cart_sessions,
sum(clicked_to_another_page) as clickthroughs,
sum(clicked_to_another_page)/count(DISTINCT cart_session_id) as cart_ctr,
sum(items_purchased)/sum(placed_order) as products_per_order,
sum(price_usd)/sum(placed_order) as aov,
sum(price_usd)/count(DISTINCT cart_session_id) as rev_per_cart_session
from cte4
group by 1;

/* November 22, 2013
Thanks!
It looks like the CTR from the /cart page didn’t go down (I
was worried), and that our products per order, AOV, and
revenue per /cart session are all up slightly since the
cross-sell feature was added.
Doesn’t look like a game changer, but the trend looks
positive. Great analysis!
-Cindy
*/

/* January 12, 2014
Good morning,
On December 12th 2013, we launched a third product
targeting the birthday gift market (Birthday Bear).
Could you please run a pre-post analysis comparing the
month before vs. the month after, in terms of session-toorder conversion rate, AOV, products per order, and
revenue per session?
Thank you!
-Cindy
*/

select 
case when a.created_at < '2013-12-12' then 'Pre_Birthday_Bear'
when a.created_at >= '2013-12-12' then 'Post_Birthday_Bear'
else 'others' end as time_period,
-- count(DISTINCT a.website_session_id) as sessions,
-- count(DISTINCT b.order_id) as orders,
count(DISTINCT b.order_id)/count(DISTINCT a.website_session_id) as cvr,
-- sum(b.price_usd) as total_revenue,
-- sum(b.items_purchased) as total_products_sold,
sum(b.price_usd)/count(DISTINCT b.order_id) as average_order_value,
sum(b.items_purchased)/count(DISTINCT b.order_id) as products_per_order,
sum(b.price_usd)/count(DISTINCT a.website_session_id) as revenue_per_session
from website_sessions a
left join orders b on b.website_session_id = a.website_session_id
where a.created_at between '2013-11-12' and '2014-01-12'
GROUP BY 1;

/*
Great – it looks like all of our critical metrics have
improved since we launched the third product. This is
fantastic!
I’m going to meet with Tom about increasing our ad
spend now that we’re driving more revenue per session,
and we may also consider adding a fourth product.
Stay tuned,
-Cindy
*/

/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */


/* PRODUCT REFUND ANALYSIS
Analyzing product refund rates is about controlling for quality and
understanding where you might have problems to address
*/

select a.order_id, a.order_item_id, a.price_usd, a.created_at,
b.order_item_refund_id, b.refund_amount_usd, b.created_at
from order_items a
left join order_item_refunds b on b.order_item_id = a.order_item_id
where a.order_id in (3489, 32049, 27061);


/* October 15, 2014
Good morning,
Our Mr. Fuzzy supplier had some quality issues which
weren’t corrected until September 2013. Then they had a
major problem where the bears’ arms were falling off in
Aug/Sep 2014. As a result, we replaced them with a new
supplier on September 16, 2014.
Can you please pull monthly product refund rates, by
product, and confirm our quality issues are now fixed?
-Cindy
*/

select year(a.created_at) as year,
month(a.created_at) as month, 
count(DISTINCT case when product_id = 1 then a.order_item_id else null end) as p1_orders,
count(DISTINCT case when product_id = 1 then b.order_item_id else null end)/count(DISTINCT 
case when product_id = 1 then a.order_item_id else null end) as p1_refund_rt,
count(DISTINCT case when product_id = 2 then a.order_item_id else null end) as p2_orders,
count(DISTINCT case when product_id = 2 then b.order_item_id else null end)/count(DISTINCT 
case when product_id = 2 then a.order_item_id else null end) as p2_refund_rt,
count(DISTINCT case when product_id = 3 then a.order_item_id else null end) as p3_orders,
count(DISTINCT case when product_id = 3 then b.order_item_id else null end)/count(DISTINCT 
case when product_id = 3 then a.order_item_id else null end) as p3_refund_rt,
count(DISTINCT case when product_id = 4 then a.order_item_id else null end) as p4_orders,
count(DISTINCT case when product_id = 4 then b.order_item_id else null end)/count(DISTINCT 
case when product_id = 4 then a.order_item_id else null end) as p4_refund_rt
from order_items a 
left join order_item_refunds b on a.order_item_id = b.order_item_id
where a.created_at < '2014-10-15'
GROUP BY 1,2;


/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */
/* -------------------------------------------------------------------- *//* -------------------------------------------------------------------- */


/*
ANALYZE REPEAT BEHAVIOR
Analyzing repeat visits helps you understand user behavior and identify
some of your most valuable customers
Businesses track customer behavior across multiple sessions using browser cookies
Cookies have unique ID values associated with them, which allows us to recognize
a customer when they come back and track their behavior over time
*/

select a.order_id, a.order_item_id, a.price_usd, a.created_at, 
b.order_item_refund_id, b.refund_amount_usd, b.created_at,
datediff(b.created_at, a.created_at) as days_order_to_refund
from order_items a
left join order_item_refunds b
on b.order_item_id = a.order_item_id
where a.order_id in ('3489', '32049', '27061');

/* November 01, 2014
Hey there,
We’ve been thinking about customer value based solely on
their first session conversion and revenue. But if customers
have repeat sessions, they may be more valuable than we
thought. If that’s the case, we might be able to spend a bit
more to acquire them.
Could you please pull data on how many of our website
visitors come back for another session? 2014 to date is good.
Thanks, Tom
*/

with
cte1 as (select user_id, website_session_id
from website_sessions
where created_at between '2014-01-01' and '2014-11-01'
and is_repeat_session = 0),
cte2 as (select a.user_id, a.website_session_id as new_session_id,
b.website_session_id as repeat_session_id
from cte1 a
left join website_sessions b
on b.user_id = a.user_id
and b.is_repeat_session = 1
and b.website_session_id > a.website_session_id
and b.created_at BETWEEN '2014-01-01' and '2014-11-01'),
cte3 as(select user_id, count(DISTINCT new_session_id) as new_sessions,
count(DISTINCT repeat_session_id) as repeat_sessions
from cte2
GROUP BY 1
ORDER BY 3 desc)
select repeat_sessions,
count(DISTINCT user_id) as users
from cte3
GROUP BY 1;

/*
Thanks, it’s really interesting to see this breakdown.
Looks like a fair number of our customers do come back to
our site after the first session.
Seems like we should learn more about this – I’ll follow up
with some next steps soon.
-Tom
*/


/* November 03, 2014
Ok, so the repeat session data was really interesting to see.
Now you’ve got me curious to better understand the behavior
of these repeat customers.
Could you help me understand the minimum, maximum, and
average time between the first and second session for
customers who do come back? Again, analyzing 2014 to date
is probably the right time period.
Thanks, Tom
*/

-- 1: Identify the relevant new sessions
-- 2: Use the user_id values from step 1 to find any repeat sessions those users had
-- 3: Find the created_at times for first and second sessions
-- 4: Find the differences between first and second sessions at a user level
-- 5: Aggregate the user level data to find the average, min, and max.

create temporary table first_to_second_session
with
cte1 as (select user_id, website_session_id, created_at
from website_sessions
where created_at between '2014-01-01' and '2014-11-03'
and is_repeat_session = 0),
cte2 as (select a.user_id, a.website_session_id as new_session_id, a.created_at as new_session_created_at,
b.website_session_id as repeat_session_id, b.created_at as repeat_session_created_at
from cte1 a
left join website_sessions b
on b.user_id = a.user_id
and b.is_repeat_session = 1
and b.website_session_id > a.website_session_id
and b.created_at BETWEEN '2014-01-01' and '2014-11-03'),
cte3 as (select user_id, new_session_id, new_session_created_at, 
min(repeat_session_id) as second_session_id, 
min(repeat_session_created_at) as second_session_created_at
from cte2
where repeat_session_id is not null
GROUP BY 1,2,3)
select user_id, 
datediff(second_session_created_at, new_session_created_at) as days_first_to_second_session
from cte3;

select * from first_to_second_session;
select avg(days_first_to_second_session) as avg_days_first_to_second,
min(days_first_to_second_session) as min_days_first_to_second,
max(days_first_to_second_session) as max_days_first_to_second
from first_to_second_session;

/* November 03, 2014
Thanks!
Interesting to see that our repeat visitors are coming back
about a month later, on average.
I think we should investigate the channels that these visitors
are using. I’ll follow up with some additional asks.
-Tom
*/

/* November 05, 2014
Hi there,
Let’s do a bit more digging into our repeat customers.
Can you help me understand the channels they come back
through? Curious if it’s all direct type-in, or if we’re paying for
these customers with paid search ads multiple times.
Comparing new vs. repeat sessions by channel would be
really valuable, if you’re able to pull it! 2014 to date is great.
Thanks, Tom
*/

SELECT case 
			when utm_source is null and http_referer in ('https://www.gsearch.com', 'https://www.bsearch.com') then 'organic_search'
            when utm_campaign = 'nonbrand' then 'paid_nonbrand'
            when utm_campaign = 'brand' then 'paid_brand'
            when utm_source is null and http_referer is null then 'direct_type_in'
            when utm_source = 'socialbook' then 'paid_social'
		end as channel_group,
	count(case when is_repeat_session = 0 then website_session_id else null end) as new_sessions,
    count(case when is_repeat_session = 1 then website_session_id else null end) as repeat_sessions
from website_sessions
where created_at BETWEEN '2014-01-01' and '2014-11-05'
GROUP BY 1
order by 3 desc;
            
/* November 05, 2014
Hi there,
So, it looks like when customers come back for repeat visits,
they come mainly through organic search, direct type-in,
and paid brand.
Only about 1/3 come through a paid channel, and brand
clicks are cheaper than nonbrand. So all in all, we’re not
paying very much for these subsequent visits.
This make me wonder whether these convert to orders…
-Tom
*/


/* November 08, 2014
Hi there!
Sounds like you and Tom have learned a lot about our repeat
customers. Can I trouble you for one more thing?
I’d love to do a comparison of conversion rates and revenue per
session for repeat sessions vs new sessions.
Let’s continue using data from 2014, year to date.
Thank you!
-Morgan
*/

select a.is_repeat_session, 
		count(DISTINCT a.website_session_id) as sessions,
        count(distinct b.order_id)/count(DISTINCT a.website_session_id) as cvr, 
        sum(b.price_usd)/count(DISTINCT a.website_session_id) as rev_per_session
	from website_sessions a
    left join orders b
		on a.website_session_id = b.website_session_id
	where a.created_at between '2014-01-01' and '2014-11-08'
    GROUP BY 1;

/*
Hey!
This is so interesting to see. Looks like repeat sessions are
more likely to convert, and produce more revenue per
session.
I’ll circle up with Tom on this one. Since we aren’t paying
much for repeat sessions, we should probably take them into
account when bidding on paid traffic.
Thanks!
-Morgan
*/


