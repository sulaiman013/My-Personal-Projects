# Cohort Analysis Project on Superstore Retail Data

This repository contains a cohort analysis project based on a superstore retail dataset. The dataset was obtained from [Kaggle](https://www.kaggle.com/datasets/jihyeseo/online-retail-data-set-from-uci-ml-repo).

## Dataset Attribute Information

- **InvoiceNo**: Invoice number. Nominal, a 6-digit integral number uniquely assigned to each transaction. If this code starts with the letter 'c', it indicates a cancellation.
- **StockCode**: Product (item) code. Nominal, a 5-digit integral number uniquely assigned to each distinct product.
- **Description**: Product (item) name. Nominal.
- **Quantity**: The quantities of each product (item) per transaction. Numeric.
- **InvoiceDate**: Invoice Date and time. Numeric, the day and time when each transaction was generated.
- **UnitPrice**: Unit price. Numeric, Product price per unit in sterling.
- **CustomerID**: Customer number. Nominal, a 5-digit integral number uniquely assigned to each customer.
- **Country**: Country name. Nominal, the name of the country where each customer resides.

## Data Preprocessing Steps

After obtaining the dataset, the following preprocessing steps were performed:

1. Fixed data types:
   - `InvoiceNo` to text
   - `StockCode` to text
   - `InvoiceDate` to date (mm/dd/yyyy)
   - `CustomerID` to whole number

2. Removed empty values from `CustomerID`.

3. Removed canceled orders (invoices starting with 'C') from `InvoiceNo`.

4. Created a "sales" column by multiplying `Quantity` and `UnitPrice` columns.

5. Removed sales entries with 0 values.

## Additional Tables Created

Two additional tables were created for the project:

1. **DimCustomers**:
   - Contains `CustomerID`, `First Transaction Month`, and `First Transaction Week`.

2. **DimDate**:
   - Contains all unique dates from 12/1/2010 to 12/9/2011.
   - Includes `Start of Month` and `Start of Week` attributes.

## Data Modeling in Power BI

The following data modeling steps were performed in Power BI:
![image](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/2846c95b-edb7-467d-802c-f48b75289cc5)

- Connected `CustomerID` from **DimCustomers** to `CustomerID` of the main table **FactSales**.
- Connected `Date` from **DimDate** to `InvoiceDate` of **FactSales**.

## DAX Measures

Eighteen DAX measures were created for cohort analysis:

1. Active Customers = DISTINCTCOUNT(FactSales[CustomerID])
2. Churned Customers =
    SWITCH(
        TRUE(),
        ISBLANK([Retention Rate]),
        BLANK(),
        [New Customers] - [Cohort Performance]
    )
3. Churned Rate = DIVIDE([Churned Customers],[New Customers])
4. Cohort Performance =
VAR _minDate = MIN(DimDate[Start of Month])
VAR _maxDate = MAX(DimDate[Start of Month])
RETURN
    CALCULATE(
        [Active Customers],
        REMOVEFILTERS(DimDate[Start of Month]),
        RELATEDTABLE(DimCustomers),
        DimCustomers[First Transaction Month] >= _minDate
            && DimCustomers[First Transaction Month] <= _maxDate
    )
5. Lost Customers =
VAR _customersThisMonth =
    VALUES(FactSales[CustomerID])
VAR _customersLastMonth =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        PREVIOUSMONTH(DimDate[Start of Month])
    )
VAR _lostCustomers =
    EXCEPT(
        _customersLastMonth, _customersThisMonth
    )
RETURN
    COUNTROWS(_lostCustomers)
6. New Customers = CALCULATE([Active Customers], FactSales[Months Since First Transaction] = 0)
7. Recovered Customers =
VAR _customersThisMonth =
    VALUES(FactSales[CustomerID])
VAR _customersLastMonth =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        PREVIOUSMONTH(DimDate[Start of Month])
    )
VAR _newCustomers =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        FactSales[Months Since First Transaction] = 0
    )
VAR _recoveredCustomers =
    EXCEPT(
        EXCEPT(_customersThisMonth, _customersLastMonth),
    _newCustomers
    )
RETURN
    COUNTROWS(_recoveredCustomers)
8. Retained Customers =
VAR _customersThisMonth =
    VALUES(FactSales[CustomerID])
VAR _customersLastMonth =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        PREVIOUSMONTH(DimDate[Start of Month])
    )
VAR _retainedCustomers =
    INTERSECT(
        _customersLastMonth, _customersThisMonth
    )
RETURN
    COUNTROWS(_retainedCustomers)
9. Retention Rate =
    DIVIDE([Cohort Performance],[New Customers])
10. Active Customers LW =
    CALCULATE(
        [Active Customers],
        DATEADD(DimDate[Date], -7, DAY)
    )
11. Weekly Churned Customers =
    SWITCH(
        TRUE(),
        ISBLANK([Weekly Retention Rate]),
        BLANK(),
        [Weekly New Customers] - [Weekly Cohort Performance]
    )
12. Weekly Churned Rate = DIVIDE([Weekly Churned Customers],[Weekly New Customers])
13. Weekly Cohort Performance =
VAR _minDate = MIN(DimDate[Start of Week])
VAR _maxDate = MAX(DimDate[Start of Week])
RETURN
    CALCULATE(
        [Active Customers],
        REMOVEFILTERS(DimDate[Start of Week]),
        RELATEDTABLE(DimCustomers),
        DimCustomers[First Transaction Week] >= _minDate
            && DimCustomers[First Transaction Week] <= _maxDate
    )
14. Weekly Lost Customers =
VAR _customersThisWeek =
    VALUES(FactSales[CustomerID])
VAR _customersLastWeek =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        DATEADD(DimDate[Date], -7,DAY)
    )
VAR _weeklylostCustomers =
    EXCEPT(
        _customersLastWeek, _customersThisWeek
    )
RETURN
    COUNTROWS(_weeklylostCustomers)
15. Weekly New Customers = CALCULATE([Active Customers], FactSales[Weeks Since First Transaction] = 0)
16. Weekly Recovered Customers =
VAR _customersThisWeek =
    VALUES(FactSales[CustomerID])
VAR _customersLastWeek =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        DATEADD(DimDate[Date], -7, DAY)
    )
VAR _newCustomers =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        FactSales[Weeks Since First Transaction] = 0
    )
VAR _weeklyrecoveredCustomers =
    EXCEPT(
        EXCEPT(_customersThisWeek, _customersLastWeek),
    _newCustomers
    )
RETURN
    COUNTROWS(_weeklyrecoveredCustomers)
17. Weekly Retained Customers =
VAR _customersThisWeek =
    VALUES(FactSales[CustomerID])
VAR _customersLastWeek =
    CALCULATETABLE(
        VALUES(FactSales[CustomerID]),
        DATEADD(DimDate[Date], -7,DAY)
    )
VAR _weeklyretainedCustomers =
    INTERSECT(
        _customersLastWeek, _customersThisWeek
    )
RETURN
    COUNTROWS(_weeklyretainedCustomers)
18. Weekly Retention Rate =
    DIVIDE([Weekly Cohort Performance],[Weekly New Customers])


## Visualizations
Finally, the project is ready for creating visualizations based on the calculated DAX measures to analyze and present the cohort analysis results.

## Monthly Cohort Analysis:

![Dashboard 1](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/0ff52650-bae1-4146-970d-7761da1a8c7b)

## Weekly Cohort Analysis:

![Dashboard 2](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/096ef5ba-e4d7-4191-b345-a8f94e736ac3)
