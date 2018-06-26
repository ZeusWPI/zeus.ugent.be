---
author: Eloïse, Isaura en Lorin
title: "De eet- en drankgewoonten in Zeus gevisualiseerd"
created_at: 17-05-2018
description: Een datavisualisatie project
toc:
  depth: 2
---

<div class='tooltip'></div>

# Introductie

Deze blogpost en de bijhorende visualisaties zijn gemaakt in functie van het vak Datavisualisatie, gegeven door Bart Mesuere.
In dit vak kregen we de opdracht om een dataset te kiezen en die te visualizeren. Het was natuurlijk een
no-brainer om de data die we al een aantal jaar aan het vergaren zijn van [Haldis](https://zeus.ugent.be/haldis) en [Tap](https://zeus.ugent.be/tap) te gebruiken.

Als je geïnteresseerd genoeg bent in het lezen van deze blogpost, ben je hoogstwaarschijnlijk geïnformeerd genoeg om te weten
wat Haldis, Tap en Tab zijn, maar voor de ongeïnitieerden volgt een korte uitleg.

## Haldis

Sinds 2 april 2015 maakt Zeus gebruik van Haldis, een applicatie om het bestellen van eten in groep te vergemakkelijken.
Dit laat onder andere toe dat mensen die nog op weg zijn naar te kelder toch eten kunnen bestellen. Bekijk
het project op <https://zeus.ugent.be/haldis>. We hebben over die aantal jaar een vierhonderdtal bestellingen geplaatst. Handmatig alle bestellingen opnemen heeft geen plaats meer in Zeus!

## Tap

Tap is onze digitale vervanging van het oude papier-en-streepjes systeem dat we al jaar en dag gebruikten om drankjes te verkopen in de kelder. Elke drankje of
versnapering was een aantal streepjes waard, wat ons weinig fine-grained controle gaf over de productprijzen. Met Tap losten we dit probleem op met een hypermodern alternatief --- een tablet (genaamd koelkast) op de koelkast.

# Visualisaties

## Haldis

### Afstanden

Op onze eerste visualisatie kunnen we via een timeline zien waar we het vaakst naartoe gaan met Zeus, en welke afstanden
we bereid zijn om hiervoor te overbruggen. Om de timeslider te gebruiken kan je de timeslider naar beneden of naar boven
slepen om in of uit te zoomen.

We zien natuurlijk dat we vaak rond de Zeus kelder onze restaurants kiezen. Als je echter de timeslider rond het academiejaar '16-'17 zet, zie je dat we nogal avontuurlijk waren! We gingen buiten onze comfortzone, en zochten restaurants verder en verder op! We denken dat dit voornamelijk komt doordat er meer Zeusleden waren die met de auto wat verder eten konden halen (vooral Benji ❤️).

<div id="leafletmap" style="height:500px; width:100%"></div>
<svg id="slider1" style="width: 100%"></svg>
<div id="dayButtons" class="has-content-centered">
  <a class="button is-small is-info is-outlined" data-day-idx='1'>Maandag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='2'>Dinsdag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='3'>Woensdag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='4'>Donderdag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='5'>Vrijdag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='6'>Zaterdag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='0'>Zondag</a>
  <a class="button is-small is-info is-outlined" data-day-idx='-1'>Reset Filters</a>
</div>
<button id="playButton" class="button is-primary">Play</button>

### Punchcard

Op onze tweede visualisatie krijgen we te zien wat de populairste uren zijn voor alle restaurants, zo zien we dat we onder andere eens 's avonds laat een frietje durven stekken bij 't Blauw Kotje! Bij de Fritoloog doen we dit minder vaak. Dit zal voornamelijk te wijten zijn aan het feit dat we nu minder laat in de kelder zitten. Door de timeslider op een vorig academiejaar te zetten kunnen we dit zien.

<div class="full-width has-content-centered">
  <svg id="punchcard" width="1300" height="600"></svg>
</div>
<svg id="slider2" style="width: 100%"></svg>
<button id="playButton2" class="button is-primary">Play</button>

### Instance

In de instance chart van Haldis zien we elke bestelling die
geplaatst werd, gesorteerd op eerste tijdstip van bestelling. Merk op hoe de Fritoloog plots onze favoriete frituur is geworden! Ook zien we dat pizza iets minder populair is geworden, en dat Ocean Garden onze favoriet blijft. Onze liefde voor Chinees is dus niet voor maar "tien minuutjes!", maar voor eeuwig.

<div class="full-width has-content-centered">
  <svg id="instance" width="1200" height="600"></svg>
</div>

### Rankings

We zien het verloop van de rangschikking van de verschillende restaurants. Interessant om te zien is onder andere de ongeloofelijke stijging van de Fritoloog als onze favoriete frituur.

<div class="full-width has-content-centered" style="overflow-x: auto">
  <svg id="rankings" width="90%" height="700"></svg>
</div>

## Haldis & Tap

### Co-occurence van Tap en Haldis

Op de volgende chart zien we welke producten er besteld worden op Tap bij bepaalde restaurants op Haldis. Zo zien we onder andere dat er 5% vaker Club Maté besteld wordt bij het Blauw Kotje (frieten) dan bij onze favoriet Ocean Garden (chinees)!

<div id="gridlo" class="full-width has-content-centered"></div>
<button name="updateButton" id="switch" value="Update" class="button is-primary">Switch</button>

### Co-occurence van Haldis, Tap en Zeus events

Hier kunnen we verschillende statistieken van Haldis en Tap met elkaar vergelijken, en tegelijkertijd een eventueel verband met de Zeus-events bekijken.

<div class="full-width has-content-centered">
  <div class="viscontainer">
    <div class="button-container">
      <div style="height:400px;">
        <p align="center">
          <strong> Haldis </strong>
        </p>
        <a class="button is-info is-outlined button-item is-fullwidth" id="haldis-user-button">
          number of users
        </a>
        <a class="button is-info is-outlined button-item is-fullwidth" id="haldis-price-button">
          total expenses
        </a>
      </div>
      <div style="height:400px;">
        <p align="center">
          <strong> Tap </strong>
        </p>
        <a class="button is-info is-outlined button-item is-fullwidth" id="tap-user-button">
          number of orders
        </a>
        <a class="button is-info is-outlined button-item is-fullwidth" id="tap-price-button">
          number of users
        </a>
      </div>
    </div>
    <div class="visualisation" style="width: 1000px">
      <div class='tooltip'></div>
      <svg id="barchart" style="height:800px; width: 100%"></svg>
      <svg id="slider" style="height: 200px; width: 100%"></svg>
    </div>
  </div>
</div>

<% content_for :scripts do %>
<script src="https://code.jquery.com/jquery-3.0.0.min.js" charset="utf-8"></script>

<!-- CDNS -->
<script src="https://d3js.org/d3.v5.min.js"></script>
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/leaflet.css" integrity="sha256-iYUgmrapfDGvBrePJPrMWQZDcObdAcStKBpjP3Az+3s=" crossorigin="anonymous" />
<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/1.3.1/leaflet.js" integrity="sha256-CNm+7c26DTTCGRQkM9vp7aP85kHFMqs9MhPEuytF+fQ=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/leaflet/0.7.7/leaflet.js" integrity="sha256-aReBHzIjoMzKrp0H4XnxXIm0mwuNG/F+00pKDiFuLxI=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/lodash.js/4.17.10/lodash.min.js" integrity="sha256-VKITM616rVzV+MI3kZMNUDoY5uTsuSl1ZvEeZhNoJVk=" crossorigin="anonymous"></script>
<script src="https://cdnjs.cloudflare.com/ajax/libs/moment.js/2.22.1/moment.min.js" integrity="sha256-L3S3EDEk31HcLA5C6T2ovHvOcD80+fgqaCDt2BAi92o=" crossorigin="anonymous"></script>

<%= asset :js, 'datavis/bubbleMap' %>
<%= asset :js, 'datavis/timeSlider' %>
<%= asset :js, 'datavis/punchcard' %>
<%= asset :js, 'datavis/rankingChart' %>
<%= asset :js, 'datavis/instanceChart' %>
<%= asset :js, 'datavis/blog' %>
<%= asset :js, 'datavis/script2' %>
<%= asset :js, 'datavis/scriptlo' %>
<% end %>

<%= asset :css, 'datavis/style' %>
<%= asset :css, 'datavis/blog' %>
