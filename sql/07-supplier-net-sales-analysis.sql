```sql
-- Dashboard: Supplier Net Sales Analysis
-- Purpose: Calculates today's net sales amount by supplier.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Database, table, column, supplier and parameter names are anonymized for portfolio use.

SELECT 
    ISNULL(SUPP.SupplierCode, 'Supplier Code Not Assigned') AS [Supplier Code],

    ISNULL(SUPP.SupplierName, 'Supplier Not Assigned') AS [Supplier Name],

    SUM(CASE
            WHEN S.TransactionType = 0 THEN SL.LineNetAmount
            WHEN S.TransactionType = 2 THEN -SL.LineNetAmount
            ELSE 0
        END) AS [Net Sales Amount]

FROM dbo.ProductSupplierAssignments AS PSA WITH (NOLOCK)

LEFT JOIN dbo.Suppliers AS SUPP WITH (NOLOCK)
    ON PSA.SupplierId = SUPP.SupplierId
   AND PSA.LineNumber = 1

LEFT JOIN dbo.Products AS P WITH (NOLOCK)
    ON PSA.ProductId = P.ProductId

LEFT JOIN dbo.SalesTransactionLines AS SL WITH (NOLOCK)
    ON P.ProductId = SL.ProductId

LEFT JOIN dbo.SalesTransactions AS S WITH (NOLOCK)
    ON S.TransactionId = SL.TransactionId

WHERE S.TransactionDate >= CONVERT(date, GETDATE())
  AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
  AND S.DocumentStatus = 0
  AND SL.LineNumber <> 0
  AND SL.LineType <> 1

  AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

GROUP BY
    ISNULL(SUPP.SupplierCode, 'Supplier Code Not Assigned'),
    ISNULL(SUPP.SupplierName, 'Supplier Not Assigned');
```
