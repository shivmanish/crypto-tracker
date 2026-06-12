# Crypto Tracker

A Flutter app for tracking cryptocurrencies. Browse the market, check trending
coins, search, open a coin to see detailed stats, and save favorites. It keeps
working offline by showing the last cached data, follows the system light/dark
theme, and supports English and Hindi.

Data comes from the free [CoinGecko API](https://www.coingecko.com/en/api).

## Features

- Global market cap and 24h volume
- Trending coins
- Paginated coin list with infinite scroll
- Search
- Coin detail (price, market cap, volume, all-time high/low, supply, about)
- Favorites with local persistence
- Pull to refresh
- Offline support — cached data is shown when there's no connection
- Light / dark theme, following the system
- English / Hindi language switching

## Getting started

You'll need Flutter 3.44+ (Dart `^3.12`) and an emulator or device. No API key
is required.

```bash
flutter pub get
flutter gen-l10n      # generate localizations from lib/l10n/*.arb
flutter run
```

Routes (auto_route) and localizations are committed, so `flutter run` works out
of the box. Regenerate routes after editing them with:

```bash
dart run build_runner build --delete-conflicting-outputs
```

Release build:

```bash
flutter build apk --release
```

## Tech stack

- `flutter_bloc` + `equatable` — state management
- `dartz` — `Either<Failure, T>` error handling
- `get_it` — dependency injection
- `dio` — HTTP client
- `sqflite` — local database
- `shared_preferences` — settings and favorites
- `internet_connection_checker_plus` — connectivity
- `auto_route` — routing
- `intl` + `flutter_localizations` — i18n
- `cached_network_image`, `flutter_svg`, `shimmer` — UI
- `mocktail` + `bloc_test` — tests

## Architecture

The app follows clean architecture with a single `markets` feature and a shared
`core`. Dependencies point inward — presentation depends on domain, data
implements domain, and domain has no knowledge of Flutter, Dio, or sqflite.
Cubits act as the view-models (MVVM).

```
presentation  ──>  domain  <──  data
  cubits           entities      repository impl
  screens          use cases      ├─ remote (Dio → CoinGecko)
  widgets          interfaces     └─ local  (sqflite + prefs)
```

```
lib/src/
├── core/
│   ├── cubit/         base cubit, generic paginated list cubit
│   ├── database/      database, generic dao + mapper
│   ├── di/            get_it registration
│   ├── error/         failures + exceptions
│   ├── network/       api client, router, error mapping
│   ├── services/      connectivity, local storage
│   ├── theme/         palette, typography, theme mode
│   └── localization/  locale manager + arb
└── features/markets/
    ├── data/          models, datasources, repository impl
    ├── domain/        entities, repository interface, use cases
    └── presentation/  cubits, screens, widgets
```

## How it works

**Offline.** The repository is network-first: when online it fetches fresh data
and updates the cache; when offline (or on a network/rate-limit error) it serves
the cached copy. Cache writes are best-effort and never fail a good fetch.

**Detail cache.** A coin's detail is stored on its own row in the `coins` table
(extra columns + a `has_detail` flag) rather than in a separate table. A list
refresh updates only the market columns via an upsert, so it never overwrites a
coin's saved detail. Offline, a coin opens with its full detail if it was viewed
online before, otherwise a partial view built from the cached list row, otherwise
a prompt to connect. The list cache is capped to the top 100 by rank, keeping
any rows that hold saved detail.

**Storage.** sqflite holds the collections that are paginated or queried (the
coin list and the trending snapshot); shared_preferences holds small values (the
global-market object, the favorite ids, theme, and locale).

**Connectivity.** Online/offline is decided by an actual reachability check
(`internet_connection_checker_plus`) rather than just whether a network interface
is attached, so a Wi-Fi connection with no real internet is treated as offline
instead of stalling on a request timeout.

**Reuse.** Pagination, table access, routing, and the cubit base are generic:
`PaginatedListCubit` handles paging (including discarding an in-flight page on
refresh), `Dao<T>` + `DbMapper<T>` handle CRUD for any table, each use case's
params describe their own endpoint, and `BaseCubit` provides safe emit and
`Either` folding.

## API

CoinGecko, base URL `https://api.coingecko.com/api/v3`:

| Purpose | Endpoint |
|---|---|
| Coin list | `GET /coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page={page}` |
| Global market | `GET /global` |
| Trending | `GET /search/trending` |
| Coin detail | `GET /coins/{id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false` |
| Search | `GET /search?query={q}` |

## Tests

```bash
flutter test
```

The suite covers the data layer (model parsing, datasources, and the repository
including the offline-fallback and detail-cache behavior, with an in-memory
sqflite), the use cases, and every cubit, plus the core utilities. Database tests
use `sqflite_common_ffi`; no code generation is needed to run them.

## CI

`.github/workflows/ci.yml` runs on every push and pull request to `main`: it
installs dependencies, generates localizations, runs `flutter analyze`, and runs
the tests.

## Notes

- The cache is an offline fallback, so there's no time-based expiry — online data
  is always refetched.
- Search needs a connection; CoinGecko's search endpoint has no offline
  equivalent and returns identity only (no price).
