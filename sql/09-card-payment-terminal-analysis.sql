```sql
-- Dashboard: Card Payment Terminal Analysis
-- Purpose: Calculates today's net sales amount by POS/card payment terminal.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column, POS terminal and parameter names are anonymized for portfolio use.

WITH TerminalSales AS (
    SELECT 
        PT.TerminalCode,
        PT.TerminalName,

        SUM(CASE 
            WHEN S.TransactionType = 0
            THEN S.NetAmount

            WHEN S.TransactionType = 2
            THEN -S.NetAmount

            ELSE 0 
        END) AS NetSales

    FROM dbo.SalesTransactions AS S WITH (NOLOCK)

    LEFT JOIN dbo.SalesPayments AS P WITH (NOLOCK)
        ON P.TransactionId = S.TransactionId

    LEFT JOIN dbo.PaymentTerminals AS PT WITH (NOLOCK)
        ON PT.TerminalCode = P.TerminalCode
       AND PT.BranchCode = P.BranchCode

    WHERE S.TransactionDate >= CONVERT(date, GETDATE())
      AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
      AND S.DocumentStatus = 0
      AND P.PaymentType = 1

      AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

    GROUP BY
        PT.TerminalCode,
        PT.TerminalName
)

SELECT
    CONCAT('POS Terminal ', ROW_NUMBER() OVER (ORDER BY NetSales DESC)) AS [POS Terminal Code],
    CONCAT('Card Terminal ', ROW_NUMBER() OVER (ORDER BY NetSales DESC)) AS [POS Terminal Name],
    NetSales AS [Net Sales]

FROM TerminalSales;
```
