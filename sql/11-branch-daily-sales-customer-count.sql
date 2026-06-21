```sql
-- Dashboard: Branch Daily Sales and Customer Count
-- Purpose: Calculates today's net sales and customer count for a selected branch.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column, branch and parameter names are anonymized for portfolio use.

SELECT
    SUM(CASE 
            WHEN S.TransactionType = 0 THEN S.NetAmount
            WHEN S.TransactionType = 2 THEN -S.NetAmount
            ELSE 0 
        END) AS [Net Sales],

    S.TransactionDate AS [Transaction Date],

    COUNT(CASE 
            WHEN S.TransactionType = 0 THEN S.TransactionId
        END) AS [Customer Count],

    CASE
        WHEN S.BranchCode = 101 THEN '101 - [Branch E]'
    END AS [Branch Name]

FROM dbo.SalesTransactions AS S WITH (NOLOCK)

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0
  AND S.TransactionType IN (0, 2)
  AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY 
    S.TransactionDate,
    CASE
        WHEN S.BranchCode = 101 THEN '101 - [Branch E]'
    END;
```
