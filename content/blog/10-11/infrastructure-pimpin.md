---
title: Infrastructure pimpin'
created_at: 24-07-2011
---

![funny-pictures-cat-fixes-your-computer](https://zeus.ugent.be/wp-content/uploads/2011/07/funny-pictures-cat-fixes-your-computer-300x200.jpg){:class="alignright"}

We zijn er al een tijdje druk aan bezig (wat je misschien kon merken aan je Zeus-account die tijdelijk niet bereikbaar was en mailtjes die wat in de soep draaiden) maar met gepaste trots mogen we jullie toch de nieuwe Zeus-infrastructuur voorstellen.

Om te beginnen hebben we zo goed als alle oude server-bakken buiten dienst gesteld. Vanaf nu draaien onze diensten enerzijds op een [Dell PowerEdge 2850](https://zeus.ugent.be/wiki/King) in het datacenter en een [Dell PowerEdge T310](https://zeus.ugent.be/wiki/Ike) in onze eigen kelder (waarop we een aantal servers op gevirtualiseerd hebben).

Vervolgens hebben we onze diensten-aanbod ook lichtjes gewijzigd en een stevige technologische update gegeven. Websites van niet-Zeus leden zijn niet meer gekoppeld aan een Zeus-account en draaien op een andere server (wat hopelijk voor een hogere beschikbaarheid zorgt).

Voor Zeus-leden voerden we volgende upgrades door:

- [Kerberos](https://zeus.ugent.be/wiki/Kerberos) vervangt LDAP als authenticatiesysteem (kenners denken nu waarschijnlijk "duh!"). Dit heeft een aantal voordelen en nadelen. Kerberos is veel veiliger dan LDAP en werkt aan de hand van ticketjes waarmee je je bij andere services kan authenticeren (zoals AFS, ssh en ftp). Je hoeft je dus maar 1 maal aan te melden en je hebt overal toegang. Dit betekent wel dat je geen gebruik kunt maken van key-based logins (voor bvb. ssh) omdat dit niet compatibel is met dit authenticatiemodel.
- [AFS](https://en.wikipedia.org/wiki/Andrew_File_System) vervangt NFS als netwerkopslag voor de home-directories. AFS is een distributed filesystem dat gebruik maakt van Kerberos. Concreet betekent dit dat niemand je gegevens kan lezen zonder een geldig Kerberos ticketje. Alle bestanden uit de oude homedirs zijn overgezet.

Binnenkort ontvangt elk Zeus-lid dat ons heeft aangegeven zijn account te willen behouden zijn een nieuw wachtwoord via mail en instructies om dit te wijzigen. Het is zeker mogelijk dat er bij de overgang naar dit nieuwe systeem nog wat kinderziektes zijn. Bij problemen/vragen aarzel niet om naar [admin@zeus.ugent.be](mailto:admin@zeus.ugent.be) te mailen.

**Update:** onze webserver staat vanaf nu in het datacenter S10. Alle andere services blijven in de servers in de kelder draaien en zijn vanaf nu te bereiken via **kelder.zeus.ugent.be**. Zeus-leden dienen dan ook naar kelder.zeus.ugent.be te SSH'en (zoals steeds op poort 2222).
