-- Dashboard: Category and Department Net Sales Analysis
-- Purpose: Calculates today's net sales by product category and department.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column and parameter names are anonymized for portfolio use.

SELECT
    C.CategoryCode AS [Category Code],

    CASE
        WHEN C.CategoryName IS NULL THEN 'Not Assigned'
        ELSE C.CategoryName
    END AS [Category Name],

    D.DepartmentCode AS [Department Code],

    CASE 
        WHEN D.DepartmentName IS NULL THEN 'Not Assigned'
        ELSE D.DepartmentName
    END AS [Department Name],

    SUM(CASE 
        WHEN S.TransactionType = 0
        THEN SL.LineNetAmount

        WHEN S.TransactionType = 2
        THEN -SL.LineNetAmount

        ELSE 0 
    END) AS [Net Sales]

FROM dbo.SalesTransactions AS S WITH (NOLOCK)

LEFT JOIN dbo.SalesTransactionLines AS SL WITH (NOLOCK)
    ON S.TransactionId = SL.TransactionId
   AND SL.LineType <> 1
   AND SL.LineNumber <> 0

LEFT JOIN dbo.Products AS P WITH (NOLOCK)
    ON SL.ProductId = P.ProductId

LEFT JOIN dbo.ProductCategories AS C WITH (NOLOCK)
    ON C.CategoryCode = P.CategoryGroupCode

LEFT JOIN dbo.ProductMarketInfo AS PM WITH (NOLOCK)
    ON PM.ProductId = P.ProductId

LEFT JOIN dbo.Departments AS D WITH (NOLOCK)
    ON PM.DepartmentCode = D.DepartmentCode
   AND D.CodeType = 11

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0

  -- Optional branch filter for dashboard parameter
  -- AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    C.CategoryCode,

    CASE
        WHEN C.CategoryName IS NULL THEN 'Not Assigned'
        ELSE C.CategoryName
    END,

    D.DepartmentCode,

    CASE 
        WHEN D.DepartmentName IS NULL THEN 'Not Assigned'
        ELSE D.DepartmentName
    END;