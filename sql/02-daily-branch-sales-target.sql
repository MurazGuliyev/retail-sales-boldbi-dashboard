```sql
-- Dashboard: Daily Branch Sales Target
-- Purpose: Calculates daily sales target, today's net sales,
-- customer count and branch-level sales performance.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column, branch and parameter names are anonymized for portfolio use.

SELECT
    T.TargetAmount AS [Daily Sales Target],

    SUM(CASE 
            WHEN S.TransactionDate >= CONVERT(date, GETDATE())
             AND S.TransactionDate <= GETDATE()
             AND S.TransactionType = 0
            THEN S.NetAmount

            WHEN S.TransactionDate >= CONVERT(date, GETDATE())
             AND S.TransactionDate <= GETDATE()
             AND S.TransactionType = 2
            THEN -S.NetAmount

            ELSE 0 
        END) AS [Today Net Sales Up To Now],

    COUNT(CASE 
            WHEN S.TransactionDate >= CONVERT(date, GETDATE())
             AND S.TransactionDate <= GETDATE()
             AND S.TransactionType = 0
            THEN S.TransactionId
        END) AS [Today Customer Count Up To Now],

    CAST(CASE
        WHEN S.BranchCode = '13' THEN '13 - [Branch A]'
        WHEN S.BranchCode = '12' THEN '12 - [Branch B]'
        WHEN S.BranchCode = '19' THEN '19 - [Branch C]'
        WHEN S.BranchCode = '20' THEN '20 - [Branch D]'
        WHEN S.BranchCode = '11' THEN '11 - [Branch E]'
     END AS NVARCHAR(50)) AS BranchName

FROM dbo.SalesTransactions AS S WITH (NOLOCK)

LEFT JOIN dbo.BranchDailyTargets AS T WITH (NOLOCK)
    ON S.BranchCode = T.BranchCode

WHERE S.TransactionType IN (0, 2)
  AND S.TransactionDate >= CONVERT(date, GETDATE())
  AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)
  AND S.DocumentStatus = 0

GROUP BY
    T.TargetAmount,
    CAST(CASE
        WHEN S.BranchCode = '13' THEN '13 - [Branch A]'
        WHEN S.BranchCode = '12' THEN '12 - [Branch B]'
        WHEN S.BranchCode = '19' THEN '19 - [Branch C]'
        WHEN S.BranchCode = '20' THEN '20 - [Branch D]'
        WHEN S.BranchCode = '11' THEN '11 - [Branch E]'
     END AS NVARCHAR(50));
```
