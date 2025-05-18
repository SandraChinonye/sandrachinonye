--Adidas Sales Analysis

--1. Create Database AdidasSales
CREATE DATABASE AdidasSales 

--2. Import the csv file and view the table
SELECT *
FROM AdidasSalesData

--3. Data duplication
--Create new table
SELECT *
INTO Adidas_Sales_Data
FROM AdidasSalesData
WHERE 1 = 0

--Insert data into new table
INSERT INTO Adidas_Sales_Data
SELECT *
FROM AdidasSalesData

--View new table
SELECT *
FROM Adidas_Sales_Data

--4. Checking for duplicates
SELECT 
      Retailer, Retailer_ID, Invoice_Date, Region, State, City, Product, Price_per_Unit,
	  Units_Sold, Total_Sales, Operating_Profit, Operating_Margin, Sales_Method,
	  COUNT(*) AS duplicate_count
FROM
     Adidas_Sales_Data
GROUP BY
      Retailer, Retailer_ID, Invoice_Date, Region, State, City, Product, Price_per_Unit,
	  Units_Sold, Total_Sales, Operating_Profit, Operating_Margin, Sales_Method
HAVING
      COUNT(*) > 1
--No duplicates found

--5. Standardizing Data
--Change data type for Price per Unit column from INT to DECIMAL(10,2)
ALTER TABLE 
           Adidas_Sales_Data
ALTER COLUMN
           [Price_per_Unit] DECIMAL(10,2) NOT NULL

--Change data type for Total Sales column from INT to DECIMAL(10,2)
ALTER TABLE
           Adidas_Sales_Data
ALTER COLUMN
           [Total_Sales] DECIMAL(10,2) NOT NULL

--Change data type for Operating Profit column from INT to DECIMAL(10,2)
ALTER TABLE
           Adidas_Sales_Data
ALTER COLUMN
           [Operating_Profit] DECIMAL(10,2) NOT NULL

--Update Operating Margin column
UPDATE Adidas_Sales_Data
SET Operating_Margin = Operating_Margin / 100;


--KPIs
--6. Total Revenue
SELECT SUM(Total_Sales) AS Total_Revenue
FROM Adidas_Sales_Data

--7. Net Profit
SELECT SUM(Operating_Profit) AS Net_Profit
FROM Adidas_Sales_Data

--8. Total Orders
SELECT COUNT(*) AS Total_Orders
FROM Adidas_Sales_Data

--9. Total Units Sold
SELECT SUM(Units_Sold) AS Total_Units_Sold
FROM Adidas_Sales_Data

--10. Average Order Value
SELECT CAST((SUM(Total_Sales) / COUNT(*)) AS DECIMAL(10,2)) AS Avg_Order_Value
FROM Adidas_Sales_Data

--11. Profit Margin %
SELECT CAST((SUM(Operating_Profit) / SUM(Total_Sales) * 100) AS DECIMAL(10,2)) AS Profit_Margin
FROM Adidas_Sales_Data


--Product Performance Analysis
--12. Total Revenue and Net Profit by Products
SELECT
      Product,
	  SUM(Total_Sales) AS Total_Revenue,
	  SUM(Operating_Profit) AS Net_Profit
FROM Adidas_Sales_Data
GROUP BY Product
ORDER BY Net_Profit DESC

--13. Total Units Sold by Month and Product
SELECT
      FORMAT(Invoice_Date, 'MMM') AS Month,
	  Product,
	  SUM(Units_Sold) AS Total_Units_Sold
FROM Adidas_Sales_Data
GROUP BY
      Product,
	  FORMAT(Invoice_Date, 'MMM')
ORDER BY
       FORMAT(Invoice_Date, 'MMM'),
	   Product

--14. Sales Contribution % by Product
SELECT
     Product,
	 (SUM(Total_Sales) * 100.0 / (SELECT SUM(Total_Sales) FROM Adidas_Sales_Data)) AS Sales_Pecentage
FROM Adidas_Sales_Data
GROUP BY Product
ORDER BY SUM(Total_Sales) * 100.0 / (SELECT SUM(Total_Sales) FROM Adidas_Sales_Data) DESC

--15. Profit Margin % by Product
SELECT
     Product,
	 ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100, 2) AS Profit_Margin
FROM Adidas_Sales_Data
GROUP BY Product
ORDER BY Profit_Margin DESC

--Regional/Market Analysis
--16. Total Revenue and Net Profit by Region
SELECT
     Region,
	 SUM(Total_Sales) AS Total_Revenue,
	 SUM(Operating_Profit) As Profit
FROM Adidas_Sales_Data
GROUP BY Region
ORDER BY Profit DESC

--17. Average Order Size by Region
SELECT Region, 
       AVG(Total_Sales) AS Avg_Order_Size
FROM Adidas_Sales_Data
GROUP BY Region
ORDER BY Avg_Order_Size DESC;

--18. Total Revenue, Net Profit and Profit Margin by State
SELECT State,
       SUM(Total_Sales) AS Total_Revenue,
	   SUM(Operating_Profit) AS Net_Profit,
	   ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100, 2) AS Profit_Margin
FROM Adidas_Sales_Data
GROUP BY State
ORDER BY Profit_Margin DESC

--19. Avg Price per Unit by Region
SELECT Region,
	   AVG(Price_per_Unit) AS Avg_Price_per_unit
FROM Adidas_Sales_Data
GROUP BY Region
ORDER BY Avg_Price_per_unit

--Retailers, Channels, and Time Series
--20. Total Revenue and Net Profit by Retailer
SELECT
     Retailer,
	 SUM(Total_Sales) AS Revenue,
	 SUM(Operating_Profit) AS Net_Profit
FROM Adidas_Sales_Data
GROUP BY Retailer
ORDER BY Net_Profit DESC

--21. Total Orders per Retailer
SELECT Retailer,
       COUNT(*) AS Total_Orders
FROM Adidas_Sales_Data
GROUP BY Retailer
ORDER BY Total_Orders DESC

--22. Average Order Size by Retailer
SELECT Retailer,
       Avg(Total_Sales) AS Avg_Order_Size
FROM Adidas_Sales_Data
GROUP BY Retailer
ORDER BY Avg_Order_Size DESC

--23. Sales Method Performance
SELECT Sales_Method,
	   SUM(Operating_Profit) As Net_Profit,
	   ROUND(SUM(Operating_Profit) / SUM(Total_Sales) * 100, 2) AS Profit_Margin
FROM Adidas_Sales_Data
GROUP BY Sales_Method
ORDER BY Net_Profit

--24. Net Profit by Month
SELECT FORMAT(Invoice_Date, 'MMM') AS Month,
	   SUM(Operating_Profit) AS Net_Profit
FROM Adidas_Sales_Data
GROUP BY FORMAT(Invoice_Date, 'MMM')
ORDER BY FORMAT(Invoice_Date, 'MMM'),
         Net_Profit
