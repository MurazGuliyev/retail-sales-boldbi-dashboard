```sql
-- Dashboard: Branch Sales and Return Operation Analysis
-- Purpose: Calculates today's total amount and customer count by branch and transaction type.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column, branch and parameter names are anonymized for portfolio use.

SELECT
    SUM(S.NetAmount) AS [Total Amount],

    COUNT(CASE 
            WHEN S.TransactionType = 0
            THEN S.TransactionId
        END) AS [Customer Count],

    CASE
        WHEN S.BranchCode = 101 THEN '101 - [Branch E]'
    END AS [Branch Name],

    CASE S.TransactionType
        WHEN 2 THEN 'Return'
        WHEN 0 THEN 'Sales'
    END AS [Transaction Type]

FROM dbo.SalesTransactions AS S WITH (NOLOCK)

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0
  AND S.TransactionType IN (0, 2)

   AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    CASE
        WHEN S.BranchCode = 101 THEN '101 - [Branch E]'
    END,

    CASE S.TransactionType
        WHEN 2 THEN 'Return'
        WHEN 0 THEN 'Sales'
    END;
```
