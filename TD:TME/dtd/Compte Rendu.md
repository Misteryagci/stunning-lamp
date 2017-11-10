## Exercice 1: DTD: Validataion du modèle de contenu

Soit le DTD des documents est le suivant :

```dtd
<?xml version="1.0" encoding="ISO-8859-1"?>
            <!ELEMENT XXX (AAA? , BBB+)>
            <!ELEMENT AAA (CCC? , DDD*)>
            <!ELEMENT BBB (CCC , DDD)>
            <!ELEMENT CCC (#PCDATA)>
            <!ELEMENT DDD (#PCDATA)>
```

- **Verification des documents**
    + **Document1.xml**

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
     <!DOCTYPE XXX SYSTEM "document.dtd">
                   <XXX>
                          <AAA>
                               <CCC/><DDD/>
                          </AAA>
                          <BBB>
                               <CCC/><DDD/>
                          </BBB>
 </XXX>
```

Le document est valide
    
+ **Document2.xml**
    
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
               <XXX>
                      <AAA>
                           <CCC/><CCC/>
                           <DDD/><DDD/>
                      </AAA>
                      <BBB>
                           <CCC/><DDD/>
                      </BBB>
               </XXX>
```

Le document initial n'est pas valide. L'élément AAA est définit avec (CCC?,DDD*) dans le fichier dtd mais dans le document on a (CCC,CCC,DDD,DDD) qui est une violation au dtd. Donc on doit le corriger en supprimant une des élements CCC dans l'élément AAA. Donc on obtient 
    
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
               <XXX>
                      <AAA>
                           <CCC/>
                           <DDD/><DDD/>
                      </AAA>
                      <BBB>
                           <CCC/><DDD/>
                      </BBB>
               </XXX>
```

qui est valide.
    
+ **Document3.xml**
    
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
               <XXX>
                      <Bbb>
                           <CCC/><DDD/>
                      </BBB>
                 </XXX>
```

Le document initial n'est pas valide. Il y a une erreur de balise. Le balise ```<Bbb>``` et le balise ```</BBB>``` ne correspondent pas. Ainsi l'élément ```<Bbb>``` n'est même pas défini dans le DTD. Pour cela il faut changer ```<Bbb>``` avec ```<BBB>```.On obtient donc:

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
               <XXX>
                      <BBB>
                           <CCC/><DDD/>
                      </BBB>
                 </XXX>
```

qui est une document valide.
    
+ **Document4.xml**
    
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
               <XXX>
                      <AAA/>
                      <BBB/>
                 </XXX>
```

Le document n'est pas valide. L'élément BBB est défini comme (CCC,DDD) d'après le dtd. Il fait donc ajouter ces éléments dans l'élément BBB. On obtient:

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
               <XXX>
                      <AAA/>
                      <BBB>
                        <CCC/>
                        <DDD/>
                      </BBB>
                 </XXX>
```

+ **Document5.xml**
    
```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
      <!DOCTYPE XXX SYSTEM "document.dtd">
          <XXX>
                      <AAA>
                      <BBB>
                           <CCC/><DDD/>
                      </BBB>
               </XXX>
```

 Le documennt n'est pas valide. La balise fermant de l'élément AAA n'existe pas. Il faut donc en ajouter. On a donc:

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
    <!DOCTYPE XXX SYSTEM "document.dtd">
           <XXX>
                    <AAA></AAA>
                     <BBB>
                        <CCC/><DDD/>
                     </BBB>
            </XXX>
```

## Exercice 2: Définition des éléments et des attributs d’un type de données

### Question 1: 

Définir une DTD (fichier ville.dtd) correspondant à la classe Ville du schéma objet telle que les objets complexes (ville et plus beau monument) et les attributs (nom, département et tarif) soient représentés par des éléments XML.

Le fichier ville.dtd est le suivant : 

