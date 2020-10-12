---
title: "Wij coden voort"
created_at: 21-7-2020
description: "We mogen de kelder opnieuw openen"
author: "Jasper Devreker"
tags:
  - Corona
  - General
---

We hebben via het WVK[^wvk] doorgekregen dat we onze geliefde kelder terug mogen openen.
Er zijn natuurlijk wel een aantal voorwaarden om dit veilig te kunnen doen:
een limiet op het aantal mensen die tegelijk in de kelder mogen zijn, een duidelijke
registratie van wie wanneer in de kelder is en het naleven van de maatregelen,
zowel deze van de UGent als die die van overheidswege komen.

Concreet: we mogen vanaf 27 juli tot 6 mensen tegelijk in de kelder toelaten, de afstand van 1.5
meter moet gerespecteerd worden en er moet een bestuurslid aanwezig zijn. Op UGent-terrein
zijn mondmaskers verplicht op alle locaties die niet toegewezen zijn aan een specifieke groep:
inkomhallen, trappen, gangen ... Eenmaal je in de kelder bent en op een veilige afstand van elkaar
stilzit, kan het eventueel toegelaten zijn om je mondmasker af te zetten,
afhankelijk van de situatie.

Om te zorgen dat iedereen een eerlijke kans heeft om eens in de kelder te kunnen
werken en om ervoor te zorgen dat we de gegevens die we moeten doorgeven makkelijk
kunnen doorgeven, hebben we een kersvers registratiesysteem geschreven
(https://git.zeus.gent/bestuur/kers). Eenmaal het volledig af is, zal het gedeployed
worden op https://kers.zeus.gent. Op dit systeem
zullen bestuursleden op voorhand een timeslot (datum + voormiddag/namiddag/avond),
een maximum aantal mensen en een beschrijving kunnen geven. In de beschrijving van
het timeslot kan er bijvoorbeeld een project staan waar aan gewerkt wordt, extra
regels die het aanwezige bestuurslid oplegt ... Eenmaal dit gebeurd is,
kunnen andere leden zich inschrijven voor dat timeslot.

Er kunnen natuurlijk meer inschrijvingen zijn voor een bepaalde timeslot dan er
plaats is, dus in dat geval
wordt een bepaalde metriek gebruikt om te bepalen wie er voorrang heeft om naar de kelder
te komen (meer over deze metriek later). Een dag voor het timeslot bepaalt het programma
wie er in de kelder mag zijn en stuurt het naar deze leden een mail.
We geven die informatie dan ook door aan de nodige mensen binnen de UGent, dus dan
is het niet mogelijk meer om wijzigingen te maken (als je niet meer kan komen, geef dit dan aan
  in het platform voor je de mail krijgt).

Wat meer info over de metriek: momenteel is dit `sum(1/now.dayssince(a.date) for a in
attendances)`. Ben je bijvoorbeeld drie en vijf dagen geleden naar de kelder gekomen,
dan is jouw score 1/3 + 1/5. De personen
met een lagere score hebben voorrang op mensen met een hogere score. We staan echter
open voor andere metrieken mits een implementatie en wat argumentatie waarom die
beter is.

We krijgen veel vrijheid van de UGent en dus tegelijk ook veel verantwoordelijkheid:
hou je dus aan de maatregelen die gelden en luister naar het aanwezige bestuurslid.
Gebruik steeds je gezond verstand en doe je best om alles veilig te doen verlopen.

Ten slotte zouden we graag onze decaan bedanken voor zowel de duidelijke en vlotte
communicatie als de mondmaskers en ontsmettingsgel die ze aan onze kelder gezet heeft.

[^wvk]: Werkgroepen- en VerenigingenKonvent, het konvent waar Zeus lid van is
