---
title: ANSIBLE IS AF
created_at: 16-08-2015
author: FlashYoshi
---

Aan het einde van het vorige academiejaar liet onze belangrijkste server, genaamd King, zijn leeftijd zien: zijn RAID-controller had het namelijk begeven, met een hoop corrupte data als gevolg. Na wat spannende momenten (blijkbaar had onze backupserver het ook begeven) kon Silox de data herstellen en wist hij ook aan reserveonderdelen te raken (bedankt Ruben!). De schade bleef dus gelukkig beperkt tot een week downtime.

King is onze server in het datacenter te S10\. Het is een Dell PowerEdge 2850, die machines worden zelfs niet meer verscheept als donatie naar onze partners in het Zuiden wegens te oud (cfr. DICT). Op King draaien alle kritieke applicaties, onze website en die van de andere studentenverenigingen maar ook de Hydra API en Gandalf. Toen het noodlot toesloeg, was het voor ons dus een duidelijk teken dat we nood hadden aan een nieuwe server en een degelijkere backupoplossing. Hiervoor contacteerden we DICT en zij hebben ons een virtuele machine aangeboden in de DICT-cloud. Het was echter niet de beste keuze om gewoon alles te kopiëren van King naar deze nieuwe virtuele machine. De software op King was verouderd en er was zo goed als geen documentatie. We wouden het ook mogelijk maken om een toekomstige migratie gemakkelijk te maken. Op aanraden van onze oude sysadmin begon op dat moment de epische queeste voor het voltooien van Ansible. <!-- more -->

[Ansible](https://docs.ansible.com/ansible/ "Ansible") is een system automation applicatie die groepen van servers kan installeren door het uitvoeren van commando's over ssh, gebaseerd op configuraties die je zelf maakt of van een of andere website downloadt (maar aan zulke makkelijke praktijken doen wij niet mee). De configuraties van Ansible zijn goed onderverdeeld en duidelijk leesbaar waardoor we zowel het probleem van toekomstige migraties en documentatie oplosten. Maar wat niet was opgelost, is het feit dat de software verouderd was en de sysadmins nog onervaren.

Procrat en ik, FlashYoshi, spendeerden vele (code)nights aan het begrijpen van de software op de oude server, het zoeken naar mogelijks nieuwe software en het proberen porten van deze software naar de nieuwe server. Op deze manier verdwenen af en toe enkele (of alle) websites van de live server, je geraakt namelijk snel verward over welke terminal nu de oude en de welke de nieuwe server is. Over het algemeen was het zeker een goede ervaring en liet het ons toe om van enkele hacks af te geraken, zoals het gebruik van Apache enkel en alleen voor de Kerberos-login van de wiki, en het vernieuwen van de software, zoals de wiki, die er nu veel beter uit ziet.

Ansible werd niet alleen maar gebruikt om King te configureren maar ook Abyss, onze NAS die in kelder naast Tweek gesitueerd is, werd door Ansible geconfigureerd.

Deze vakantie liep het allemaal tot een einde, Ansible werkt afgewerkt en de server werd succesvol gemigreerd. Dit feit is enkel mogelijk gemaakt door de grote hulp die Procrat en Silox leverden gedurende het jaar, waarvoor duizendmaal dank, zonder hen zou de volgende sysadmin er nog aan bezig zijn.

Ten slotte kunnen wij, de sysadmins (Silox, Procrat en FlashYoshi), u eindelijk mededelen: **ANSIBLE IS AF!**

P.S.: Onze Ansible-configuratie is openbaar beschikbaar op [GitHub](https://zeus.ugent.be/git/ansible-config "GitHub").
