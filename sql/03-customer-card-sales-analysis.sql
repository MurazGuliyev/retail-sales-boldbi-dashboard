-- Dashboard: Customer Card Sales Analysis
-- Purpose: Compares net sales amount between customers with loyalty card
-- and customers without loyalty card.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column and parameter names are anonymized for portfolio use.

SELECT
    CASE
        WHEN NULLIF(LTRIM(RTRIM(S.CustomerCardNo)), '') IS NULL
            THEN N'Without Customer Card'
        ELSE N'With Customer Card'
    END AS [Customer Type],

    SUM(CASE 
        WHEN S.TransactionType = 0
        THEN S.NetAmount

        WHEN S.TransactionType = 2
        THEN -S.NetAmount

        ELSE 0 
    END) AS [Net Sales]

FROM dbo.SalesTransactions AS S

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0

  -- Optional branch filter for dashboard parameter
  -- AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    CASE
        WHEN NULLIF(LTRIM(RTRIM(S.CustomerCardNo)), '') IS NULL
            THEN N'Without Customer Card'
        ELSE N'With Customer Card'
    END;