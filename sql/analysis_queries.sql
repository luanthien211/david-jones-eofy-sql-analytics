USE david_jones_eofy_sql_analytics;

-- Business Concern 1: Platform Revenue Performance --
-- Which platform drives the highest total gross sales? --
SELECT PL.Platform_Name, ROUND(SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout), 2) AS Total_Revenue
FROM PLATFORM PL
JOIN ADVERTISEMENT AD ON PL.Platform_ID = AD.Platform_ID
JOIN SHOP_ORDER SO ON AD.Ad_ID = SO.Ad_ID
JOIN ORDER_PRODUCT OP ON SO.Order_ID = OP.Order_ID
GROUP BY PL.Platform_Name
ORDER BY Total_Revenue DESC;

-- Business Concern 2: Return on Ad Spend (ROAS) --
-- Which platform is most cost-effective (revenue / commission cost)? --
SELECT PL.Platform_Name, 
       ROUND(SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout), 2) AS Total_Revenue,
       ROUND(SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout * SO.Order_CommissionRate), 2) AS Total_Cost,
	   ROUND((SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout) / SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout * SO.Order_CommissionRate)), 2) AS Return_On_Ad_Spend
FROM PLATFORM PL
JOIN ADVERTISEMENT AD ON PL.Platform_ID = AD.Platform_ID
JOIN SHOP_ORDER SO ON AD.Ad_ID = SO.Ad_ID
JOIN ORDER_PRODUCT OP ON SO.Order_ID = OP.Order_ID
GROUP BY PL.Platform_Name
ORDER BY Return_On_Ad_Spend DESC;

-- Business Concern 3: Top Performing Ad Campaigns --
-- Which 3 individual ads generated the most revenue? --
SELECT AD.Ad_Name, ROUND(SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout), 2) AS Ad_Revenue
FROM ADVERTISEMENT AD
JOIN SHOP_ORDER SO ON AD.Ad_ID = SO.Ad_ID
JOIN ORDER_PRODUCT OP ON SO.Order_ID = OP.Order_ID
GROUP BY AD.Ad_Name
ORDER BY Ad_Revenue DESC
LIMIT 3;

-- Business Concern 4: Category Popularity by Platform --
-- Which product categories sold the most units on each platform? --
SELECT 
    PL.Platform_Name, 
    P.Product_Category, 
    SUM(OP.Product_Quantity) AS Total_Quantity_Sold
FROM PLATFORM PL
JOIN ADVERTISEMENT AD ON PL.Platform_ID = AD.Platform_ID
JOIN SHOP_ORDER SO ON AD.Ad_ID = SO.Ad_ID
JOIN ORDER_PRODUCT OP ON SO.Order_ID = OP.Order_ID
JOIN PRODUCT P ON OP.Product_SKU = P.Product_SKU
GROUP BY PL.Platform_Name, P.Product_Category
ORDER BY Total_Quantity_Sold DESC;

-- Business Concern 5: Platform Performance by Time Window --
-- Which platforms lead in orders and revenue across four daily time windows? --
SELECT 
    CASE 
        WHEN HOUR(SO.Order_Date) BETWEEN 0 AND 5 THEN '1. Late Night (00-06)'
        WHEN HOUR(SO.Order_Date) BETWEEN 6 AND 11 THEN '2. Morning (06-12)'
        WHEN HOUR(SO.Order_Date) BETWEEN 12 AND 17 THEN '3. Afternoon (12-18)'
        WHEN HOUR(SO.Order_Date) BETWEEN 18 AND 23 THEN '4. Evening (18-00)'
    END AS Time_Window,
    PL.Platform_Name,
    COUNT(DISTINCT SO.Order_ID) AS Total_Orders,
    ROUND(SUM(OP.Product_Quantity * OP.Product_PriceAtCheckout), 2) AS Gross_Revenue
FROM PLATFORM PL
JOIN ADVERTISEMENT AD ON PL.Platform_ID = AD.Platform_ID
JOIN SHOP_ORDER SO ON AD.Ad_ID = SO.Ad_ID
JOIN ORDER_PRODUCT OP ON SO.Order_ID = OP.Order_ID
GROUP BY Time_Window, PL.Platform_Name
ORDER BY Time_Window, Gross_Revenue DESC;

-- Business Concern 6: Ad-Driven Order Rate --
-- What share of all orders is linked to an advertisement? --
SELECT 
    COUNT(SO.Order_ID) AS Total_Orders,
    COUNT(AD.Ad_ID) AS Ad_Driven_Orders,
    ROUND((COUNT(AD.Ad_ID) / COUNT(SO.Order_ID)) * 100, 2) AS Ad_Driven_Order_Rate
FROM SHOP_ORDER SO
LEFT JOIN ADVERTISEMENT AD ON SO.Ad_ID = AD.Ad_ID;
