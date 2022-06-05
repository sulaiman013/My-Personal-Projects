-- Trying to see some important columns of the dataset
SELECT location, date, total_cases, new_cases, total_deaths, population FROM coviddeaths
ORDER BY 1,2
LIMIT 10;

-- Let's fix those column constraints
ALTER TABLE coviddeaths ALTER COLUMN date TYPE DATE 
using to_date(cast(date as TEXT), 'MM-DD-YYYY');

ALTER TABLE covidvaccinations ALTER COLUMN date TYPE DATE 
using to_date(cast(date as TEXT), 'MM-DD-YYYY');

ALTER TABLE coviddeaths ALTER COLUMN total_cases TYPE numeric USING (total_cases::numeric);

ALTER TABLE coviddeaths ALTER COLUMN new_cases TYPE numeric USING (new_cases::numeric);
ALTER TABLE covidvaccinations ALTER COLUMN new_vaccinations TYPE numeric USING (new_vaccinations::numeric);

ALTER TABLE coviddeaths ALTER COLUMN total_deaths TYPE numeric USING (total_deaths::numeric);

ALTER TABLE coviddeaths ALTER COLUMN population TYPE numeric USING (population::numeric);

-- Now, let's see the dataset again!
SELECT location, date, total_cases, new_cases, total_deaths, population FROM coviddeaths
ORDER BY 1,2
LIMIT 10;

-- Looking at total cases vs total deaths = death percentages

SELECT location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases)*100),3) 
AS death_pct FROM coviddeaths
ORDER BY total_deaths DESC NULLS LAST
LIMIT 10;

-- Looking at the death percentages of a specific location
-- shows likelihood of dying if you contract covid in your country
SELECT location, date, total_cases, total_deaths, ROUND(((total_deaths/total_cases)*100),3) 
AS death_pct FROM coviddeaths
WHERE location ILIKE '%states%'
ORDER BY 1,2;


-- Looking at total cases vs population
-- Shows what pct of population got covid
SELECT location, date, population, total_cases, ROUND(((total_cases/population)*100),3) 
AS percentage_of_population_infected FROM coviddeaths
WHERE location ILIKE '%desh%'
ORDER BY 1,2;

-- Looking at the countries with the highest infection rate compared to Population
-- Sorted by highest to lowest
SELECT location, population, MAX(total_cases), ROUND(MAX((total_cases/population)*100),3) 
AS percentage_of_population_infected FROM coviddeaths
GROUP BY location, population
ORDER BY percentage_of_population_infected DESC NULLS LAST;

-- Showing countries with highest death count per population
-- Sorted by highest to lowest
SELECT location, MAX(total_deaths) AS TotalDeathCount FROM coviddeaths
GROUP BY location
ORDER BY TotalDeathCount DESC NULLS LAST;

-- Removing the continents
SELECT location, MAX(total_deaths) AS TotalDeathCount FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC NULLS LAST;

-- Only with continents
SELECT location, MAX(total_deaths) AS TotalDeathCount FROM coviddeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC NULLS LAST;

-- Global numbers
SELECT date, SUM(CAST(new_cases AS BIGINT)) AS total_cases, SUM(CAST(new_deaths AS BIGINT)) AS total_deaths, 
ROUND(SUM(CAST(new_deaths AS BIGINT))/SUM(CAST(new_cases AS BIGINT))*100, 3) AS Death_pct
FROM coviddeaths
WHERE continent IS NOT NULL
GROUP BY date
ORDER BY 1,2;

-- Let's see the COVID VACCINATION table
SELECT * FROM covidvaccinations
LIMIT 20;

-- Table JOINING [INNER JOIN]
SELECT * FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
ON dea.location = vac.location 
AND dea.date = vac.date
LIMIT 100;

-- Looking at total population vs total vaccinations
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
LIMIT 1000;


-- Looking at Cumulative sum of total vaccination by location and date
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_vaccinations
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
ORDER BY 2,3
LIMIT 1000;

-- Looking at Cumulative percentages of total vaccination by location and date [USING CTE]
WITH POPvsVAC (continent, location, date, population, new_vaccinations, cumulative_vaccinations)
AS (
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_vaccinations
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
LIMIT 1000
)
SELECT *, ROUND((cumulative_vaccinations/population)*100,3) AS cumulative_percentages
FROM POPvsVAC;

-- Using Temp Table to perform Calculation on Partition By in previous query

--DROP TABLE IF EXISTS percentpopvaccinated;
CREATE TABLE percentpopvaccinated(
continent varchar(255),
location varchar(255),
date date,
population numeric,
new_vaccinations numeric,
cumulative_vaccinations numeric
)

INSERT INTO percentpopvaccinated
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_vaccinations
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

SELECT *, ROUND((cumulative_vaccinations/population)*100,3) AS cumulative_percentages
FROM percentpopvaccinated
LIMIT 1000;



-- Creating View to store data for later visualizations

Create VIEW percentpopvaccinatedd as
SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS cumulative_vaccinations
FROM coviddeaths AS dea
INNER JOIN covidvaccinations AS vac
ON dea.location = vac.location 
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL;

-- Exporting the VIEW
COPY (SELECT * FROM percentpopvaccinatedd) TO 'F:\My-Personal-Projects-master\COVID PROJECT\mydata.csv' DELIMITER ',' CSV HEADER;




