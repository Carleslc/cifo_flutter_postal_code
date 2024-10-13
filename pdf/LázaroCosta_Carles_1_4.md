---
date: 11 d'octubre de 2024
title: Activitat d'avaluació 1.4 - Crea una app amb connexió a backend
subtitle: Postal Code Info
author:
- title: CIFO L'Hospitalet
  name: Desenvolupament d’Aplicacions mòbils per iOS i Android amb Flutter
- title: Alumne
  name: Carles Lázaro Costa
- title: Tutor
  name: Eduard Carreras
colorlinks: true
linkcolor: Black
toc: true
toc-depth: 3
# Generat amb `md2pdf LázaroCosta_Carles_1_4.md ca "Rosario" 12pt`
---

# Postal Code

**Repositori del codi: [cifo_flutter_postal_code](https://github.com/Carleslc/cifo_flutter_postal_code)**

**Repositori d'aplicacions: [cifo_flutter](https://github.com/Carleslc/cifo_flutter)**

Activitat d'accés a una API externa utilitzant Flutter.

Hi ha dues pantalles, una primera per buscar la localitat d'un codi postal en un país determinat, i una segona per buscar a partir d'un nom les localitats que contenen el nom introduït amb els seus codis postals, juntament amb un selector de país i regió.

<a href="https://idx.google.com/import?url=https%3A%2F%2Fgithub.com%2FCarleslc%2Fcifo_flutter_postal_code%2F" target="_blank">
  <picture>
    <source
      media="(prefers-color-scheme: dark)"
      srcset="https://cdn.idx.dev/btn/open_dark_32.svg">
    <source
      media="(prefers-color-scheme: light)"
      srcset="https://cdn.idx.dev/btn/open_light_32.svg">
    <img
      height="32"
      alt="Open in IDX"
      src="https://cdn.idx.dev/btn/open_purple_32.svg">
  </picture>
</a>

\pagebreak

## Instal·lació

1. S'ha d'haver instal·lat el [Flutter SDK](https://docs.flutter.dev/get-started/install).

2. Clonar el repositori:

```sh
git clone https://github.com/Carleslc/cifo_flutter_postal_code.git
# GitHub CLI: gh repo clone Carleslc/cifo_flutter_postal_code

cd cifo_flutter_postal_code
```

3. Instal·lar les dependències:

```sh
flutter pub get
```

4. Executar l'aplicació amb `flutter run` o desde l'IDE.

## Estructura de l'aplicació

```
lib
├── main.dart
├── models
│   ├── data_model.dart
│   ├── iso_country.dart
│   └── postal_places.dart
├── providers
│   └── country_provider.dart
├── screens
│   ├── place_by_code_page.dart
│   ├── place_by_code_results.dart
│   ├── place_screen.dart
│   ├── places_by_name_page.dart
│   └── places_by_name_results.dart
├── services
│   ├── country_service.dart
│   └── zippopotam_service.dart
├── styles
│   ├── app_styles.dart
│   ├── color_styles.dart
│   └── text_styles.dart
├── utils
│   ├── error.dart
│   ├── logger.dart
│   └── strings.dart
└── widgets
    ├── map_button.dart
    ├── place_info.dart
    ├── places_list.dart
    ├── postal_place_info.dart
    ├── searching_indicator.dart
    ├── selectors
    │   ├── country_selector.dart
    │   ├── selector.dart
    │   └── subdivision_selector.dart
    ├── text_fields
    │   ├── place_name_text_field.dart
    │   └── post_code_text_field.dart
    └── text_label_value.dart
assets
└── iso-3166-ca.json
```

L'inici de l'aplicació és a `main.dart`.

A la carpeta **`models`** es troben les classes de domini i serialització, com `PostalPlacesByCode`, `PostalPlacesByName`, `Country` i `Subdivision`, entre d'altres.

Les pantalles de l'aplicació es troben a la carpeta **`screens`**. La pantalla principal és `place_screen.dart`, que té dues pàgines `PlaceByCodePage` (`place_by_code_page.dart`) i `PlacesByNamePage` (`places_by_name_page.dart`). La búsqueda i els resultats es mostren a les pantalles `PlaceByCodeResults` (`place_by_code_results.dart`) o `PlacesByNameResults` (`places_by_name_results.dart`), respectivament.

A **`providers`** es guarda l'estat global de l'aplicació del país seleccionat per l'usuari, a `country_provider.dart`.

A la carpeta **`services`** hi ha el servei `CountryService`, que llegeix el fitxer `assets/iso-3166-ca.json` que conté els noms i codis dels països i les seves regions, i el servei `ZippopotamService` que accedeix a la API externa per obtenir codis postals i localitats, i conté informació sobre els països suportats per la API.

A la carpeta **`styles`** es troben els estils de l'aplicació, que s'accedeixen mitjançant la classe `AppStyles` definida a `app_styles.dart`. Les altres classes d'estils són per organitzar millor el codi i definir el tema de colors i textos.

A **`widgets`** hi ha els widgets propis que no es corresponen amb una pantalla determinada, que ajuden a mantenir el codi organitzat.

`PlacesList` mostra la llista de llocs, amb la capçalera `PostalPlaceInfo` que mostra informació compartida per les localitats, i cada localitat és un `PlaceInfo` que mostra la informació de la localitat individual.

A `widgets/text_fields` hi ha els widgets per l'entrada de text per part de l'usuari, per al codi postal `PostCodeTextField` i per al nom `PlaceNameTextField`.

A `widgets/selectors` hi ha els selectors de país `CountrySelector` i regió `SubdivisionSelector`, que utilitzen el selector genèric `Selector<T>` de `selector.dart`.

Hi han altres widgets d'utilitat com `TextLabelValue` o `SearchingIndicator`.

A **`utils`** hi ha mètodes auxiliars per tractar strings `strings.dart` i per mostrar missatges d'error `error.dart` o missatges de debug `logger.dart`.

## Notes del desenvolupament

Per començar l'aplicació he llegit el pdf [Activitat davaluació 1.4 - Crea una app amb connexió a backend.pdf](<./Activitat davaluació 1.4 - Crea una app amb connexió a backend.pdf>) per tenir una idea general de com funciona la API de [_Zippopotam_](https://zippopotam.us/) i les tasques a desenvolupar.

Després he investigat la pàgina de la API i he provat els exemples `https://api.zippopotam.us/es/08900` i `https://api.zippopotam.us/es/ct/hospi`, entre d'altres, per veure quin és el format que retornen les dues crides, una per buscar la localitat d'un codi postal i l'altre per buscar les diferents localitats amb el seus codis postals a partir d'un nom.

Les classes d'estils `AppStyles`, `ColorStyles` i `TextStyles` s'han copiat de l'anterior aplicació [1.3](https://github.com/Carleslc/cifo_flutter_fitness_time/tree/master/lib/styles) i s'han modificat per adaptar el tema dels widgets utilitzats. La paleta de colors s'ha definit mitjançant [`ColorScheme.fromSeed`](https://api.flutter.dev/flutter/material/ColorScheme/ColorScheme.fromSeed.html) i [`Colors.blueGrey`](https://api.flutter.dev/flutter/material/Colors/blueGrey-constant.html).

He definit els models del fitxer `models/postal_places.dart`, primerament utilitzant la pàgina [`quicktype`](https://app.quicktype.io/) i després modificant el resultat perque utilitzi herència, ja que en les dues crides els atributs dels llocs són els mateixos, però estàn disposats amb una estructura diferent. He creat la clase base `PostalPlaces` amb els atributs comuns a les dues crides (_country, countryAbbreviation, places_) i les clases `PostalPlacesByCode` i `PostalPlacesByName` que afegeixen els atributs diferents per cada cas d'ús. La llista de llocs utilitza una estructura similar, amb `Place` com a classe base pels atributs comuns a un lloc (_name, latitude, longitude_) i les clases `PlaceByCode` i `PlaceByName` per afegir els atributs diferents de cada crida.

Després he creat el servei `ZippopotamService` per afegir els dos tipus de cerca, per codi postal i per nom, utilitzant els models definits prèviament.

He investigat com funcionen els paràmetres dels codis de país i regió, que utilitzen l'estàndard [ISO-3166](https://www.iso.org/iso-3166-country-codes.html) (_ISO-3166-1-alpha2_ pel codi de país de dos dígits com `es` per Espanya, i la segona part del codi _ISO-3166-2_ pel codi de la regió, com `ct` per Catalunya). A l'apartat [_Countries Supported_](https://zippopotam.us/#where) de la pàgina de _Zippopotam_ es mostren quins codis de país es poden utilitzar, però no hi ha gaire informació sobre les regions. Més informació a [geonames.org](https://www.geonames.org/countries). Per generar els codis de països amb les seves regions (subdivisions) he creat un script amb Python a `scripts/iso3166.py`, que utilitzant la llibreria [`pycountry`](https://pypi.org/project/pycountry/) genera un fitxer amb els països i les seves regions, que he afegit a `assets/iso-3166-ca.json` i definit a `pubspec.yaml` perque estigui disponible a l'aplicació. Aquest fitxer es llegeix mitjançant el servei `CountryService` i els països es filtren per guardar només els suportats mitjançant el mètode `loadSupportedCountries()` definit a `ZippopotamService`, que es crida a l'inici de l'aplicació a `main.dart` perque estiguin disponibles pels selectors de país i de regió. D'aquesta manera quan es renderitza la pantalla principal ja apareix el selector, amb el país per defecte seleccionat i el nom traduït al català.

S'han afegit les dues pantalles de búsqueda mitjançant un `PageView` dins de la pantalla principal `PlaceScreen`.

La primera pàgina és `PlaceByCodePage` (`screens/place_by_code_page.dart`) i conté un selector de país mitjançant el widget `CountrySelector`, un _text field_ per introduïr el codi postal amb el widget `PostCodeTextField` (`widgets/text_fields/post_code_text_field.dart`), i un botó [`ElevatedButton`](https://api.flutter.dev/flutter/material/ElevatedButton-class.html) per buscar resultats. També funciona mitjançant l'acció `onSubmit` del teclat a l'introduïr el codi postal.

S'ha afegit validació del format del codi postal espanyol, per verificar que té 5 dígits numèrics i que està dins del rang que es mostra a l'apartat [_Countries Supported_](https://zippopotam.us/#where) de la pàgina de _Zippopotam_. Es podria millorar ampliant aquesta comprovació per la resta de països, que actualment només verifica que no sigui buit i es limita la mida màxima a 10 caràcters. Pels països amb codi postal on tots els caràcters son numèrics s'utilitza el teclat numèric, per la resta el teclat de text d'adreça.

La pantalla de resultats és `PlaceByCodeResults` (`screens/place_by_code_results.dart`), que utilitza un [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html) per fer la crida asíncrona `fetchPlacesByCode` utilitzant el servei `ZippopotamService` i gestionar la resposta. Els resultats es mostren amb el widget `PlacesList`, que mostra una capçalera amb el widget `PostalPlaceInfo` per la informació comuna a tots els llocs trobats, i després una llista [`ListView`](https://api.flutter.dev/flutter/widgets/ListView-class.html) amb els llocs, on cada lloc utilitza el widget `PlaceInfo` per mostrar la seva informació com nom i regió. Generalment s'espera que només hi hagi un resultat, però aquest widget es pot reutilitzar per més resultats com en el següent cas.

La segona pàgina és `PlacesByNamePage` (`screens/places_by_name_page.dart`), que és similar a l'anterior però afegeix el selector de regió `SubdivisionSelector` i el _text field_ permet introduïr text fins a 100 caràcters utilitzant el widget `PlaceNameTextField` (`widgets/text_fields/place_name_text_field.dart`).

La pantalla de resultats és `PlacesByNameResults` (`places_by_name_results.dart`), que igual que a l'anterior pantalla utilitza un [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html) per fer la crida asíncrona `fetchPlacesByName` utilitzant el servei `ZippopotamService` i gestionar la resposta. Es reutilitza el mateix widget `PlacesList` per mostrar els resultats, ja que requereix un objecte `PostalPlaces` que correspon a la classe base dels dos casos, i dins dels widgets `PostalPlaceInfo` i `PlaceInfo` es decideix quina informació s'ha de mostrar a la fila en funció del tipus específic de dades, `PostalPlacesByCode` / `PostalPlacesByName` i `PlaceByCode` / `PlaceByName`. En el cas d'aquesta segona pantalla que busca per nom, es mostra el nom de la localitat i el seu codi postal. Aquesta informació es pot copiar ja que s'utilitza un [`SelectableText`](https://api.flutter.dev/flutter/material/SelectableText-class.html).

També hi ha un botó `MapButton` (`widgets/map_button.dart`) a cada localitat dels resultats que obre l'aplicació de Google Maps amb la ubicació de la localitat utilitzant la llibreria [url_launcher](https://pub.dev/packages/url_launcher). El botó té un [`Tooltip`](https://api.flutter.dev/flutter/material/Tooltip-class.html) que mostra les coordinades si es fa una pulsació llarga.

Per tal de que es comparteixi i es sincronitzi la selecció del país entre les dues pantalles s'utilitza el [provider](https://pub.dev/packages/provider) `CountryProvider`, inicialitzat a `main.dart` i utilitzat amb [`Consumer<CountryProvider>`](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html) a `PlaceByCodePage` i `PlacesByNamePage` amb `setCountry` i `setSubdivision` que criden a [`notifyListeners`](https://api.flutter.dev/flutter/foundation/ChangeNotifier/notifyListeners.html).

Les principals dificultats que he trobat han sigut modelar les dades de la API perque utilitzin herència degut a que la majoria d'atributs es repeteixen en les dues crides de la API però tenen una estructura diferent, i modelar els països i les seves regions, utilitzant el fitxer generat `assets/iso-3166-ca.json` i les classes de `models/iso_country.dart`, per fer els selectors de país i regió, que comparteixen l'estat entre pantalles mitjançant el provider `CountryProvider`.
També he trigat temps en organitzar el codi, com per exemple utilitzant `Selector<T>` pels selectors i widgets d'utilitat com `TextLabelValue`, i els widgets de les dades `PostalPlaceInfo` i `PlaceInfo`.

Es podria seguir millorant el codi per exemple generalitzant les classes dels diferents `text_fields`, que són similars. Probablement també es podrien refactoritzar els fitxers `place_by_code_page.dart` i `place_by_name_page.dart` ja que la seva estructura és molt similar, al igual que les pàgines de resultats corresponents.

També es podria investigar com inicialitzar els països d'una manera diferent que a `main.dart`, ja que actualment no s'inicia l'aplicació fins que es carreguen els països suportats, i pot ser un procés una mica lent.

He utilitzat l'IDE _Visual Studio Code_ durant tot el desenvolupament, utilitzant principalment un mòvil físic Pixel 8 amb Android 14 (API 35). També he provat l'aplicació amb un emulador amb Android 10 (API 29) i mitjançant l'IDE web [Project IDX](https://idx.google.com/import?url=https%3A%2F%2Fgithub.com%2FCarleslc%2Fcifo_flutter_fitness_time%2F).

## Imatges

![postal_code_1.png](<../images/postal_code_1.png>)

![postal_code_2.png](<../images/postal_code_2.png>)

![postal_code_3.png](<../images/postal_code_3.png>)

![postal_code_4.png](<../images/postal_code_4.png>)

![postal_code_5.png](<../images/postal_code_5.png>)

![postal_code_6.png](<../images/postal_code_6.png>)

![postal_code_7.png](<../images/postal_code_7.png>)

![postal_code_8.png](<../images/postal_code_8.png>)

![postal_code_9.png](<../images/postal_code_9.png>)

![postal_code_10.png](<../images/postal_code_10.png>)

![postal_code_11.png](<../images/postal_code_11.png>)

![postal_code_12.png](<../images/postal_code_12.png>)

![postal_code_13.png](<../images/postal_code_13.png>)

![postal_code_14.png](<../images/postal_code_14.png>)

![postal_code_15.png](<../images/postal_code_15.png>)

![postal_code_16.png](<../images/postal_code_16.png>)

![postal_code_17.png](<../images/postal_code_17.png>)

## Recursos

[**Zippopotam API**](https://api.zippopotam.us/)

Codis de país:

- [ISO-3166-1 (iso.org)](https://www.iso.org/iso-3166-country-codes.html) ([search](https://www.iso.org/obp/ui/#search))
- [ISO-3166-1 (Wikipedia)](https://es.wikipedia.org/wiki/ISO_3166-1)
- [Geonames: Country Codes](https://www.geonames.org/countries/)
- [Països suportats a Zippopotam](https://api.zippopotam.us/#where)
- ISO-3166 Download: [World Countries](https://stefangabos.github.io/world_countries/), [ip2location](https://www.ip2location.com/free/country-information)

Codis de subdivisions i regions:

- [ISO 3166-2 (Wikipedia)](https://es.wikipedia.org/wiki/ISO_3166-2)
- [ISO 3166-2 Spain (iso.org)](https://www.iso.org/obp/ui/#iso:code:3166:ES)
- [Geonames: Subdivisions (Spain)](https://www.geonames.org/ES/administrative-division-spain.html)
- [Geonames: Subdivisions (United States)](https://www.geonames.org/US/administrative-division-united-states.html)
- ISO-3166-2 Download: [World Countries](https://stefangabos.github.io/world_countries/), [ip2location](https://www.ip2location.com/free/iso3166-2)

Relacionats amb Flutter:

- [JSON Serialization](https://docs.flutter.dev/data-and-backend/serialization/json)
- [`TextField`](https://api.flutter.dev/flutter/material/TextField-class.html)
- [`DropdownMenu`](https://api.flutter.dev/flutter/material/DropdownMenu-class.html)
- [`PageView`](https://api.flutter.dev/flutter/widgets/PageView-class.html)
- [`BottomNavigationBar`](https://api.flutter.dev/flutter/material/BottomNavigationBar-class.html)
- [`ListView`](https://api.flutter.dev/flutter/widgets/ListView-class.html)
- [`SelectableText`](https://api.flutter.dev/flutter/material/SelectableText-class.html)
- [`GlobalKey`](https://api.flutter.dev/flutter/widgets/GlobalKey-class.html)
- [`FutureBuilder`](https://api.flutter.dev/flutter/widgets/FutureBuilder-class.html)
- [`ThemeData`](https://api.flutter.dev/flutter/material/ThemeData-class.html) ([`ColorScheme`](https://api.flutter.dev/flutter/material/ColorScheme-class.html), [`TextTheme`](https://api.flutter.dev/flutter/material/TextTheme-class.html))
- [`ChangeNotifierProvider<T>`](https://pub.dev/documentation/provider/latest/provider/ChangeNotifierProvider-class.html)
- [`Consumer<T>`](https://pub.dev/documentation/provider/latest/provider/Consumer-class.html)

Altres:

- [Quicktype](https://app.quicktype.io/)
- [Font: Montserrat](https://fonts.google.com/specimen/Montserrat)
- [pycountry](https://pypi.org/project/pycountry/)

## Llibreries externes

- [http](https://pub.dev/packages/http)
- [url_launcher](https://pub.dev/packages/url_launcher)
- [google_fonts](https://pub.dev/packages/google_fonts)
- [provider](https://pub.dev/packages/provider)
