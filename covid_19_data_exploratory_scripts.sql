Select *
From [Covid-19]..CovidDeaths
order by 3,4

--Select *
--From [Covid-19]..CovidVaccinations
--order by 3,4

Select Location,date,total_cases,new_cases,total_deaths,population
From [Covid-19]..CovidDeaths
where continent is not null
order by 1,2

Select Location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as DeathPercentage
From [Covid-19]..CovidDeaths
Where Location  like '%tunisia%'
order by 1,2

Select Location,date,total_cases,population,(total_cases/population)*100 as PopulationPercentage
From [Covid-19]..CovidDeaths
Where Location  like '%tunisia%'
order by 1,2

Select Location,MAX(total_cases) as Highestinfectioncount,population,MAX((total_cases/population))*100 as PopulationPercentageinfected
From [Covid-19]..CovidDeaths
Group by location,population
order by  PopulationPercentageinfected desc

Select location,MAX(cast(total_deaths as int)) as Highestdeathcount
From [Covid-19]..CovidDeaths
where continent is null
Group by location
order by Highestdeathcount desc

Select SUM(new_cases) as total_cases ,SuM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as deathpercentage 
From [Covid-19]..CovidDeaths
Where continent is not null
--Group by date
order by 1,2

Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,dea.date) as rollingpeoplevaccinated

From [Covid-19]..CovidDeaths dea
join [Covid-19]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date  = vac.date
where dea.continent is not null 
order by 2,3


With PopvsVac (continent,location,date,population,new_vaccination ,rollingpeoplevaccinated)
as (
Select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(Convert(int,vac.new_vaccinations)) OVER (Partition by dea.location Order by dea.location ,dea.date) as rollingpeoplevaccinated

From [Covid-19]..CovidDeaths dea
join [Covid-19]..CovidVaccinations vac
	on dea.location = vac.location
	and dea.date  = vac.date
where dea.continent is not null 
--order by 2,3
)

Select *,(rollingpeoplevaccinated/population)*100
From PopvsVac

--TEMP TABLE 
DROP Table if exists #percentvaccinated 
Create Table #percentvaccinated 
(
continent nvarchar(255),
location nvarchar(255),
date datetime,
population numeric,
new_vaccination numeric,
rollingpeoplevaccinated numeric,
)
Insert into #percentvaccinated



Select *,(rollingpeoplevaccinated/population)*100
From #percentvaccinated

--Creating view to store data for visualisations


Create View percentvaccinated1 as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location, dea.Date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Covid-19]..CovidDeaths dea
Join [Covid-19]..CovidVaccinations vac
	On dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null 

select * from dbo.percentvaccinated1




