---
status: additional
---

KeRS is geschreven om Zeus bij te staan in het vervullen van haar verplichtingen omtrent het toelaten van studenten in de kelder, conform de coronamaatregelen.
Alle data die verzameld worden door deze applicatie zullen dan ook enkel voor dit doel gebruikt worden.

Concreet worden volgende gegevens verzameld:

- De applicatiegegevens zelf: voor welke evenementen een gebruiker zich heeft ingeschreven, voor welke evenementen een gebruiker aanwezig mag zijn, enzovoort.
- De UGent verplicht Zeus om een lijst door te geven van de studenten die aanwezig zullen zijn in de kelder.
  Hiervoor moet Zeus de echte naam en het studentennummer van de gebruiker opslaan.
  Deze gegevens worden enkel binnen KeRS opgeslagen en worden buiten het doorgeven aan de UGent niet gebruikt.

Tot slot wordt er in KeRS gebruik gemaakt van geautomatiseerde besluitvorming.
Indien er meer gebruikers ingeschreven zijn voor een evenement dan dat er aanwezigen kunnen zijn in de kelder, zal aan de hand van een metriek op geautomatiseerde wijze bepaald worden wie voorrang krijgen bij het inschrijven voor dat evenement.
Dit is noodzakelijk om elke gebruiker de kans te geven aanwezig te kunnen zijn in de kelder van Zeus.
De exacte metriek is te vinden in de broncode van de applicatie en ligt niet vast: deze kan gewijzigd worden om de eerlijkheid van de selectie te bevorderen.
Meer informatie en context vindt u in [deze blogpost](https://zeus.ugent.be/blog/20-21/wij-coden-voort/).