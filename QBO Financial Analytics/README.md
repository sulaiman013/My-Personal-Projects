# QBO Financial Analytics

A Power BI financial reporting solution built on QuickBooks Online data, featuring a three-layer MySQL data warehouse architecture and advanced visualization techniques including SVG-based KPI cards and HTML Content visuals for formatted financial statements.

## Table of Contents

1. [Project Overview](#project-overview)
2. [Architecture](#architecture)
3. [Data Model](#data-model)
4. [Financial Reports](#financial-reports)
5. [Advanced Visualizations](#advanced-visualizations)
6. [Balance Sheet Analytics](#balance-sheet-analytics)
7. [Technical Implementation](#technical-implementation)
8. [Setup Instructions](#setup-instructions)

## Project Overview

This project transforms raw QuickBooks Online accounting data into interactive Power BI reports that replicate standard financial statements:

- **Profit and Loss Statement** with year-over-year comparison
- **Balance Sheet** with proper account hierarchy and financial KPIs
- **Accounts Receivable Aging** by customer
- **Accounts Payable Aging** by vendor

The solution demonstrates enterprise-grade data modeling practices suitable for any accounting system integration.

## Architecture

### Data Warehouse Layers

The MySQL database follows a medallion architecture with three schemas:

```
icla_finance_bronze    Raw data extracted from QuickBooks API
         |
         v
icla_finance_silver    Cleaned and validated data
         |
         v
icla_finance_gold      Dimensional model optimized for reporting
```

**Bronze Layer**: Contains raw JSON responses and flat extracts from QuickBooks API endpoints including invoices, bills, payments, customers, vendors, and chart of accounts.

**Silver Layer**: Applies data quality rules, standardizes data types, handles null values, and creates audit columns for tracking data lineage.

**Gold Layer**: Implements a star schema with conformed dimensions and fact tables designed for analytical queries and Power BI consumption.

### Balance Sheet Data Flow

The Balance Sheet follows a specific transformation path:

1. **Bronze**: `bronze_accounts` stores raw QuickBooks account data with `current_balance`
2. **Silver**: `silver_accounts` adds `bs_category` classification (Cash, AR, AP, Equity, etc.)
3. **Gold**: `fact_bs_balance` creates monthly snapshots with proper sign conventions:
   - `current_balance`: Raw signed value from QuickBooks
   - `display_balance`: Absolute value for reporting display

## Data Model

### Star Schema Design

The semantic model follows star schema principles with a central date dimension connecting multiple fact tables:

```
                    [Dim Date]
                        |
    +-------+-------+---+---+-------+-------+
    |       |       |       |       |       |
[Fact PL] [Fact BS] [Fact Invoice] [Fact Bill] [Fact Payment]
    |       |           |       |       |
    +---+---+       +---+       +---+---+
        |           |               |
  [Dim Account] [Dim Customer] [Dim Vendor]
                    |               |
              [Dim Item]    [Dim Aging Bucket]
```

### Dimension Tables

| Table | Purpose | Key Attributes |
|-------|---------|----------------|
| Dim Date | Time intelligence | fiscal_year, fiscal_month, fiscal_quarter, is_month_end |
| Dim Account | Chart of accounts | account_type, classification, pl_category, bs_category |
| Dim Customer | Customer master | customer_name, company_name, city, state |
| Dim Vendor | Vendor master | vendor_name, company_name |
| Dim Item | Products/Services | item_name, item_type, unit_price |
| Dim Aging Bucket | AR/AP aging ranges | bucket_name, days_min, days_max |

### Fact Tables

| Table | Grain | Measures |
|-------|-------|----------|
| Fact PL Line | One row per P&L transaction line | amount |
| Fact BS Balance | One row per account per month-end | balance |
| Fact Invoice | One row per invoice header | total_amount, balance_due |
| Fact Invoice Line | One row per invoice line item | quantity, amount |
| Fact Bill | One row per bill header | total_amount, balance_due |
| Fact Bill Line | One row per bill line item | quantity, amount |
| Fact Payment | One row per payment | amount |
| Fact AR Aging | One row per customer per aging bucket | amount |
| Fact AP Aging | One row per vendor per aging bucket | amount |

### Relationship Design

The model uses single-direction relationships from fact tables to dimensions, enabling filter propagation from slicers to measures:

- **Fact PL Line** connects to Dim Date, Dim Account, Dim Customer, Dim Vendor, and Dim Item
- **Fact BS Balance** connects to Dim Date via `balance_date` for historical snapshots
- Customer filtering on P&L affects revenue transactions (from invoices)
- Vendor filtering on P&L affects expense transactions (from bills)

## Financial Reports

### Profit and Loss Statement

The P&L report uses a header table approach for row ordering:

**PL Header Table** defines the report structure:
```
LineItemNumber | LineItemDescription      | LineItemID        | ExpenseIncome | Highlight
1              | Income                   | Income            | 1             | 1
2              |     Billable Expense     | BillableExpense   | 1             | 0
...
9              | Total Income             | TotalIncome       | 1             | 1
10             | Cost of Sales            | CostofSales       | -1            | 1
...
32             | Net Income               | NetIncome         | 1             | 1
```

Each line item has a corresponding DAX measure (prefixed with underscore):
- `_TotalIncome` sums revenue accounts
- `_TotalCostofSales` sums COGS accounts
- `_GrossProfit` = `_TotalIncome` - `_TotalCostofSales`
- `_NetIncome` = `_NetOperatingIncome` + `_NetOtherIncome`

### Balance Sheet

The BS Header Table defines account hierarchy with indentation levels:

```
LineItemNumber | LineItemDescription           | Section              | Level | Indent
1              | Assets                        | Assets               | 1     | 0
2              | Current Assets                | Assets               | 2     | 1
3              | Bank Accounts                 | Assets               | 3     | 2
4              |     Checking                  | Assets               | 4     | 3
...
20             | Total for Assets              | Assets               | 1     | 0
21             | Liabilities and Equity        | Liabilities and Eq   | 1     | 0
```

Balance Sheet measures (prefixed with `_BS_`) pull from either:
1. **Fact BS Balance** for historical month-end snapshots
2. **Calculated fields** that derive values from P&L (e.g., Retained Earnings)

## Advanced Visualizations

### SVG KPI Cards

The project includes DAX measures that generate complete SVG graphics for KPI cards. These provide:

- Dynamic sparkline charts showing trend data
- Year-over-year change indicators with color coding
- Formatted currency values with K/M suffixes
- Responsive design within the card boundaries

**Technical approach:**

1. Calculate current and prior year values
2. Generate sparkline data points using `SUMMARIZE` and `ADDCOLUMNS`
3. Scale values to SVG coordinate space (0-260 x 0-160)
4. Construct SVG path strings using `CONCATENATEX`
5. Return complete SVG as data URI: `data:image/svg+xml;utf8,<svg>...</svg>`

Example structure from `SVG KPI - Total Revenue`:

```dax
VAR SvgContent = "
<svg xmlns='http://www.w3.org/2000/svg' viewBox='0 0 260 160'>
    <defs>
        <linearGradient id='sparkGrad'>...</linearGradient>
    </defs>
    <rect ... />  <!-- Card background -->
    <text ...>" & RevenueFormatted & "</text>  <!-- Main value -->
    <polygon points='" & SparklineArea & "' fill='url(#sparkGrad)'/>
    <polyline points='" & SparklinePoints & "' stroke='" & SparklineColor & "'/>
</svg>"
```

The SVG is displayed using the Image visual with the measure set as the image URL.

### HTML Content Visuals

For formatted financial statements, the project uses the HTML Content custom visual. This enables:

- Proper indentation for account hierarchies
- Bold formatting for subtotals and totals
- Conditional coloring (red for negative values)
- Fixed-width columns for alignment
- Scrollable content with custom scrollbar styling

## Balance Sheet Analytics

### SVG KPI Cards for Balance Sheet

The Balance Sheet page features four specialized SVG KPI cards that visualize key financial health indicators:

#### 1. Working Capital
Displays the difference between Current Assets and Current Liabilities with a visual comparison bar.

```
Working Capital = Current Assets - Current Liabilities
```

**Visual Features:**
- Main value displayed in large format ($2.6M)
- Horizontal comparison bars showing CA vs CL amounts
- Color-coded bars (green for assets, gray for liabilities)
- Labels showing actual dollar amounts

#### 2. Current Ratio
Shows the organization's ability to pay short-term obligations with a threshold indicator bar.

```
Current Ratio = Current Assets / Current Liabilities
```

**Visual Features:**
- Ratio value displayed (e.g., 2.17x)
- Health threshold bar with three zones:
  - Red zone: < 1.0 (Poor)
  - Yellow zone: 1.0 - 1.5 (Fair)
  - Green zone: > 1.5 (Good)
- Triangle marker indicating current position
- Threshold labels for quick interpretation

#### 3. Quick Ratio (Acid-Test)
Measures the ability to meet short-term obligations with liquid assets only.

```
Quick Ratio = (Current Assets - Inventory) / Current Liabilities
```

**Visual Features:**
- Ratio value displayed (e.g., 2.17x)
- Stacked bar showing liquid vs non-liquid asset breakdown
- Color differentiation between liquid assets and inventory
- Percentage labels for each component

#### 4. Debt-to-Equity Ratio
Illustrates the capital structure split between debt financing and equity.

```
Debt-to-Equity = Total Liabilities / Total Equity
```

**Visual Features:**
- Ratio value displayed (e.g., 0.86x)
- Capital structure bar split into debt and equity portions
- Percentage labels (e.g., 46% Debt | 54% Equity)
- Color-coded segments for easy interpretation

### Balance Sheet Trend Charts

Two DAX measures enable trend analysis over time:

```dax
_BS_TotalAssets_Trend =
VAR SelectedDate = MAX('Dim Date'[date_key])
RETURN CALCULATE(
    SUM('Fact BS Balance'[display_balance]),
    'Fact BS Balance'[classification] = "Asset",
    'Fact BS Balance'[balance_date] = EOMONTH(SelectedDate, 0)
)

_BS_TotalLiabilities_Trend =
VAR SelectedDate = MAX('Dim Date'[date_key])
RETURN CALCULATE(
    SUM('Fact BS Balance'[display_balance]),
    'Fact BS Balance'[classification] = "Liability",
    'Fact BS Balance'[balance_date] = EOMONTH(SelectedDate, 0)
)
```

These measures map to Dim Date allowing line charts to show Assets vs Liabilities over time.

### HTML Financial Ratios Table

An HTML Content visual displays additional financial ratios with multi-year comparison:

| Ratio | 2023 | 2024 | 2025 YTD | Description |
|-------|------|------|----------|-------------|
| Debt Ratio | 42% | 46% | 46% | Total Liabilities / Total Assets |
| Financial Leverage | 1.72x | 1.86x | 1.86x | Total Assets / Total Equity |
| Equity Ratio | 58% | 54% | 54% | Total Equity / Total Assets |

**Styling Features:**
- Matches existing HTML report scrollbar pattern
- Conditional formatting on year-over-year changes
- Color-coded variance indicators (green = favorable, red = unfavorable)
- Header styled with #e6e6e6 border

## Technical Implementation

### DAX Measure Organization

Measures follow a naming convention:

| Prefix | Purpose | Example |
|--------|---------|---------|
| `_` | P&L line items | `_TotalIncome`, `_NetIncome` |
| `_BS_` | Balance Sheet line items | `_BS_Checking`, `_BS_TotalAssets` |
| None | General calculations | `Total Revenue`, `Revenue PY` |
| `SVG KPI -` | SVG visualizations | `SVG KPI - Total Revenue`, `SVG KPI - Working Capital` |
| `HTML` | HTML Content reports | `HTML Financial Ratios Table` |

### Time Intelligence

Prior year calculations use `SAMEPERIODLASTYEAR`:

```dax
VAR pyTotalIncome = CALCULATE(
    [_TotalIncome],
    SAMEPERIODLASTYEAR('Dim Date'[date_key])
)
```

The sparkline measures use `DATESINPERIOD` for rolling windows:

```dax
VAR MonthlyData = CALCULATETABLE(
    'Dim Date',
    DATESINPERIOD('Dim Date'[date_key], MaxDate, -12, MONTH)
)
```

### Data Validation

The Balance Sheet data has been validated through:

1. **Accounting Equation Check**: Assets = Liabilities + Equity (verified to balance)
2. **Transaction Tracing**: AR/AP changes traced through invoices, bills, and payments
3. **Historical Continuity**: Balance changes verified against transaction activity
4. **Cross-Layer Validation**: Bronze -> Silver -> Gold transformations verified

### TMDL Format

The semantic model uses Tabular Model Definition Language (TMDL), a human-readable format for Power BI models that enables:

- Version control with meaningful diffs
- Code review of model changes
- Automated deployment pipelines

File structure:
```
ICLA Finance Project.SemanticModel/
  definition/
    model.tmdl           # Model metadata
    relationships.tmdl   # All relationships
    tables/
      Dim Account.tmdl   # Table definition + columns
      Fact PL Line.tmdl
      Fact BS Balance.tmdl
      BS Header Table.tmdl
      _Measures.tmdl     # All measures (P&L, BS, KPIs, HTML)
```

## Setup Instructions

### Prerequisites

- Power BI Desktop (November 2024 or later for TMDL support)
- MySQL Server 8.0+
- QuickBooks Online account (for data extraction)

### Database Setup

1. Create the three MySQL schemas:
   ```sql
   CREATE SCHEMA icla_finance_bronze;
   CREATE SCHEMA icla_finance_silver;
   CREATE SCHEMA icla_finance_gold;
   ```

2. Run the ETL scripts to populate tables from QuickBooks API

3. Verify the gold layer tables exist:
   - dim_date, dim_account, dim_customer, dim_vendor, dim_item, dim_aging_bucket
   - fact_pl_line, fact_bs_balance, fact_invoice, fact_invoice_line
   - fact_bill, fact_bill_line, fact_payment, fact_ar_aging, fact_ap_aging

### Power BI Setup

1. Open `ICLA Finance Project.pbip` in Power BI Desktop

2. Update the MySQL connection string in Power Query:
   - Server: localhost (or your MySQL server)
   - Database: icla_finance_gold
   - Authentication: MySQL credentials

3. Refresh the data model

4. The report pages will populate with your financial data

### Customization

To adapt for different chart of accounts:

1. Update `PL Header Table` with your P&L structure
2. Update `BS Header Table` with your Balance Sheet structure
3. Create corresponding measures for each line item
4. Update the HTML Report measures to reference new line items

## File Reference

| File | Description |
|------|-------------|
| `ICLA Finance Project.pbix` | Power BI report file |
| `ICLA Finance Project.pbip` | Power BI project file |
| `ICLA Finance Project.Report/` | Report pages and visuals |
| `ICLA Finance Project.SemanticModel/` | Data model (TMDL) |

## Recent Updates

### December 2024
- Added Balance Sheet Analytics page with 4 SVG KPI cards
- Implemented trend charts for Assets vs Liabilities over time
- Created HTML Financial Ratios Table with multi-year comparison
- Validated all Balance Sheet KPIs against MySQL source data
- Documented ETL transformation logic through Bronze -> Silver -> Gold layers
