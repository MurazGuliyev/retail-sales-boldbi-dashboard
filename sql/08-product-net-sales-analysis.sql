```sql
-- Dashboard: Product Net Sales Analysis
-- Purpose: Calculates today's net sales amount by product.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column, product and parameter names are anonymized for portfolio use.

WITH ProductSales AS (
    SELECT 
        P.ProductCode,
        P.ProductName,

        SUM(CASE 
            WHEN S.TransactionType = 0
            THEN SL.LineNetAmount

            WHEN S.TransactionType = 2
            THEN -SL.LineNetAmount

            ELSE 0 
        END) AS NetSales

    FROM dbo.SalesTransactionLines AS SL WITH (NOLOCK)

    LEFT JOIN dbo.SalesTransactions AS S WITH (NOLOCK)
        ON S.TransactionId = SL.TransactionId
       AND S.DocumentStatus = 0

    INNER JOIN dbo.Products AS P WITH (NOLOCK)
        ON SL.ProductId = P.ProductId

    WHERE S.TransactionDate >= CONVERT(date, GETDATE())
      AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
      AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)
      AND SL.LineType <> 1
      AND SL.LineNumber <> 0

    GROUP BY
        P.ProductCode,
        P.ProductName
)

SELECT
    CONCAT('Product Code ', ROW_NUMBER() OVER (ORDER BY NetSales DESC)) AS [Product Code],
    CONCAT('Product ', ROW_NUMBER() OVER (ORDER BY NetSales DESC)) AS [Product Name],
    NetSales AS [Net Sales]

FROM ProductSales;
```
