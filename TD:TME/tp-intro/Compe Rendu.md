#TME 1: Requêtes SQL

## Exercice 1: SQL sur le base MONDIAL

Ecrire en SQL les requêtes suivantes

1. Le nom de pays membres des nations unies trié par le nom de pays
```sql
SELECT c.Name 
FROM Organization un 
INNER JOIN IsMember m 
ON un.Name='United Nations' 
    AND 
    m.Organization=un.Abbreviation 
INNER JOIN Country c 
ON c.Code = m.Country 
ORDER BY c.Name;
```
2. Idem avec la population, trié décroissant par population
```sql
SELECT c.Name,c.Population 
FROM Organization un 
INNER JOIN IsMember m 
ON un.Name='United Nations' 
    AND 
    m.Organization=un.Abbreviation 
INNER JOIN Country c 
ON c.Code = m.Country 
ORDER BY c.Population DESC;
```
3. Le nom des pays NON membre des nations unies
```sql
SELECT cnm.Name 
FROM Country cnm 
WHERE cnm.Name NOT IN (
                        SELECT c.Name 
                        FROM Organization un 
                        INNER JOIN isMember m 
                        ON un.Name='United Nations' 
                           AND 
                           m.Organization=un.Abbreviation 
                        INNER JOIN Country c 
                        ON c.Code=m.Country
                       ) 
ORDER BY cnm.Name;
```
4. Les pays frontailers de la france (solution avec union)
```sql
SELECT voisins.Name 
FROM Country france 
INNER JOIN Borders b 
ON france.Name='France'  
   AND 
   b.Country1 = france.Code 
INNER JOIN Country voisins 
ON b.Country2=voisins.Code 
UNION 
SELECT voisins.Name 
FROM Country france 
INNER JOIN Borders b 
ON france.Name='France' 
   AND 
   b.Country2 = france.Code 
INNER JOIN Country voisins 
ON b.Country1=voisins.Code;
```
5. Les pays frontailers de la france (solution avec OR)
```sql
SELECT voisins.Name  
FROM Country france 
INNER JOIN Borders b 
ON france.Name='France' 
    AND 
    (
        b.Country1 = france.Code 
        OR 
        b.Country2=france.Code
    ) 
INNER JOIN Country voisins 
ON (
    b.Country2=voisins.Code 
    OR 
    b.Country1=voisins.Code
) 
AND 
voisins.Code<>france.Code;
```
6. La longueuer de la frontière française
```sql
SELECT SUM(b.length) AS LONGUEUR_FRONTIERE_FRANCAISE
FROM Country france 
INNER JOIN Borders b 
ON france.Name='France' 
   AND 
   (
    b.Country1 = france.Code 
    OR 
    b.Country2=france.Code
   ); 
```
7. Pour chaque pays, le nombre de voisins
```sql
SELECT c.Name, COUNT(b.length) 
FROM Country c 
INNER JOIN Borders b 
ON (
        c.Code=b.Country1 
        OR 
        c.Code=b.Country2
    ) 
GROUP BY c.Name
ORDER BY c.Name;
```
8. Pour chaque pats, la population totale de ses voisins
```sql
SELECT c.Name, SUM(voisins.population) 
FROM Country c 
INNER JOIN Borders b 
ON (
        c.Code=b.Country1 
        OR 
        c.Code=b.Country2
    ) 
INNER JOIN Country voisins 
ON (
        voisins.Code=b.Country1 
        OR 
        voisins.Code=b.Country2
    ) 
    AND 
    voisins.Code<>c.Code 
GROUP BY c.Name 
ORDER BY c.Name;
```
9. Pour chaque pays d'Europe, la population totale de ses voisins
```sql
SELECT paysEurope.Name, 
       SUM(voisins.Population) 
FROM Encompasses codePaysEurope 
INNER JOIN Country paysEurope 
ON codePaysEurope.Continent='Europe' 
   AND 
   codePaysEurope.Country=paysEurope.Code 
INNER JOIN Borders b 
ON b.Country1=paysEurope.Code 
    OR 
    b.Country2=paysEurope.Code 
INNER JOIN Country voisins 
ON (
        voisins.Code=b.Country1 
        OR 
        voisins.Code=b.Country2
    ) 
    AND 
    voisins.Code <> paysEurope.Code 
GROUP BY paysEurope.Name 
ORDER BY paysEurope.Name;
```
10. Les organisaitons, avec le nombre de membre et de population totale
```sql
SELECT o.Name AS Oganization_Name,
       COUNT(members.Country) AS Number_of_members,
       SUM(memberCountries.Population) AS Total_population_of_members
FROM Organization o 
INNER JOIN isMember members 
ON members.Organization=o.Abbreviation 
INNER JOIN Country memberCountries 
ON memberCountries.Code=members.Country 
GROUP BY o.Name 
ORDER BY o.Name;
```
11. Les organisations regroupant plus de 100 pays,avec le nombre de membres et de population totale
```sql
SELECT o.Name AS Oganization_Name, 
       COUNT(members.Country) AS Number_of_members,
       SUM(memberCountries.Population) AS Total_population_of_members 
FROM Organization o 
INNER JOIN isMember members 
ON members.Organization=o.Abbreviation 
INNER JOIN Country memberCountries 
ON memberCountries.Code=members.Country 
GROUP BY o.Name 
HAVING COUNT(members.Country)>100 
ORDER BY o.Name;
```
12. Les pays d'Amérique avec leur plus haute montagne 
```sql
SELECT countryMaxMountain.Country_name, 
       Mountain.Name as Mountain_name, 
       countryMaxMountain.Max_height 
FROM (
        SELECT paysAmerique.Name as Country_name,
               MAX(mountains.Height) AS Max_height
        FROM Encompasses codePaysAmerique 
        INNER JOIN Country paysAmerique 
        ON codePaysAmerique.Continent='America' 
           AND
           codePaysAmerique.Country=paysAmerique.Code 
        INNER JOIN Geo_Mountain gm 
        ON gm.Country=codePaysAmerique.Country 
        INNER JOIN Mountain mountains 
        ON gm.Mountain=mountains.Name 
        GROUP BY (paysAmerique.Name)
    ) countryMaxMountain 
    INNER JOIN Mountain 
    ON Mountain.Height=countryMaxMountain.Max_height
    ORDER BY countryMaxMountain.Country_name;
```

