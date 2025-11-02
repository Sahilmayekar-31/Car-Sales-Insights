-- Top customer with most spen
SELECT Customer_Name, SUM(Price) AS Total_Spent
FROM car_sales
GROUP BY Customer_Name
ORDER BY Total_Spent DESC
LIMIT 5;

-- monthly cars sold revenue
SELECT 
    DATE_FORMAT(STR_TO_DATE(Date, '%d-%m-%Y'), '%Y-%m') AS Month,
    COUNT(Car_id) AS Cars_Sold,
    SUM(Price) AS Revenue
FROM car_sales
GROUP BY Month
ORDER BY Month;

-- company Avg price
SELECT Company, ROUND(AVG(Price), 2) AS Avg_Price
FROM car_sales
GROUP BY Company
ORDER BY Avg_Price DESC;

-- Top 5 ranked region as per total sales
with Ranked_dealers as(
SELECT 
    Dealer_Name,
    Dealer_Region,
    SUM(Price) AS Total_Sales,
    RANK() OVER (PARTITION BY Dealer_Region ORDER BY sum(Price) DESC) AS Region_Rank
FROM car_sales
GROUP BY Dealer_Name, Dealer_Region)
select * from ranked_dealers
where region_Rank <=5;

 -- the most sold car model for each company
WITH Model_Counts AS (
    SELECT Company, Model, COUNT(*) AS Model_Sales
    FROM car_sales
    GROUP BY Company, Model
)
SELECT *
FROM Model_Counts mc
WHERE Model_Sales = (
    SELECT MAX(Model_Sales)
    FROM Model_Counts
    WHERE Company = mc.Company
);
 
 -- avg price as per gender buyers
SELECT Gender, COUNT(*) AS Cars_Bought, ROUND(AVG(Price), 2) AS Avg_Price
FROM car_sales
GROUP BY Gender;

-- car buyers as per income groups
SELECT 
    CASE 
        WHEN Annual_Income >= 1000000 THEN 'High Income'
        WHEN Annual_Income >= 500000 THEN 'Mid Income'
        ELSE 'Low Income'
    END AS Income_Group,
    COUNT(*) AS Cars_Bought,
    ROUND(AVG(Price), 2) AS Avg_Car_Price
FROM car_sales
GROUP BY Income_Group;

-- unique models sold by dealer 

SELECT 
    Dealer_Name,
    COUNT(Car_id) AS Cars_Sold,
    SUM(Price) AS Total_Revenue,
    ROUND(AVG(Price), 2) AS Avg_Price,
    COUNT(DISTINCT Model) AS Unique_Models_Sold
FROM car_sales
GROUP BY Dealer_Name
ORDER BY Total_Revenue DESC;

 -- top company with most total sales
SELECT company, COUNT(*) AS total_sales
FROM car_sales
GROUP BY company
HAVING COUNT(*) = (
  SELECT MAX(brand_count)
  FROM (
    SELECT company, COUNT(*) AS brand_count
    FROM car_sales
    GROUP BY company
  ) AS sub
);