```dtd
<?xml version="1.0" encoding="ISO-8859-1"?>
    <!ELEMENT ville (plusBeauMonument) >
    <!ATTLIST ville name CDATA #REQUIRED>
    <!ATTLIST ville departement CDATA #REQUIRED>
    <!ELEMENT plusBeauMonument EMPTY >
    <!ATTLIST plusBeauMonument name CDATA #REQUIRED>
    <!ATTLIST plusBeauMonument tarif CDATA #REQUIRED>
```

Ecrire le guide (ville.xml) conforme à la DTD ville.dtd , en ajoutant la ville Paris, département 75. Le plus beau monument de Paris est le Louvre dont l’entrée coûte 8 €. 

```xml
 <?xml version="1.0" encoding="ISO-8859-1"?>
    <!DOCTYPE ville SYSTEM "ville.dtd">

    <ville name='Paris' departement='75'>
        <plusBeauMonument name='le Louvre' tarif='8€'/>
    </ville>
```

### Question 2 : 

Définir une deuxième DTD (ville2.dtd) correspondant au type Ville du schéma telle que :

- un élément XML représente un objet complexe (Ville)
- un attribut XML représente un attribut atomique (nom, département, tarif, ...)

Le fichier ville2.dtd est le suivant :

```dtd
<?xml version="1.0" encoding="ISO-8859-1"?>
    <!ELEMENT ville EMPTY >
    <!ATTLIST ville name CDATA #REQUIRED>
    <!ATTLIST ville tarif CDATA #REQUIRED>
    <!ATTLIST ville plusBeauMonument CDATA #REQUIRED>
```

Ecrire le guide (ville2.xml) conforme à la DTD ville2.dtd et contenant la ville Paris avec son plus beau monument

```xml
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE ville SYSTEM "ville2.dtd">
<ville name='Paris' plusBeauMonument='Le Louvre' tarif='8€'/>
```

### Question 3 :

Définir la DTD restaurant.dtd pour représenter un restaurant avec ses menus.

```dtd
<?xml version="1.0" encoding="ISO-8859-1"?>
<!ELEMENT restaurant (ville,menus)>
<!ELEMENT menus (menu*)>
<!ELEMENT menu EMPTY>
<!ELEMENT ville EMPTY>
<!ATTLIST restaurant nom CDATA #REQUIRED>
<!ATTLIST restaurant ville IDREF #REQUIRED>
<!ATTLIST restaurant fermeture CDATA #REQUIRED>
<!ATTLIST restaurant etoile CDATA #REQUIRED>
<!ATTLIST menu nom CDATA #REQUIRED>
<!ATTLIST menu prix CDATA #REQUIRED>
<!ATTLIST ville name ID #REQUIRED>
```

Ecrire le guide restaurant.xml pour qu’il contienne le restaurant universitaire de Paris, sans étoile, fermé le
week-end, dont le menu unique coûte 2 €..

```xml  
<?xml version="1.0" encoding="ISO-8859-1"?>
<!DOCTYPE restaurant SYSTEM "restaurant.dtd">
<restaurant nom='restaurant universitaire de Paris' ville='Paris' fermeture='Le week-end' etoile='0'>
    <ville name="Paris"></ville>
     <menus>
        <menu nom='Menu unique' prix='2€'></menu>
    </menus>
</restaurant>
```

### Question 4:

Définir la DTD (base1.dtd) la plus simple possible qui valide le document base1.xml (sans modifier les données de
base1.xml) Voici le document base1.dtd:

```dtd
<?xml version="1.0" encoding="ISO-8859-1"?>
<!ELEMENT base (restaurant|ville)* >
<!ELEMENT ville (plusBeauMonument?) >
<!ATTLIST ville nom ID #REQUIRED>
<!ATTLIST ville departement CDATA #REQUIRED>
<!ELEMENT plusBeauMonument EMPTY >
<!ATTLIST plusBeauMonument nom CDATA #REQUIRED>
<!ATTLIST plusBeauMonument tarif CDATA #REQUIRED>
<!ELEMENT restaurant (fermeture?,menu+)>
<!ATTLIST restaurant nom CDATA #REQUIRED>
<!ATTLIST restaurant ville IDREF #REQUIRED>
<!ATTLIST restaurant etoile CDATA #REQUIRED>
<!ELEMENT menu EMPTY>
<!ATTLIST menu nom CDATA #REQUIRED>
<!ATTLIST menu prix CDATA #REQUIRED>
<!ELEMENT fermeture (#PCDATA)>
```

