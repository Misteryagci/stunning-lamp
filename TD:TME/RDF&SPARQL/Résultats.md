# TME RDF et SPARQL

[Kaan Yagci](https://kaanyagci.com) <kaan@kaanyagci.com>

L'énoncé de cette TME peut être trouvé [ici](http://www-bd.lip6.fr/wiki/site/enseignement/master/mlbda/tmes/rdf_et_sparql)

## Exercices 

### Exercice facultatif
Construire des requêtes SPARQL à partir des motifs de l'exercice 2 du TD et les tester sur les triplets du fichier **Ex2.ttl**.

### Exercice obligatoire
Reprendre les exercices 3 et 4 du TD en utilisant, respectivement, les triplets des fichiers Ex3.ttl et Ex4.ttl. Vous pouvez utiliser les fichiers qx_Ex3.spl et qx_Ex4.spl fournis. Écrivez chaque requête dans un fichier séparé.

#### Exercice 3

#### **Q1.a** : Extraire l’ensemble des IRI des sujets

```sparql

    A COMPLETER

```


#### **Q1.b** : Idem en retournant les nom locaux

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT DISTINCT ?nom WHERE {
    ?nom ?relation ?personne.
    }
```

**Résultat attendu**

```shell
    ---------------
    | nom         |
    ===============
    | :nyc        |
    | :mi         |
    | :J.Horrow   |
    | :monica     |
    | :liz        |
    | :cmu        |
    | :larry      |
    | :ucsb       |
    | :luke       |
    | :robert     |
    | :suzan      |
    | :john       |
    | :Jim        |
    | :pittsburgh |
    | :richard    |
    | :dan        |
    | :mit        |
    ---------------
```
#### **Q2** : Même question avec les prédicats

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?relation
    WHERE
    {
        ?person ?relation ?person1
    }
```

**Résultat attendu**

```shell
    -----------------
    | relation      |
    =================
    | rdf:type      |
    | :studiedAt    |
    | :supervisedBy |
    | :friend       |
    | :livesIn      |
    | :hasFather    |
    | :hasMother    |
    | :hasBrother   |
    | :locatedAt    |
    | :hasDegree    |
    | rel:ChildOf   |
    -----------------
```


#### **Q3** : Les villes citées dans des triples de cette base.

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?ville
    WHERE
    {
        ?attribute :livesIn|:locatedAt ?ville 
    }
```

**Résultat attendu**

```shell
    ------------------
    | ville          |
    ==================
    | :santaBarbara  |
    | :pittsburgh    |
    | :westLafayette |
    | :nyc           |
    ------------------
```

#### **Q4** :  Les personnes qui ont étudié dans la même université que l’un de leur parents (sans prendre en compte la propriété childOf).

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?personne
    WHERE
    {
        ?personne a ?personType .
        FILTER (?personType IN (:Person, :Artist)) .
        ?personne :hasMother|:hasFather ?parent .
        ?personne :studiedAt ?place .
        ?parent :studiedAt ?place
    }
```

**Résultat attendu**

```shell
    ------------
    | personne |
    ============
    | :liz     |
    | :john    |
    | :larry   |
    ------------
```

#### **Q5** : Les personnes qui ont étudié dans une université où leur deux parents ont étudié.

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?personne
    WHERE
    {
        ?personne a ?personType .
        FILTER (?personType IN (:Person, :Artist)) .
        ?personne :hasMother ?mother .
        ?personne :hasFather ?father .
        ?personne :studiedAt ?place .
        ?mother :studiedAt ?place .
        ?father :studiedAt ?place
    }
```

**Résultat attendu**

```shell
    ------------
    | personne |
    ============
    | :liz     |
    ------------
```

#### **Q6** : Donnez les personnes qui ont étudié dans une université où aucun de leur parent n’a étudié.

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?personne
    WHERE
    {
        ?personne a ?personType .
        FILTER (?personType IN (:Person, :Artist)) .
        ?personne :hasMother ?mother .
        ?personne :hasFather ?father .
        ?personne :studiedAt ?place .
        ?mother :studiedAt ?pplace .
        ?father :studiedAt ?pplace .
        FILTER NOT EXISTS {?personne :studiedAt ?pplace}
    }
```

**Résultat Attendu**

```shell
    ------------
    | personne |
    ============
    ------------
```

#### **Q7** : Donnez les noms et les universités des personnes qui ont au moins un frère ou une soeur

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?personne ?universite
    WHERE
    {
        ?personne a ?personType .
        FILTER (?personType IN (:Person, :Artist)) .
        ?personne ?siblingPredicate ?sibling
        FILTER (?siblingPredicate IN (:hasBrother, :hasSister)) .
        ?personne :studiedAt ?universite
    }
```

**Résultat attendu**

```shell
    -------------------------
    | personne | universite |
    =========================
    | :liz     | :cmu       |
    | :john    | :ucsd      |
    -------------------------
```

#### **Question subsidiaire** : Donnez les noms et les universités des personnes qui ont au moins un frère ou une soeur et qui n'ont pas de frère ou de soeur qui ont étudié à la même université qu'elles.

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?personne ?universite
    WHERE
    {
        ?personne a ?personType .
        FILTER (?personType IN (:Person, :Artist)) .
        ?personne ?siblingPredicate ?sibling
        FILTER (?siblingPredicate IN (:hasBrother, :hasSister)) .
        ?personne :studiedAt ?universite .
        FILTER NOT EXISTS { ?sibling :studiedAt ?universite }
    }
```

**Résultat attendu**

```shell
    -------------------------
    | personne | universite |
    =========================
    | :liz     | :cmu       |
    | :john    | :ucsd      |
    -------------------------
```

#### **Q8** : Extraire les personnes qui étudient dans une ville différente de celle où ils habitent.

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?personne
    WHERE
    {
        ?personne a ?personType .
        FILTER (?personType IN (:Person, :Artist)) .
        ?personne :studiedAt ?enseignement .
        ?personne :livesIn ?bled
        FILTER NOT EXISTS { ?enseignement :locatedAt ?bled }
    }
```

**Résultat attendu**

```shell
    ------------
    | personne |
    ============
    | :liz     |
    ------------
```
#### **Q9** : Extraire les personnes qui sont ami(e)s d’un(e) ami(e) de Liz. **Remarque** : ne pas retourner Liz et les ami(e)s direct(e)s de Liz!

```sparql
    base <http://example.org>
    prefix foaf: <http://xmlns.com/foaf/0.1/> 
    prefix rel: <http://www.perceive.net/schemas/relationship/> 
    prefix : <http://example.org/> 
    prefix rdf: <http://www.w3.org/1999/02/22-rdf-syntax-ns#> 
    prefix univ: <http://www.faculty.ac> 

    SELECT distinct ?amisDeAmisDeLiz
    WHERE
    {
    {
        {?amisDeLiz :friend :liz} UNION
        {:liz :friend ?amisDeLiz}
    } .
    {
        {?amisDeLiz :friend ?amisDeAmisDeLiz} UNION
        {?amisDeAmisDeLiz :friend ?amisDeLiz}
    } . 
    FILTER NOT EXISTS { {?amisDeAmisDeLiz :friend :liz } UNION {:liz :friend ?amisDeAmisDeLiz }} .
    FILTER (?amisDeAmisDeLiz NOT IN (:liz))
    }
```
**Résultat Attendu**

```shell
-------------------
| amisDeAmisDeLiz |
===================
| :john           |
-------------------
```