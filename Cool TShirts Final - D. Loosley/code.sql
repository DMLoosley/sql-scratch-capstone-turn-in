/*
1a. How many campaigns does CoolTShirts use - query counts the number of campaigns
*/
SELECT COUNT(DISTINCT utm_campaign) AS 'Campaign Count'
FROM page_visits;
/*
1b. How many sources does CoolTShirts use - query counts the number of sources
*/
SELECT COUNT(DISTINCT utm_source) AS 'Source Count'
FROM page_visits;
/*
1c. Which source is used for each campaign - query finds
the relationship between campaigns and the sources
*/
SELECT DISTINCT utm_campaign AS Campaign,
                utm_source AS Source
FROM page_visits;
/*
1.2 - Find unique pages on the CoolTshirts website
*/
SELECT DISTINCT page_name AS 'Page'
FROM page_visits;
/*
2.1 - Count the number of first touches by Campaign,
listing the Source associated with the first touch is
beneficial.
*/
WITH first_touch AS (
      SELECT user_id,
          MIN(timestamp) AS first_touch_at
      FROM page_visits
      GROUP BY user_id),
ft_attr AS(
        SELECT  ft.user_id,
                ft.first_touch_at,
                pv.utm_source,
                pv.utm_campaign
        FROM first_touch ft
        JOIN page_visits pv
        ON ft.user_id = pv.user_id
        AND ft.first_touch_at = pv.timestamp
)
SELECT  ft_attr.utm_source AS Source,
        ft_attr.utm_campaign AS Campaign,
        Count(*) AS First_Touches
FROM ft_attr
GROUP BY 1, 2
ORDER BY 3 DESC;
/*
2.2 - Counting the CoolTShirts last touches per campaign,
including the source helps to identify which campaigns
work best.
*/
WITH last_touch AS (
      SELECT user_id,
          MAX(timestamp) AS last_touch_at
      FROM page_visits
      GROUP BY user_id),
      lt_attr AS(
      SELECT lt.user_id,
             lt.last_touch_at,
             pv.utm_source,
             pv.utm_campaign
      FROM last_touch lt
      JOIN page_visits pv
        ON lt.user_id = pv.user_id
        AND lt.last_touch_at = pv.timestamp
 )
 SELECT lt_attr.utm_source AS Source,
        lt_attr.utm_campaign AS Campaign,
        COUNT(*) AS Last_Touches
 FROM lt_attr
 GROUP BY 1, 2
 ORDER BY 3 DESC;
 /*
 2.3 - Count the unique number of customers that make
 purchases from CoolTShirts.
 */
 SELECT COUNT(DISTINCT user_id) AS 'Number of Customers Who Made Purchases'
 FROM page_visits
 WHERE page_name = '4 - purchase';
 /*
 2.4 - Count the last touches by campaign that resulted 
 in a purchase for CoolTShirts.
 */
 WITH last_touch AS (
      SELECT user_id,
          MAX(timestamp) AS last_touch_at
      FROM page_visits
      WHERE page_name = '4 - purchase'
      GROUP BY user_id),
      lt_attr AS (
      SELECT  lt.user_id,
              lt.last_touch_at,
              pv.utm_source,
              pv.utm_campaign
      FROM last_touch lt
      JOIN page_visits pv
      	ON lt.user_id = pv.user_id
      	AND lt.last_touch_at = pv.timestamp
 )
 SELECT  lt_attr.utm_source AS Source,
         lt_attr.utm_campaign AS Campaign,
         COUNT(*) AS 'Last Touches'
 FROM lt_attr
 GROUP BY 1, 2
 ORDER BY 3 DESC;
 /*
 3. Conclusion - show traffic on the different sources
 */
 SELECT utm_source AS 'Source',
    COUNT(DISTINCT user_id) AS '# of Visits'
 FROM page_visits
 GROUP BY 1
 ORDER BY 2 DESC;