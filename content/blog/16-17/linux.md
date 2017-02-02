---
title: "Linux: hoe doe?"
created_at: 02-02-2017
description: Uitleg en tips voor iedereen die linux wil installeren.
author: Rien
toc:
  depth: 1
---

_Tijdens het begin van ieder schooljaar komt er een verse lading studentjes Informatica toe die in de lessen Computergebruik kennis maken met de wondere wereld van GNU/Linux. Velen onder hen worden geprikkeld door de onontgonnen mysteries van dit besturingssysteem en groeien een verlangen om de kunst van het Unix-tovenaarschap zich eigen te maken._

Deze blogpost dient als een leidraad voor de dappersten onder hen: zij die het pad naar de verlossing willen bewandelen en een eigen Linux-installatie willen tot leven wekken.

# Enkele tips voor je begint
---

## Probeer eerst in een virtuele machine
Als je nog geen ervaring hebt met het installeren van Linux start je best door eens te oefenen op een VM (virtuele machine). Zo komt niet alles in één keer op je af. Zo kun je eerst het installatieproces onder de knie krijgen zonder meteen rekening te hoeven houden met eventuele problemen, dual boot opzetten en andere obstakels.

## Zit je vast? RTFM!
Read The Fucking Manual (of forum, of wiki). Kom je op een rare error terecht, weet je niet wat de volgende stap is of weet je niet waar te beginnen? Raak niet direct in paniek, ieder struikelblok is een kans om te leren. Foutmeldingen geven vaak een aanwijzing waar het probleem zou kunnen liggen, lees die dus goed. Indien dat geen verlichting brengt: zoek je specifiek probleem op. De kans is klein dat jij de eerste bent met hetzelfde probleem.

