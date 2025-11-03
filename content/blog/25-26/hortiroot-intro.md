---
title: HortiRoot scanners
created_at: 03-11-2025
description: Zeus helpt bio-ingenieurs om *timelapses* te maken van plantengroei.
author: Jonas Meeuws
tags:
  - Project
  - HortiRoot
---

Beste Zeussers en Zeusinnen,

Enkele weken geleden werden we gecontacteerd door de onderzoeksgroep [HortiRoot](https://www.ugent.be/bw/plants-and-crops/en/research/hortiroot).
In hun lab hebben ze een redelijk aantal Epson *flatbed foto scanners* omgebouwd om er kleine plantjes in petriplaten op te kunnen groeien.
Hiermee kunnen ze met korte tijdsintervallen scans nemen, om *timelapses* te maken van de groei in hoge resolutie.

![A metal frame holding 4 scanners in place, sitting in a lab. On the left there is an electrical box where the LED controls and Arduinos are housed.](https://pics.zeus.gent/ImlHShBfCz0cCAXIKl1QEcGk3aEvKeFBuolFn3VA.png)

De UGent workshop [WE62](https://www.ugent.be/we/en/faculty/faculty-offices/technical-scientific-workshop/overview) heeft hun geholpen met de hardware mods:

- Het deksel (lid) werd verwijderd. De elektronica verantwoordelijk voor de "closed" detectie wordt nu nagebootst door een Arduino.
- Over het bed kan nu een kunststoffen plaat geschoven worden waar de petriplaten in passen.
- Een frame werd gemaakt om alles op zijn plaats te houden, en zodat de scans *verticaal* gemaakt kunnen worden.
- Ook is er nu een ledstrip om semi-natuurlijk licht na te bootsen.

Voor de software merkten de onderzoekers echter dat de UGent geen equivalent van die werkplaats heeft.
De onderzoekers van HortiRoot hebben zelf wat geprobeerd om de standaard Windows 10 Epson software te automatiseren met behulp van `pyautogui`.
Uiteindelijk hadden ze wel een werkend systeem, dat momenteel nog steeds gebruikt wordt.
Onderhoudbaar is dit helemaal niet: automatisch de muis proberen bedienen schaalt niet bepaald goed...
Ze hadden ook de software voor *Ubuntu* uitgeprobeerd, maar die avonturen waren jammer genoeg van korte duur omdat DICT geen ondersteundend personeel had met voldoende expertise hiermee.
Nu recent stak de [verplichte update naar Windows 11](https://endof10.org) ook een spaak in het wiel.

Na wat details van het project te horen wees DICT de onderzoeksgroep naar ons door.
Even later werden Xander, Hannes en ik hartelijk ontvangen op campus *Coupure*.
In een labo vol groen konden wij de verschillende iteraties van de scanner mods aanschouwen.
Maar vooral van de vele *hacks* die ze gevonden hadden om toch maar de software te doen werken, waren we onder de indruk.
Zo lukte het niet om de scan software te gebruiken met meerdere apparaten aangesloten, dus hadden ze als oplossing om elke scanner op een *aparte virtuele machine* aan te sluiten.
Niet ideaal, dus probeerden ze om maar 1 apparaat tegelijk te tonen aan de software met behulp van *programmeerbare USB hubs*.
Dit werkte niet meer in Windows 11, maar zelfs dan was dit vrij beperkt in aantal apparaten.
Ook hadden ze ontdekt dat ze doorheen dinsdagnacht geen scans konden doen, omdat DICT *[patch tuesdays](https://en.wikipedia.org/wiki/Patch_Tuesday)* doet...

Na uitwisselen van ons intern telefoonnummer, werden even later 2 van de scanners geleverd aan de Zeuskelder.
Er zijn hier al wat mensen bezig geweest met de scanners om te helpen de opties te verkennen.
Wat ons meteen verrastte is dat de Linux software `epsonscan2` die Epson publiceert, bijna volledig open-source en vrij is.
Bovendien is dit een grote bron aan documentatie van de interne werking van de scanners. De enige drempel is dat die deels in het Japans is 😅.

Om deze software inderdaad werkend te krijgen, is een ander verhaal.
Wanneer de software probeerde te verbinden gingen de scanners steeds in een "internal error" state.
Door wat instrumentatie aan `esponscan2` toe voegen en veel verschillende opstellingen te proberen, vonden we uiteindelijk een oplossing.
We merkten dat een scanner slechts éénmaal correct geïnitializeerd moest worden door andere software (zoals de windows 11 versie), waarna de scanner werkt met alle software.
Door de communicatie te onderscheppen, konden we een programma maken dat de scanners op dezelfde manier kan initializeren.
Waarom exact dit nodig is, is nog niet helemaal duidelijk.

We zijn opgelucht dat dit werkt, omdat dit betekent dat we helemaal geen nood hebben aan Windows, virtuele machines, USB multiplexers of het automatisch navigeren van menu's.
In de plaats kunnen we volledig werken met de betrouwbare en voorspelbare software die we gewend zijn.

Het plan is om scanners per ~4 te groeperen, die samen aangestuurd worden door 1 *node* (Raspberry Pi).
Deze *nodes* worden ontdekt op het lokale netwerk door de backend van een webapplicatie.
Die webapplicatie stuurt dan requests uit om scans te nemen met bepaalde parameters, op regelmatige intervallen.
De geproduceerde afbeeldingen worden dan verplaatst van de node naar de machine waar de webapp draait.
Gebruikers kunnen dan die *timelapses* beheren vanuit de webapp op het lokaal netwerk, en eveneens ook de afbeeldingen downloaden.

Wat is reeds geïmplementeerd?

- Nodes:
    - Er is een script dat nieuw aangesloten scanners detecteert en ze meteen correct initializeert.
        - Dit gebeurt [hier](https://git.zeus.gent/ZeusWPI/hortiroot-scanners/src/commit/f125641dc8/sc/source/sc/scanner/initialize.d#L40) door specifieke `USB_BULK` pakketten te sturen, onder andere met de firmware blob.
        - Het script (`sc`) is in D geschreven, zogoed als alles wordt gedaan via de `libusb` C library.
        - Soms faalt het initializeren door een "permission denied", omdat de udev rule nog niet geactiveerd is op het moment dat `libusb` het apparaat detecteert.
          Als *root* uitvoeren fixt het...
        - Het protocol dat gebruikt wordt bovenop `USB_BULK` is *ESC/I*.
          Enkele links naar documentatie hierover zijn [hier](https://git.zeus.gent/ZeusWPI/hortiroot-scanners/src/commit/f125641dc8/epsonscan2) te vinden.
        - Dit protocol verder ontdekken kan nog steeds handig zijn:
          Het lukt momenteel niet om elke scanner uniek te identificeren.
          Ze dragen geen *serial number* zoals de meeste USB devices.
          Misschien is er wel een command om iets gelijkaardig op te slaan?
          Ik zie ook verwijzingen naar een *non-volatile user variables* api.
    - De `epsonscan2` software build vanuit de [git repo](https://git.zeus.gent/ZeusWPI/hortiroot-scanners) met behulp van docker.
        - De build artifact is gemaakt voor Debian Bookworm.
          Kijken of het mogelijk is te upgraden naar Trixie.
        - Er is een dependency op een non-free tool, die binair gepatcht wordt om de paden ook naar `/opt/epsonscan2` te doen wijzen.
          Deze prefix is gemakkelijker te gebruiken dan `.deb` packages maken die naar `/usr` uitpakken.
        - De software heeft een command-line versie, maar die kan nog niet een bepaalde scanner selecteren.
          We kunnen dit zelf implementeren.
- Webapp:
    - Nog niets!
      Bepaal zelf welke taal/framework (of talen/frameworks, meer is beter right?).
      Requirements in de repo te vinden.

Kijk zeker eens in de [git repo](https://git.zeus.gent/ZeusWPI/hortiroot-scanners) en join al vast het [~horitroot-scanners](https://mattermost.zeus.gent/zeus/channels/hortiroot-scanners) kanaal op Mattermost!

*PS: Wat zouden wij kunnen scannen?*
