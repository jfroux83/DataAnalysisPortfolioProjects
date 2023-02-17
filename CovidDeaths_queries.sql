
-- Select Data that we are going to be using
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL
ORDER BY 1, 2

-- Looking at Total Cases vs Total Deaths
SELECT location, 
       date, 
	   total_cases, 
	   total_deaths, 
	   (total_deaths/total_cases)*100 AS DeathPercentage
FROM CovidData..CovidDeaths
WHERE location LIKE '%states%' AND
      continent IS NOT NULL
ORDER BY 1, 2 

-- Looking at Total Cases vs Population
SELECT location, 
       date, 
	   total_cases, 
	   population, 
	   (total_cases/population)*100 AS PercentPopulationInfected
FROM CovidData..CovidDeaths
WHERE location LIKE '%states%' AND
      continent IS NOT NULL
ORDER BY 1, 2 

-- Looking at Countries with Highest Infection Rate compared to Population
SELECT location,
	   population,
	   MAX(total_cases) AS HighestInfectionCount, 
	   MAX((total_cases/population))*100 AS PercentPopulationInfected
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location, population
ORDER BY PercentPopulationInfected DESC

-- Showing Countries with Highest Death Count per Population
SELECT location,
	   MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Showing continents with the Highest death count per population
SELECT location,
	   MAX(CAST(total_deaths AS int)) AS TotalDeathCount
FROM CovidData..CovidDeaths
WHERE continent IS NULL
GROUP BY location
ORDER BY TotalDeathCount DESC

-- Global Numbers
SELECT SUM(new_cases) AS total_cases,
	   SUM(CAST(new_deaths AS int)) AS total_deaths,
	   SUM(CAST(new_deaths AS int))/SUM(new_cases)*100 AS DeathPercentage
FROM CovidData..CovidDeaths
WHERE continent IS NOT NULL
