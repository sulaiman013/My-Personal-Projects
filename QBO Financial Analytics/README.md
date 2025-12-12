# ICLA Finance Power BI Project

A comprehensive **Financial Analytics Solution** built with Power BI, designed to transform QuickBooks Online (QBO) data into actionable financial insights through an enterprise-grade data model and interactive dashboards.

## Table of Contents

- [Overview](#overview)
- [Features](#features)
- [Architecture](#architecture)
- [Data Model](#data-model)
  - [Dimension Tables](#dimension-tables)
  - [Fact Tables](#fact-tables)
  - [Relationships](#relationships)
- [Report Pages](#report-pages)
- [DAX Measures](#dax-measures)
- [Getting Started](#getting-started)
- [Prerequisites](#prerequisites)
- [Configuration](#configuration)
- [Project Structure](#project-structure)
- [Technical Highlights](#technical-highlights)
- [License](#license)

---

## Overview

This Power BI solution provides a complete financial reporting suite that replicates and extends QuickBooks Online's native reports with enhanced analytics capabilities. The solution follows the **medallion architecture** (Bronze/Silver/Gold layers) for data processing and delivers pixel-perfect financial statements with advanced time intelligence.

### Key Objectives

- **100% Accuracy Match**: Balance Sheet figures match QuickBooks exactly
- **99.999% P&L Accuracy**: Profit & Loss statements with near-perfect reconciliation
- **Real-time Analytics**: Interactive dashboards with drill-down capabilities
- **Time Intelligence**: YoY comparisons, trend analysis, and fiscal period support

---

## Features

### Financial Statements
- **Profit & Loss Statement** - Complete income statement with all revenue and expense categories
- **Balance Sheet** - Assets, Liabilities, and Equity with hierarchical account structure
- **Cash Flow Statement** - Operating, investing, and financing activities

### Advanced Analytics
- **SVG-based KPI Cards** - Dynamic sparkline visualizations with YoY trend indicators
- **HTML Financial Reports** - Pixel-perfect formatted statements using HTML Content visual
- **Aging Analysis** - AR and AP aging with standard bucket breakdowns (Current, 1-30, 31-60, 61-90, 90+)
- **General Ledger** - Detailed transaction-level data with date slicing capability

### Time Intelligence
- Fiscal year and calendar year support
- Same Period Last Year (SPLY) comparisons
- Monthly/Quarterly/Annual trend analysis
- Rolling period calculations

---

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                      QuickBooks Online API                       │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                    ETL Pipeline (MySQL)                          │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │   Bronze    │─▶│   Silver    │─▶│         Gold            │ │
│  │  (Raw Data) │  │ (Cleaned)   │  │  (icla_finance_gold)    │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Power BI Semantic Model                     │
│  ┌──────────────────────┐    ┌────────────────────────────────┐ │
│  │   Dimension Tables   │    │        Fact Tables             │ │
│  │  • Dim Account       │    │  • Fact Invoice/Invoice Line   │ │
│  │  • Dim Date          │◀──▶│  • Fact Bill/Bill Line         │ │
│  │  • Dim Customer      │    │  • Fact Payment                │ │
│  │  • Dim Vendor        │    │  • Fact AR/AP Aging            │ │
│  │  • Dim Item          │    │  • Fact General Ledger         │ │
│  │  • Dim Aging Bucket  │    │  • Fact BS Balance             │ │
│  └──────────────────────┘    │  • Fact PL Line                │ │
│                              └────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
                                 │
                                 ▼
┌─────────────────────────────────────────────────────────────────┐
│                       Power BI Reports                           │
│  ┌─────────────┐  ┌─────────────┐  ┌─────────────────────────┐ │
│  │ Profit &    │  │  Balance    │  │     Cash Flow           │ │
│  │   Loss      │  │   Sheet     │  │     Statement           │ │
│  └─────────────┘  └─────────────┘  └─────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

---

## Data Model

### Dimension Tables

#### Dim Account
The chart of accounts with comprehensive categorization for financial reporting.

| Column | Type | Description |
|--------|------|-------------|
| `account_key` | Integer | Primary key (surrogate) |
| `account_id` | String | QBO Account ID |
| `account_name` | String | Account display name |
| `account_type` | String | QBO account type (Income, Expense, Asset, etc.) |
| `account_sub_type` | String | Account sub-classification |
| `classification` | String | Asset, Liability, Equity, Revenue, Expense |
| `report_category` | String | Financial statement category |
| `pl_category` | String | P&L section mapping |
| `bs_category` | String | Balance Sheet section mapping |
| `cf_category` | String | Cash Flow section mapping |
| `fully_qualified_name` | String | Full account hierarchy path |
| `parent_account_id` | String | Parent account reference |
| `account_level` | Integer | Hierarchy depth level |
| `display_order` | Integer | Report ordering |
| `is_active` | Boolean | Active status flag |

#### Dim Date
Enterprise date dimension with fiscal calendar support.

| Column | Type | Description |
|--------|------|-------------|
| `date_key` | Date | Primary key (date value) |
| `day_of_month` | Integer | Day number (1-31) |
| `day_of_week` | Integer | Day of week (1-7) |
| `day_name` | String | Day name (Monday, Tuesday, etc.) |
| `week_of_year` | Integer | ISO week number |
| `month_number` | Integer | Month (1-12) |
| `month_name` | String | Full month name |
| `month_short` | String | Abbreviated month (Jan, Feb, etc.) |
| `quarter_number` | Integer | Quarter (1-4) |
| `quarter_name` | String | Quarter label (Q1, Q2, etc.) |
| `calendar_year` | Integer | Calendar year |
| `fiscal_year` | Integer | Fiscal year |
| `fiscal_quarter` | Integer | Fiscal quarter |
| `fiscal_month` | Integer | Fiscal month |
| `period_year_month` | String | YYYY-MM format |
| `period_year_quarter` | String | YYYY-QN format |
| `is_weekend` | Boolean | Weekend flag |
| `is_month_end` | Boolean | Month end flag |
| `is_quarter_end` | Boolean | Quarter end flag |
| `is_year_end` | Boolean | Year end flag |

#### Dim Customer
Customer master data for receivables analysis.

#### Dim Vendor
Vendor master data for payables analysis.

#### Dim Item
Product and service items for line-level analysis.

#### Dim Aging Bucket
Standard aging bucket definitions (Current, 1-30, 31-60, 61-90, Over 90 days).

---

### Fact Tables

#### Fact General Ledger
Transaction-level general ledger entries for detailed financial analysis.

| Column | Type | Description |
|--------|------|-------------|
| `gl_key` | Integer | Primary key |
| `transaction_id` | String | Source transaction reference |
| `transaction_type` | String | Transaction type (Invoice, Bill, Payment, etc.) |
| `line_number` | Integer | Line sequence |
| `transaction_date` | Date | Transaction date |
| `posting_date` | Date | GL posting date |
| `account_key` | Integer | FK to Dim Account |
| `debit_amount` | Decimal | Debit amount |
| `credit_amount` | Decimal | Credit amount |
| `customer_key` | Integer | FK to Dim Customer |
| `vendor_key` | Integer | FK to Dim Vendor |
| `memo` | String | Transaction memo |
| `fiscal_year` | Integer | Fiscal year |
| `fiscal_month` | Integer | Fiscal month |
| `fiscal_quarter` | Integer | Fiscal quarter |

#### Fact BS Balance
Pre-calculated Balance Sheet balances for performance optimization.

| Column | Type | Description |
|--------|------|-------------|
| `balance_key` | Integer | Primary key |
| `account_key` | Integer | FK to Dim Account |
| `account_id` | String | Account identifier |
| `account_name` | String | Account name |
| `account_type` | String | Account type |
| `bs_category` | String | Balance Sheet category |
| `classification` | String | Asset/Liability/Equity |
| `balance_date` | Date | Balance as-of date |
| `opening_balance` | Decimal | Period opening balance |
| `debit_balance` | Decimal | Debit movements |
| `credit_balance` | Decimal | Credit movements |
| `transaction_balance` | Decimal | Period activity |
| `display_balance` | Decimal | Ending balance for display |
| `fiscal_year` | Integer | Fiscal year |
| `fiscal_month` | Integer | Fiscal month |
| `fiscal_quarter` | Integer | Fiscal quarter |

#### Fact PL Line
Profit & Loss transaction lines for income statement analysis.

| Column | Type | Description |
|--------|------|-------------|
| `line_key` | Integer | Primary key |
| `source_table` | String | Source transaction type |
| `source_id` | String | Source transaction ID |
| `line_number` | Integer | Line sequence |
| `transaction_date_key` | Date | Transaction date |
| `account_key` | Integer | FK to Dim Account |
| `line_type` | String | Line classification |
| `amount` | Decimal | Line amount |
| `fiscal_year` | Integer | Fiscal year |
| `fiscal_month` | Integer | Fiscal month |
| `fiscal_quarter` | Integer | Fiscal quarter |

#### Fact AR Aging
Accounts Receivable aging snapshot data.

| Column | Type | Description |
|--------|------|-------------|
| `ar_key` | Integer | Primary key |
| `as_of_date` | Date | Aging snapshot date |
| `invoice_id` | String | Invoice reference |
| `customer_key` | Integer | FK to Dim Customer |
| `bucket_key` | Integer | FK to Dim Aging Bucket |
| `original_amount` | Decimal | Original invoice amount |
| `amount_paid` | Decimal | Payments received |
| `balance_due` | Decimal | Outstanding balance |
| `days_outstanding` | Integer | Days since due date |
| `current_amount` | Decimal | Current bucket amount |
| `days_1_30` | Decimal | 1-30 days bucket |
| `days_31_60` | Decimal | 31-60 days bucket |
| `days_61_90` | Decimal | 61-90 days bucket |
| `days_over_90` | Decimal | Over 90 days bucket |

#### Fact AP Aging
Accounts Payable aging snapshot data (same structure as AR Aging).

#### Fact Invoice / Fact Invoice Line
Sales transaction headers and line items.

#### Fact Bill / Fact Bill Line
Purchase transaction headers and line items.

#### Fact Payment
Customer and vendor payment transactions.

---

### Relationships

The data model follows a **star schema** design with the following key relationships:

```
                          ┌──────────────────┐
                          │   Dim Account    │
                          └────────┬─────────┘
                                   │
        ┌──────────────────────────┼──────────────────────────┐
        │                          │                          │
        ▼                          ▼                          ▼
┌───────────────┐          ┌───────────────┐          ┌───────────────┐
│ Fact PL Line  │          │Fact BS Balance│          │Fact Gen Ledger│
└───────────────┘          └───────────────┘          └───────────────┘
        │                          │                          │
        └──────────────────────────┼──────────────────────────┘
                                   │
                          ┌────────┴─────────┐
                          │    Dim Date      │
                          └──────────────────┘
```

**Key Relationship Patterns:**
- All fact tables connect to `Dim Date` via date keys
- Transaction facts connect to `Dim Account` for financial categorization
- Customer-facing facts connect to `Dim Customer`
- Vendor-facing facts connect to `Dim Vendor`
- Aging facts connect to `Dim Aging Bucket`
- Bi-directional filtering enabled on `Fact BS Balance` → `Dim Account` for Balance Sheet reporting

---

## Report Pages

### 1. Profit & Loss Statement
**Page: `Profit & Loss`**

Interactive income statement featuring:
- SVG KPI cards with sparkline trends for key metrics:
  - Total Revenue (with YoY comparison)
  - Gross Profit (with margin percentage)
  - Net Operating Income
  - Net Income
  - Net Profit Margin
- Detailed P&L breakdown by account category
- Time-based filtering (Fiscal Year, Quarter, Month)
- Waterfall visualization for variance analysis

### 2. Balance Sheet
**Page: `Balance Sheet`**

Comprehensive balance sheet report featuring:
- HTML-rendered financial statement matching QBO format exactly
- Assets section (Current Assets, Fixed Assets)
- Liabilities section (Current Liabilities, Long-term Liabilities)
- Equity section (Opening Balance, Retained Earnings, Net Income)
- Interactive date selection for point-in-time balances
- Visual interactions disabled for specific elements to maintain report integrity

### 3. Cash Flow Statement
**Page: `Cashflow Statement`**

Cash flow analysis featuring:
- Operating activities
- Investing activities
- Financing activities
- Net change in cash

---

## DAX Measures

### Core Financial Measures

```dax
// Revenue & Expenses
Total Revenue = SUM('Fact Invoice'[total_amount])
Total Expenses = SUM('Fact Bill'[total_amount])
Net Income = [Total Revenue] - [Total Expenses]
Gross Margin % = DIVIDE([Net Income], [Total Revenue], 0)

// Revenue from Line Items
Revenue Amount = SUM('Fact Invoice Line'[amount])
Expense Amount = SUM('Fact Bill Line'[amount])
```

### P&L Template Measures

Individual line item measures following the QuickBooks P&L structure:

```dax
// Income Categories
_TotalIncome = CALCULATE(SUM('Fact PL Line'[amount]), 'Dim Account'[account_type] = "Income")
_CostofGoodsSold = CALCULATE(SUM('Fact PL Line'[amount]), 'Dim Account'[account_type] = "Cost of Goods Sold")
_GrossProfit = [_TotalIncome] - [_TotalCostofSales]

// Expense Categories
_TotalExpenses = CALCULATE(SUM('Fact PL Line'[amount]), 'Dim Account'[account_type] = "Expense")
_NetOperatingIncome = [_GrossProfit] - [_TotalExpenses]

// Other Income/Expenses
_TotalOtherExpenses = CALCULATE(SUM('Fact PL Line'[amount]), 'Dim Account'[account_type] = "Other Expense")
_NetIncome = [_NetOperatingIncome] + [_NetOtherIncome]
```

### Balance Sheet Measures

```dax
// Assets
_BS_TotalBankAccounts = [_BS_Checking] + [_BS_Savings]
_BS_TotalCurrentAssets = [_BS_TotalBankAccounts] + [_BS_TotalAR] + [_BS_TotalOtherCurrentAssets]
_BS_TotalAssets = [_BS_TotalCurrentAssets] + [_BS_TotalFixedAssets]

// Liabilities
_BS_TotalCurrentLiabilities = [_BS_TotalAP] + [_BS_TotalCreditCards] + [_BS_TotalOtherCurrentLiabilities]
_BS_TotalLiabilities = [_BS_TotalCurrentLiabilities] + [_BS_TotalLongTermLiabilities]

// Equity
_BS_TotalEquity = [_BS_OpeningBalanceEquity] + [_BS_RetainedEarnings] + [_BS_NetIncomeBS]
_BS_TotalLiabilitiesAndEquity = [_BS_TotalLiabilities] + [_BS_TotalEquity]
```

### Time Intelligence Measures

```dax
// Prior Year Comparison
Revenue PY = CALCULATE([Total Revenue], SAMEPERIODLASTYEAR('Dim Date'[date_key]))

// YoY Change Calculation (used in SVG KPIs)
YoYChange = CurrentValue - PriorYearValue
YoYPercent = DIVIDE(YoYChange, PriorYearValue, 0)
```

### SVG KPI Measures

Dynamic SVG-based KPI cards with embedded sparklines:

```dax
SVG KPI - Total Revenue =
    // Generates complete SVG visualization with:
    // - Formatted current value
    // - YoY percentage change badge
    // - Dynamic sparkline (Monthly when year selected, Annual otherwise)
    // - Color-coded trend indicators (green/red)
```

**Available SVG KPIs:**
- `SVG KPI - Total Revenue`
- `SVG KPI - Gross Profit`
- `SVG KPI - Gross Margin`
- `SVG KPI - Net Operating Income`
- `SVG KPI - Net Income`
- `SVG KPI - Net Profit Margin`

### HTML Report Measures

```dax
BS HTML Report =
    // Generates complete HTML Balance Sheet with:
    // - CSS styling matching QuickBooks format
    // - Scrollable container
    // - Hierarchical account structure
    // - Proper indentation and totaling
```

---

## Getting Started

### Prerequisites

1. **Power BI Desktop** (latest version recommended)
2. **MySQL Server** with the `icla_finance_gold` database
3. **MySQL ODBC Connector** or MySQL.Database() connection capability
4. **QuickBooks Online** account with API access (for data extraction)

### Configuration

1. **Database Connection**

   Update the MySQL connection string in the Power Query source:
   ```powerquery
   Source = MySQL.Database("localhost", "icla_finance_gold", [ReturnSingleDatabase=true])
   ```

   Modify `localhost` to your MySQL server address.

2. **Data Refresh**

   Configure scheduled refresh in Power BI Service or refresh manually in Power BI Desktop.

3. **Fiscal Year Settings**

   The model supports fiscal year configurations. Update the `Dim Date` table generation to match your organization's fiscal calendar.

---

## Project Structure

```
ICLA Finance Power BI Project/
├── ICLA Finance Project.pbip              # Power BI Project file
├── ICLA Finance Project.pbix              # Power BI Desktop file
├── ICLA Finance Project.Report/           # Report definition
│   ├── definition/
│   │   ├── pages/                         # Report pages
│   │   │   ├── 994fc452.../              # Profit & Loss page
│   │   │   ├── 7214090d.../              # Balance Sheet page
│   │   │   └── 39cc49e7.../              # Cashflow Statement page
│   │   ├── bookmarks/                     # Report bookmarks
│   │   └── report.json                    # Report configuration
│   └── StaticResources/                   # Images and themes
├── ICLA Finance Project.SemanticModel/    # Semantic model definition
│   ├── definition/
│   │   ├── tables/                        # Table definitions (TMDL)
│   │   │   ├── Dim Account.tmdl
│   │   │   ├── Dim Date.tmdl
│   │   │   ├── Dim Customer.tmdl
│   │   │   ├── Dim Vendor.tmdl
│   │   │   ├── Dim Item.tmdl
│   │   │   ├── Dim Aging Bucket.tmdl
│   │   │   ├── Fact General Ledger.tmdl
│   │   │   ├── Fact BS Balance.tmdl
│   │   │   ├── Fact PL Line.tmdl
│   │   │   ├── Fact AR Aging.tmdl
│   │   │   ├── Fact AP Aging.tmdl
│   │   │   ├── Fact Invoice.tmdl
│   │   │   ├── Fact Invoice Line.tmdl
│   │   │   ├── Fact Bill.tmdl
│   │   │   ├── Fact Bill Line.tmdl
│   │   │   ├── Fact Payment.tmdl
│   │   │   └── _Measures.tmdl             # All DAX measures
│   │   ├── relationships.tmdl             # Model relationships
│   │   └── model.tmdl                     # Model configuration
│   └── TMDLScripts/                       # Development scripts
└── README.md                              # This file
```

---

## Technical Highlights

### 1. Medallion Architecture
The solution implements a **Bronze → Silver → Gold** data pipeline:
- **Bronze**: Raw QBO API extracts
- **Silver**: Cleansed and conformed data
- **Gold**: Business-ready dimensional model (`icla_finance_gold`)

### 2. TMDL Format
The semantic model uses **Tabular Model Definition Language (TMDL)** for:
- Version control friendly structure
- Human-readable model definitions
- Easy diff/merge operations

### 3. SVG Visualizations
Custom SVG-based KPI cards provide:
- Embedded sparkline charts
- Dynamic color-coded trend indicators
- Context-aware period labels (Monthly vs Annual)
- No external visual dependencies

### 4. HTML Content Visual
Pixel-perfect Balance Sheet rendering using:
- Custom CSS styling
- Scrollable container with custom scrollbars
- Hierarchical indentation
- Proper accounting formatting (parentheses for negatives)

### 5. Performance Optimization
- Pre-calculated Balance Sheet balances (`Fact BS Balance`)
- Efficient date filtering with dedicated date dimension
- Bi-directional filtering only where necessary
- Import mode for all tables

---

## License

This project is provided as-is for educational and portfolio demonstration purposes.

---

## Author

**Sulaiman Ahmed**

- GitHub: [@sulaiman013](https://github.com/sulaiman013)

---

*Built with Power BI Desktop and MySQL*
