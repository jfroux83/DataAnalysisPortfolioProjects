
-- Looking at Total Population vs Vaccinations
WITH PopvsVac (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS (
 SELECT dea.continent,
        dea.location,
	    dea.date,
	    dea.population,
	    vac.new_vaccinations,
	    SUM(CONVERT(decimal(20,0), vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidData..CovidDeaths dea
JOIN CovidData..CovidVaccinations vac ON
	dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent IS NOT NULL AND
      dea.location = 'South Africa')
--ORDER BY 2, 3
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopvsVac


-- Temp Table
DROP TABLE IF EXISTS #PercentPopulationVaccinated
CREATE TABLE #PercentPopulationVaccinated
(Continent NVARCHAR(255),
 Location NVARCHAR(255),
 Date DATETIME,
 Population NUMERIC,
 New_vaccinations NUMERIC,
 RollingPeopleVaccinated NUMERIC)

INSERT INTO #PercentPopulationVaccinated
SELECT dea.continent,
       dea.location,
	   dea.date,
	   dea.population,
	   vac.new_vaccinations,
	   SUM(CONVERT(decimal(20,0), vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidData..CovidDeaths dea
JOIN CovidData..CovidVaccinations vac ON
	dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent IS NOT NULL AND
      dea.location = 'South Africa'

SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPopulationVaccinated


-- CREATE View to store data for later visualizations
CREATE VIEW PercentPopulationVaccinated AS
SELECT dea.continent,
       dea.location,
	   dea.date,
	   dea.population,
	   vac.new_vaccinations,
	   SUM(CONVERT(decimal(20,0), vac.new_vaccinations)) OVER (PARTITION BY dea.location ORDER BY dea.location, dea.date) AS RollingPeopleVaccinated
FROM CovidData..CovidDeaths dea
JOIN CovidData..CovidVaccinations vac ON
	dea.location = vac.location AND
	dea.date = vac.date
WHERE dea.continent IS NOT NULL AND
      dea.location = 'South Africa'

SELECT * FROM PercentPopulationVaccinated