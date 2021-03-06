CREATE TABLE CovidDeaths(		
iso_code	varchar(500)	,
continent	varchar(500)	,
location	varchar(500)	,
date	varchar(500)	,
total_cases	varchar(500)	,
new_cases	varchar(500)	,
new_cases_smoothed	varchar(500)	,
total_deaths	varchar(500)	,
new_deaths	varchar(500)	,
new_deaths_smoothed	varchar(500)	,
total_cases_per_million	varchar(500)	,
new_cases_per_million	varchar(500)	,
new_cases_smoothed_per_million	varchar(500)	,
total_deaths_per_million	varchar(500)	,
new_deaths_per_million	varchar(500)	,
new_deaths_smoothed_per_million	varchar(500)	,
reproduction_rate	varchar(500)	,
icu_patients	varchar(500)	,
icu_patients_per_million	varchar(500)	,
hosp_patients	varchar(500)	,
hosp_patients_per_million	varchar(500)	,
weekly_icu_admissions	varchar(500)	,
weekly_icu_admissions_per_million	varchar(500)	,
weekly_hosp_admissions	varchar(500)	,
weekly_hosp_admissions_per_million	varchar(500)	,
new_tests	varchar(500)	,
total_tests	varchar(500)	,
total_tests_per_thousand	varchar(500)	,
new_tests_per_thousand	varchar(500)	,
new_tests_smoothed	varchar(500)	,
new_tests_smoothed_per_thousand	varchar(500)	,
positive_rate	varchar(500)	,
tests_per_case	varchar(500)	,
tests_units	varchar(500)	,
total_vaccinations	varchar(500)	,
people_vaccinated	varchar(500)	,
people_fully_vaccinated	varchar(500)	,
new_vaccinations	varchar(500)	,
new_vaccinations_smoothed	varchar(500)	,
total_vaccinations_per_hundred	varchar(500)	,
people_vaccinated_per_hundred	varchar(500)	,
people_fully_vaccinated_per_hundred	varchar(500)	,
new_vaccinations_smoothed_per_million	varchar(500)	,
stringency_index	varchar(500)	,
population	varchar(500)	,
population_density	varchar(500)	,
median_age	varchar(500)	,
aged_65_older	varchar(500)	,
aged_70_older	varchar(500)	,
gdp_per_capita	varchar(500)	,
extreme_poverty	varchar(500)	,
cardiovasc_death_rate	varchar(500)	,
diabetes_prevalence	varchar(500)	,
female_smokers	varchar(500)	,
male_smokers	varchar(500)	,
handwashing_facilities	varchar(500)	,
hospital_beds_per_thousand	varchar(500)	,
life_expectancy	varchar(500)	,
human_development_index	varchar(500)
);

SELECT * FROM coviddeaths;

COPY coviddeaths FROM 'F:\My-Personal-Projects-master\COVID PROJECT\CovidDeaths.csv' HEADER CSV;

CREATE TABLE covidvaccinations(		
iso_code	varchar(500)	,
continent	varchar(500)	,
location	varchar(500)	,
date	varchar(500)	,
new_tests	varchar(500)	,
total_tests	varchar(500)	,
total_tests_per_thousand	varchar(500)	,
new_tests_per_thousand	varchar(500)	,
new_tests_smoothed	varchar(500)	,
new_tests_smoothed_per_thousand	varchar(500)	,
positive_rate	varchar(500)	,
tests_per_case	varchar(500)	,
tests_units	varchar(500)	,
total_vaccinations	varchar(500)	,
people_vaccinated	varchar(500)	,
people_fully_vaccinated	varchar(500)	,
new_vaccinations	varchar(500)	,
new_vaccinations_smoothed	varchar(500)	,
total_vaccinations_per_hundred	varchar(500)	,
people_vaccinated_per_hundred	varchar(500)	,
people_fully_vaccinated_per_hundred	varchar(500)	,
new_vaccinations_smoothed_per_million	varchar(500)	,
stringency_index	varchar(500)	,
population_density	varchar(500)	,
median_age	varchar(500)	,
aged_65_older	varchar(500)	,
aged_70_older	varchar(500)	,
gdp_per_capita	varchar(500)	,
extreme_poverty	varchar(500)	,
cardiovasc_death_rate	varchar(500)	,
diabetes_prevalence	varchar(500)	,
female_smokers	varchar(500)	,
male_smokers	varchar(500)	,
handwashing_facilities	varchar(500)	,
hospital_beds_per_thousand	varchar(500)	,
life_expectancy	varchar(500)	,
human_development_index	varchar(500)	
);		

SELECT * FROM covidvaccinations;

COPY covidvaccinations FROM 'F:\My-Personal-Projects-master\COVID PROJECT\CovidVaccinations.csv' HEADER CSV;


