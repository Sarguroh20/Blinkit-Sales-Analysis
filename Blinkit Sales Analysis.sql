SELECT * FROM blinkitdb;

SELECT COUNT(*) FROM blinkit_data;

-- DATA CLEANING

SELECT DISTINCT(Item_Fat_Content) FROM blinkit_data;

UPDATE blinkit_data
SET Item_Fat_Content = 
CASE
WHEN Item_Fat_Content = 'reg' THEN 'Regular'
WHEN Item_Fat_Content IN ('low fat', 'LF') THEN 'Low Fat'
ELSE Item_Fat_Content
END

-- KPIs

-- 1) Total Sales

SELECT CONCAT(CAST(SUM(Total_Sales) / 1000000 AS decimal(10, 2)), ' millions') AS Total_Sales_Millions
FROM blinkit_data;

-- 2) Average Sales

SELECT CAST(AVG(Total_Sales) AS decimal(10, 0)) AS Avg_Sales FROM blinkit_data;

-- 3) Number of items

SELECT COUNT(*) AS No_of_items FROM blinkit_data;

-- 4) Average Rating

SELECT CAST(AVG(Rating) AS decimal(10, 2)) AS Avg_Rating FROM blinkit_data;

-- Total Sales by Fat Content

SELECT Item_Fat_Content, 
		CAST(SUM(Total_Sales) / 1000 AS decimal(10, 2)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS decimal(10, 0)) AS Avg_Sales,
		COUNT(*) AS No_of_items,
		CAST(AVG(Rating) AS decimal(10, 2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Item_Fat_Content
ORDER BY Total_Sales_Thousands DESC;

-- Total Sales by Item Type

SELECT TOP 5 Item_Type, 
		CAST(SUM(Total_Sales) / 1000 AS decimal(10, 2)) AS Total_Sales_Thousands,
		CAST(AVG(Total_Sales) AS decimal(10, 0)) AS Avg_Sales,
		COUNT(*) AS No_of_items,
		CAST(AVG(Rating) AS decimal(10, 2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Item_Type
ORDER BY Total_Sales_Thousands DESC;

-- Fat Content by Outlet for Total Sales

SELECT Outlet_Location_Type,
		ISNULL([Low Fat], 0) AS Low_Fat,
		ISNULL([Regular], 0) AS Regular
FROM 
(
	SELECT Outlet_Location_Type, Item_Fat_Content,
		CAST(SUM(Total_Sales) AS decimal(10, 2)) AS Total_Sales
	FROM blinkit_data
	GROUP BY Outlet_Location_Type, Item_Fat_Content
) AS SourceTable
PIVOT
(
	SUM(Total_Sales)
	FOR Item_Fat_Content IN ([Low Fat], [Regular])
) AS PivotTable
ORDER BY Outlet_Location_Type;

-- Total Sales by Outlet Establishment

SELECT Outlet_Establishment_Year,
	CAST(SUM(Total_Sales) AS decimal(10, 2)) AS Total_Sales,		
	CAST(AVG(Total_Sales) AS decimal(10, 0)) AS Avg_Sales,
	COUNT(*) AS No_of_items,
	CAST(AVG(Rating) AS decimal(10, 2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Establishment_Year
ORDER BY Total_Sales DESC;

-- Percentage of Sales by Outlet Size

SELECT 
	Outlet_Size,
	CAST(SUM(Total_Sales) AS decimal(10, 2)) AS Total_Sales,
	CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage
FROM blinkit_data
GROUP BY Outlet_Size
ORDER BY Total_Sales DESC;

-- Sales by Outlet Location

SELECT Outlet_Location_Type,
	CAST(SUM(Total_Sales) AS decimal(10, 2)) AS Total_Sales,
	CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage,
	CAST(AVG(Total_Sales) AS decimal(10, 0)) AS Avg_Sales,
	COUNT(*) AS No_of_items,
	CAST(AVG(Rating) AS decimal(10, 2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Location_Type
ORDER BY Total_Sales DESC;

-- All Metrics by Outlet Type

SELECT Outlet_Type,
	CAST(SUM(Total_Sales) AS decimal(10, 2)) AS Total_Sales,
	CAST((SUM(Total_Sales) * 100.0 / SUM(SUM(Total_Sales)) OVER()) AS DECIMAL(10, 2)) AS Sales_Percentage,
	CAST(AVG(Total_Sales) AS decimal(10, 0)) AS Avg_Sales,
	COUNT(*) AS No_of_items,
	CAST(AVG(Rating) AS decimal(10, 2)) AS Avg_Rating
FROM blinkit_data
GROUP BY Outlet_Type
ORDER BY Total_Sales DESC;