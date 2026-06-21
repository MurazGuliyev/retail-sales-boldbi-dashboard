```sql
-- Dashboard: Branch Monthly Net Sales Trend
-- Purpose: Calculates monthly net sales by branch for the last 6 months.
-- Tool: Bold BI
-- Database: MS SQL Server
-- Note: Table, column, branch and parameter names are anonymized for portfolio use.

WITH BranchMonthlySales AS (
    SELECT
        SUM(CASE 
                WHEN S.TransactionType = 0
                THEN S.NetAmount

                WHEN S.TransactionType = 2
                THEN -S.NetAmount

                ELSE 0 
            END) AS NetSales,

        DATEFROMPARTS(
            YEAR(S.TransactionDate),
            MONTH(S.TransactionDate),
            1
        ) AS MonthDate,

        S.BranchCode

    FROM dbo.SalesTransactions AS S WITH (NOLOCK)

    WHERE S.TransactionDate >= DATEADD(
                                MONTH,
                                -5,
                                DATEFROMPARTS(YEAR(GETDATE()), MONTH(GETDATE()), 1)
                            )
      AND S.TransactionDate < DATEADD(day, 1, CONVERT(date, GETDATE()))
      AND S.DocumentStatus = 0

       AND CAST(S.BranchCode AS NVARCHAR(20)) IN (@BranchCodeList)

    GROUP BY
        DATEFROMPARTS(
            YEAR(S.TransactionDate),
            MONTH(S.TransactionDate),
            1
        ),
        S.BranchCode
)

SELECT
    NetSales AS [Net Sales],
    MonthDate AS [Month],
    CONCAT('Branch ', DENSE_RANK() OVER (ORDER BY BranchCode)) AS [Branch Name]

FROM BranchMonthlySales;
```
