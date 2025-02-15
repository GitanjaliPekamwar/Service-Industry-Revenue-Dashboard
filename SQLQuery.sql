use serviceBranch_db;

SELECT * FROM services_data;

SELECT * FROM branch_data;


/*1.	Revenue by Region */

SELECT 
    b.Region, 
    s.service_date AS ServiceDate, 
    SUM(s.total_revenue) AS TotalRevenue
FROM dbo.services_data s
JOIN dbo.branch_data b ON s.branch_id = b.branch_id
GROUP BY b.Region, s.service_date

/*REVENUE BY DEPARTMENT*/

SELECT 
    department, 
    SUM(total_revenue) AS TotalRevenue,
    service_date
FROM dbo.services_data
GROUP BY department, service_date;

/*REVENUE BY CUSTOMERS */

SELECT 
    TOP 5 client_name, 
    SUM(total_revenue) AS TotalRevenue,
    service_date
FROM dbo.services_data
GROUP BY client_name, service_date

/*1.	Total Revenue */

SELECT SUM(total_revenue) AS TotalRevenue
FROM services_data;

/*2.	Total Hours */

SELECT SUM(hours) AS TotalHours
FROM services_data;

/* 3.	Revenue by Region over Overall Revenue */

SELECT 
    department, 
    SUM(total_revenue) AS DepartmentRevenue,
    (SUM(total_revenue) / (SELECT SUM(total_revenue) FROM services_data)) * 100 AS RevenuePercentage
FROM 
    services_data
GROUP BY 
    department;

	/*4.	Month on Month Percentage Increase */

WITH MonthlyRevenue AS (
    SELECT 
        FORMAT(service_date, 'yyyy-MM') AS Month,
        SUM(total_revenue) AS Revenue
    FROM 
        services_data
    GROUP BY 
        FORMAT(service_date, 'yyyy-MM')
),
RevenueComparison AS (
    SELECT 
        Month,
        Revenue,
        LAG(Revenue) OVER (ORDER BY Month) AS PreviousMonthRevenue
    FROM 
        MonthlyRevenue)
SELECT 
    Month,
    Revenue,
    PreviousMonthRevenue,
    CASE WHEN PreviousMonthRevenue > 0 THEN
((Revenue - PreviousMonthRevenue) / PreviousMonthRevenue) * 100 ELSE NULL END AS RevenuePercentageIncrease
FROM 
    RevenueComparison
WHERE 
    PreviousMonthRevenue IS NOT NULL;









