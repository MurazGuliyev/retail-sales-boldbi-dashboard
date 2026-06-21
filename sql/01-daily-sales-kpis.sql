```sql
-- Dashboard: Daily Sales KPI
-- Purpose: Calculates today's sales, yesterday's sales, net sales, returns,
-- customer count and average basket amount up to the current time.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column and parameter names are anonymized for portfolio use.

SELECT
    SUM(CASE 
        WHEN S.TransactionDate >= CONVERT(date, GETDATE())
         AND S.TransactionDate <= GETDATE()
         AND S.TransactionType = 0
        THEN S.NetAmount
        ELSE 0 
    END) AS [Today Sales Up To Now],

    SUM(CASE 
        WHEN S.TransactionDate >= DATEADD(day, -1, CONVERT(date, GETDATE()))
         AND S.TransactionDate <= DATEADD(day, -1, GETDATE())
         AND S.TransactionType = 0
        THEN S.NetAmount
        ELSE 0 
    END) AS [Yesterday Sales Up To Same Time],

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

    SUM(CASE 
        WHEN S.TransactionDate >= DATEADD(day, -1, CONVERT(date, GETDATE()))
         AND S.TransactionDate <= DATEADD(day, -1, GETDATE())
         AND S.TransactionType = 0
        THEN S.NetAmount

        WHEN S.TransactionDate >= DATEADD(day, -1, CONVERT(date, GETDATE()))
         AND S.TransactionDate <= DATEADD(day, -1, GETDATE())
         AND S.TransactionType = 2
        THEN -S.NetAmount

        ELSE 0 
    END) AS [Yesterday Net Sales Up To Same Time],

    SUM(CASE 
        WHEN S.TransactionDate >= CONVERT(date, GETDATE())
         AND S.TransactionDate <= GETDATE()
         AND S.TransactionType = 2
        THEN S.NetAmount
        ELSE 0 
    END) AS [Today Returns Up To Now],

    SUM(CASE 
        WHEN S.TransactionDate >= DATEADD(day, -1, CONVERT(date, GETDATE()))
         AND S.TransactionDate <= DATEADD(day, -1, GETDATE())
         AND S.TransactionType = 2
        THEN S.NetAmount
        ELSE 0 
    END) AS [Yesterday Returns Up To Same Time],

    COUNT(CASE 
        WHEN S.TransactionDate >= CONVERT(date, GETDATE())
         AND S.TransactionDate < GETDATE()
         AND S.TransactionType = 0
        THEN S.TransactionId
    END) AS [Today Customer Count Up To Now],

    COUNT(CASE 
        WHEN S.TransactionDate >= DATEADD(day, -1, CONVERT(date, GETDATE()))
         AND S.TransactionDate < DATEADD(day, -1, GETDATE())
         AND S.TransactionType = 0
        THEN S.TransactionId
    END) AS [Yesterday Customer Count Up To Same Time],

    AVG(CASE 
        WHEN S.TransactionDate >= CONVERT(date, GETDATE())
         AND S.TransactionDate < GETDATE()
         AND S.TransactionType = 0
        THEN S.NetAmount
    END) AS [Today Average Basket Amount],

    AVG(CASE 
        WHEN S.TransactionDate >= DATEADD(day, -1, CONVERT(date, GETDATE()))
         AND S.TransactionDate < DATEADD(day, -1, GETDATE())
         AND S.TransactionType = 0
        THEN S.NetAmount
    END) AS [Yesterday Average Basket Amount]

FROM dbo.SalesTransactions AS S WITH (NOLOCK)
WHERE S.TransactionType IN (0, 2)
  AND S.TransactionDate >= DATEADD(day, -2, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0
  AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList);
```
