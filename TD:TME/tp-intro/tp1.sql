-- MABD TP1 SQL avec la base MONDIAL


-- -------------------- binome -------------------------
-- NOM : YAGCI
-- Prenom : Kaan

-- NOM
-- Prenom
-- -----------------------------------------------------

-- pour se connecter à oracle:
-- sqlplus E3201099/E3201099@orall

set sqlbl on
set linesize 150

prompt schema de la table Country
desc Country

prompt schema de la table City
desc City

prompt schema de la table IsMember
desc IsMember

prompt schema de la table City
desc City

-- pour afficher un nuplet entier sur une seule ligne
column name format A15
column capital format A15
column province format A20

-- Requete 0
-- La requete qui affiche la ligne correspondant à la France

select * from Country where name = 'France';

-- Requete 1
-- Le nom des pays membres des nations unies trié par nom de pays

select c.Name
from   Country c, Organization o, isMember m
where  c.Code = m.Country 
and    o.Name = 'United Nations'
and    o.Abbreviation = m.Organization
order by (c.Name);

prompt

-- Requete 2
-- Les populations des pays membres des nations unies trié décroissant par population

select c.Population
from   Country c, Organization  o, isMember m
where  c.Code = m.Country 
and    o.Name = 'United Nations'
and    o.Abbreviation = m.Organization
order by (c.Population) desc;

prompt

-- Requete 3
-- Le nom de pays NON membre des nations unies

select c.Name
from Country c
where not exists (
		  select *
		  from isMember m
		  where m.Organization = 'UN'
		  and m.Country = c.Code
		 );

-- Requete 4
-- Les pays frontaliers de la France (solution avec union)

(
  select c.Name
  from Country f, Country c, Borders b
  where f.Name = 'France'
  and f.Code = b.Country1
  and c.Code = b.Country2
) union
(
  select c.Name
  from Country f, Country c, Borders b
  where f.Name = 'France'
  and 	f.Code = b.Country2
  and 	c.code = b.Country1
);

-- Requete 5
-- Les pays frontailers de la France (solution avec OR)

select c.Name
from Country c, Country f, Borders b
where f.Name = 'France'
and ((f.Code = b.Country1 and c.code = b.Country2)
     or
     (f.code = b.Country2 and c.code = b.Country1)
    );

-- Requete 6
-- La longueur de la Frontière Française

select sum(b.Length) as Frontière_Française
from Country f, Country c, Borders b
where f.Name = 'France'
and ((f.Code = b.Country1 and c.code = b.Country2)
     or
     (f.code = b.Country2 and c.code = b.Country1)
    );

-- Requete 7
-- Pour chaque pays, le nombre de voisins Groupé par le nom de pays

select	 c.Name, count(*)
from    Country c, Borders b
where 	c.Code = b.Country1
or 	c.Code = b.Country2
group by c.Name;

-- Requete 8
-- Pour chaque pays, la population totale de ses voisins

select c.Code
from Country c
where exists (	select c1.Code
      	     	from Country c1, Borders b
		where c1.code = b.Country1
		or    c1.code = b.Country2
	     );

-- Requete 9
-- Pour chaque pays d'Europe, la population totale de ses voisins

-- Requete 10
-- Les organisations, avec le nombre de membre de population totale

select o.Abbreviation, count(*),sum(c.Population)
from Organization o, isMember m, Country c
where m.Country = c.Code
and m.Organization = o.Abbreviation
group by o.Abbreviation
order by o.Abbreviation;

-- Requete 11
-- Les organisations regroupent plud de 100 pays, avec le nombre de membre et population totale

-- Solution alternative
select Name, NbMembres, Population
from ( select o.Abbreviation as Name,
       	      count(*) as NbMembres,
	      sum(c.population) as Population
       from Organization o, isMember m, Country c
       where m.country = c.code
       and   m.Organization = o.Abbreviation
       group by (o.Abbreviation)
     )
where NbMembres >= 100
order by Name;

-- Solution avec un HAVING
select o.Abbreviation, count(*),sum(c.Population)
from Organization o, isMember m, Country c
where m.Country = c.Code
and m.Organization = o.Abbreviation
having count(*) > 100
group by o.Abbreviation
order by o.Abbreviation;
