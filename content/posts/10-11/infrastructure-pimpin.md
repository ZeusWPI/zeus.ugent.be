---
title: Infrastructure pimpin'
banner: http://zeus.ugent.be/wp-content/uploads/2011/07/funny-pictures-cat-fixes-your-computer-300x200.jpg
created_at: 24-07-2011
time: 23-02-2016
location: Zeus kelder
---

<img src="http://zeus.ugent.be/wp-content/uploads/2011/07/funny-pictures-cat-fixes-your-computer-300x200.jpg" alt="" title="funny-pictures-cat-fixes-your-computer" width="300" height="200" class="alignright size-medium wp-image-752" />

We zijn er al een tijdje druk aan bezig (wat je misschien kon merken aan je Zeus-account die tijdelijk niet bereikbaar was en mailtjes die wat in de soep draaiden) maar met gepaste trots mogen we jullie toch de nieuwe Zeus-infrastructuur voorstellen.

Om te beginnen hebben we zo goed als alle oude server-bakken buiten dienst gesteld. Vanaf nu draaien onze diensten enerzijds op een <a href="http://zeus.ugent.be/wiki/King">Dell PowerEdge 2850</a> in het datacenter en een <a href="http://zeus.ugent.be/wiki/Ike">Dell PowerEdge T310</a> in onze eigen kelder (waarop we een aantal servers op gevirtualiseerd hebben).

Vervolgens hebben we onze diensten-aanbod ook lichtjes gewijzigd en een stevige technologische update gegeven. Websites van niet-Zeus leden zijn niet meer gekoppeld aan een Zeus-account en draaien op een andere server (wat hopelijk voor een hogere beschikbaarheid zorgt). 

Voor Zeus-leden voerden we volgende upgrades door:
<ul>
	<li><a href="http://zeus.ugent.be/wiki/Kerberos">Kerberos</a> vervangt LDAP als authenticatiesysteem (kenners denken nu waarschijnlijk "duh!").

Dit heeft een aantal voordelen en nadelen. Kerberos is veel veiliger dan LDAP en werkt aan de hand van ticketjes waarmee je je bij andere services kan authenticeren (zoals AFS, ssh en ftp). Je hoeft je dus maar 1 maal aan te melden en je hebt overal toegang. Dit betekent wel dat je geen gebruik kunt maken van key-based logins (voor bvb. ssh) omdat dit niet compatibel is met dit authenticatiemodel.</li>

	<li><a href="http://en.wikipedia.org/wiki/Andrew_File_System">AFS</a> vervangt NFS als netwerkopslag voor de home-directories.

AFS is een distributed filesystem dat gebruik maakt van Kerberos. Concreet betekent dit dat niemand je gegevens kan lezen zonder een geldig Kerberos ticketje. Alle bestanden uit de oude homedirs zijn overgezet.</li>
</ul>

Binnenkort ontvangt elk Zeus-lid dat ons heeft aangegeven zijn account te willen behouden zijn een nieuw wachtwoord via mail en instructies om dit te wijzigen. Het is zeker mogelijk dat er bij de overgang naar dit nieuwe systeem nog wat kinderziektes zijn. Bij problemen/vragen aarzel niet om naar <a href="mailto:admin@zeus.ugent.be">admin@zeus.ugent.be</a> te mailen.

<strong>Update:</strong> onze webserver staat vanaf nu in het datacenter S10. Alle andere services blijven in de servers in de kelder draaien en zijn vanaf nu te bereiken via <strong>kelder.zeus.ugent.be</strong>. Zeus-leden dienen dan ook naar kelder.zeus.ugent.be te SSH'en (zoals steeds op poort 2222).