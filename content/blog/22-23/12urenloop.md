---
title: Rondjes tellen met Bluetooth Low Energy op de 12urenloop
created_at: 15-04-2022
author: "Jasper Devreker"
---

De 12urenloop is een jaarlijkse loopwedstrijd aan de Universiteit Gent. De deelnemende
studentenverenigingen lopen in een estafetterace die 12 uur duurt zoveel mogelijk rondjes.
Elk team krijgt één baton (doorgeefstok) toegekend, dus ze kunnen maar één loper tegelijk hebben.

Zeus doet al even het tellen op de 12urenloop: eerst via een manueel telsysteem waarbij
de rugnummers van de lopers worden ingegeven, dan vanaf 2011 met een automatisch
telsysteem dat werkt via bluetooth-modules in de batons. Voor de rest van de context qua
de historische hardware en software kan je de [blogpost uit 2011](/blog/10-11/counting-laps-using-bluetooth-dongle-detection-on-the-12-urenloop/) lezen.

Het oude telsysteem had een aantal issues:

- De gyrids (de computers die rond het circuit opgesteld waren en de bluetooth-beacons opvingen) begonnen vrij oud te worden en gingen kapot
- De gyrids pollden welke Bluetooth devices er in de buurt waren, waarna de batons antwoordden.
  De detecties van batons was niet betrouwbaar, en de betrouwbaarheid daalde jaar na jaar, waarschijnlijk doordat er steeds meer mensen Bluetooth devices bijhadden.
- Niemand van de huidige generatie leden in Zeus begrijpt het telprogramma count-von-count echt (het is geschreven in Haskell op de manier waarop je Haskell moet schrijven), wat het lastig maakt om features toe te voegen of als er iets mis loopt tijdens het event te debuggen.
- ...

Om bovenstaande redenen hebben we in 2019, na een editie waarbij we volledig op manualcount hebben moeten draaien, beslist om
zowel de hardware als de software te vervangen: count-von-count wordt vervangen door Telraam, de gyrids door Raspberry Pi's en de bluetooth modules in de batons door Bluetooth Low Energy (BLE) microcontrollers die we zelf kunnen programmeren.

# De hardware

## Batons

De batons bevatten een Adafruit Feather nRF52 Bluefruit LE microcontroller en een herlaadbare lithium-ion batterij. Ze zijn geprogrammeerd om 10 keer per seconde een beacon-pakketje te sturen waarin het batterijpercentage en de uptime zitten: op die manier kunnen we monitoren of er batons zijn waarvan de batterij bijna plat is. Via de uptime kunnen we detecteren of de batons rebootten tijdens het event.

De voordelen van deze microcontrollers ten opzichte van de vorige 'domme' bluetooth-chips, is dat tweevoud: ten eerste kunnen we zelf programmeren wat de microcontrollers sturen in de beacon-pakketjes. Hierdoor kunnen we telemetry kunnen meegeven. Ten tweede sturen de microcontrollers nu zelf heel frequent hun beacon-pakket, zonder dat deze gepolled moeten worden.

