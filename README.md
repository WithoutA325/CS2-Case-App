# CS2 Skins App

Aplikacja mobilna Flutter wyswietlajaca skrzynki z Counter-Strike 2 oraz skiny dostepne w wybranej skrzynce. Dane sa pobierane z REST API ByMykel/CSGO-API i zapisywane lokalnie w Hive, dzieki czemu aplikacja moze pokazac ostatnio pobrane dane takze offline.

## Funkcje

- lista skrzynek CS2 z wyszukiwaniem i filtrowaniem po typie,
- ekran szczegolow skrzynki z lista skinow i rzadkich dropow,
- ekran szczegolow skina z powiekszonym zdjeciem i dodatkowymi informacjami,
- wishlista zapisywana lokalnie w Hive,
- reczne odswiezanie danych z API,
- obsluga ladowania, bledow i lokalnego cache.

## REST API

Aplikacja korzysta z publicznych plikow JSON:

- `https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api/en/crates.json`
- `https://raw.githubusercontent.com/ByMykel/CSGO-API/main/public/api/en/skins.json`

Pierwszy endpoint pobiera skrzynki wraz z podstawowa zawartoscia. Drugi endpoint jest uzywany na ekranie szczegolow skina, aby uzupelnic dane o opis, bron, kategorie oraz zakres float.

## Lokalna baza danych

Do trybu offline uzywany jest Hive. Aplikacja zapisuje:

- pobrane skrzynki,
- szczegoly odwiedzonych skinow,
- liste zyczen uzytkownika.

## Uruchomienie

```bash
flutter pub get
flutter run
```

Projekt jest przygotowany jako aplikacja mobilna Flutter dla Androida.
