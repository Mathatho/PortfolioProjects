
Select * 
FROM [Portfolio project 1].dbo.CovidDeaths
Where continent is not null
Order by 3,4

--Select * 
--FROM [Portfolio project 1].dbo.CovidVaccinations
--Order by 3,4

--SELECT Data that we are going to be using 

Select Location, date, total_cases, new_cases, total_deaths, population 
FROM [Portfolio project 1].dbo.CovidDeaths 
Where continent is not null
order by 1,2


--Looking at the Total Cases vs Total Deaths
--Show the likelihood of dying if you contracted Covid in South Africa
Select Location, date, total_cases, total_deaths, (Total_deaths/total_cases)*100 as DeathPercentage
FROM [Portfolio project 1].dbo.CovidDeaths 
WHERE Location like 'South Africa'
order by 1,2 


--Looking at the Total Cases vs Population 
--Show what Percentage of population got Covid 
Select Location, date, total_cases, Population, (total_cases/population)*100 as PercentofPopulationInfected
FROM [Portfolio project 1].dbo.CovidDeaths 
WHERE Location like 'South Africa'
order by 1,2

--Looking at countries with highest infection rate compared to population 

Select Location, Max(total_cases) as HighestInfectionCount, Population, MAX((total_cases/population))*100 as 
	PercentofPopulationInfected
FROM [Portfolio project 1].dbo.CovidDeaths 
--WHERE Location like 'South Africa'
Group by Location, Population 
order by PercentofPopulationInfected desc

--Showing countries with highest death from Covid per population 
Select Location, MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio project 1].dbo.CovidDeaths 
--WHERE Location like 'South Africa'
Where continent is not null
Group by Location 
order by TotalDeathCount desc


--Let's break things down by continent
--Showing the continents with the highest death count per population 
Select continent, MAX(Cast(Total_deaths as int)) as TotalDeathCount
FROM [Portfolio project 1].dbo.CovidDeaths 
--WHERE Location like 'South Africa'
Where continent is not null
Group by continent
order by TotalDeathCount desc


--Global numbers
Select SUM(new_cases) as total_cases, SUM(cast(new_deaths as int)), SUM(cast(new_deaths as int))/Sum
	(new_cases)*100 as DeathPercentage
From [Portfolio project 1].dbo.CovidDeaths
--Where location is like 'South Africa'
Where continent is not null
--Group by date
Order by 1,2
 

 --Looking at the total population vs vaccinations 
 Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(new_vaccinations as int)) OVER (partition by dea.location order by dea.location,
 dea.date) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
 From [Portfolio project 1]..CovidDeaths dea
 Join [Portfolio project 1]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
order by 2,3


-- Use CTE 
With PopvsVac (Continent, location, date, population, new_vaccinations, RollingPeopleVaccinated)
as
(
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
 , SUM(cast(new_vaccinations as int)) OVER (partition by dea.location order by dea.location,
 dea.date) as RollingPeopleVaccinated
 --, (RollingPeopleVaccinated/population)*100
 From [Portfolio project 1]..CovidDeaths dea
 Join [Portfolio project 1]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3
)
Select *, (RollingPeopleVaccinated/population)*100
From PopvsVac


--TEMP Table
Drop table if exists #PercentPopulationVaccinated

Create Table #PercentPopulationVaccinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
New_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #PercentPopulationVaccinated
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project 1]..CovidDeaths dea
Join [Portfolio project 1]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
--Where dea.continent is not null
--Order by 2,3

Select *, (RollingPeopleVaccinated/population)*100
From #PercentPopulationVaccinated



--Create a view to store data for later visualisations 
Create View PercentPopulationVaccinated as
Select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, SUM(convert(int,vac.new_vaccinations)) OVER (partition by dea.location order by dea.location,
	dea.date) as RollingPeopleVaccinated
--, (RollingPeopleVaccinated/population)*100
From [Portfolio project 1]..CovidDeaths dea
Join [Portfolio project 1]..CovidVaccinations vac
	On dea.location = vac.location 
	and dea.date = vac.date
Where dea.continent is not null
--Order by 2,3


Select *
From PercentPopulationVaccination





















