---
title: "12 Uren Tellen"
created_at: 24-09-2019
description: Over rennen en tellen
author: Arne Bertrand
---

Men lope rondjes. Men telt die rondjes.

Het lijkt een eenvoudige opgave. Maar er komt zoals altijd heel wat meer bij kijken dan je verwacht. Bij een manuele telling wordt men moe, of mist men al eens een rondje.

Ook bij een automatisch systeem duiken er onverwachte problemen op, en natuurlijk is zo'n systeem onmiddelijk een stuk complexer. Daarbij komen dan nog software bugs, hardware ongelukjes, stroomuitvallingen, noem maar op. Hoe lang we dit lijstje ook maken, volgende editie is er toch weer iets waar we niet aan hadden gedacht.

Hieronder even een overzicht hoe we dit tot nu toe hebben aangepakt.

## Bluetooth en Espressos

Een eerste probleem waar een telsysteem mee kampt is hoe de passerende lopers te detecteren. 

Hiervoor worden er een aantal telstations opgezet rondom het circuit. 
Zo'n "telstation" bestaat uit een "espressobin", een mini-computertje met een bluetooth-ontvanger eraan, die telkens doorstuurt welke bluetooth-apparaten er zich in de omgeving bevinden. 
En dan geven we de lopers een baton (lees "een stuk pvc-buis") waarin een bluetooth zendertje zit. Simpel, toch?
Het nadeel hieraan is dan dat het niet alleen de lopers detecteert, maar ook jan en alleman die zijn bluetooth niet heeft uitgezet...


## Graaf Tel

Al jaren doet het functioneel huzarenstukje [Count von Count][cvcrepo] dienst als brein van het 12urenloop telsysteem. En dat werkt. Denken we.

Om eerlijk te zijn hebben we geen idee. Het aantal mensen dat genoeg haskell kan om de codebase te doorgronden begint stilletjesaan kleiner te worden dan, uh, 1.

CVC gaat al een hoop edities mee, en het feit dat het blijft draaien zonder enige significante updates is eigenlijk een klein wonder. Maar stilaan komen we op het punt waar
we extra features nodig hebben, maar eigenlijk weet niemand hoe en waar die te steken... Functioneel programmeren is niet bepaald het meest populaire vak... (Sorry Jasper & Felix)

## Dan toch maar met de hand

Als backup hebben we sinds jaar en dag reeds het trouwe [manualcount][mcrepo], dat vorig jaar volledig herschreven is. 
Idealiter is dit iets waar we enkel het eerste uur op steunen om ons er van te vergewissen dat de automatische telling correct is opgestart.
De realiteit loopt echter vaak anders...

Je merkt al dat er heel wat "maar"-en naar boven komen. Het is een publiek geheim dat er elke editie wel iets grondig misgaat, en in de meest recente edities kwam dit des te meer naar boven.
We spreken over de vorige editie als een success, maar eigenlijk is er heel de dag gewoon manueel geteld geweest. 
Gelukkig werkte de bovenvermelde manualcount perfect en zijn we heelhuids de twaalf uren doorgekomen, op de keel van de spotters na dan.

Na afloop van zo'n desastreuze editie kunnen we steeds weer extra ervaring neerschrijven, en onszelf beloven dat we het volgend jaar beter doen.
Maar wat is er nu eigenlijk foutgelopen? Dat blijkt telkens een enorm lastige vraag om te beantwoorden. Het hele telsysteem bestaat uit een hoop losse onderdelen, die dan nog eens met vrij fragiele
ethernet-kabels verbonden zijn (zie editie 2017 voor verhalen over koetsen en kabels). 
De telstations zelf kunnen het natuurlijk ook begeven (zie editie 2018 voor een les over batterijen en polariteit).
Er is daarnaast sprake van mogelijke bluetooth-interferentie, overbelasting van de servers, etc. En, in zo goed als alle gevallen, alles tegelijk.

## Een nieuwe start

Hoewel we zoals hierboven vermeld nooit echt zeker zijn van waar de druppel die de server doet kortsluiten vandaan komt, staat het buiten kijf dat we collectief doorheen de jaren een hoop ervaring hebben 
verzameld. En daarbij kwamen steeds ideëen naar boven die we niet of moeilijk konden integreren in het bestaande systeem. 
Vandaar dus de beslissing van het Zeus-bestuur om samen met het 12urenloop-comité onze schouders te zetten onder een volledig nieuw systeem. Nieuwe hardware, nieuwe software.

### Telraam

Hoofdrolspeler van het nieuwe systeem wordt Telraam, de spirituele opvolger van Count Von Count. Cruciaal doen we het deze keer niet in Haskell (want dat kunnen we niet) maar in het 
gouwe ouwe, saaie Java. Ja, een stuk minder sexy. Maar wel garantie dat volgende generaties makkelijk het heft kunnen overnemen. Het is de taal die we als eerste leren in onze opleiding, wat
de zaken ook een stuk toegankelijker maakt.

De focus van telraam houden we zo nauw mogelijk: rondjes tellen, meer niet. In tegenstelling tot CvC laten we de detectie van valsspelers over aan de organisatie. Waar we wel op hameren is DOCUMENTATIE.
Het is altijd een ondankbaar werkje om steeds die wiki up to date te houden, maar het is van onschatbare waarde in het heetst van de strijd, om dan nog maar te zwijgen van het gemak bij de overdracht
naar volgende jaren. 

Daarnaast willen we deze keer zeker echt jawel echt waar UNIT TESTS schrijven. Uit alles blijkt dat de 12urenloop een project van een heel ander kaliber is dan het gemiddelde
zeusproject. Het ding moet gewoon perfect werken.

### Golfjes

Naast nieuwe software komt er ook nieuwe hardware. Het vrijkomen van een iets groter budget hiervoor bij de 12urenloop organisatie is wat de hele discussie rond een nieuw ontwerp in gang heeft gezet.
We zijn er nog niet helemaal uit wat het precies zal worden, maar duidelijk is dat we bluetooth zullen achterlaten voor een andere draadloze technologie.


## Zeus needs you!

Een nieuw, schoon vers project waar ook nog eens leuke nieuwe speeltjes bij komen... ik moet u natuurlijk al niet meer overtuigen om mee te doen, ge staat verzekers al te springen om eraan te beginnen!

### Hoe Wat Waar?
Kom eens langs in het [~12urenloop][12ulmm] kanaal op mattermost, en neem een kijkje op de [repo][telraamrepo]

Doorheen het jaar organiseren we themaweken rond de 12urenloop. Er is dan steeds iemand aanwezig in de kelder die weet heeft van de huidige status en van wat er nog moet gebeuren. 
Telkens werken we naar een concreet doel op het einde van de week: een nieuwe versie, een pakket issues, een grote integratietest, etc. 

Je mag mij (@abeformatter) natuurlijk ook steeds contacteren met vragen of ideëen.

[telraamrepo]: https://github.com/12urenloop/Telraam
[12ulmm]: https://mattermost.zeus.gent/zeus/channels/12urenloop
[cvcrepo]: https://github.com/12urenloop/cvc
[mcrepo]: https://github.com/12urenloop/manual-count-2
