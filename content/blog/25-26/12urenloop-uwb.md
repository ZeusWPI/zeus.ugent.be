---
title: "Op weg naar rondjes tellen met UltraWideBand op de 12Urenloop"
created_at: "2026-07-07"
description: "Een Open-source multi-tag lokaal positionering-systeem."
author: "Robin Paret"
---

De 12urenloop is een jaarlijkse loopwedstrijd op het Sint-Pietersplein in Gent. De deelnemende studentenverenigingen lopen in een estafetterace 12 uur zoveel mogelijk rondjes. Elk team krijgt één baton (doorgeefstok) toegekend, dus ze kunnen maar één loper tegelijk hebben.

Zeus doet al even het tellen op de 12urenloop: eerst via een manueel telsysteem waarbij de rugnummers van de lopers worden ingegeven, dan vanaf 2011 met een automatisch telsysteem dat werkt via bluetooth-modules in de batons. Voor de rest van de context qua de historische hardware en software kan je de [blogpost uit 2011](https://zeus.gent/blog/10-11/counting-laps-using-bluetooth-dongle-detection-on-the-12-urenloop/) lezen.

In 2019-2022 werd de hele stack opnieuw vernieuwd, met modernere hardware, een ingeschatte positie van de lopers op de website, en uitgebreide redundancy, fault-tolerance en monitoring. Ook hier is een [gedetaileerde blogpost](https://zeus.gent/blog/22-23/12urenloop/) over geschreven.

![12Urenloop circuit](https://pics.zeus.gent/JA9I7ZXKXfOpGQyOoT1GsavWAn467bp3LzJj6Xq1.png)

### Wat is UWB?

Rond eind oktober dit jaar zag ik online enkele demo's van UltraWideBand hardware met gemakkelijk te verkrijgen en relatief goedkope hardware. UltraWideBand is een radiocommunicatie-standaard gefocust op centimeter-level localisatie van zenders of ontvangers. Dit kan o.a. omdat het een groot deel van het radiospectrum (500 Mhz) gebruikt en zo heel goed is in het negeren van reflecties van een signaal. Het kan dus gemakkelijk het begin van een ontvangen packet identificeren. Als je dat paart met een klok die accuraat is op picoseconden-niveau en je de verzendtijd van een pakket vergelijkt met de tijd van ontvangen, dan kan je berekenen hoe lang dat pakket in de lucht is geweest (aan de lichtsnelheid) tussen zender en ontvanger. Vermenigvuldig die tijd met de lichtsnelheid en je krijgt de afstand tussen zender en ontvanger. Als je die afstand tot een bewegende UWB zender (Tag) kan meten vanaf meerdere UWB zenders op een vaste positie, kan je de positie van de tag berekenen. Dit is hetzelfde principe dat GPS gebruikt, maar op een kleinere schaal.

Deze technologie wordt o.a. gebruikt in Iphones en Airtags; om de afstand en richting naar de Airtag te tonen. Ook in nieuwe autosleutels die de auto openen als je dichtbij komt, omdat een UWB signaal geëncrypteerd kan zijn en zo resistant is tegen [relay aanvallen](https://www.ace.aaa.com/insurance/advocacy/keyless-car-theft.html).

### Wat maakt deze technologie mogelijk?

Er werd sinds 2021 al gepraat over UWB gebruiken bij de 12Urenloop, want het biedt enkele grote voordelen:
- Exacte positiemeting: Het huidige bluetooth-systeem geeft een goede inschatting van de voortgang op het circuit (door de snelheid te berekenen), maar geen positiemetingen. 
- Met positionering kan een ronde ronde geteld op het exacte moment dat iemand over de startlijn gaat, Dit lukt niet met bestaande RFID systemen die voor loopraces worden gebruikt, want bij 12Urenloop is er een startlijn per team (aan de tent van elk team van verenigingen).
- Meer statistieken over individuele lopers: Maximum/minimumsnelheid, snelheid in bochten etc.
- Een signaal met minder ruis, want er is veel ruis door bluetooth-signalen van de honderden toeschouwers.

### Wat je zelf doet, doe je meestal goedkoper

Er bestaan kant en klare RTLS (realtime location system) oplossingen met alle hardware en software die je nodig hebt, maar deze zijn buiten het budget van een loopwedstrijd georganiseerd door studenten (De starter-kit van het Gentse [Pozyx](https://www.pozyx.io/store) kost al rond de 5000 euro).

De laatste jaren is de prijs van UWB-modules sterk gezakt naar rond de 19-25 euro per module voor de officiëel verpakte modules van Qorvo (Wordt gebruikt door Pozyx en is interoperabel met apple U1 chip), en zelf 12 euro voor aftermarket verpakte modules (clones) met een geïntegreerde microcontroller.

Daarom leek het mij een goed moment om te verkennen hoe mogelijk en nuttig een UWB systeem kan zijn op de 12Urenloop.

Bij nader inzien is er zo goed als geen open-source software die het positioneren van meerdere tags ondersteunt. Bijna alle beschikbare code focust op het tracken van één tag met meerdere anchors, want dat is ook veel simpeler. Wanneer er meerdere tags en anchors zijn moeten alle UWB modules coördineren wanneer ze mogen uitzenden; alle communicatie verloopt over één kanaal, dus er mag niet over elkaar gepraat worden. De synchronisatie tussen modules moet binnen de paar milliseconden zijn voor een meetsnelheid van 1-10 keer per seconde per tag.

Dit wetend, hebben we 5 DWM3000 UWB modules besteld zodat we een opstelling kunnen maken van 3 anchors op vaste posities, en 2 tags om de positie van te bepalen.

Om de UWB modules aan te sturen werd gekozen voor de ESP32-WROOM, omdat die goedkoop zijn (4 euro), bluetooth en wifi hebbben, en ook in ons kelderlokaal al aanwezig zijn. De code werd in het arduino-framework geschreven, dus is ook makkelijk over te brengen naar andere microcontrollers.

![Qorvo DWM3000EVB dev boards](https://pics.zeus.gent/xF9JD804WaMrnsjo07In6RFjSGQiQMnfXsyrrOv9.jpg)

### Tuning & testing

De DW3000 chipset van de UWB-module wordt aangesproken via SPI, door het lezen en schrijven van honderden registers en een tiental commandos. Qorvo (de fabrikant) stelt een SDK ter beschhikking om bepaalde functies simpeler te maken om te implementeren, maar deze werkt enkel voor een handvol microcontrollers zoals de NRF52 en STM32 familie, geen espressif chips. Gelukkig is er een community port van de driver library naar het Arduino framework.

De focus van de eerste weken was om te bepalen of de DWM3000 UWB-module geschikt was om te gebruiken op de 12Urenloop: Is het meetbereik van de module ver genoeg (het doel was minstens 30 meter), is de gemeten afstand accuraat genoeg, en hoe vaak kan je de positie meten wanneer er 15 tags (1 per loper) op het circuit zijn.


Na heel wat tunen van registers voor de structuur van de radio-frame en het uitzendvermogen lukte het om afstand te meten tot op ongeveer 50 meter afstand. Met grotere antennes aan de anchors kan dit waarschijnlijk nog veel verbeterd worden. Het bereik wordt wel slechter als er geen Visueel contact (Line Of Sight) tussen beide modules is of als er veel metaal in de buurt is (beide zorgen voor reflecties van het radiosignaal).

![Range test 40 meter resultaten](https://pics.zeus.gent/9QJiwHj9FDUv3Y4ekijv5ftBArf7o82ZtyHVm6KI.png)

Na een beetje calibratie lukte het om afstand te meten tussen 2 modules met ongeveer 2 centimeter tolerantie binnen de 5 meter. Op langere afstand is er iets meer calibratie nodig per module om accuraat te meten.

Na deze initiële resultaten was het tijd om een positionerings-test te doen: 2 Anchor-modules werden in de hoek van ons lokaal geplaatst, de derde Tag-module start beurtelings een meting van de afstand naar elke Anchor, de anchors sturen de afstanden naar de tag over wifi door via MQTT.

De getrianguleerde positie werd in realtime gevisualiseerd door een dashboard gemaakt met [Bevy](https://bevy.org) .

![realtime positie demo](https://mattermost.zeus.gent/files/n9cp37pfxfgojr1f7beqoi3osc/public?h=4UiGkuFYTRZQ9xIhak6DNkQ_FP2tSEMUwgD-BkLStXg)

Om dit systeem te laten werken met 2 tags op hoge snelheid zonder dat er over elkaar wordt gepraat op het radiokanaal, is er synchronisatie nodig tussen anchors: Die moeten weten wanneer het aan hun beurt is om een bericht uit te sturen en wanneer ze moeten wachten om de rest hun metingen te laten doen. In de implementatie werkt dat door een gedeelde klok tussen alle anchors: Elke anchor krijgt een tijd-slot toegewezen in een interval. Met een interval van 1 seconde en tijd-slots van 10 milliseconden kan je bijvoorbeeld 100 afstandsmetingen maken per seconde.

De distributie van de klok (telling van aantal ticks op de UWB-chip) werkt via de bestaande UWB-berichten. Elke keer een bericht gestuurd wordt tussen een anchor en tag wisselen ze elkaars klokwaarde uit, de hoogste klokwaarde wordt overgenomen door beide zenders.

![setup met 5 UWB modules](https://pics.zeus.gent/RpnwBADe6w9OMfF0Q3fjrcGjGeikSkUTpfoBDS8f.jpg)

_de setup met 5 UWB modules aan één laptop_

Hier is een demo in ideale omstandigheden met 3 anchors en 2 tags: Metingen worden gecoördineerd op een snelheid van 60 Hz, dat zijn 60 / 2 / 3 = 10 positiemetingen per seconde. Theoretisch kan deze timing dus voor 20 tags de positie 1 keer per seconde updaten.

![grasveld demo](https://mattermost.zeus.gent/files/a3uyukxq7fr3xgh8smr41m8c8y/public?h=9EqalStLvKMUJPbeFxvve5GTdjRCBi3U7PJmxrKU3Yg&bypass=true)


Om al deze metingen in realtime te aggregeren op de 12Urenloop om een live-tracking visualizatie te maken, is wat meer software nodig. Het huidige systeem gebruikt 7 stations met Raspberry-Pi's verspreid over het circuit verbonden met Ethernet. Om dit prototype te testen op de 12Urenloop-editie van dit jaar werden de 3 anchors aangesloten via USB aan de raspberry pi's. Een publisher-script leest de meetresultaten van de anchors en stuurt die berichten naar een centrale RabbitMQ-server in onze controlekamer (container) . Het realtime bevy-dashboard leest alle berichten en voert alle triangulatie-logica uit, daar kan dan een rondetelling op gebaseerd worden.

### Meer anchors ondersteunen

Er wordt geschat dat er 7-10 anchors zullen nodig zijn om op het volledige circuit van de 12Urenloop tags te kunnen positioneren, maar dan zullen maar maximaal 3 anchors ooit tegelijk binnen bereik van een tag zijn. Als elke anchor toch altijd het kanaal nodig heeft om elke tag apart te contacteren stort de snelheid van metingen snel naar beneden met het aantal anchors.

Dit kan worden opgelost door het hergebruiken van timeslots tussen anchors die niet tegelijk in het bereik van een tag kunnen zijn.

Daarmee is de basis van de proof-of-concept af. Het systeem werd getest op één bocht van het 12Urenloop circuit de dagg voor de wedstrijd. De resultaten waren (na calibratie) voldoende kwalitatief om een accurate tracking mee te doen.