-- Dashboard: Daily Net Sales
-- Purpose: Calculates today's net sales amount by transaction date/time.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column and parameter names are anonymized for portfolio use.

SELECT
    S.TransactionDate AS [Transaction Date],

    SUM(CASE 
        WHEN S.TransactionType = 0
        THEN S.NetAmount

        WHEN S.TransactionType = 2
        THEN -S.NetAmount

        ELSE 0 
    END) AS [Net Sales]

FROM dbo.SalesTransactions AS S WITH (NOLOCK)

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0
  AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    S.TransactionDate;