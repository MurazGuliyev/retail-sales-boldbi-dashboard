-- Dashboard: Cashier Sales and Return Analysis
-- Purpose: Compares today's sales and return amounts by cashier.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column and parameter names are anonymized for portfolio use.

SELECT
    S.CashierCode AS [Cashier],

    CASE S.TransactionType
        WHEN 0 THEN N'Sales'
        WHEN 2 THEN N'Return'
    END AS [Transaction Type],

    SUM(S.NetAmount) AS [Total Amount]

FROM dbo.SalesTransactions AS S WITH (NOLOCK)

WHERE S.DocumentStatus = 0
  AND S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))

  -- Optional branch filter for dashboard parameter
  -- AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    S.CashierCode,
    S.TransactionType;