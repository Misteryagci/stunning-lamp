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
13. Les affluents direct du Nil: tous les fleuves qui se jettent dans le Nil
```sql
SELECT affluentsDirect.Name 
FROM River nile 
INNER JOIN River affluentsDirect 
ON nile.Name='Nile' 
   AND
   affluentsDirect.River = nile.Name;
```
14. Tous les affluents du Nil:ceux qui s'écoulent direcement ou indirectement dans le nil *(les affluents des affluents des affluents du Nil n’ont aucun affluent)*
```sql
SELECT affluentsInDirect.Name AS Affluents_direct_et_indirect 
FROM River nile 
INNER JOIN River affluentsDirect 
ON nile.Name='Nile' 
   AND 
   affluentsDirect.River = nile.Name 
INNER JOIN River affluentsIndirect 
ON affluentsDirect.Name=affluentsIndirect.River 
UNION 
SELECT affluentsDirect.Name AS Affluents_direct_et_indirect 
FROM River nile 
INNER JOIN River affluentsDirect 
ON nile.Name='Nile' 
   AND 
   affluentsDirect.River = nile.Name 
UNION 
SELECT affluentsAffluentsInDirect.Name AS Affluents_direct_et_indirect 
FROM River nile 
INNER JOIN River affluentsDirect 
ON nile.Name='Nile' 
   AND
   affluentsDirect.River = nile.Name 
INNER JOIN River affluentsIndirect 
ON affluentsDirect.Name=affluentsIndirect.River 
INNER JOIN River affluentsAffluentsInDirect 
ON affluentsAffluentsInDirect.River=affluentsInDirect.Name;
```
15. La longueur totale des cours d'eau aliment le Nil, Nil inclus
```sql
SELECT SUM(Length_direct_et_indirect) AS Longueur_totale 
FROM (
        SELECT affluentsInDirect.Length AS Length_direct_et_indirect 
        FROM River nile 
        INNER JOIN River affluentsDirect
        ON nile.Name='Nile' 
           AND 
           affluentsDirect.River = nile.Name 
        INNER JOIN River affluentsIndirect 
        ON affluentsDirect.Name=affluentsIndirect.River 
        UNION 
        SELECT affluentsDirect.Length AS Length_direct_et_indirect 
        FROM River nile 
        INNER JOIN River affluentsDirect 
        ON nile.Name='Nile' 
           AND 
           affluentsDirect.River = nile.Name 
        UNION 
        SELECT affluentsAffluentsInDirect.Length AS Length_direct_et_indirect
        FROM River nile 
        INNER JOIN River affluentsDirect 
        ON nile.Name='Nile' 
           AND affluentsDirect.River = nile.Name 
        INNER JOIN River affluentsIndirect 
        ON affluentsDirect.Name=affluentsIndirect.River 
        INNER JOIN River affluentsAffluentsInDirect 
        ON affluentsAffluentsInDirect.River=affluentsInDirect.Name 
        UNION 
        SELECT nile.Length AS Length_direct_et_indirect 
        FROM River nile 
        WHERE nile.Name='Nile'
    );
```
16. 1. La plus grande organisation en termes de nombre de pays membre
```sql
SELECT * 
FROM (
        SELECT o.Name AS Oganization_Name, 
               COUNT(members.Country) AS Number_of_members 
        FROM Organization o 
        INNER JOIN isMember members 
        ON members.Organization=o.Abbreviation 
        GROUP BY o.Name 
        ORDER BY Number_of_members DESC
    ) 
WHERE ROWNUM=1;
```
    2. Les 3 plus grandes organisations en termes de nombre de pays membre