Enkele goede bronnen van informatie:
- Google en [DuckDuckGo](https://duckduckgo.org) zijn uw vriend!
- De [wiki](https://wiki.archlinux.org/) of het [forum](https://bbs.archlinux.org/) van Arch Linux. Veel algemene concepten en problemen worden hier uitgelegd die toepasbaar zijn op veel andere distro's.
- Een online [manpage](http://man.he.net/).

## Kies een distro
Er zijn veel verschillende Linux-distributies, elk met een verschillende _look & feel_, moeilijkheidsgraad en ideologie. Voor beginners kan ik *Linux Mint* of *Fedora* aanraden. Wie al wat meer ervaring heeft en niet bang is van een terminal kan eens een kijkje nemen naar *Arch Linux*. [Hier](https://linuxjourney.com/lesson/linux-history#) vind je uitleg over de courantste distro's en op [distrowatch](https://distrowatch.com/) staan de meeste distributies met een korte uitleg.


# 1. Voorbereiding
---

## Fix windows

Als je van plan bent een dual-boot te doen (Linux en Windows op één machine) moet je rekening houden met het volgende:

- Maak ruimte vrij op je harde schijf. Voor Linux 20GB is een goed begin. Als je zeker wilt zijn is 50GB zeker genoeg.
- [Schakel _fast startup_ uit.](https://www.tenforums.com/tutorials/4189-fast-startup-turn-off-windows-10-a.html) Dit geeft  op meerdere manieren problemen met Linux. Als je Windows-installatie op een SSD staat is het verschil in opstartsnelheid toch verwaarloosbaar.
- [Stel je hardwaretijd in op UTC](https://wiki.archlinux.org/index.php/time#UTC_in_Windows).
- **Secure Boot:** secure boot is een feature waarmee enkel goedgekeurde bestanden op je harde schijf kunnen gebruikt worden als bootloader: dit bestand wordt bij het opstarten als eerste aangesproken en heeft als taak het besturingssysteem in te laden. Indien je Linux wil kunnen opstarten zul je secure boot moeten uitschakelen of de bootloader in de BIOS moeten toevoegen als veilig. Je zoekt best voor jouw specifieke machine op hoe je dit doet.

## Neem backups
Als je Linux installeert naast Windows (of andere belangrijke data op dezelfde machine), hou er dan rekening mee dat het _kan_ mislopen. De installatie zelf zal niets kapotmaken, maar een ongelukje is snel gebeurd (je bent eventjes verstrooid en markeert de verkeerde partitie voor verwijdering). Neem daarom een backup van je belangrijkste bestanden op een externe harde schijf, andere laptop, de _cloud_ ... Better safe than sorry.

# 2. Installatie
---

Kies een installatietutorial voor de distributie die je gekozen hebt. Probeer steeds alles te snappen wat je aan het doen bent.

- **Fedora:** [wikihow](http://www.wikihow.com/Install-Fedora), de [officiële installatiegids](https://docs.fedoraproject.org/en-US/Fedora/25/html/Installation_Guide/chap-introduction.html) of [een tutorial specifiek voor dualboot](http://linuxbsdos.com/2016/12/01/dual-boot-fedora-25-windows-10-on-a-computer-with-uefi-firmware/)
- **Linux Mint:** [dualboot tutorial](http://www.tecmint.com/install-linux-mint-18-alongside-windows-10-or-8-in-dual-boot-uefi-mode/) of de [offiële user guide](https://www.linuxmint.com/documentation/user-guide/Cinnamon/english_18.0.pdf)
- **Arch Linux:** de [installation guide](https://wiki.archlinux.org/index.php/installation_guide) op de wiki is erg uitgebreid.

## Enkele concepten die vaak aan bod komen

### UEFI en BIOS
Dit zijn componenten in je laptop die het opstarten van je PC regelen. UEFI is de nieuwere versie van BIOS (alle recente laptops hebben UEFI). BIOS wordt ook wel _legacy boot_ genoemd en de meeste laptops zijn backwards compatible. De naam BIOS wordt echter nog steeds gebruikt ook al wordt UEFI bedoeld.

Indien je geen UEFI ter beschikking hebt moet je hier extra rekening mee houden. Er zijn grote verschillen in hoe bootloaders worden opgestart en waar ze zich moeten bevinden. Ze hebben bijvoorbeeld geen ESP (zie hieronder). Je zoekt hier best gespecialiseerde tutorials voor.

### EFI en ESP
In de installers en tutorials zul je vaak deze termen zien passeren. De ESP (EFI System Partition) is een speciale partitie, meestal geformatteerd in FAT32, waar UEFI de bootloaders uit gaat opstarten. In Linux is deze partitie meestal gemount onder `/boot/` of `/boot/EFI/`.

De Windows-bootloader is hier ook geïnstalleerd. Als je deze partitie dus verwijderd zul je niet meer in Windows kunnen opstarten (er zijn manieren om dit te fixen, maar het is meestal simpeler om Windows opnieuw te installeren). Het kan geen kwaad om hier extra bootloaders te installeren (meer zelfs, het is de bedoeling). Maar wees extra voorzichtig en weet wat je doet.

### Bootloaders
Zoals eerder vermeld hebben bootloaders de taak om je besturingssysteem in te laden wanneer je computer wordt opgestart. Wanneer je Linux installeert heb je keuze tussen verschillende bootloaders: grub, grub2, refind, syslinux of andere.
Bootloaders kunnen ingesteld worden dat je tijdens het opstarten kunt kiezen welk besturingssysteem je opstart: Windows of Linux. Sommige bootloaders detecteren automatisch wat de verschillende keuzes zijn, maar meestal moet je die zelf configureren.


# 3. Na de installatie
---

Als alles goed is gegaan heb je normaal een werkende Linux installatie. Proficiat! Wat je nu nog kunt doen:

- Mount automatisch bij het opstarten je Windows partities in Linux
- [Ricing](https://rizonrice.github.io/resources), het eeuwigdurende pimpen van je Linux-installatie
- Backups maken van je huidige installatie, die je kunt terugzetten wanneer je je installatie breekt (vroeger of later is dit sowieso het geval).
- Je installatie showen aan je vrienden, ouders, grootmoeder, proffen, buren ... om te tonen wat voor een badass computergoochelaar je wel niet bent.
