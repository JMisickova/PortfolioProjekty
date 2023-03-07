--- Kontrola, ci som data previedla z excelu spravne.
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

--- Vyber dat, ktore budem pouzivat.
SELECT Location, date, total_cases, new_cases, total_deaths, population
FROM [Portolio Projekt]..Covid_Deaths
ORDER BY 1,2

--- Ake pozorujeme zmeny v percentualnej umrtnosti na Covid-19 v jednotlivych krajinach? 
--- Najprv však zmena datovych typov premennych, s ktorymi ideme pracovat.
--- Podla WHERE location like 'x' vidime vývoj v jednotlivých krajinach.
ALTER TABLE..Covid_Deaths
ALTER column  total_cases DECIMAL

ALTER TABLE..Covid_Deaths
ALTER column  total_deaths DECIMAL

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
--- WHERE location like 'xxx'
ORDER BY 1,2

--- Najviac nas zaujima Slovensko a Cesko, preto sa zameriame na tieto.
--- Vysledok na Slovensku - Celkovo bol pocet mrtvych na pocet nakazenych velmi nizky. Takmet cely cas sa umrtnost drzala pod 1 %.
--- Vynimku a Slovensku tvori obdobie od polovice marca 20220 - teda, uplných pociatkoch sirenia koronavirusu v nasom prostredi, do leta 2020 a obdobie od januára 2021, 
--- do konca februara 2022. V ani jednom pripade vsak umrtnost neprevysovala 2 %.
--- Prveho cloveka nakazeneho covidom pozorujeme na Slovensku 6.3. 2020, a prveho zomrelého az mesiac na to. Pandemia sa v porovnani so Slovenskom zacala skor. Prvych nakazenych malo Cesko uz v januari 2020 a prve umrtia na konci marca 2020.
--- Ak porovname so Slovensko Cesko, Cesko malo  v zaciatkoch ovela vyssiu umrtnost na Covid-19. V dalsich kovidovych vlnach sa umrtnost drzala nad 1 %.

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Slovakia'
ORDER BY 1,2

SELECT Location, date, total_cases, total_deaths, (total_deaths/total_cases)*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'czech%'
ORDER BY 1,2

--- Aky bol vyvoj premorenia slovenskej populacie a aka je premorenost v sucanosti (pocet nakazenych vs pocet zomrelych)?
--- V oktobri 2020 to bolo 1 % populacie a momentálne (do 15.2. 1023) prekonalo covid už takmer polovica (konk. 47,2 %).
ALTER TABLE..Covid_Deaths
ALTER column  population DECIMAL

SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS SlovakianPopulationCovidPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Slovakia'
ORDER BY 1,2

--- Aký bol vývoj premorenia ceskej populacie a aka je premorenost v sucanosti (pocet nakazenych vs pocet zomrelych)?
--- Rovnako aj v Cesku zacal stupat pocet rapidne v oktobri 2020 (1 % populacie malo covid), momentálne prekonalo covid 43,8 % ceskej populacie. 
--- To znamena, ze Slovensko je o takmer 4 % premorene viac ako Cesko.

SELECT Location, date, total_cases, Population, (total_cases/Population)*100 AS CzechPopulationCovidPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'Czechia'
ORDER BY 1,2

--- Aka krajina mala najvyssiu mieru nakazenia? 
--- Najvyssiu mieru premorenia krajiny ma Cyprus 72 %, San Marino 69 %, Rakúsko 65 %, Faerske ostrovy 65, Slovinsko 62. Ak sa pozieme na Slovensko, je to 47 %, CZ 43 %
SELECT Location, Population, MAX (total_cases) AS HighestInfectionCountry, MAX((total_cases/Population))*100 AS PercentPopulationInfected
FROM [Portolio Projekt]..Covid_Deaths
GROUP BY Location, Population
ORDER BY PercentPopulationInfected DESC

--- Krajiny s najvyssim poctom umrti. Najviac ludí v USA (1 115 564), Brazília (697 904), India (530 757), Rusko (387 689), Mexiko (332 695).

SELECT TOP 5 Location, MAX(total_deaths) AS TotalDeathCount
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY Location
ORDER BY TotalDeathCount DESC


--- Najviac umrti podla continentov = Severna Amerika, Juzna Amerika, Azia, Europa, Afrika, Oceania
SELECT continent, MAX(total_deaths) AS TotalDeathCount
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY continent
ORDER BY TotalDeathCount DESC

--- Kolko ľudí na celom svete umrelo na covid?
--- Spolu na covid umrelo do 15. 2 6 857 286 ľudí.

SELECT date,location, total_deaths
FROM [Portolio Projekt]..Covid_Deaths
WHERE location like 'World' 
ORDER BY total_deaths DESC

--- Celosvetovy pohlad - Kolko nakazenych umrelo - po jednotlivych dnoch?. 
--- Najvyssie percenta v prvom roku - od marca do juna 2020 (3 - 10 %). Potom sa to udrziavalo na 1-2 %. Od zaciatku roka 2022 je umrtnost na Covid-19 pod 1 %.
SELECT new_deaths
FROM [Portolio Projekt]..Covid_Deaths

SELECT date, SUM(cast(new_cases as DECIMAL)) AS totalCases, SUM (cast(new_deaths as DECIMAL)) AS totalDeaths,
SUM(cast(new_deaths as DECIMAL)) / SUM(cast(new_cases as DECIMAL))*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
GROUP BY date
ORDER BY 1,2

--- Vypocet priemernej umrtnosti na covid. Momentalna umrtnost na covid je 1 % (1 zo 100 nakazenych ludi zomrie na Covid).
SELECT SUM(cast(new_cases as DECIMAL)) AS totalCases, SUM (cast(new_deaths as DECIMAL)) AS totalDeaths,
SUM(cast(new_deaths as DECIMAL)) / SUM(cast(new_cases as DECIMAL))*100 AS DeathPercentage
FROM [Portolio Projekt]..Covid_Deaths
WHERE continent is not null
ORDER BY 1,2

---- Idem sa pozriet na 2. tabulku - covid vakcinacie.
SELECT *
FROM [Portolio Projekt]..Covid_Vaccinations

---- Prepojenie tabuliek na základe rovnakej lokality a dátumu.
SELECT *
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date

--- Vyvoj ockovania na Slovensku.
--- Prvy den (28.12. 2020) sa ockovalo 1686 ludi. Do 14.2. bolo vykonanych 2 980 930 vakcinacii. 
--- Chybaju udaje o tom, kolkokrat boli jednotlivi ludia zaockovani. Tento udaj by sme zrejme zistili zo statnych statistik o covide.

SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null AND dea.location like 'Slo%'
ORDER BY 2,3

--- Vyvoj ockovania v Cesku.
--- Prvych 2301 ludi bolo zaockovanych 28.12.2020. Do 14.2 bolo vykonanych uz 18 612 431 vakcinacii (niektori ludia sa boli ockovat viackrat, cudzinci)
SELECT dea.continent, dea.location, dea.date, population, vacc.new_vaccinations,
SUM(cast(vacc.new_vaccinations as DECIMAL)) OVER (Partition by dea.location ORDER BY dea.location, dea.date) as RollingPeopleVaccinated
FROM [Portolio Projekt]..Covid_Deaths dea
JOIN [Portolio Projekt]..Covid_Vaccinations vacc
ON dea.location = vacc.location
AND dea.date = vacc.date
WHERE dea.continent is not null AND dea.location like 'Czechia'
ORDER BY 2,3
