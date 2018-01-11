# TME XQuery : séance 1

Les questions de TME se trouve [ici](http://www-bd.lip6.fr/wiki/site/enseignement/master/mlbda/tmes/xquery1)

## Exercice 1

### Les requêtes de XMark

1. Le nom de la personne dont l'identifiant est “person0”.

```xquery
    //person[@id="person0"]/name
```

**Résultat**

```xml
    <name>Xiulin Poch</name>
```

2. La valeur initiale des trois premières enchères en cours.

```xquery
   for $i in (1 to 3)
    return <result> {//open_auctions/auction[$i]/@id} {//open_auctions/auction[$i]/initial} </result>
```

**Résultat**

```xml
    <result id="open_auction0">
        <initial>112.22</initial>
    </result>
    <result id="open_auction1">
        <initial>145.44</initial>
    </result>
    <result id="open_auction2">
        <initial>93.60</initial>
    </result>
```


3. La valeur de la première et de la dernière augmentation effectuée sur les trois premières des enchères en cours, selon l'ordre des enchères défini dans les données xml (ne pas trier les enchères chronologiquement).

```xquery
    for $li in (1 to 3)
        let $first :=  data(//open_auctions/auction[$li]//bidder[1]/increase)
        let $lastIndex := count(//open_auctions/auction[$li]//bidder)
        let $last := data(//open_auctions/auction[$li]//bidder[$lastIndex]/increase)
        return 
        <result>
        { //open_auctions/auction[$li]/@id }
        <first>{$first}</first>
        <last>{$last}</last>
</result>
```

**Résultat**

```xml
    <result id="open_auction0">
        <first>18.00</first>
        <last>3.00</last>
    </result>
    <result id="open_auction1">
        <first>7.50</first>
        <last>6.00</last>
    </result>
    <result id="open_auction2">
        <first>4.50</first>
        <last>6.00</last>
    </result>
```


4. Le prix des objets vendu à plus de 480.

```xquery
    //closed_auctions/auction[price>480]/price
```

**Résultat**

```xml
    <price>482.90</price>
    <price>617.31</price>
    <price>594.95</price>
    <price>534.37</price>
    <price>494.66</price>
```

5. Le nom des objets du continent africain

```xquery
    //regions/africa/item/name
```

**Résultat**

```xml
    <name>duteous nine eighteen</name>
    <name>condemn</name>
    <name>earnestly subtle spotted attend</name>
    <name>poisons</name>
    <name>thought inland different</name>
    <name>approves</name>
    <name>disguise engross hero restraint</name>
    <name>renown stained entrails bone</name>
    <name>irrevocable holding succeeding</name>
    <name>unloose freshness swallowing</name>
    <name>parson sure heavy</name>
    <name>henceforward decreed</name>
    <name>contain spring fate rebellious</name>
    <name>sour</name>
    <name>canonized piece</name>
    <name>truths</name>
    <name>forced strangle violence apprehends</name>
    <name>sleeps</name>
    <name>nev puts</name>
    <name>hie stirr divine niece</name>
    <name>fie carrying cassio</name>
    <name>bestowed liable congruent everything</name>
    <name>foot</name>
    <name>bewitched proculeius away quoth</name>
    <name>greg house turnips</name>
    <name>tripp beef prepar</name>
    <name>conquer insupportable assurance</name>
    <name>perpetual patient company well</name>
    <name>fair use conveyance</name>
    <name>balthasar bred breathe</name>
    <name>villainy</name>
    <name>buried ere burst</name>
    <name>flourish harms oratory</name>
    <name>esteem observance else</name>
    <name>lecherous mortal</name>
    <name>stake cassandra shake</name>
    <name>relate shame pedant flat</name>
    <name>prudence jewels deserves sacred</name>
```

6. Le nom des objets du continent africain avec leur prix de vente

```xquery
    for $item in //regions/africa/item, $vente in //closed_auctions/auction
where $vente/itemref[@item=data($item/@id)]
return
  <res>
   {$item/name}
   {$vente/price}
   </res>
```

**Résultat**

```xml
    <res>
        <name>condemn</name>
        <price>14.80</price>
    </res>
    <res>
        <name>thought inland different</name>
        <price>141.43</price>
    </res>
    <res>
        <name>disguise engross hero restraint</name>
        <price>93.55</price>
    </res>
    <res>
        <name>irrevocable holding succeeding</name>
        <price>38.59</price>
    </res>
    <res>
        <name>henceforward decreed</name>
        <price>174.92</price>
    </res>
    <res>
        <name>truths</name>
        <price>109.40</price>
    </res>
    <res>
        <name>nev puts</name>
        <price>68.19</price>
    </res>
    <res>
        <name>hie stirr divine niece</name>
        <price>43.54</price>
    </res>
    <res>
        <name>bewitched proculeius away quoth</name>
        <price>35.75</price>
    </res>
    <res>
        <name>greg house turnips</name>
        <price>80.08</price>
    </res>
    <res>
        <name>tripp beef prepar</name>
        <price>4.00</price>
    </res>
    <res>
        <name>conquer insupportable assurance</name>
        <price>249.85</price>
    </res>
    <res>
        <name>fair use conveyance</name>
        <price>34.71</price>
    </res>
    <res>
        <name>balthasar bred breathe</name>
        <price>63.02</price>
    </res>
    <res>
        <name>buried ere burst</name>
        <price>1.90</price>
    </res>
    <res>
        <name>flourish harms oratory</name>
        <price>54.38</price>
    </res>
    <res>
        <name>lecherous mortal</name>
        <price>133.49</price>
    </res>
    <res>
        <name>prudence jewels deserves sacred</name>
        <price>66.68</price>
    </res>
```


7. Le nombre de personnes qui n'ont pas de page web (i.e. les personnes sans élément homepage)

```xquery
    count(//people/person)-count(//people/person/homepage)
```

**Résultat**

`874`

## Exercice 2

1. Donner l’année et le titre des livres publiés par Addison Wesley après 1991.

```xquery
    for $book in //bib/book[@year>1991]
    where data($book/publisher) = 'Addison-Wesley'
    return 
    <book>
        {$book/@year}
        {$book/title}
    </book>
```

**Résultat**

```xml
    <bib>
        <book year="1994">
            <title>TCP/IP Illustrated</title>
        </book>
        <book year="1992">
            <title>Advanced Programming in the Unix environment</title>
        </book>
    </bib>
```

2. Donner la liste de tous les couples (titre, auteur). Un couple est formé par un élément \<result> contenant un titre et un auteur.

```xquery
    <results>
    {
        for $book in //bib/book
        where $book/author
            return 
            <result>
                {$book/title}
                {$book/author}
            </result>
    }
    </results>
```

**Résultat**

```xml
    <results>
        <result>
            <title>TCP/IP Illustrated</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </result>
        <result>
            <title>Advanced Programming in the Unix environment</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </result>
        <result>
            <title>Data on the Web</title>
            <author>
                <last>Abiteboul</last>
                <first>Serge</first>
            </author>
        </result>
        <result>
            <title>Data on the Web</title>
            <author>
                <last>Buneman</last>
                <first>Peter</first>
            </author>
        </result>
        <result>
            <title>Data on the Web</title>
            <author>
                <last>Suciu</last>
                <first>Dan</first>
            </author>
        </result>
    </results>
```

3. Pour chaque livre, donner le titre et les auteurs regroupés dans un élément \<results>.

```xquery
   <results>
        {
        for $livre in //bib/book
        return
            <result>
            {$livre/title}
            {$livre/author}
            </result>
        }
    </results>
```

**Résultat**

```xml
    <results>
        <result>
            <title>TCP/IP Illustrated</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </result>
        <result>
            <title>Advanced Programming in the Unix environment</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </result>
        <result>
            <title>Data on the Web</title>
            <author>
                <last>Abiteboul</last>
                <first>Serge</first>
            </author>
            <author>
                <last>Buneman</last>
                <first>Peter</first>
            </author>
            <author>
                <last>Suciu</last>
                <first>Dan</first>
            </author>
        </result>
        <result>
            <title>The Economics of Technology and Content for Digital TV</title>
        </result>
    </results>
```

4. Pour chaque auteur, donner la liste des titres de ses livres. Un élément du résultat contient un auteur avec tous les
titres qu’il a écrit.

```xquery
    <results>
        {
            for $authorLast in distinct-values(//author/last), $authorFirst in distinct-values(//author/first)
            where //author[first=$authorFirst][last=$authorLast]
                let $author :=  //author[first=$authorFirst][last=$authorLast]
                return
                    <result>
                    { $author[1] }
                    { //book[author=$author]/title }
                    </result>
        }
    </results>
```

**Résultat**

```xml
    <results>
        <result>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
            <title>TCP/IP Illustrated</title>
            <title>Advanced Programming in the Unix environment</title>
        </result>
        <result>
            <author>
                <last>Abiteboul</last>
                <first>Serge</first>
            </author>
            <title>Data on the Web</title>
        </result>
        <result>
            <author>
                <last>Buneman</last>
                <first>Peter</first>
            </author>
            <title>Data on the Web</title>
        </result>
        <result>
            <author>
                <last>Suciu</last>
                <first>Dan</first>
            </author>
            <title>Data on the Web</title>
        </result>
    </results>
```



5. Pour chaque livre de la bibliographie Bib qui a une critique dans Review, donner son titre et tous ses prix.

```xquery
    <books-with-prices>
        {
            let $reviews := doc("/Users/ky/Google Drive/Kisisel/UPMC/MLBDA/TD:TME/XQuery/xquery/review.xml")
            for $book in //book
            where $reviews//entry[title=$book/title]
                return
                    <book-with-prices>
                        { $book/title }
                        <price-review>
                            {data($reviews//entry[title=$book/title]/price)}
                        </price-review>
                        <price-bib>
                            {data($book/price)}
                        </price-bib>
                    </book-with-prices>
        }
    </books-with-prices>
```

**Résultat**

```xml
    <books-with-prices>
        <book-with-prices>
            <title>TCP/IP Illustrated</title>
            <price-review>65.95</price-review>
            <price-bib>65.95</price-bib>
        </book-with-prices>
        <book-with-prices>
            <title>Advanced Programming in the Unix environment</title>
            <price-review>65.95</price-review>
            <price-bib>65.95</price-bib>
        </book-with-prices>
        <book-with-prices>
            <title>Data on the Web</title>
            <price-review>34.95</price-review>
            <price-bib>39.95</price-bib>
        </book-with-prices>
    </books-with-prices>
```


6. Pour chaque livre ayant au moins un auteur, donner le titre et le nom d’au plus deux auteurs. Le nom des auteurs
suivants est remplacé par l’élément \<et-al> (i.e., abréviation latine signifiant et les autres).

```xquery
   for $book in //book 
    where $book/author
    return
      if (count($book/author) >= 1) then (
       if (count($book/author) >= 2) then (
          if (count($book/author) >= 3) then (
           <book>
             {$book/title}
             {$book/author[1]}
             {$book/author[2]}
             <et-al/>
           </book>
       )
       else (
         <book>
           {$book/title}
           {$book/author}
         </book>
       )
       )
       else (
          <book>
           {$book/title}
           {$book/author}
         </book>
       )
      )
     else
     ()
```

**Résultat**

```xml
    <bib>
        <book>
            <title>TCP/IP Illustrated</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </book>
        <book>
            <title>Advanced Programming in the Unix environment</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </book>
        <book>
            <title>Data on the Web</title>
            <author>
                <last>Abiteboul</last>
                <first>Serge</first>
            </author>
            <author>
                <last>Buneman</last>
                <first>Peter</first>
            </author>
            <et-al/>
        </book>
    </bib>
```

7. Donner, dans l’ordre alphabétique, le titre et l’année des livres publiés par Addison-Wesley après 1991.

```xquery
    for $book in //book[publisher = "Addison-Wesley"][@year >1991]
    order by $book/title
        return
            <book>
                {$book/@year}
                {$book/title}
            </book>
```

**Résultat**

```xml
    <bib>
        <book year="1992">
            <title>Advanced Programming in the Unix environment</title>
        </book>
        <book year="1994">
            <title>TCP/IP Illustrated</title>
        </book>
    </bib>
```

8. Quels sont les livres qui ont un élément dont le nom se termine par «or» et dont un sous élément contient la chaîne
«Suciu».

```xquery
    for $book in //book , $b in $book/*
    where ends-with(name($b),"or") and contains($book,"Suciu")
        return $book
```

**Résultat**

```xml
    <book>
        <title>Data on the Web</title>
        <author>
            <last>Suciu</last>
            <first>Dan</first>
        </author>
    </book>
```

9. Dans le livre book.xml, quels sont tous les titres de chapitre ou de section qui contiennent le mot « XML » ?

```xquery
    let $books := doc("/Users/ky/Google Drive/Kisisel/UPMC/MLBDA/TD:TME/XQuery/xquery/book.xml")
    for $title in $books//title
    where contains($title,"XML")
        return $title/..
```

**Résultat**

```xml
    <section>
        <title>XML</title>
        <section>
            <title>Basic Syntax</title>
        </section>
        <section>
            <title>XML and Semistructured Data</title>
        </section>
    </section>
    <section>
        <title>XML and Semistructured Data</title>
    </section>
```

10. Dans le document price.xml, donner le prix le moins cher de chaque livre. Le résultat est une liste d’éléments
\<minprice>.Le titre est un attribut de \<minprice>, le prix est un élément de \<minprice>.

```xquery
    let $prices := doc("/Users/ky/Google Drive/Kisisel/UPMC/MLBDA/TD:TME/XQuery/xquery/price.xml")

    for $title in distinct-values($prices//title)
    let $mp := min($prices//book[title = $title]/price)
    return 
        <minprice title = '{$title}'>
        <price>
            {$mp}
        </price>
        </minprice>
```

**Résultat**

```xml
    <results>
        <minprice title="Advanced Programming in the Unix environment">
            <price>65.95</price>
        </minprice>
        <minprice title="TCP/IP Illustrated">
            <price>65.95</price>
        </price>
        <minprice title="Data on the Web">
            <price>34.95</price>
        </minprice>
    </results>
```

11. Pour chaque livre avec au moins un auteur, donner le titre et les auteurs, pour chaque livre avec un éditeur, donner
une référence contenant le titre du livre et l’affiliation de l’éditeur.

```xquery
    <bib>
        {
            for $ba in //book
                where $ba/author
                return 
                    <book>
                    {$ba/title}
                    {$ba/author}
                    </book>
        }
        {
            for $be in //book
                where $be/editor
                return 
                    <reference>
                    {$be/title}
                    {$be/editor/affiliation}
                    </reference>
        }
    </bib>
```

**Résultat**

```xml
    <bib>
        <book>
            <title>TCP/IP Illustrated</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </book>
        <book>
            <title>Advanced Programming in the Unix environment</title>
            <author>
                <last>Stevens</last>
                <first>W.</first>
            </author>
        </book>
        <book>
            <title>Data on the Web</title>
            <author>
                <last>Abiteboul</last>
                <first>Serge</first>
            </author>
            <author>
                <last>Buneman</last>
                <first>Peter</first>
            </author>
            <author>
                <last>Suciu</last>
                <first>Dan</first>
            </author>
        </book>
        <reference>
            <title>The Economics of Technology and Content for Digital TV</title>
            <affiliation>CITI</affiliation>
        </reference>
    </bib>
```

12. Trouver les paires de livres qui ont les mêmes auteurs et des titres différents. Ne pas tenir compte de l’ordre des auteurs

```xquery
   <bib>
        {
            for $book1 in //book , $book2 in //book
            where $book1/author = $book2/author and  index-of(//book,$book1) < index-of(//book,$book2)
                return
                    <book-pair>
                    { $book1/title }
                    { $book2/title }
                    </book-pair>
        }
    </bib>
```

**Résultat**

```xml
    <bib>
        <book-pair>
            <title>TCP/IP Illustrated</title>
            <title>Advanced Programming in the Unix environment</title>
        </book-pair>
    </bib>
```