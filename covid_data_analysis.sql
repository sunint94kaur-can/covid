--Total Cases Vs. Total Population
SELECT location,date,total_cases,total_deaths,
(CAST(total_deaths as float)/CAST(total_cases as float))* 100 AS DeathPercentage
FROM Covid..CovidDeaths
WHERE location LIKE '%states%'
order by 1,2
--Total Cases Vs. Population
SELECT location, date,total_cases,population,
(cast(total_cases AS FLOAT)/CAST(population AS float)) * 100 AS percentagepopulation_affected
FROM Covid..CovidDeaths
order by 1,2
--Looking at countries with highest infection rate compared to population
SELECT location,population,MAX(total_cases) AS highest_infection_count,
(CAST(MAX(total_cases) AS FLOAT)/(CAST(population AS FLOAT)))*100 AS PercentagePopulationInfected
FROM Covid..CovidDeaths
GROUP BY location,population
order by PercentagePopulationInfected DESC
--Showing countries with highest death count per population
SELECT location,population,MAX(total_cases) AS highest_infection_count
(CAST(MAX(total_cases) AS FLOAT)/(CAST(population AS FLOAT)))*100 AS PercentagePopulationInfected
FROM Covid..CovidDeaths
GROUP BY location,population
order by PercentagePopulationInfected DESC
--Looking at total population VS.vaccination using CTE
WITH PopVsVac AS
(
SELECT dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(CAST(vac.new_vaccinations AS FLOAT)) OVER (PARTITION BY dea.location ORDER BY dea.location,dea.date) AS RollingPeopleVaccinated
FROM Covid..CovidDeaths dea
JOIN Covid..Covidvaccinations vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
)
SELECT *,
(RollingPeopleVaccinated/Population)*100 AS PercentageofPopulationVaccinated
FROM PopVsVac

