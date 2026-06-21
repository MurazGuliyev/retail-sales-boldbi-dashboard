-- Dashboard: Branch Net Sales Trend
-- Purpose: Calculates net sales trend by date and branch from a selected start date.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column, branch and parameter names are anonymized for portfolio use.

WITH BranchDailySales AS (
    SELECT
        SUM(CASE 
                WHEN S.TransactionType = 0
                THEN S.NetAmount

                WHEN S.TransactionType = 2
                THEN -S.NetAmount

                ELSE 0 
            END) AS NetSales,

        CONVERT(date, S.TransactionDate) AS SaleDate,

        S.BranchCode

    FROM dbo.SalesTransactions AS S WITH (NOLOCK)

    WHERE S.TransactionDate >= CONVERT(date, '2024-01-01')
      AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
      AND S.DocumentStatus = 0

       AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

    GROUP BY
        CONVERT(date, S.TransactionDate),
        S.BranchCode
)

SELECT
    NetSales AS [Net Sales],

    SaleDate AS [Date],

    CONCAT('Branch ', DENSE_RANK() OVER (ORDER BY BranchCode)) AS [Branch Name]

FROM BranchDailySales;