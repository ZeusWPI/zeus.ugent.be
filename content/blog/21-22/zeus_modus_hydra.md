---
title: Zeus-modus in Hydra
description: "Ceci n'est pas une application pour Zeus"
created_at: 01-08-2022
author: "Niko Strijbol"
---

Hydra heeft recent een reeks nieuwe functies gekregen, waarbij de focus lag op de nieuwe _Zeus-modus_.
In Zeus-modus zit allerlei functionaliteit die nuttig kan zijn voor Zeus-leden.
Zo vervangt Hydra functioneel het nu niet meer werkende Tappb.
Merk wel op dat dit enkel voor de Android-versie van de app is.

## Zeus-functies

Momenteel kan u in Hydra de volgende dingen doen:

- Beheer van Ta(p/b), zoals producten bekijken, orders plaatsen, en transacties bekijken en plaatsen.
- Cammie bekijken en berichten sturen.
- De deur open en dicht doen, hierover hieronder meer.

Een aantal zaken kunnen nog niet, maar misschien in de toekomst wel, zoals beheer van _requests_ in Tab, _pending orders_ bekijken en beheren in Tap, dagschotels beheren, etc.

<div class="columns">
  <div class="column">
    <img src="https://pics.zeus.gent/njaETVEbtdMO6aVDposElPDdNdlFz2sYejysnyAm.jpg" alt="Producten in Tap">
  </div>
  <div class="column">
    <img src="https://pics.zeus.gent/KG6tH6wGL76N2zjm8NW6rjObJhAG5K1SoL8Pkqkl.jpg" alt="Bestellen in Tap">
  </div>
  <div class="column">
    <img src="https://pics.zeus.gent/FH6H3c7g8vHvYNqK3qep4onUxAauvBW9C55a4HFX.jpg" alt="Cammie bekijken">
  </div>
</div>

## De deur beheren

Via Hydra kunt u nu de deur openen en sluiten.
In veel gevallen is dit sneller dan via Mattermost, aangezien de mobiele applicatie van Mattermost nogal traag is.
Samen met de snelkoppeling naar de Zeus-modus, kan de deur geopend worden in 3 keer drukken.

Daarnaast kunnen mensen met een smartphone die NFC ondersteunt ook het nieuwe badgesysteem gebruiken.
Nabij de deur hangen op de muur twee badges: een om de deur te openen en een om te sluiten.
Als een ontgrendelde GSM tegen een van die badges wordt gehouden, zal Hydra automatisch de actie uitvoeren en de deur dus openen of sluiten.

Hoe werkt dit technisch? Niet zo moeilijk.

De badges hebben elk een NDEF-tag, met daarin een URI: `zeus://hydra.ugent.be/open` en `zeus://hydra.ugent.be/close`.
De Hydra-app [registreert](https://developer.android.com/guide/topics/connectivity/nfc/nfc#filter-intents) zichzelf als ontvanger voor NFC-tags met het schema `zeus://` en host `hydra.ugent.be`.
De meeste Android-smartphones scannen automatisch naar NFC-tags als ze ontgrendeld zijn.
Vindt het systeem een van onze tags, dan wordt Hydra geopend.
Daarna volgt een netwerkverzoek naar de API-endpoint en _voila_, de deur is open (of dicht).
Een groot voordeel van hoe dit werkt, en van NFC in het algemeen, is de zeer lage invloed op het batterijverbruik: bijna verwaarloosbaar.

Onze printspecialist van dienst heeft ook een eerste iteratie van een _case_ afgedrukt om de tape waarmee ze tijdelijk ophingen te vervangen.
Een volgende iteratie zal nog komen.

<div class="columns">
  <div class="column">
    <img src="https://pics.zeus.gent/1ifiZKzWmjJOv9MmVqQCDdG8j3xQbKCCJYSsJPyg.jpg" alt="Opgehangen op zijn Zeus">
  </div>
  <div class="column">
    <img src="https://pics.zeus.gent/YymeIbhhmmEak5U95BrQlCOD5H4ok56Sno7sm3BX.jpg" alt="De eerste iteratie">
  </div>
</div>

<div class="columns">
  <div class="column">
    <img src="https://pics.zeus.gent/ONq93RjU5wE7YjACWHtDm6Dnsgbskd1DU4uBduqH.jpg" alt="Het hangt op!">
  </div>
  <div class="column">
    Komt hier later nog een versie?
  </div>
</div>

## Zeus-modus gebruiken

<a href='https://play.google.com/store/apps/details?id=be.ugent.zeus.hydra&utm_source=global_co&utm_medium=prtnr&utm_content=Mar2515&utm_campaign=PartBadge&pcampaignid=MKT-Other-global-all-co-prtnr-py-PartBadge-Mar2515-1'><img alt='Get it on Google Play' src='https://play.google.com/intl/en_us/badges/images/generic/en_badge_web_generic.png' style="max-width: 250px"/></a>

Om Zeus-modus te activeren, moet het u volgende doen:

1. Installeer Hydra vanop de [Play Store](https://play.google.com/store/apps/details?id=be.ugent.zeus.hydra) (momenteel enkel voor testers, binnenkort stabiel) of soon™ in [F-Droid](https://f-droid.org/en/packages/be.ugent.zeus.hydra.open/)).
2. Ga naar <kbp><samp>Navigatie-menu</samp></kbp> > <kbp><samp>Instellingen</samp></kbp> > <kbp><samp>Over</samp></kbp>.
3. Druk tweemaal op <kbp><samp>Gemaakt door Zeus WPI</samp></kbp>.

Nu kan u via het navigatie-menu naar de Zeus-modus gaan.
Eens u daar bent, zult u via de menubalk bovenaan naar <kbp><samp>Aanmeldgegevens beheren</samp></kbp> moeten gaan.
Daar kunt u uw API-sleutels voor Tap, Tab en de deur invullen, samen met uw Zeus-gebruikersnaam.

De verschillende API-sleutels zijn te vinden op:

- Tap: eens aangemeld, op de startpagina onderaan.
- Tab: eens aangemeld, op de Transactie/Gebruikerspagina
- Deur: voer het commando `door getkey` uit in Mattermost.
- Gebruikersnaam: uw eigen hoofd.

Nu bent u klaar om te genieten van Zeus-modus.


<div style="background: #1e64c8; text-align: center; padding-top: 35px">
    <img src="https://hydra.ugent.be/img/logo-hydra.svg" alt="Beautiful Hydra logo">
    <img src="https://hydra.ugent.be/img/snakes.svg" alt="Beautiful Hydra snakes">
</div>
