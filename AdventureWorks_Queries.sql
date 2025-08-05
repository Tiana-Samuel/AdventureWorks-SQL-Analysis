-- SQL Project -- Provide insights and data to help a marketing team implement a Customer Loyalty program.
----------------------------------------------------------------------------------------------------------------
----------------------------------------------------------------------------------------------------------------
-- QUESTION 1
-- Provide the top 10 customers (full name) by revenue, the country they shipped to, the cities and
-- their revenue (orderqty * unitprice).
-- This insight will help you understand where your top spending customers are coming from. You can
-- market better, get more capable customer service rep, have more stock and build partnerships in these
-- countries and cities.


SELECT TOP 10 
       CONCAT(C.FirstName,' ', C.MiddleName,' ', C.LastName) AS FullName,
       SUM(SOD.OrderQty * SOD.UnitPrice) AS Revenue,
       A.CountryRegion AS Country,
       A.City
FROM SalesLT.Customer C
JOIN SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
JOIN SalesLT.CustomerAddress CA ON C.CustomerID = CA.CustomerID
JOIN SalesLT.[Address] A ON CA.AddressID = A.AddressID
JOIN SalesLT.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY C.FirstName, C.MiddleName, C.LastName, A.CountryRegion, A.City
ORDER BY Revenue DESC



-----------------------------------------------------------------------------------------------------------------
-- Question 2
-- Create 4 distinct Customer segments using the total Revenue (orderqty * unitprice) by customer.
-- List the customer details (ID, Company Name), Revenue and the segment the customer belongs to.
-- This analysis can be used to create a loyalty program, market customers with discount or leave customers as-is.


SELECT 
       C.CustomerID AS 'Customer ID',
       C.CompanyName AS 'Company Name',
	   SUM(SOD.OrderQty * SOD.UnitPrice) AS 'Total Revenue',
CASE
       WHEN SUM(SOD.OrderQty * SOD.UnitPrice) >= 70000 THEN 'High Patronage'
	   WHEN SUM(SOD.OrderQty * SOD.UnitPrice) >= 50000 THEN 'Medium Patronage'
	   WHEN SUM(SOD.OrderQty * SOD.UnitPrice) >= 30000 THEN 'Low Patronage'
	   WHEN SUM(SOD.OrderQty * SOD.UnitPrice) < 10000 THEN 'Very Low Patronage'
	   ELSE 'Very Low Revenue'
END AS 'Customer Segment'
FROM SalesLT.Customer C
JOIN SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
JOIN SalesLT.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY C.CustomerID, C.CompanyName
ORDER BY 'Total Revenue'



---------------------------------------------------------------------------------------------------------------------
-- Question 3
-- What products with their respective categories did our customers buy on our last day of business?
-- List the CustomerID,Product ID, Product Name, Category Name and Order Date.
-- This insight will help understand the latest products and categories that your customers bought from. This will help
-- you do near-real-time marketing and stockpiling for these products.



SELECT 
     SOH.CustomerID AS 'Customer ID',
	 P.ProductID AS 'Product ID',
     P.[Name] AS 'Product Name',
	 PC.Name AS 'Category Name',
	 SOH.OrderDate AS 'Order Date'
FROM SalesLT.SalesOrderHeader SOH
JOIN SalesLT.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
JOIN SalesLT.[Product] P ON SOD.ProductID = P.ProductID
JOIN SalesLT.ProductCategory PC ON P.ProductCategoryID = PC.ProductCategoryID
WHERE SOH.OrderDate = (SELECT MAX(OrderDate) FROM SalesLT.SalesOrderHeader)



---------------------------------------------------------------------------------------------------------------------
-- Question 4
-- Create a view called customer segment that stores the details (id, name, revenue) for customers and their segment
-- i.e build a view for question 2.
-- You can connect this view to Tableau and get insights without needing to write the same query every time.


CREATE VIEW CustomerSegment AS
SELECT 
       C.CustomerID AS 'Customer ID',
       C.CompanyName AS 'Company Name',
	   SUM(SOD.OrderQty * SOD.UnitPrice) AS 'Total Revenue',
CASE
       WHEN SUM(SOD.OrderQty * SOD.UnitPrice) >= 70000 THEN 'High Patronage'
	   WHEN SUM(SOD.OrderQty * SOD.UnitPrice) >= 50000 THEN 'Medium Patronage'
	   WHEN SUM(SOD.OrderQty * SOD.UnitPrice) >= 30000 THEN 'Low Patronage'
	   WHEN SUM(SOD.OrderQty * SOD.UnitPrice) < 10000 THEN 'Very Low Patronage'
	   ELSE 'Very Low Revenue'
            END AS 'Customer Segment'
FROM SalesLT.Customer C
JOIN SalesLT.SalesOrderHeader SOH ON C.CustomerID = SOH.CustomerID
JOIN SalesLT.SalesOrderDetail SOD ON SOH.SalesOrderID = SOD.SalesOrderID
GROUP BY C.CustomerID, C.CompanyName
--ORDER BY 'Total Revenue'



---------------------------------------------------------------------------------------------------------------------
-- Question 5
-- What are the top 3 selling product (include productname) in each category (include categoryname) by revenue? 
-- Tip: Use ranknum
-- This analysis will ensure you can keep track of your top selling products in each category. The output is very 
-- powerful because you don't have to write multiple queries to be able to see your top selling products in each category.
-- This analysis will inform your marketing, your supply chain, your partnerships, position of products on your website, etc.
-- NB: This question is asked a lot in interviews!


WITH [PRODUCT REVENUE] AS (
SELECT
         P.Name AS [Product Name],
         PC.Name AS [Category Name],
         SUM (SOD.OrderQty * SOD.UnitPrice) AS Revenue,
		 ROW_NUMBER() OVER 
		 (PARTITION BY PC.Name 
		 ORDER BY SUM (SOD.OrderQty * SOD.UnitPrice) DESC) 
		 AS RankNum
    FROM SalesLT.SalesOrderDetail SOD
    JOIN SalesLT.Product P ON SOD.ProductID = P.ProductID
    JOIN SalesLT.ProductCategory PC ON P.ProductCategoryID = PC.ProductCategoryID
	GROUP BY P.Name, PC.Name
)
SELECT
    [Product Name],
	[Category Name],
	Revenue,
	RankNum
FROM
    [PRODUCT REVENUE]
WHERE 
    RankNum <= 3
ORDER BY
    [Category Name], Revenue DESC