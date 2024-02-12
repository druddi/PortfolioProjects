--Observing Our imported Data from World Data

Select*
From PortfolioProject..CovidDeaths
Order by 3,4

--Everything seems to be working. Time for some Exploration of the data

Select Location, date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order by 1,2

-- Observing total cases relative to total deaths (worldwide)

Select Location, date, total_cases, new_cases, total_deaths, (cast(total_deaths as float))/(cast(total_cases as float))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
Order by 1,2

--Observing the UK
Presenting the likelihood of dyining if you contracted covid in the UK
Select Location, date, total_cases, new_cases, total_deaths, (cast(total_deaths as float))/(cast(total_cases as float))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where location like '%kingdom%'
Order by 1,2

-- Between April and June of 2020 was the Uk's worst death percentage (20%+)

Now, observing total cases against population
Select Location, date, total_cases, new_cases, population, (cast(total_cases as float))/(cast(population as float))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
where location like '%kingdom%'
Order by 1,2

--Observing Infection Rates
Select Location, population, Max(total_cases) as highest_infection_count , Max(cast(total_cases as float))/(cast(population as float))*100 as Cases_to_population
From PortfolioProject..CovidDeaths
--where location like '%kingdom%'
group by location, population
Order by Cases_to_population desc

-- Showing countries with the highest death count

Select Location, max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
--where location like '%kingdom%'
where continent is not null
group by location
Order by totaldeathcount desc

-- America has the highest death count (1170784), Tuvalu and Nauru have the lowest (1)

-- Observing continents

Select continent, max(cast(total_deaths as int)) as totaldeathcount
From PortfolioProject..CovidDeaths
--where location like '%kingdom%'
where continent is not null
group by continent
Order by totaldeathcount desc

--Global Numbers
Select date, SUM(new_cases), SUM(cast(new_deaths as int)), SUM(cast(new_deaths as float))/sum(CAST(new_cases as float))*100 as Death_Percentage
From PortfolioProject..CovidDeaths
--where location like '%kingdom%'
where continent is not null
group by date
Order by 1,2

--Joining the two tables
-- Total Population vs Vaccinations

with popvsvac (continent, location, date, population, new_vaccinations, Rollingpeoplevaccinated)
as
(
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select*, (Rollingpeoplevaccinated/population)*100
from popvsvac

-- TEMP TABLE
DROP table if exists #percentpopulationvaccinated
Create Table #percentpopulationvaccinated
(
Continent nvarchar(255),
location nvarchar(255),
Date datetime,
Population numeric,
new_vaccinations numeric,
RollingPeopleVaccinated numeric
)

Insert into #percentpopulationvaccinated
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3

select*, (Rollingpeoplevaccinated/population)*100
from #percentpopulationvaccinated

-- Creating a view to use and store the data for visualisations!

Create view PercentPopulationVaccinated as
select dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations
, sum(convert(float,vac.new_vaccinations)) over (partition by dea.location order by dea.location, dea.date) as Rollingpeoplevaccinated
From PortfolioProject..CovidDeaths dea
join PortfolioProject..CovidVaccinations vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3