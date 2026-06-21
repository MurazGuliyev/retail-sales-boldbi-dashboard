```sql
-- Dashboard: Payment Type Net Sales Analysis
-- Purpose: Calculates today's net sales amount by payment type.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column and parameter names are anonymized for portfolio use.

SELECT   
    CASE P.PaymentType 
        WHEN 0 THEN 'Cash'
        WHEN 1 THEN 'Bank/Card'
        WHEN 4 THEN 'Bonus'
    END AS [Payment Type],

    SUM(CASE 
        WHEN S.TransactionType = 0 AND P.PaymentDirection = 1
        THEN P.PaymentAmount

        WHEN S.TransactionType = 2 AND P.PaymentDirection = 2
        THEN -P.PaymentAmount

        ELSE 0
    END) AS [Net Sales]

FROM dbo.SalesPayments AS P WITH (NOLOCK)

LEFT JOIN dbo.SalesTransactions AS S WITH (NOLOCK)
    ON P.TransactionId = S.TransactionId
   AND S.DocumentStatus = 0

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND P.PaymentType IN (0, 1, 4)

  AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    CASE P.PaymentType 
        WHEN 0 THEN 'Cash'
        WHEN 1 THEN 'Bank/Card'
        WHEN 4 THEN 'Bonus'
    END;
```
