# Introduction

I've recently joined Maven Fuzzy Factory as an eCommerce Database Analyst, where I'm part of the startup team working closely with the CEO, Head of Marketing, and Website Manager. Our primary focus is to navigate the online retail space, analyze marketing channels, optimize website performance, and measure the impact of our new product launches.

# Data Information

Our database plays a pivotal role in our analysis and decision-making processes. It consists of six key tables:

1. **website_sessions**: This table holds essential information about website sessions, including details like session duration, user source, campaign, device type, and referral sources.

2. **website_pageviews**: Here, we store data related to website page views, tracking user activity across our web pages.

3. **products**: This table is dedicated to our product catalog, containing valuable data about our products, including their names and creation dates.

4. **orders**: We keep track of all customer orders in this table, capturing data on order IDs, website sessions, user IDs, primary products, items purchased, prices, and costs.

5. **order_items**: Each order can consist of multiple items, and this table stores the details of these items, such as product IDs, prices, and costs.

6. **order_item_refunds**: In case of any refunds, we meticulously record refund data here, including refund amounts and their associations with orders and items.

As we dive deeper into the data, my goal is to become the data expert for Maven Fuzzy Factory, providing mission-critical analyses that help drive our business forward and achieve our goals.

## Traffic Source Analysis

Understanding the sources of your website's traffic is a crucial aspect of marketing analysis. In this analysis, we'll explore different traffic sources using UTM parameters and evaluate how well these sources perform in terms of driving website sessions and orders. UTM parameters allow us to track and link website activity to specific traffic sources and campaigns.

**1. Size of Various Traffic Sources**

To start, we want to determine the size of various traffic sources by focusing on the "utm_content" parameter. This parameter can help us identify the key components of our traffic sources. The SQL code for this part of the analysis looks at website sessions with IDs between 1000 and 2000 and groups them by "utm_content," counting the number of sessions for each content type. The results show the following:

| utm_content | Sessions |
|------------|----------|
| g_ad_1     | 975      |
| null       | 18       |
| g_ad_2     | 6        |
| b_ad_2     | 2        |

- "g_ad_1" is the most significant traffic source, driving 975 sessions.
- "null" represents untagged or untracked sessions, contributing 18 sessions.
- "g_ad_2" and "b_ad_2" have minimal sessions.

**2. Which UTM Content Drives the Most Orders?**

While understanding the volume of sessions is valuable, what ultimately matters is how these sessions convert into orders. Therefore, we proceed to evaluate which "utm_content" drives the most orders. The SQL code extends the previous query by joining the "website_sessions" table with the "orders" table and counting the number of orders associated with each "utm_content." The results are as follows:

| utm_content | Sessions | Orders |
|------------|----------|--------|
| g_ad_1     | 975      | 35     |
| null       | 18       | 0      |
| g_ad_2     | 6        | 0      |
| b_ad_2     | 2        | 0      |

- "g_ad_1" maintains its lead in sessions and also drives 35 orders.
- Unfortunately, "null," "g_ad_2," and "b_ad_2" have not resulted in any orders during this period.

**3. Adding Session-to-Order Conversion Rate**

Finally, we take a closer look at the session-to-order conversion rate for each "utm_content." Conversion rate is a key performance metric, showing how effectively traffic sources lead to conversions (in this case, orders). The SQL code adds the conversion rate calculation, and the results provide us with insights into the effectiveness of each traffic source:

| utm_content | Sessions | Orders | Session-to-Order Conversion Rate |
|------------|----------|--------|---------------------------------|
| g_ad_1     | 975      | 35     | 3.59%                           |
| null       | 18       | 0      | 0.00%                           |
| g_ad_2     | 6        | 0      | 0.00%                           |
| b_ad_2     | 2        | 0      | 0.00%                           |

- "g_ad_1" maintains its position as the leading traffic source with a 3.59% conversion rate.
- Unfortunately, "null," "g_ad_2," and "b_ad_2" have not yet resulted in any conversions.

This analysis provides valuable insights into the performance of different traffic sources, enabling us to focus on optimizing and investing in those sources that are most effective in driving both website sessions and, more importantly, orders.
