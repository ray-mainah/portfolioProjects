--SELECT *
--FROM [COVID project].[dbo].[coviddeaths]
--WHERE continent IS NOT NULL
--ORDER BY 3,4

--SELECT [COVID project].[dbo].[coviddeaths]
  --     [continent]
  --    ,[location]
  --    ,[date]
  --    ,[population_density]
  --    ,[population]
  --    ,[total_deaths_per_million]
	 -- ,[total_cases_per_million]
	 -- ,[new_cases_per_million]
	 -- --,([total_deaths_per_million]/[new_cases_per_million]) as [DeathPercentage]
      
    
  --FROM [COVID project].[dbo].[coviddeaths]
  -- WHERE [location] = 'Kenya'
  --ORDER BY 1,2
  
  --SELECT
  --     [continent]
  --    ,[location]
  --    ,[date]
	 -- ,[new_cases_per_million]
	 -- ,[total_deaths_per_million]
	 -- ,[population]
	 -- ,([new_cases_per_million]/[total_deaths_per_million])* 100 as [death ratio]
	   
	 --   FROM [COVID project].[dbo].[coviddeaths]
  -- WHERE [location] = 'Kenya'
  -- ORDER BY 3

   -- countries with highest infection rate
  
  --SELECT 
  --    -- [continent]
  --    [location]
	 -- --,[population]
	 -- ,MAX ([total_cases_per_million]) as [highest_infection_count]
	 -- ,MAX ([total_cases_per_million]/[population])* 100 as [death ratio]
  --    FROM [COVID project].[dbo].[coviddeaths]
	 -- WHERE [continent] = 'Africa'
	 --   GROUP BY [location]
		--ORDER BY [death ratio] DESC

		 --SELECT
   --    [continent]
   --   ,[location]
   --   ,[date]
	  --,[new_cases]
	  --,[total_deaths]
	  --,([new_cases]/[total_deaths])*100 as [death probability]
	  --FROM [COVID project].[dbo].[coviddeaths]
	  --WHERE [location] = 'Kenya'
	  --ORDER BY 3 

	  --countries with highest death count per population
	  
	 -- SELECT 
	 -- [location]
	 -- --[continent]
	 -- ,MAX(CAST([total_deaths] AS INT)) as [TotalDeathCount]
	 -- FROM [COVID project].[dbo].[coviddeaths]
	 ---- WHERE [continent] = 'Africa' 
	 -- WHERE [continent] IS NOT NULL
	 -- GROUP BY [location]
	 -- ORDER BY [TotalDeathCount] DESC

	  --Showing continents with highest death count

	 --  SELECT 
	 -- --[location]
	 -- [continent]
	 -- ,MAX(CAST([total_deaths] AS INT)) as [TotalDeathCount]
	 -- FROM [COVID project].[dbo].[coviddeaths]
	 ---- WHERE [continent] = 'Africa' 
	 -- WHERE [continent] IS NOT NULL
	 -- GROUP BY [continent]
	 -- ORDER BY [TotalDeathCount] DESC

	  --Global numbers
	  	 
	--SELECT
 --     [continent]
 --     ,[location]
 --     [date]
	--  ,[new_cases]
	--  ,SUM([new_cases]) as [total_new_cases]
	--  ,SUM([new_deaths]) as [Total_new_deaths]
	-- ,[total_deaths]
	--  ,SUM([new_deaths]/[new_cases])*100 as [death probability]
	--  FROM [COVID project].[dbo].[coviddeaths]
	--  WHERE [continent]  IS not null
	--  GROUP BY [date]
	--  ORDER BY 1,2 

	--Looking at total population v vaccinations 

	SELECT 
	A.continent
	,A.[location]
	,A.date
	,A.population
	,B.new_vaccinations
	,SUM(CONVERT(bigint,B.new_vaccinations)) OVER (PARTITION BY A.[location] ORDER BY A.location,A.date ) AS [RollingPeopleVaccinated]
	FROM [COVID project].[dbo].[coviddeaths] A
	JOIN [COVID project].[dbo].[covidvaccinations] B
	   ON A.location = B.location
	   AND A.date = B.date
	   WHERE A.[continent] IS NOT NULL
	ORDER BY 2,3 

	--USE CTE
	WITH Popvsvac (continent,location,date,population,new_vaccinations,RollingPeopleVaccinated)
	as
	(

	SELECT 
	A.continent
	,A.[location]
	,A.date
	,A.population
	,B.new_vaccinations
	,SUM(CONVERT(bigint,B.new_vaccinations)) OVER (PARTITION BY A.[location] ORDER BY A.location,A.date ) AS [RollingPeopleVaccinated]
	
	FROM [COVID project].[dbo].[coviddeaths] A
	JOIN [COVID project].[dbo].[covidvaccinations] B
	   ON A.location = B.location
	   AND A.date = B.date
	   WHERE A.[continent] IS NOT NULL
	--ORDER BY 2,3 
	)
	SELECT*
	,([RollingPeopleVaccinated]/population)*100
	FROM Popvsvac


	-- TEMP TABLE

	CREATE TABLE 
	[PercentPopulationVaccinated]
	(
	Continent nvarchar(255)
	,Location nvarchar(255)
	,Date  datetime
	,Population numeric
	,New_vaccinations numeric
	,RollingPeopleVaccinated numeric
	)

	INSERT INTO [PercentPopulationVaccinated]
	SELECT 
	A.continent
	,A.[location]
	,A.date
	,A.population
	,B.new_vaccinations
	,SUM(CONVERT(bigint,B.new_vaccinations)) OVER (PARTITION BY A.[location] ORDER BY A.location,A.date ) AS [RollingPeopleVaccinated]
	
	FROM [COVID project].[dbo].[coviddeaths] A
	JOIN [COVID project].[dbo].[covidvaccinations] B
	   ON A.location = B.location
	   AND A.date = B.date
	   WHERE A.[continent] IS NOT NULL
	--ORDER BY 2,3 

	SELECT*
	,([RollingPeopleVaccinated]/population)*100
	FROM [PercentPopulationVaccinated]

	--creating view to store data for later visualisation
	
	CREATE VIEW [VaccinatedPercentage] as
	SELECT 
	A.continent
	,A.[location]
	,A.date
	,A.population
	,B.new_vaccinations
	,SUM(CONVERT(bigint,B.new_vaccinations)) OVER (PARTITION BY A.[location] ORDER BY A.location,A.date ) AS [RollingPeopleVaccinated]
	
	FROM [COVID project].[dbo].[coviddeaths] A
	JOIN [COVID project].[dbo].[covidvaccinations] B
	   ON A.location = B.location
	   AND A.date = B.date
	   WHERE A.[continent] IS NOT NULL
	--ORDER BY 2,3 