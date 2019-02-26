---
title: "A Gateway to collaboration"
created_at: 26-02-2019
description: Het ProjectenProject
author: Arne Bertrand
---
> Ik wil meedoen met een zeus project, hoe doe?

Het is een vraag die enorm vaak voorkomt en verbazend moeilijk te 
beantwoorden is. De keuze van het project op zich is vaak al lastig. 
Welke technologie wil ik gebruiken? Welke projecten zijn nog relevant?
Welk project heeft het meeste hulp nodig? Het zijn stuk voor stuk aspecten
die meespelen en elkaar vaak tegenspreken.

Eens een project gekozen, komt er vaak nog een hele boterham setup bij kijken
die, we moeten het eerlijk toegeven, niet altijd goed gedocumenteerd is.
Eens dan eindelijk de setup voltooid is, komt nog het moeilijkste deel:
het selecteren van een issue die:

- relevant is
- binnen je niveau ligt
- enigszins doenbaar is in de beperkte tijd die je kan vrijmaken


## G2 - Gateway

De oplossing? NOG een project natuurlijk! G2 wordt onze eigenste
project-management hub. Het zal projectleiders de tools aanbieden om issues
en branches op een logische manier te structureren. Projecten worden 
recursief onderverdeeld in subprojecten, die elk op zich een logisch
samenhangende collectie van issues en branches zijn. 

Ja, dit kan nu ook al op zekere hoogte met zaken zoals tags op git(hub|lab). 
De meerwaarde zit dan ook vooral in de andere richting.

Nieuwe leden kunnen op een eenvoudige en gecentraliseerde manier de lopende
projecten verkennen. Hierbij moeten ze niet steeds de repos doorspitten,
maar kunnen ze zoeken op talen, frameworks en "soort" projecten (backend, 
frontend, etc). 

Leden met al enige pull requests achter de kiezen kunnen na een hiatus
zich makkelijk herorienteren in hun favoriete projecten, en een 
subproject uitkiezen dat hun aanspreekt.

Het projectbestuur kan mensen met bovenstaande vraag makkelijk doorverwijzen,
alsook een oogje houden op de status en populariteit van alle projecten.

## G2 - Gamification 2

Na een eerste versie met bovenvermelde functionaliteit, is het een logische
uitbreiding om hieraan ook een opgefriste versie van onze alom geliefde
gamification metrics toe te voegen. De concrete implementatie hiervan ligt nog
niet vast, maar er is duidelijk een voorkeur om meer richting "badges en 
achievements" te gaan in de plaats van een arbitraire score.

## We want you

G2 wordt een ambitieus project, met een geplande timeframe van ongeveer een jaar
voor het gateway gedeelte. Alle hens aan dek dus! Gezien het altijd leuker
en makelijker is om in een versgeplukt project in te stappen is het nu hét moment
bij uitstek om je kans te grijpen en er van het begin bij te zijn. 

Hieronder een korte beschrijving van de geplande tech stack. Hier kunnen zeker
nog wijzigingen in komen, maar het is alvast hoe we zullen beginnen:

**Dataopslag**

SQL-based database. Effectieve variant nog nader te bepalen, maar er zal 
hoogstwaarschijnlijk met een abstractielaag worden gewerkt waardoor dit een minder
belangrijk detail wordt.

**Backend**

Web server in [Clojure][clojure], een functionele taal met een focus op 
elegante multithreading. Hét perfecte excuus om je functionele spieren nog eens
te laten rollen, of juist om je voor te bereiden op de onvermijdelijke Haskell
lessen.

**Front-end**

Hier houden we het bewust simpel. We gaan niet voor een flashy react/vue/angular
SPA (Single Page App). Simpele HTML templating dus, met een gezonde dosis CSS en
een lichte garnituur van JavaScript. Ideaal voor beginners!

## Contact

De meeste communicatie zal gebeuren in het [G2 mattermost kanaal][mmost], dus
ben je ook maar enigszins geinteresseerd neem dan zeker daar een kijkje.

Het project loopt onder leiding van Maxime (mattermost: Flynn).
Daarnaast kan je uiteraard zoals voor alle projecten steeds bij mij (Arne - abeformatter) terecht.


[clojure]: https://clojure.org/
[mmost]: https://mattermost.zeus.gent/zeus/channels/g2