```sql
SELECT * 
FROM (
        SELECT o.Name AS Oganization_Name, 
               COUNT(members.Country) AS Number_of_members 
        FROM Organization o 
        INNER JOIN isMember members 
        ON members.Organization=o.Abbreviation 
        GROUP BY o.Name 
        ORDER BY Number_of_members DESC
    ) 
WHERE ROWNUM<4;
```
17. La densité de population (exprimée en nombre d'habitants par km2) formée de l'Algérie et la Lybie ainsi que de tous leurs voisins directs.
```sql
SELECT SUM(Country_Population)/SUM(Country_surface) AS DENSITE_POPULATION 
FROM (
        SELECT algerie.Name AS Country_Name,
               algerie.Code AS Country_Code,
               algerie.Population AS Country_Population,
               algerie.Area AS Country_surface
        FROM Country algerie
        WHERE algerie.Name='Algeria'
        UNION
        SELECT Lybie.Name AS Country_Name,
               Lybie.Code AS Country_Code,
               Lybie.Population AS Country_Population,
               Lybie.Area AS Country_surface
        FROM Country Lybie
        WHERE Lybie.Name='Libya'
        UNION
        SELECT voisinsAlgerie.Name as Country_Name,
               voisinsAlgerie.Code as Country_Code,
               voisinsAlgerie.Population as Country_Population,
               voisinsAlgerie.Area as Country_surface
        FROM Country algerie 
        INNER JOIN Borders bordersAlgerie
        ON algerie.Name='Algeria'
           AND
           (
                algerie.Code=bordersAlgerie.Country1
                OR
                algerie.Code=bordersAlgerie.Country2
           )
        INNER JOIN Country voisinsAlgerie
        ON (
                voisinsAlgerie.Code=bordersAlgerie.Country1
                OR
                voisinsAlgerie.Code=bordersAlgerie.Country2
           )
           AND
           voisinsAlgerie.Code <> algerie.Code
        UNION
        SELECT voisinsLybie.Name as Country_Name,
               voisinsLybie.Code as Country_Code,
               voisinsLybie.Population as Country_Population,
               voisinsLybie.Area as Country_surface
        FROM Country lybie 
        INNER JOIN Borders bordersLybie
        ON lybie.Name='Libya'
           AND
           (
                lybie.Code=bordersLybie.Country1
                OR
                lybie.Code=bordersLybie.Country2
           )
        INNER JOIN Country voisinsLybie
        ON (voisinsLybie.Code=bordersLybie.Country1
                OR
                voisinsLybie.Code=bordersLybie.Country2)
           AND
           voisinsLybie.Code <> lybie.Code
    );
```
18. Idem mais en enlevant tous les déserts de la zone en question
```sql
SELECT (SUM(z.Country_population)/(SUM(z.Country_Surface)-SUM(deserts.Desert_surface))) AS Densite_sans_deserts
FROM (
        SELECT desertsDeZone.Name as Desert_name,
               desertsDeZone.Area as Desert_surface
        FROM Geo_Desert geoDesertsDeZone
        INNER JOIN (
                        SELECT algerie.Name AS Country_Name,
                               algerie.Code AS Country_Code,
                               algerie.Population AS Country_Population,
                               algerie.Area AS Country_surface
                        FROM Country algerie
                        WHERE algerie.Name='Algeria'
                        UNION
                        SELECT Lybie.Name AS Country_Name,
                               Lybie.Code AS Country_Code,
                               Lybie.Population AS Country_Population,
                               Lybie.Area AS Country_surface
                        FROM Country Lybie
                        WHERE Lybie.Name='Libya'
                        UNION
                        SELECT voisinsAlgerie.Name as Country_Name,
                               voisinsAlgerie.Code as Country_Code,
                               voisinsAlgerie.Population as Country_Population,
                               voisinsAlgerie.Area as Country_surface
                        FROM Country algerie 
                        INNER JOIN Borders bordersAlgerie
                        ON algerie.Name='Algeria'
                           AND
                           (
                                algerie.Code=bordersAlgerie.Country1
                                OR
                                algerie.Code=bordersAlgerie.Country2
                           )
                        INNER JOIN Country voisinsAlgerie
                        ON (
                                voisinsAlgerie.Code=bordersAlgerie.Country1
                                OR
                                voisinsAlgerie.Code=bordersAlgerie.Country2
                           )
                           AND
                           voisinsAlgerie.Code <> algerie.Code
                        UNION
                        SELECT voisinsLybie.Name as Country_Name,
                               voisinsLybie.Code as Country_Code,
                               voisinsLybie.Population as Country_Population,
                               voisinsLybie.Area as Country_surface
                        FROM Country lybie 
                        INNER JOIN Borders bordersLybie
                        ON lybie.Name='Libya'
                           AND
                           (
                                lybie.Code=bordersLybie.Country1
                                OR
                                lybie.Code=bordersLybie.Country2
                           )
                        INNER JOIN Country voisinsLybie
                        ON (voisinsLybie.Code=bordersLybie.Country1
                                OR
                                voisinsLybie.Code=bordersLybie.Country2)
                           AND
                           voisinsLybie.Code <> lybie.Code
                    ) zone
        ON zone.Country_Code = geoDesertsDeZone.Country
        INNER JOIN Desert desertsDeZone
        ON desertsDeZone.Name = geoDesertsDeZone.Desert
     ) deserts,
     (
        SELECT algerie.Name AS Country_Name,
               algerie.Code AS Country_Code,
               algerie.Population AS Country_Population,
               algerie.Area AS Country_surface
        FROM Country algerie
        WHERE algerie.Name='Algeria'
        UNION
        SELECT Lybie.Name AS Country_Name,
               Lybie.Code AS Country_Code,
               Lybie.Population AS Country_Population,
               Lybie.Area AS Country_surface
        FROM Country Lybie
        WHERE Lybie.Name='Libya'
        UNION
        SELECT voisinsAlgerie.Name as Country_Name,
               voisinsAlgerie.Code as Country_Code,
               voisinsAlgerie.Population as Country_Population,
               voisinsAlgerie.Area as Country_surface
        FROM Country algerie 
        INNER JOIN Borders bordersAlgerie
        ON algerie.Name='Algeria'
           AND
           (
                algerie.Code=bordersAlgerie.Country1
                OR
                algerie.Code=bordersAlgerie.Country2
           )
        INNER JOIN Country voisinsAlgerie
        ON (
                voisinsAlgerie.Code=bordersAlgerie.Country1
                OR
                voisinsAlgerie.Code=bordersAlgerie.Country2
           )
           AND
           voisinsAlgerie.Code <> algerie.Code
        UNION
        SELECT voisinsLybie.Name as Country_Name,
               voisinsLybie.Code as Country_Code,
               voisinsLybie.Population as Country_Population,
               voisinsLybie.Area as Country_surface
        FROM Country lybie 
        INNER JOIN Borders bordersLybie
        ON lybie.Name='Libya'
           AND
           (
                lybie.Code=bordersLybie.Country1
                OR
                lybie.Code=bordersLybie.Country2
           )
        INNER JOIN Country voisinsLybie
        ON (voisinsLybie.Code=bordersLybie.Country1
                OR
                voisinsLybie.Code=bordersLybie.Country2)
           AND
           voisinsLybie.Code <> lybie.Code
     ) z;
```
19. Le pourcentage de croyants de chaque religion dans la population mondiale
```sql
SELECT religions.Religion_name,
       (religions.Nombre_croyants/totalPopulation.total)*100 as Pourcentage
FROM (
        SELECT Religion.Name as Religion_Name,
               SUM((Religion.Percentage * Country.Population)/100) as Nombre_croyants
        FROM Religion
        INNER JOIN Country
        ON Country.Code = Religion.Country
        GROUP BY Religion.Name
        ORDER BY Religion.Name
     ) religions,
     (
        SELECT SUM(Country.population) as total
        FROM Country
     ) totalPopulation
ORDER BY Pourcentage;
```
20. Les couples de pays européens ayant exactement accès aux mêmes mers 

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

