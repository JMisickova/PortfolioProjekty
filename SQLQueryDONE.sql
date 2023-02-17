--- Kontrola, �i sa d�ta previedli spr�vne
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

--- Vyberiem si d�ta, ktor� budem pou��va�
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portolio Projekt]..Covid_Deaths
ORDER BY 1,2

--- Ko�ko z celkov�ho po�tu �ud�, ktor� mali covid (total_cases), aj zomreli (total_deaths)? Najprv v�ak zmena d�tov�ch typov t�chto premenn�ch (boli VARCHAR - no s� DECIMAL)
ALTER TABLE..Covid_Deaths
ALTER column  total_cases DECIMAL

ALTER TABLE..Covid_Deaths
ALTER column  total_deaths DECIMAL

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
ORDER BY 1,2

--- Ko�ko z celkov�ho po�tu �ud�, ktor� mali covid (total_cases), aj zomreli (total_deaths) na SLOVENSKU? Vy�lo ve�mi n�zke precentu�lne zast�penie, dr�alo sa to takmer cel� �as pod 1 % zomrel�ch (zo v�etk�ch nakazen�ch)
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Slovakia'
ORDER BY 1,2

--- Ko�ko z celkov�ho po�tu �ud�, ktor� mali covid (total_cases), aj zomreli (total_deaths) v EUR�PE? �esko malo oproti Slovensku v za�iatkoch ove�a vy��ie percentu�lne zast�penie m�tvych a v �al��ch kovidov�ch vln�ch sa �alej sa dr�alo nad 1 percentom
SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'czech%'
ORDER BY 1,2

--- Ko�ko percent slovenskej popul�cie malo covid? V okt�bri 2020 to bolo 1% a moment�lne (15.2. 1023) prekonalo covid u� takmer 50 % Slovenskej popul�cie (konk. 47 % �ud� v popul�cie)
ALTER TABLE..Covid_Deaths
ALTER column  population DECIMAL

SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS SlovakianPopulationCovidPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Slovakia'
ORDER BY 1,2

--- Ko�ko percent �eskej popul�cie malo covid (premorenie obyvate�stva)? Pre porovnanie, rovnako aj v �esku za�al st�pa� po�et rap�dne v okt�bri 2020 (1 % popul�cie malo covid), moment�lne prekonalo covid 44 % �eskej popul�cie
SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS CzechPopulationCovidPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Czechia'
ORDER BY 1,2

--- Ak� krajina mala najvy��iu mieru nakazenia (ak to porovn�vame v ve�kos�ou krajiny)? Najvy��iu mieru prepomeria krajiny m� Cyprus (72 %, San Marino 69 %, Rak�sko 65 %) - ak sa pozieme na Slovensko, je to 47 %, CZ 43 %
SELECT Location, Population, MAX (total_cases) AS HighestInfectionCountry, MAX((total_cases/Population))*100 AS PercentPopulationInfected
FROM [Portolio Projekt]..Covid_Deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--- Krajiny s najvy���m po�tom �mrt� z jej popul�cie. Spolu na covid umrelo do 15. 2 6 857 286 �ud�, Najviac �ud� v USA (1 115 564), Braz�lia, India, Rusko, Mexiko
SELECT Location, MAX(total_deaths) AS TotalDeathCount
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC

--- Vyh�ad�vanie pod�a kontinentov = Najv䚚ie �mrstia na svete m� - Severn� amerika, potom ju�n� Amerika, �sia, Eur�pa, Afrika, Oceania
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--- celosvetov� poh�ad - ko�ko nakazen�ch covidom umrelo - po d�och. Najvy��ie percent� v prvom roku - od marca do j�na 2020. potom sa to dr�alo na 1-2 %. Od decembra 2021 pozorujeme klesaj�cu tendenciu 
FROM [Portolio Projekt]..Covid_Deaths

SELECT new_deaths
FROM [Portolio Projekt]..Covid_Deaths

SELECT date, SUM(cast(new_cases as DECIMAL)) AS totalCases, SUM (cast(new_deaths as DECIMAL)) AS totalDeaths,
SUM(cast(new_deaths as DECIMAL)) / SUM(cast(new_cases as DECIMAL))*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--- Moment�lna percentu�lna �mrtnos� zo v�etk�ch nakazen�ch je 1 % 
SELECT SUM(cast(new_cases as DECIMAL)) AS totalCases, SUM (cast(new_deaths as DECIMAL)) AS totalDeaths,
SUM(cast(new_deaths as DECIMAL)) / SUM(cast(new_cases as DECIMAL))*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
ORDER BY 1,2

---- Idem sa pozrie� na 2. tabu�ku - vakcin�cie
SELECT *
FROM [Portolio Projekt]..Covid_Vaccinations

---- Prepojenie tabuliek (join) na z�klade rovnakej lokality a d�tumu
SELECT *
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date

--- Pozrieme sa na celkov� po�et �ud�, ktor� s� o�kovan� (museli sme �pecifikova�, z akej tabu�ky berieme lokaciu a d�tum, preto je pred nimi dea.), miesto total_vaccinations funkcia Partition
SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null
ORDER BY 2,3

--- 2 mo�nosti: 1. pou�ijeme CTE
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

--- 2. mo�nos� 2. pou�ijeme TEMP TABLE
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

--- Vytvorenie View pre vytvorenie vizualiz�cii

CREATE View PercPeopleVaccinated as
SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null

SELECT * FROM PercPeopleVaccinated