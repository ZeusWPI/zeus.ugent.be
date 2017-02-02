---
title: "Linux: hoe doe?"
created_at: 02-02-2017
description: Uitleg en tips voor iedereen die linux wil installeren.
author: Rien
toc: true
---

_Bij het begin van ieder schooljaar komt er een verse lading studentjes Informatica toe die in de lessen Computergebruik kennis maken met de wondere wereld van GNU/Linux.
Velen onder hen worden geprikkeld door de onontgonnen mysteries van dit besturingssysteem en groeien een verlangen om zich de kunst van het Unix-tovenaarschap eigen te maken._

Deze blogpost dient als een leidraad voor de dappersten onder hen: zij die het pad naar de verlossing willen bewandelen en een eigen Linux-installatie tot leven willen wekken.

# Enkele tips voor je begint
---

## Probeer eerst in een virtuele machine
Als je nog geen ervaring hebt met het installeren van Linux start je best door eens te oefenen op een VM (virtuele machine).
Zo komt niet alles in één keer op je af en kun je het installatieproces onder de knie krijgen zonder dat je jezelf in de problemen kunt brengen doordat je naast het OS installeren ook rekening moet houden met andere obstakels zoals een dualboot systeem opzetten.

## Zit je vast? RTFM!
Read The Fucking Manual (of forum, of wiki).
Krijg je een rare error, weet je niet wat de volgende stap is of weet je niet waar te beginnen? Panikeer niet onmiddellijk, ieder struikelblok is een kans om te leren.
Foutmeldingen geven vaak een aanwijzing waar het probleem zou kunnen liggen, lees die dus goed.
Indien dat geen verlichting brengt: zoek je specifiek probleem op.
De kans is klein dat jij de eerste bent met hetzelfde probleem.

