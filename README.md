# AdventureWorks SQL Project
This project explores customer and product data from the AdventureWorks dataset using structured SQL queries. The analysis is designed to support marketing and sales strategy using insights generated from customer purchase behavior and product sales.

## 📊 SQL Tasks & Queries
### 🔹 Query 1: Top 10 Customers by Revenue
- Retrieves top 10 customers based on revenue (`OrderQty * UnitPrice`)
- Includes customer full name, city, and country.
### 🔹 Query 2: Customer Segmentation
- Segments customers into 4 groups based on total revenue.
- Shows Customer ID, Company Name, Revenue, and Segment.
### 🔹 Query 3: Products Bought on Last Day of Business
- Lists products purchased on the most recent order date.
- Shows Customer ID, Product Name, Category, and Order Date.
### 🔹 Query 4: Customer Segment View
- Creates a reusable view called `CustomerSegment` for segmentation.
- Simplifies dashboard or analytics integration.
### 🔹 Query 5: Top 3 Selling Products in Each Category
- Uses `ROW_NUMBER()` to identify top 3 products by revenue in each product category.
- Shows Product Name, Category, Revenue, and Ranking.

## 🧰 Tools Used
- SQL Server Management Studio (SSMS)
- AdventureWorks Sample Database

## 📁 Tables Referenced
- `Address`
- `Customer`
- `CustomerAddress`
- `Product`
- `ProductCategory`
- `ProductDescription`
- `ProductModel`
- `ProductModelProductDescription`
- `SalesOrderDetail`
- `SalesOrderHeader`