![Inhoud van de batons](https://pics.zeus.gent/oY4noB478FwToO5jVQFtnO1bVeZXz9AoxJxwgZsP.jpg)


## Stations

Er staan verschillende dozen rond het loopcircuit. In elke doos zit een Raspberry Pi, een kleine netwerkswitch, een autobatterij en twee spanningsomvormers (voor de networkswitch en de Pi). Het geheel van die hardware wordt een station genoemd (intussen is de term "Ronny" ook wel populair geworden). De stations zijn onderling via ethernetkabels verbonden. De ethernetkabels gaan het parcours rond in een lus. Op het verste station van de centrale IT-container is 1 kabel niet ingeplugd zodat we geen loops in het netwerk hebben. De kabel zelf ligt er wel, zodat als een andere kabel kapot gaat (doordat er bijvoorbeeld een koets over rijdt), we gewoon een kabel moeten insteken om onze stations terug netwerkconnectiviteit te geven.

De Raspberry Pi's in de stations luisteren naar de beacon-pakketjes die uitgestuurd worden door de batons en slaan de informatie uit de ontvangen pakketten op in een lokale database:

- MAC-adres van de baton
- RSSI (signaalsterkte, dit komt kort door de bocht overeen met de afstand van de baton tot het station)
- uptime en batterijpercentage van de baton
- Unix timestamp waarop het pakket ontvangen is
- het ID van de detectie (een getal dat strikt stijgt, per station)

Vroeger stuurden de Gyrids die gegevens dan rechtstreeks door naar count-von-count. Hierdoor was de setup
zeer gevoelig aan netwerk- en ander falen: als er bijvoorbeeld een koets over de netwerkkabels reed (helaas is dit geen theoretisch voorbeeld) of count-von-count down was, dan gingen alle detecties verloren tot de detecties terug toekwamen. Dit is nu opgelost door de detecties vanaf Telraam binnen te trekken in plaats van die vanuit de stations naar Telraam te duwen: er draait een kleine webserver op elk station die een endpoint `/detections/<id>` heeft. Deze geeft alle detecties *na* het meegegeven ID terug: op die manier is het makkelijk
om alle detecties naar een lokale databank te synchroniseren. Als extra voordeel is het hiermee nu ook mogelijk
om voor elk station alle detecties te downloaden waarmee dan het event gereplayed kan worden. Zo kan er makkelijk gesleuteld worden aan het algoritme in Telraam, zonder telkens een fysiek event te moeten doen.

De spanningsomvormers (buck converters) zetten het voltage van de batterij om in 9V voor de switch en 5V
voor de Raspberry Pi. Ze zijn via een JST-connector verbonden met de autobatterij, waardoor het niet meer 
mogelijk is om per ongeluk de polariteit om te keren. Aan een van de omvormers hangt ook een digitale 
spanningsmeter, waardoor het in één oogopslag duidelijk is hoeveel energie er nog in de autobatterij zit.
Ter bescherming van de omvormers zijn er ook behuizingen ge-3D-print.

<p float="left">
  <img src="https://pics.zeus.gent/aZT3dvn424rHhjmtCBkAJUFX28uOZmZCsGMFjOJW.jpg" width="49%" />
  <img src="https://pics.zeus.gent/rbCTBUH1t03klQs9oLlU0dMNudlrzGEHrmnmd6b1.jpg" width="49%" /> 
</p>

Op onderstaande foto kan je zien wat er allemaal in een station-doos gaat (behalve de netwerkswitch of ethernetkabels)

![Inhoud van de stations](https://pics.zeus.gent/MFnFeInrzspGuW2CTXzxTmx1ggxVj3xemVZoTjmk.jpg)

# Netwerk

Ook qua netwerk zijn we er wat op vooruit gegaan: vroeger trokken we voor onze uplink een kabel 
van de nabijgelegen Sint-Pietersabdij naar de IT-container. De vorige editie hebben we deze 
kabel vervangen door een "straler" (een point-to-point Wi-Fi verbinding die zich gedraagt als 
een kabel). Zo moeten we de hoogtewerker niet meer gebruiken, waardoor we veel sneller kunnen opbouwen. Daarnaast hebben we nu ook een reserve-uplink: de TADAAM. Dit is een 4G router
die maar €40 kost per maand voor ongelimiteerd internet aan 30 Mbps. Het is mogelijk dat we die naar de komende jaren zullen gebruiken als enige uplink.

# Software

## Telraam

Telraam is het nieuwe telprogramma, ter vervanging van count-von-count. Het gebruikt [Viterbi](https://en.wikipedia.org/wiki/Viterbi_algorithm) als
algoritme om detecties van batons te transformeren naar rondjes. We gebruiken Viterbi omdat de 
stations niet altijd voorbijkomende batons detecteren. Viterbi werkt aan de hand van een hidden-markov-model, waarbij de detecties de 'events' zijn, en de hidden state de locatie van de baton (aan welk station die dus is).

Telraam is in Java geschreven. Minder flashy dan count-von-count in Haskell, maar zo kunnen we wel garanderen dat volgende generaties ook overweg kunnen met de code: Java is de eerste taal die we zien in de opleiding.

## Emmanuel Count

Emmanuel Count (manual count) is de software waarmee we tijdens de eerste uren van de wedstrijd manueel tellen (door de rugnummers van de lopers in te geven). Eenmaal de automatische telling en de manuele telling lang genoeg overeenkomen, kunnen we overschakelen op de automatische telling. Dit kan vrij makkelijk in Telraam.

De manualcount frontend houdt nu zelf de rondjes bij en synct deze naar de backend, zodat het tellen kan doorgaan, ook al breekt de netwerkverbinding of is de backend down. Het is ook ondersteund om via meerdere toestellen tegelijk te tellen, zodat er een vlotte overgang kan gebeuren bij het wisselen van manualcount-personeel.

![Manualcount screenshot](https://pics.zeus.gent/fwrQ226iCJPAwIayJcC8upjfMtRi3m3c1chP1iMG.jpg)

## Loxsi de proxy

Loxsi de proxy (vernoemd naar @lox 🧡) is het stuk software die het aantal rondjes voor de live-site servet. Dit vraagt aan Telraam het aantal rondjes per team op, en exposet een Websockets API om die dan terug te geven. De livesite vraagt dit niet direct aan Telraam, omdat we anders bij een hoog aantal van de bezoekers mogelijk Telraam zouden overweldigen. In plaats daarvan vraagt Loxsi om de zoveel tijd aan Telraam het aantal rondjes, en geeft het dan dit gecachete aantal terug.

# Monitoring

We hebben ook veel monitoring geïntroduceerd, dit geven we allemaal weer via een Grafana dashboard. We geven (onder andere) het volgende weer:

- aantal rondjes per team
- status van de batons: batterijpercentage en of ze gerestart zijn (dit is wanneer hun uptime gedaald is)
- status van de stations: zijn ze nog bereikbaar over het netwerk? werkt hun HTTP-server nog? hoe lang geleden is de laatste detectie?
- status van de software (telraam en manualcount)

Op onderstaande screenshot staat een (intussen lichtjes verouderde) versie van de monitoring setup.

![Grafana dashboard](https://pics.zeus.gent/BqiMMGPqMGuXcOYXr2FCU6QowxzygLziPCiVGAg7.png)

# Evaluatie en toekomst

We hebben de vorige 12urenloop-editie het automatisch telsysteem kunnen gebruiken: we hebben 
enkel de eerste paar uren van het event manueel geteld tot we zagen dat onze automatische 
telling betrouwbaar was.

De 12urenloop-stack is nu een heel pak betrouwbaarder, nauwkeuriger en meer debugbaar; maar 
natuurlijk stopt ons werk daarmee niet: