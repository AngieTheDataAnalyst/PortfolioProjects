--Select *
--From PortfolioProject..CovidVaccinations
--Order By 3, 4

Select *
From PortfolioProject..CovidDeaths
Where Continent is Not Null 
Order By 3, 4


--Select Data That We Are Going To Be Using

Select Location, Date, total_cases, new_cases, total_deaths, population
From PortfolioProject..CovidDeaths
Order By 1, 2


-- Looking At Total Cases Vs Total Deaths
-- Shows Chance of Dying If Contract Covid in US

Select Location, Date, total_cases, total_deaths, (total_deaths / total_cases)*100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Location like '%states%'
Order By 1, 2


-- Looking At Total Cases Vs The Population
-- Shows What % Of Population Got Covid

Select Location, Date, population, total_cases, (total_cases / population)*100 As PercentofPopulationInfected
From PortfolioProject..CovidDeaths
Where Location like '%states%'
Order By 1, 2


-- Looking At Countries With Highest Infection Rate Compared to Population

Select Location, Population, Max(total_cases) As HighestInfectionCount, Max((total_cases/Population))*100 as PercentofPopulationInfected
From PortfolioProject..CovidDeaths
Group By Location, Population
Order By PercentofPopulationInfected Desc


-- Showing Countries With The Highest Death Count Per Population

Select Location, Max(Cast(total_deaths As Int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is Not Null 
Group By Location
Order By TotalDeathCount Desc


-- Showing Things By Continent
-- Showing The Continents With The Highest Death Counts Per Population

Select Continent, Max(Cast(total_deaths As Int)) As TotalDeathCount
From PortfolioProject..CovidDeaths
Where Continent is Not Null 
Group By Continent
Order By TotalDeathCount Desc


-- Global Numbers

Select Date, Sum(new_cases) As total_cases, Sum(Cast(new_deaths as Int)) As total_deaths, Sum(Cast(new_deaths as Int))/Sum(new_cases) * 100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is Not Null
Group By Date
Order By 1, 2

-- Copy Without Date


Select Sum(new_cases) As total_cases, Sum(Cast(new_deaths as Int)) As total_deaths, Sum(Cast(new_deaths as Int))/Sum(new_cases) * 100 As DeathPercentage
From PortfolioProject..CovidDeaths
Where Continent is Not Null
Order By 1, 2


-- Looking At Total Population Vs Vaccinations

With PopVsVac (Continent, Location, Date, Population, new_vaccinations ,RollingPeopleVaccinated)
As 
(
Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as Int)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date) As RollingPeopleVaccinated-- (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.Location = Vac.Location
	And Dea.Date = Vac.Date
Where Dea.continent is Not Null
--Order By 2, 3
)
Select * , (RollingPeopleVaccinated/Population)*100
From PopVsVac


--Temp Table
Drop Table If Exists #PercentPopulationVaccinated
Create Table #PercentPopulationVaccinated
(
Continent nvarchar(225),
Location nvarchar(255),
Date datetime,
Population numeric,
New_Vaccinations numeric,
RollingPeopleVaccinated numeric,
)

Insert Into #PercentPopulationVaccinated
Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as Int)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date) As RollingPeopleVaccinated-- (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.Location = Vac.Location
	And Dea.Date = Vac.Date
Where Dea.continent is Not Null
--Order By 2, 3

Select *, (RollingPeopleVaccinated/Population)*100
From #PercentPopulationVaccinated


-- Creating View To Store Data For Later Visaulization

Create View PercentPopulationVaccinated As 
Select Dea.continent, Dea.Location, Dea.Date, Dea.Population, Vac.new_vaccinations
, Sum(Cast(Vac.new_vaccinations as Int)) OVER (Partition By Dea.Location Order By Dea.Location, Dea.Date) As RollingPeopleVaccinated-- (RollingPeopleVaccinated/Population)*100
From PortfolioProject..CovidDeaths Dea
Join PortfolioProject..CovidVaccinations Vac
	On Dea.Location = Vac.Location
	And Dea.Date = Vac.Date
Where Dea.continent is Not Null

Select * 
From PercentPopulationVaccinated
