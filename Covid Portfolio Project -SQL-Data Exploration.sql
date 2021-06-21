select *
FROM PortfolioProject..CovidDeaths
--where location like '%states%' AND date='2021-06-17'
where continent is null
order by 3,4

--select *
--FROM PortfolioProject..CovidVaccinations
--order by 3,4

select location,date,total_cases,new_cases,total_deaths,population
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--total cases vs total deaths

select location,date,total_cases,total_deaths, (total_deaths/total_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--shows what percentage of population got covid

select location,date,population,total_cases,total_deaths, (total_cases/population)*100 as infection_rate
from PortfolioProject..CovidDeaths
where location like '%states%'
order by 1,2

--countries with highest infection rate compared to population
select location,population,MAX(total_cases) as HighestInfectionCount,MAX((total_cases/population)*100) as PercentPopulationInfected
from PortfolioProject..CovidDeaths
--where location like'%states%'
group by location,population
order by PercentPopulationInfected DESC


--showing Countries with Highest Death Count per Population
select location, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by location
order by TotalDeathCount DESC

--Break down the things by continent
select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC

-- Showing continents with the highest death count per population
select continent, MAX(CAST(total_deaths as int)) as TotalDeathCount
FROM PortfolioProject..CovidDeaths
where continent is not null
group by continent
order by TotalDeathCount DESC

-- Global numbers

select SUM(new_cases) as total_cases,SUM(cast(new_deaths as int)) as total_deaths,SUM(cast(new_deaths as int))/SUM(new_cases)*100 as DeathPercentage
from PortfolioProject..CovidDeaths
--where location like '%states%'
where continent is not null
--group by date
order by 1,2

-- Looking at total Population vs Vaccinations

select dea.continent,dea.location,dea.date,dea.Population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated--,(RollingPeopleVaccinated/population)*100
from 
     PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
	 order by 2,3

--USE CTE

With PopvsVac (Continent, Location, Date, Population,new_vaccinations, RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.Population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from 
     PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
	
)
select * , (RollingPeopleVaccinated/Population)*100
From PopvsVac

--Temp Table


DROP Table if exists #PercentPopulationVaccinated
Create Table #PercentPopulationVacinated
(
Continent nvarchar(255),
Location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)
Insert INTO #PercentPopulationVacinated
select dea.continent,dea.location,dea.date,dea.Population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from 
     PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null

select * , (RollingPeopleVaccinated/Population)*100
From 
#PercentPopulationVacinated


-- Creating view to store data for later visualization

Create View PercentPopulationVacinated as
select dea.continent,dea.location,dea.date,dea.Population,vac.new_vaccinations,SUM(CONVERT(int,vac.new_vaccinations)) OVER (Partition by dea.Location Order by dea.location,dea.Date) as RollingPeopleVaccinated
from 
     PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
     on dea.location = vac.location
	 and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select * 
from PercentPopulationVacinated 



