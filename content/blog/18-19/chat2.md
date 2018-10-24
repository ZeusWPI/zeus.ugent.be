---
title: "State of the Chat"
created_at: 14-10-2018
description: De langverwachte beslissing
author: het Zeusbestuur
---

Laat ons de **tl;dr** eerst geven: vanaf nu is [Mattermost](https://mattermost.zeus.gent) het officiële chat-kanaal van Zeus WPI voor het regelen van bestuurszaken, events, ... Het Slackteam blijft echter wel bestaan voor zij die willen.

# Waarom veranderen?

In het begin van de vakantie hebben we al een [blogpost](/blog/18-19/chat/) gemaakt waarin we zeggen waarom we willen afstappen van ons huidig chatplatform. De grote tekortkomingen waren, kort samengevat:

- Een gebrek aan backlog: je kunt enkel de laatste 10.000 berichten bekijken
- Een gebrek aan 'hackbaarheid': Slack is closed-source en niet self-hosted, dus wij hangen voor 100% af van het bedrijf achter Slack. Op de gratis versie is het aantal integraties ook beperkt, waardoor we zelf geen nieuwe coole features konden toevoegen.

# Waarom Mattermost?


Er zijn veel alternatieven uitgeprobeerd, maar van alle applicaties was Mattermost die waar we het meest tevreden van waren.
Hoewel Mattermost zichzelf profileert als een alternatief voor Slack, wordt in het totaalpakket niet altijd hetzelfde niveau van bereikt. 
Alle belangrijke functionaliteiten zijn aanwezig, maar het is soms nog wat "rough around the edges".

De voordelen van Mattermost wegen wel op tegen de nadelen. Het doorslaggevende argument om over te schakelen was het bestaan van een **backlog**, waarvan het ontbreken in Slack voor een aantal zaken (projectwerking, bestuur) heel ongemakkelijk was.
In combinatie met de openheid van de software lijkt Mattermost uiteindelijk een betere fit voor Zeus als organisatie.

Uit de rondvraag bleek ook dat uit de "open" applicaties, de meeste leden Mattermost zien als een geschikt alternatief. Van andere organisaties hebben we ook gehoord dat die tevreden zijn van Mattermost.

<%= figure 'https://zeus.ugent.be/zeuswpi/1xQrObwH.png', 'De resultaten van de poll uit onze vorige blogpost, per deelnemer waren meerdere antwoorden mogelijk. Hoewel Slack het meeste stemmen heeft, maakt de vrijheid die we krijgen bij Mattermost de #1 van het bestuur.' %>

# Wat gebeurt er met Slack?

Wij kunnen (en willen) niemand forceren om ons in die keuze te volgen. Het bestuur zal voor alle chatting migreren naar Mattermost, en hopen dat jullie dat samen met ons ook doen. Nieuwe leden zullen we ook naar daar verwijzen.

Als bestuur hebben we geen probleem met het voortbestaan van Slack. Idealiter wordt een nieuwe account aanmaken daar afgesloten, en migreert iedereen vanzelf, maar op zich heeft nudded als primary owner de controle over wat er met Slack gebeurt.

# Hoe stap je over?

1. Ga naar de mattermost server <https://mattermost.zeus.gent> of <https://chat.zeus.gent>
    - met je favoriete browser
    - met de [Android-app](https://play.google.com/store/apps/details?id=com.mattermost.rn)
    - de [iOS-app](https://itunes.apple.com/us/app/mattermost/id1257222717?mt=8).
2. Maak een account aan met een email naar keuze, ook niet-ugent emails worden geaccepteerd. De accounts zijn ook (nog) niet gekoppeld aan je Zeus-account.
3. Join je favoriete kanalen (~cats en ~top-secret-stuff zijn aanraders)

## De belangrijkste veranderingen ten opzichte van Slack

Eerst en vooral: nu de Mattermostserver zelf gehost wordt hebben de sysadmins volledige toegang tot de databank. Dit wil zeggen dat ze alle berichten kunnen lezen, wijzigen of wissen. We vertrouwen er op dat ze dit nooit zullen doen zonder expliciete toestemming van alle partijen betrokken in de conversatie en een algemene aankondiging hierover. Maar als je wilt confidentiële gesprekken hebben dan gebruik je hier best een applicatie voor met end-to-end encryptie (bijvoorbeeld [Signal](https://www.signal.org/)).

- Je refereert naar kanalen met een ~ i.p.v. een #.
- Tab-completion werkt niet zonder @.
- De (niet web)-clients ondersteunen geen meerdere servers, als je dus meerdere workspaces hebt, moet je helaas gebruik maken van iets zoals een app cloner, voor Android werkt [deze](https://play.google.com/store/apps/details?id=com.applisto.appcloner&hl=en) alvast.
- De naam van een kanaal veranderen verandert alleen de display name, in de URL blijft de originele naam.
- \#zeus wordt ~zeus, \#general wordt ~off-topic, maar die dingen lijken nog wat te moeten settelen aangezien er wierig aan naamsverandering wordt gedaan voorlopig.
- Je krijgt mails over mentions, maar die kan je uitzetten.
- `/door` werkt, al kan het wel zijn dat je eerst 'regular-user' status moet krijgen, poke een admin als je die rechten wilt.
- `/cammiechat`, en `/stock` werken ook
- De integraties vind je op <https://github.com/ZeusWPI/mattermore>, iedereen wordt aangemoedigd om nieuwe dingen toe te voegen.
- Sommige andere integraties werken nog niet (quotes bijvoorbeeld), maar daar wordt aan gewerkt.
- Het bestuur-kanaal zal integraal naar Mattermost verhuizen (naar ~bestuur), bestuurszaken gaan we vanaf nu dus bespreken daar en niet meer op Slack.
- Custom emoji zijn nog steeds een ding 🎉.

## Wat staat er nog op de planning?

- We gaan misschien de Mattermost app zelf builden en publiceren op de appstores zodat de clone hack niet nodig is.
- Voor de features die we missen in Mattermost gaan we pull requests maken, want het is open source!
- We gaan wat experimenteren met bridges (naar Slack, IRC, ...) om op zoveel mogelijk plaatsen aanspreekbaar te zijn.
- Dit wordt allemaal nog eens via mail gecommuniceerd ook.
- Veel custom responses en gifs zijn nog niet er nog niet _!wenkbrauw_.

We hopen jullie allemaal te zien op Mattermost.

<br/>

Met vriendelijke groeten

Uw Zeusbestuur
