SELECT * FROM transactions_cleaned LIMIT 5;
SELECT * FROM customer_rfm LIMIT 5;

-- Q1.Revenue by country
SELECT
    country,
    SUM(quantity * unitprice) AS revenue,
    COUNT(DISTINCT invoiceno) AS orders,
    COUNT(DISTINCT customerid) AS customers
FROM transactions_cleaned
GROUP BY country
ORDER BY revenue DESC;

-- Prediction : United Kingdom dominates: revenue ~ 7.3M, 16,646 orders, 3,920 customers
-- → The business is heavily UK-centric.
--
-- International markets exist but are much smaller: Netherlands (~285k), EIRE (~265k), Germany (~228k), France (~209k).
-- → Growth opportunity: focus on top non-UK markets.

--Q2.Monthly revenue trend

SELECT
    strftime('%m', invoicedate) AS month,
    SUM(quantity * unitprice) AS revenue,
    COUNT(DISTINCT invoiceno) AS orders
FROM transactions_cleaned
GROUP BY month
ORDER BY revenue desc;


--Prediction: Demand is seasonal, revenue grows through the year and peaks in Oct–Dec.
-- Top months: November (~1.16M) is highest, December (~1.09M) also very high

--Q3.Top customers by monetary value

SELECT
    customerid,
    SUM(quantity * unitprice) AS revenue,
    COUNT(DISTINCT invoiceno) AS orders,
    AVG(quantity * unitprice) AS avg_order_value
FROM transactions_cleaned
GROUP BY customerid
ORDER BY revenue DESC
LIMIT 20;

--Prediction:Your top customers contribute huge revenue compared to the typical customer.
--Example: Custid 14646 ≈ 280k revenue (73 orders), Custid 18102 ≈ 260k revenue (60 orders)
--Business implication: losing a few high-value customers can noticeably reduce total revenue.

--Q4.Repeat purchase proxy

SELECT
    CASE WHEN order_count >= 2 THEN 'repeat' ELSE 'one_time' END AS customer_type,
    COUNT(*) AS customers
FROM (
         SELECT customerid, COUNT(DISTINCT invoiceno) AS order_count
         FROM transactions_cleaned
         GROUP BY customerid
     )
GROUP BY customer_type;

--Prediction: About 1 in 3 customers buy only once, which is a retention opportunity.

-- Q5.Top products by revenue

SELECT
    stockcode,
    description,
    SUM(quantity * unitprice) AS revenue,
    SUM(quantity) AS units_sold
FROM transactions_cleaned
GROUP BY stockcode, description
ORDER BY revenue DESC
LIMIT 20;

--Prediction: Top product “PAPER CRAFT, LITTLE BIRDIE” alone generated ~168k revenue and sold ~80,995 units.
-- This suggests revenue is concentrated in “hero” items.
--Recommendation:Protect availability (avoid stockouts), feature these items in campaigns, create bundles around them

--Q6.Average order value by country

SELECT
    country,
    AVG(order_total) AS avg_order_value
FROM (
         SELECT invoiceno, country, SUM(quantity * unitprice) AS order_total
         FROM transactions_cleaned
         GROUP BY invoiceno, country
     )
GROUP BY country
ORDER BY avg_order_value DESC;

-- Prediction:International orders are higher-ticket than UK , UK AOV ≈ 439
-- Many non-UK countries have much higher AOV (e.g., Singapore ≈ 3039, Netherlands ≈ 3036, Australia ≈ 2430).
-- UK has the highest total revenue because it has many more orders/customers, but UK orders are smaller on average (low AOV).
-- Non-UK countries have fewer orders, but each order is typically larger (high AOV).

--Q7.Segment distribution from RFM table

SELECT
    segment,
    COUNT(*) AS customers,
    AVG(recency) AS avg_recency,
    AVG(frequency) AS avg_frequency,
    AVG(monetary) AS avg_monetary
FROM customer_rfm
GROUP BY segment
ORDER BY customers DESC;

--Prediction: Most customers are not loyal yet → retention is the main growth lever.
-- Many customers buy once and disappear — win-back needed.
-- Protect Champions with VIP benefits because losing them hurts revenue disproportionately.


