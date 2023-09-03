# HR Analytics - Atlas Labs

## Case Study Goals
### Primary Goal:
- Monitor key HR metrics on employees.

### Secondary Goal:
- Understand what factors impact attrition.

## Data Transformation and Loading
We initiated the project by transforming and loading the following data sets:

1. **DimDate.txt**: This dataset contained various date attributes. To facilitate analysis, we created a new table and incorporated all DAX measures related to date calculations.

2. **EducationLevel.csv**: It included EducationLevelID and EducationLevel columns.

3. **Employee.csv**: This dataset contained essential employee information.

4. **RatingLevel.csv**: It consisted of RatingID and RatingLevel columns.

5. **SatisfiedLevel.csv**: Contained SatisfiedLevelID and SatisfiedLevel data.

6. **PerformanceRating.csv**: Included multiple employee performance-related columns.

## Data Modeling
We performed intricate data modeling, resulting in a structured database schema that allows for meaningful HR analytics.

![Screenshot 2023-09-03 193614](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/10bb9f7c-ac4c-4cea-b990-5585eddbf382)

## DAX Measures and Their Explanations
1. **% Attrition Rate**:
   - Formula: DIVIDE([Inactive Employees], [Active Employees] + [Inactive Employees], 0)
   - Calculates the percentage of employees who have left the organization.

2. **% Attrition Rate Date**:
   - Formula: DIVIDE([InactiveEmployeesDate], [TotalEmployeesDate], 0) * 100
   - Measures the attrition rate over time, expressed as a percentage.

3. **Active Employees**:
   - Formula: COUNTROWS(FILTER(DimEmployee, DimEmployee[Attrition] = "No"))
   - Counts the number of currently active employees.

4. **Average Salary**:
   - Formula: AVERAGE(DimEmployee[Salary])
   - Provides the average salary of all employees.

5. **Environment Satisfaction**:
   - Formula: CALCULATE(MAX(FactPerformanceRating[EnvironmentSatisfaction]), USERELATIONSHIP(FactPerformanceRating[EnvironmentSatisfaction], DimSatisfiedLevel[SatisfactionLevel]))
   - Captures the maximum environment satisfaction level among employees.

6. **Inactive Employees**:
   - Formula: COUNTROWS(FILTER(DimEmployee, DimEmployee[Attrition] = "Yes"))
   - Counts the number of employees who have left the organization.

7. **Inactive Employees Date**:
   - Formula: CALCULATE([Inactive Employees], USERELATIONSHIP(DimEmployee[HireDate], DimDate[Date]))
   - Measures the count of inactive employees over time.

8. **Job Satisfaction**:
   - Formula: MAX(FactPerformanceRating[JobSatisfaction])
   - Represents the highest job satisfaction level among employees.

9. **Last Review Date**:
   - Formula: (Refer to code for details)
   - Determines the date of the last employee review or indicates if no review has occurred.

10. **Manager Rating**:
    - Formula: CALCULATE(MAX(FactPerformanceRating[ManagerRating]), USERELATIONSHIP(FactPerformanceRating[ManagerRating], DimRatingLevel[RatingLevel]))
    - Retrieves the maximum manager rating level.

11. **Manager Satisfaction**:
    - Formula: CALCULATE(MAX(FactPerformanceRating[ManagerRating]), USERELATIONSHIP(FactPerformanceRating[ManagerRating], DimRatingLevel[RatingLevel]))
    - Represents the manager satisfaction level.

12. **Next Review Date**:
    - Formula: (Refer to code for details)
    - Calculates the date of the next employee review based on hire date or the previous review date.

13. **Oldest Employee**:
    - Formula: MAX(DimEmployee[Age])
    - Identifies the age of the oldest employee.

14. **Relationship Satisfaction**:
    - Formula: CALCULATE(MAX(FactPerformanceRating[RelationshipSatisfaction]), USERELATIONSHIP(FactPerformanceRating[RelationshipSatisfaction], DimSatisfiedLevel[SatisfactionLevel]))
    - Indicates the highest level of relationship satisfaction among employees.

15. **Self Rating**:
    - Formula: MAX(FactPerformanceRating[SelfRating])
    - Represents the highest self-rating level among employees.

16. **Total Employees**:
    - Formula: COUNTROWS(DimEmployee)
    - Counts the total number of employees.

17. **Total Employees Date**:
    - Formula: CALCULATE([Total Employees], USERELATIONSHIP(DimDate[Date], DimEmployee[HireDate]))
    - Measures the total number of employees over time.

18. **Work Life Balance**:
    - Formula: CALCULATE(MAX(FactPerformanceRating[WorkLifeBalance]), USERELATIONSHIP(FactPerformanceRating[WorkLifeBalance], DimSatisfiedLevel[SatisfactionLevel]))
    - Represents the highest work-life balance level among employees.

19. **Youngest Age**:
    - Formula: MIN(DimEmployee[Age])
    - Identifies the age of the youngest employee.

## Dashboard
The project's dashboard consists of four pages:

### 1. Overview
- Key Performance Indicators (KPIs): Total employees, active employees, inactive employees, % Attrition Rate.
- Bar chart showing Active Employees by Department.
- Stacked column chart showing employee hiring trends.
- Table displaying Active employees by department and job role.

![1](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/d8632b9d-3ae8-4eab-8521-5f33ca9f48e5)

### 2. Demographics
- KPIs: Youngest age, oldest age.
- Slicer for attrition (with "Yes" and "No" buttons).
- Clustered column chart of employees by age and gender.
- Column chart showing total employees by age.
- Line and stacked column chart showing total employees (columns) and average salary (line) by ethnicity.
- Bar chart showing employees by marital status.

![2](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/20808895-ff6a-466a-9506-29958c81abe9)

### 3. Performance Tracker
- KPIs: Employee starting date, last review date, next review date.
- Slicer to select an employee name.
- Six-line chart displaying different performances by year (relationship satisfaction, job satisfaction, environment satisfaction, self-rating, manager rating, work-life balance).

![3](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/a844ec40-8294-465d-8e1b-576b05091483)

### 4. Attrition
- Line chart showing attrition by hire date.
- Donut chart displaying attrition by overtime.
- Stacked column chart showing attrition rate by department and job role.
- Column chart of attrition by tenure.
- Column chart of attrition by travel frequency.
- Clustered column chart of attrition rate by ethnicity and marital status.

![4](https://github.com/sulaiman013/My-Personal-Projects/assets/55143390/725fa2db-eec3-4c7f-9734-9d2a0c18454d)

## Key Insights Uncovered
1. Atlas Labs has employed over 1,470 people.
2. Currently, Atlas Labs employs over 1,200 people.
3. The largest department by far is Technology.
4. The attrition rate for employees leaving the organization is 16%.
5. The majority of employees are between 20-29 years old.
6. Currently, Atlas Labs employs 2.7% more women than men.
7. Employees who identify as non-binary make up 8.5% of total employees.
8. White employees have the highest average salary, while those from 'Mixed or multiple ethnic groups' have one of the lowest average salaries.