## Exercice 4: DTD avec contrainte d’intégrité

### Question 1 :

Définir une DTD (fichier contrainte.dtd) qui permet de valider les contraintes suivantes :

- **C1 :** un restaurant a toujours au moins 2 menus

```dtd
<!ELEMENT restaurant (fermeture?,menu,menu+)>
```

- **C2 :** une ville peut avoir un plus beau monument, certaines villes n’en ont pas.

```dtd
<!ELEMENT ville (plusBeauMonument?)>
```

- **C3 :** un monument a toujours un nom et un tarif

```dtd
<!ATTLIST plusBeauMonument nom CDATA #REQUIRED>
<!ATTLIST plusBeauMonument tarif CDATA #REQUIRED>
```

- **C4 :** une ville a toujours un nom et un département

```dtd
<!ATTLIST ville nom ID #REQUIRED>
<!ATTLIST ville departement CDATA #REQUIRED>
```

- **C5 :** un restaurant a entre 0 et 3 étoiles

```dtd
<!ATTLIST restaurant etoile (0|1|2|3) #REQUIRED>
```

- **C6 :** la ville d’un restaurant doit exister dans la base (i.e., il doit exister un élément ville pour chaque nom de ville référencé dans un élément restaurant)

```dtd
 <!ATTLIST restaurant ville IDREF #REQUIRED>
```

### Question 2 : 

Le document base-sans-contrainte.xml ne respectant pas les contraintes ci-dessus, vérifiez que la
validation du document base-sans-contrainte.xml produit 6 erreurs
Pour chaque erreur, indiquez quelle est la contrainte non respectée. 

**Erreur N°1**
```console
base-sans-contrainte.xml:4: element restaurant: validity error : Value "4" for attribute etoile of restaurant is not among the enumerated set
  <restaurant nom="la tour d'argent" etoile="4" ville="Paris">
```
**Explication N°1**: À la ligne 4, l'étoile à la valeur 4. *Violation de la contrainte 5*.

**Erreur N°2**
```console                                                             ^
base-sans-contrainte.xml:7: element restaurant: validity error : Element restaurant content does not follow the DTD, expecting (fermeture? , menu , menu+), got (fermeture menu )
  </restaurant>
               ^
```
**Explication N°2**: À la ligne 7, dans l'élément restaurant il n'y en a qu'une seule. *Violation de la contrainte 1*

**Erreur N°3**
```console
base-sans-contrainte.xml:12: element ville: validity error : Element ville content does not follow the DTD, expecting (plusBeauMonument)?, got (plusBeauMonument plusBeauMonument )
  </ville>
          ^
```
**Explication N°3**:

**Erreur N°4**
```console
base-sans-contrainte.xml:12: element ville: validity error : Element ville does not carry attribute departement
  </ville>
          ^
```
**Explication N°4**: À la ligne 12 l'élément ville ne contient pas d'attribut département. *Violation de la contrainte 4*

**Erreur N°5**
```console
base-sans-contrainte.xml:30: element plusBeauMonument: validity error : Element plusBeauMonument does not carry attribute tarif
    <plusBeauMonument nom="le pont" />
                                      ^
```
**Explication N°5**: À la ligne 30, l'élément plusBeauMonument ne contient pas d'attribut tarif. *Violation de la contrainte 3*

**Erreur N°6**
```console
base-sans-contrainte.xml:20: element restaurant: validity error : IDREF attribute ville references an unknown ID "Marseille"
```
**Explication N°6**: À la ligne 20, l'élement restaurant fait référence à une ville dont son id est 'Marseille' mais qui n'est pas définit dans le document. *Violation de la contrainte 6*







    