**Bonus** Pour chaque pays, la longueur de la frontière 
```sql
SELECT c.Name, SUM(b.length) 
FROM Country c 
INNER JOIN Borders b 
ON (
        c.Code=b.Country1 
        OR 
        c.Code=b.Country2
    ) 
GROUP BY c.Name 
ORDER BY c.Name;
```

**Bonus** Les noms des pays d'Europe
```sql
SELECT paysEurope.Name 
FROM Encompasses codePaysEurope 
INNER JOIN Country paysEurope 
ON codePaysEurope.Continent='Europe' 
    AND
    codePaysEurope.Country=paysEurope.Code;
```

**Bonus** Les noms des pays d'Amérique
```sql
SELECT paysAmerique.Name 
FROM Encompasses codePaysAmerique 
INNER JOIN Country paysAmerique
ON codePaysAmerique.Continent='America' 
    AND
    codePaysAmerique.Country=paysAmerique.Code;
```

**Bonus** Tous les montagnes des pays d'Amérique
```sql
SELECT paysAmerique.Name,mountains.Name,mountains.Height 
FROM Encompasses codePaysAmerique 
INNER JOIN Country paysAmerique 
ON codePaysAmerique.Continent='America' 
    AND
    codePaysAmerique.Country=paysAmerique.Code 
INNER JOIN Geo_Mountain gm 
ON gm.Country=codePaysAmerique.Country 
INNER JOIN Mountain mountains 
ON gm.Mountain=mountains.Name;
```