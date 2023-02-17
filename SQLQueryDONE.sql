--- Kontrola, Ëi sa d·ta previedli spr·vne
SELECT *
FROM [Portolio Projekt]..Covid_Vaccinations
ORDER BY 3,4

SELECT *
FROM [Portolio Projekt]..Covid_Deaths
ORDER BY 3,4

SELECT *
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
ORDER BY 3,4

--- Vyberiem si d·ta, ktorÈ budem pouûÌvaù
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portolio Projekt]..Covid_Deaths
ORDER BY 1,2

--- Koæko z celkovÈho poËtu æudÌ, ktorÌ mali covid (total_cases), aj zomreli (total_deaths)? Najprv vöak zmena d·tov˝ch typov t˝chto premenn˝ch (boli VARCHAR - no s˙ DECIMAL)
ALTER TABLE..Covid_Deaths
ALTER column  total_cases DECIMAL

ALTER TABLE..Covid_Deaths
ALTER column  total_deaths DECIMAL

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
ORDER BY 1,2

--- Koæko z celkovÈho poËtu æudÌ, ktorÌ mali covid (total_cases), aj zomreli (total_deaths) na SLOVENSKU? Vyölo veæmi nÌzke precentu·lne zast˙penie, drûalo sa to takmer cel˝ Ëas pod 1 % zomrel˝ch (zo vöetk˝ch nakazen˝ch)
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Slovakia'
ORDER BY 1,2

--- Koæko z celkovÈho poËtu æudÌ, ktorÌ mali covid (total_cases), aj zomreli (total_deaths) v EUR”PE? »esko malo oproti Slovensku v zaËiatkoch oveæa vyöúie percentu·lne zast˙penie m‡tvych a v ÔalöÌch kovidov˝ch vln·ch sa Ôalej sa drûalo nad 1 percentom
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'czech%'
ORDER BY 1,2

--- Koæko percent slovenskej popul·cie malo covid? V oktÛbri 2020 to bolo 1% a moment·lne (15.2. 1023) prekonalo covid uû takmer 50 % Slovenskej popul·cie (konk. 47 % æudÌ v popul·cie)
ALTER TABLE..Covid_Deaths
ALTER column  population DECIMAL

SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS SlovakianPopulationCovidPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Slovakia'
ORDER BY 1,2

--- Koæko percent Ëeskej popul·cie malo covid (premorenie obyvateæstva)? Pre porovnanie, rovnako aj v »esku zaËal st˙paù poËet rapÌdne v oktÛbri 2020 (1 % popul·cie malo covid), moment·lne prekonalo covid 44 % Ëeskej popul·cie
SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS CzechPopulationCovidPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Czechia'
ORDER BY 1,2

--- Ak· krajina mala najvyööiu mieru nakazenia (ak to porovn·vame v veækosùou krajiny)? Najvyööiu mieru prepomeria krajiny m· Cyprus (72 %, San Marino 69 %, Rak˙sko 65 %) - ak sa pozieme na Slovensko, je to 47 %, CZ 43 %
SELECT Location, Population, MAX (total_cases) AS HighestInfectionCountry, MAX((total_cases/Population))*100 AS PercentPopulationInfected
FROM [Portolio Projekt]..Covid_Deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--- Krajiny s najvyööÌm poËtom ˙mrtÌ z jej popul·cie. Spolu na covid umrelo do 15. 2 6 857 286 æudÌ, Najviac æudÌ v USA (1 115 564), BrazÌlia, India, Rusko, Mexiko
SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

--- Vyhæad·vanie podæa kontinentov = Najv‰ööie ˙mrstia na svete m· - Severn· amerika, potom juûn· Amerika, ¡sia, EurÛpa, Afrika, Oceania
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--- celosvetov˝ pohæad - koæko nakazen˝ch covidom umrelo - po dÚoch. Najvyööie percent· v prvom roku - od marca do j˙na 2020. potom sa to drûalo na 1-2 %. Od decembra 2021 pozorujeme klesaj˙cu tendenciu 
FROM [Portolio Projekt]..Covid_Deaths

SELECT new_deaths
FROM [Portolio Projekt]..Covid_Deaths

SELECT date, SUM(cast(new_cases as DECIMAL)) AS totalCases, SUM (cast(new_deaths as DECIMAL)) AS totalDeaths,
SUM(cast(new_deaths as DECIMAL)) / SUM(cast(new_cases as DECIMAL))*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--- Moment·lna percentu·lna ˙mrtnosù zo vöetk˝ch nakazen˝ch je 1 % 
SELECT SUM(cast(new_cases as DECIMAL)) AS totalCases, SUM (cast(new_deaths as DECIMAL)) AS totalDeaths,
SUM(cast(new_deaths as DECIMAL)) / SUM(cast(new_cases as DECIMAL))*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
ORDER BY 1,2

---- Idem sa pozrieù na 2. tabuæku - vakcin·cie
SELECT *
FROM [Portolio Projekt]..Covid_Vaccinations

---- Prepojenie tabuliek (join) na z·klade rovnakej lokality a d·tumu
SELECT *
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date

--- Pozrieme sa na celkov˝ poËet æudÌ, ktorÌ s˙ oËkovanÌ (museli sme öpecifikovaù, z akej tabuæky berieme lokaciu a d·tum, preto je pred nimi dea.), miesto total_vaccinations funkcia Partition
SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null
ORDER BY 2,3

--- 2 moûnosti: 1. pouûijeme CTE
WITH PopulationVSVaccination (Continent, Location, Date, Population, New_Vaccinations, RollingPeopleVaccinated)
AS
(
SELECT dea.continent, dea.location,dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null
)
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM PopulationVSVaccination

--- 2. moûnosù 2. pouûijeme TEMP TABLE
CREATE TABLE #PercentPeopleVaccinated
(
Continent NVARCHAR (255),
Location NVARCHAR (255),
Date DATETIME,
Population NUMERIC,
New_Vaccinations NUMERIC,
RollingPeopleVaccinated NUMERIC
)
INSERT INTO #PercentPeopleVaccinated
SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null
SELECT *, (RollingPeopleVaccinated/Population)*100
FROM #PercentPeopleVaccinated

--- Vytvorenie View pre vytvorenie vizualiz·cii

CREATE View PercPeopleVaccinated as
SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null

SELECT * FROM PercPeopleVaccinated