Enkele goede bronnen van informatie:
- Google en [DuckDuckGo](https://duckduckgo.org) zijn uw vriend!
- De [wiki](https://wiki.archlinux.org/) of het [forum](https://bbs.archlinux.org/) van Arch Linux.
Veel algemene concepten en problemen worden hier uitgelegd die toepasbaar zijn op veel andere distro's.
- Een online [manpage](http://man.he.net/).

## Kies een distro
Er zijn veel verschillende Linux-distributies, elk met een verschillende _look & feel_, moeilijkheidsgraad en ideologie.
Voor beginners kan ik *Linux Mint* of *Fedora* aanraden.
Wie al wat meer ervaring heeft en niet bang is van een terminal kan eens een kijkje nemen naar *Arch Linux*.
[Hier](https://linuxjourney.com/lesson/linux-history#) vind je uitleg over de courantste distro's en op [distrowatch](https://distrowatch.com/) staan de meeste distributies met een korte uitleg.


# 1. Voorbereiding
---

## Fix windows

Als je van plan bent een dualboot te doen (Linux en Windows op één machine) moet je rekening houden met het volgende:

- Maak ruimte vrij op je harde schijf.
Voor Linux is 20GB een goed begin.
Als je zeker wilt zijn is 50GB zeker genoeg.
- [Schakel _fast startup_ uit.](https://www.tenforums.com/tutorials/4189-fast-startup-turn-off-windows-10-a.html) Dit geeft  op meerdere manieren problemen met Linux.
Als je Windows-installatie op een SSD staat is het verschil in opstartsnelheid toch verwaarloosbaar.
- [Stel je hardwaretijd in op UTC](https://wiki.archlinux.org/index.php/time#UTC_in_Windows).
- **Secure Boot:** secure boot is een feature waarmee enkel goedgekeurde bestanden op je harde schijf kunnen gebruikt worden als bootloader: dit bestand wordt bij het opstarten als eerste aangesproken en heeft als taak het besturingssysteem in te laden.
Indien je Linux wil kunnen opstarten zul je secure boot moeten uitschakelen of de bootloader in de BIOS moeten toevoegen als veilig.
Je zoekt best voor jouw specifieke machine op hoe je dit doet.

## Neem backups
Als je Linux installeert naast Windows (of andere belangrijke data op dezelfde machine), hou er dan rekening mee dat het _kan_ mislopen.
De installatie zelf zal niets kapotmaken, maar een ongelukje is snel gebeurd (je bent eventjes verstrooid en markeert de verkeerde partitie voor verwijdering).
Neem daarom een backup van je belangrijkste bestanden op een externe harde schijf, andere laptop, de _cloud_ ...
Better safe than sorry.

# 2. Installatie
---

Kies een installatietutorial voor de distributie die je gekozen hebt.
Probeer steeds alles te snappen voor je iets effectief doet.

- **Fedora:** [wikihow](http://www.wikihow.com/Install-Fedora), de [officiële installatiegids](https://docs.fedoraproject.org/en-US/Fedora/25/html/Installation_Guide/chap-introduction.html) of [een tutorial specifiek voor dualboot](http://linuxbsdos.com/2016/12/01/dualboot-fedora-25-windows-10-on-a-computer-with-uefi-firmware/)
- **Linux Mint:** [dualboot tutorial](http://www.tecmint.com/install-linux-mint-18-alongside-windows-10-or-8-in-dualboot-uefi-mode/) of de [offiële user guide](https://www.linuxmint.com/documentation/user-guide/Cinnamon/english_18.0.pdf)
- **Arch Linux:** de [installation guide](https://wiki.archlinux.org/index.php/installation_guide) is erg uitgebreid.

## Enkele concepten die vaak aan bod komen
Meestal blijven deze delen verborgen als je een installer gebruikt.
Wanneer er iets fout loopt kan het misschien wel handig zijn om te weten wat er precies verkeerd loopt.
Daarnaast is het ook gewoon handig om te weten hoe alles in zijn werk gaat.

### UEFI en BIOS
Hier kan er enige verwarring rond ontstaan.

[UEFI](https://en.wikipedia.org/wiki/Unified_Extensible_Firmware_Interface) is het component waarmee het opstarten van je PC wordt geregeld, BIOS (ook _legacy boot_ genoemd) is de voorganger van [BIOS](https://en.wikipedia.org/wiki/BIOS).
Sinds 2014 hebben de meeste computers een combinatie van beide systemen, men spreekt dan ook wel van UEFI/BIOS.

Het grootste verschil tussen beide systemen is hoe ze booten en welk partitiesysteem ze ondersteunen:

- **BIOS** ondersteund enkel het MBR-partitiesysteem (Master Boot Record).
Bij het opstarten wordt er gekeken naar een paar specifieke sectoren op je harde schijf.
- **UEFI** ondersteund het MBR- en GPT-partitiesysteem (GPT is de opvolger van MBR).
Opstarten kan vanaf ieder UEFI-bestand (eindigend op `.efi` en in een EFS-partitie).

### EFI en ESP
In de installers en tutorials zul je deze termen af en toe zien passeren.
De ESP (EFI System Partition) is een speciale partitie, meestal geformatteerd in FAT32, waar UEFI de bootloaders uit gaat opstarten.
In Linux is deze partitie meestal gemount onder `/boot/` of `/boot/EFI/`.

De Windows-bootloader is hier ook geïnstalleerd.
Als je deze partitie dus verwijderd, zul je niet meer in Windows kunnen opstarten (er zijn manieren om dit te fixen, maar het is meestal simpeler om Windows opnieuw te installeren).
Het kan geen kwaad om hier extra bootloaders te installeren (meer zelfs, het is de bedoeling).
Maar wees extra voorzichtig en weet wat je doet.

### Bootloaders
Bootloaders zijn een soort programma's die de taak hebben om een besturingssysteem in te laden wanneer je computer wordt opgestart.
Wanneer je Linux installeert heb je keuze tussen verschillende bootloaders: grub, grub2, refind, syslinux of andere.
Bootloaders kunnen ingesteld worden zodat je tijdens het opstarten kunt kiezen welk besturingssysteem er wordt opstart: Windows of Linux.
Sommige bootloaders detecteren automatisch wat de verschillende keuzes zijn, maar meestal moet je die zelf configureren of doet de installer dat voor jouw.

### Secure boot
TODO


# 3. Na de installatie
---

Als alles goed is gegaan heb je normaal een werkende Linux installatie.
Proficiat! Wat je nu nog kunt doen:

- Mount automatisch bij het opstarten je Windows partities in Linux
- [Ricing](https://rizonrice.github.io/resources), het eeuwigdurende pimpen van je Linux-installatie.
Kom gerust eens langs in de [Zeus kelder](https://zeus.ugent.be/about/) om installatie te showen en om tips en tricks te vragen.
- Backups maken van je huidige installatie, die je kunt terugzetten wanneer je je installatie breekt (vroeger of later is dit sowieso het geval).
- Je installatie showen aan je vrienden, ouders, grootmoeder, proffen, buren ... om te tonen wat voor een badass computergoochelaar je wel niet bent.
