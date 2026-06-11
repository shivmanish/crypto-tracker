# Crypto Tracker

A cryptocurrency tracking app — global market cap, trending coins, a paginated
and searchable coin list with infinite scroll, detailed coin screens, favorites
with local persistence, full offline support, system-driven dark/light themes,
and English ⇄ Hindi language switching.

Built with **Flutter** on a **Clean Architecture** foundation (data / domain /
presentation), **MVVM** via Cubits, the **CoinGecko** REST API, **sqflite** +
**shared_preferences** for persistence, and a **124-test** suite.

---

## Feature checklist

| Requirement | Status | Where |
|---|---|---|
| Global market cap | ✅ | `global_market` cubit + `GlobalMarketCard` |
| Trending coins (horizontal) | ✅ | `trending` cubit + `TrendingSection` |
| Paginated coin list | ✅ | generic `PaginatedListCubit` → `CoinsListCubit` |
| Search | ✅ | `CoinSearchCubit` (CoinGecko `/search`, min 3 chars, debounced) |
| Infinite scroll | ✅ | `PaginatedListView` (auto-fetch on scroll near end) |
| Detail screen | ✅ | `CoinDetailCubit` + `CoinDetailScreen` |
| Mark/unmark favorites + persistence | ✅ | `FavoritesCubit` (optimistic) → KV storage |
| Pull to refresh | ✅ | `RefreshIndicator` → `cubit.reset()` |
| Loading / error / empty states | ✅ | sealed states + `StatusView` |
| Offline support | ✅ | network-first repo + sqflite/KV cache |
| System dark/light theme | ✅ | `AppThemeManager` (defaults to system) |
| Language switching (EN/HI) | ✅ | `AppLocaleManager` + ARB localizations |
| MVVM | ✅ | Cubits as view-models |
| State management | ✅ | `flutter_bloc` |
| Clean Architecture | ✅ | `data` / `domain` / `presentation` per feature |
| TDD/BDD | ✅ | 124 tests across every layer |
| REST API | ✅ | Dio `ApiClient` + `APIRouter` |
| Database | ✅ | sqflite (`coins`, `trending`) + versioned migrations |
| Dependency Injection | ✅ | `get_it`, layer-wise registration |
| CI pipeline (GitHub Actions) | ➖ | see [Continuous Integration](#continuous-integration) |

---

## Tech stack

- **Flutter** 3.44 / **Dart** SDK `^3.12`
- **flutter_bloc** + **equatable** — state management
- **dartz** — `Either<Failure, T>` for typed error handling
- **get_it** — dependency injection
- **dio** — HTTP client
- **sqflite** (+ `sqflite_common_ffi` for tests) — relational cache
- **shared_preferences** — key-value settings/favorites
- **internet_connection_checker_plus** — real internet reachability
- **auto_route** — routing
- **intl** + `flutter_localizations` — i18n (ARB)
- **cached_network_image**, **flutter_svg**, **shimmer** — UI
- **mocktail** + **bloc_test** — testing

---

## Getting started

### Prerequisites
- Flutter **3.44+** (Dart `^3.12`)
- An Android/iOS emulator or a physical device
- No API key required — CoinGecko's free tier is used

### Setup & run
```bash
flutter pub get          # install dependencies
flutter gen-l10n         # generate localizations (lib/l10n/*.arb → Dart)
flutter run              # run on the connected device/emulator
```

`auto_route` and localizations are committed as generated files, so a plain
`flutter run` works. To regenerate routes after changing them:
```bash
dart run build_runner build --delete-conflicting-outputs
```

### Build a release APK
```bash
flutter build apk --release
```

---

## Architecture

Clean Architecture with one feature module (`markets`) and a shared `core`.
The dependency rule points inward: **presentation → domain ← data**. The domain
layer (entities, repository interfaces, use cases) knows nothing about Flutter,
Dio, or sqflite.

```
┌──────────────── presentation ────────────────┐
│  Screens / Widgets                            │
│  Cubits (MVVM view-models) ── flutter_bloc    │
└───────────────────────┬───────────────────────┘
                        │ calls UseCases, gets Either<Failure, Entity>
┌───────────────────────▼─────────── domain ────┐
│  Entities · Repository interfaces · UseCases   │
└───────────────────────┬───────────────────────┘
                        │ implemented by
┌───────────────────────▼─────────── data ──────┐
│  RepositoryImpl  (network-first + cache)       │
│   ├── Remote DataSource  → Dio → CoinGecko     │
│   └── Local  DataSource  → sqflite + KV cache  │
│  Models (fromApi / fromDb / toDbMap)           │
└────────────────────────────────────────────────┘
```

### Project structure
```
lib/src/
├── core/
│   ├── cubit/            BaseCubit, generic PaginatedListCubit
│   ├── database/         AppDatabase (migrations), generic Dao + DbMapper
│   ├── di/               get_it registration (layer-wise part files)
│   ├── error/            Failures (domain) + Exceptions (data)
│   ├── network/          ApiClient, APIRouter, ServerType, error mapping
│   ├── services/         connectivity + local storage abstractions
│   ├── theme/            palette, typography, ThemeMode manager
│   └── localization/     locale manager + ARB
└── features/markets/
    ├── data/             models, datasources (remote/local), repository impl
    ├── domain/           entities, repository interface, use cases
    └── presentation/     cubits, screens, widgets
```

---

## Key design decisions

### 1. Offline strategy: network-first, cache as fallback
When online the repository fetches fresh data and **refreshes the cache** as a
side effect; when offline (or on a network/rate-limit error) it serves the last
cached data. Cache writes are best-effort — a failed write never fails a good
fetch. This keeps the UI always-current online and still usable offline.

### 2. One `coins` table that doubles as the detail cache
Rather than a separate `coin_details` table, a coin's **full detail is stored on
its own `coins` row** via extra columns (`description`, `ath`, `atl`, supply, …)
guarded by a `has_detail` flag. Consequences:

- **Partial upserts.** A list refresh writes *only* the market columns
  (`ON CONFLICT(id) DO UPDATE SET <market cols>`), so it never wipes a coin's
  saved detail. Opening a detail online enriches that same row and sets
  `has_detail = 1`.
- **Graceful degradation offline.** Opening a coin returns the full detail if it
  was opened online before (`has_detail = 1`), else a **partial** detail built
  from the cached list row (price/cap/volume), else a clear "connect to view"
  screen.
- **Bounded cache.** After each list refresh, rows beyond the top
  `market_cap_rank` (100) are pruned — but **detail-enriched rows are kept**
  (`WHERE market_cap_rank > 100 AND has_detail = 0`).

### 3. Storage split by data shape
- **sqflite** for collections that are queried/paginated/bounded — the `coins`
  list (paginated by rank) and the `trending` snapshot.
- **shared_preferences** for tiny singletons and settings — the global-market
  object, the favorites id-set, theme mode, and locale.

### 4. Connectivity = real reachability, not just an interface
Connectivity is checked with `internet_connection_checker_plus`
(`hasInternetAccess`), which performs an actual reachability probe, rather than
only checking whether a network interface is attached. A device can have Wi-Fi
attached but no real internet (captive portal, router with no uplink). With a
plain interface check the app would think it's online and stall on the connect
timeout before falling back to cache; the reachability probe avoids that.
*Trade-off:* each check costs a small round-trip when online — acceptable since
it runs once per fetch.

### 5. Generic, reusable building blocks
- **`PaginatedListCubit<T, P>`** — forward-only pagination, in-flight de-dupe,
  and a generation counter so a `reset()` (pull-to-refresh) safely discards an
  in-flight page. Features subclass it and implement only `buildParams`.
- **`Dao<T>` + `DbMapper<T>`** — generic CRUD over any table, so features don't
  hand-write SQL for ordinary reads/writes.
- **`APIRouter` + `ServerType`** — each use-case's `Params` describes its
  endpoint (path/query) and target server, so the route travels with the call.
- **`BaseCubit`** — `safeEmit` (no emit-after-close crashes) and `handleUseCase`
  (folds `Either` into success/failure callbacks, guards against late results).

### 6. Typed error handling
Data-layer `Exception`s (`Network`, `RateLimit`, `NotFound`, `Cache`, `Server`)
are mapped by the `RepositoryResultHandler` mixin into domain `Failure`s wrapped
in `Either`. Dio errors are normalized in one place (`ApiClient._mapError`),
including a small retry on CoinGecko's `429`.

---

## API

CoinGecko (free, no key). Base URL: `https://api.coingecko.com/api/v3`.

| Purpose | Endpoint |
|---|---|
| Coin list (paginated) | `GET /coins/markets?vs_currency=usd&order=market_cap_desc&per_page=20&page={page}` |
| Global market cap | `GET /global` |
| Trending | `GET /search/trending` |
| Coin detail | `GET /coins/{id}?localization=false&tickers=false&market_data=true&community_data=false&developer_data=false` |
| Search | `GET /search?query={q}` (identity only, no price → online-only) |

---

## Testing

124 tests cover every architectural layer:

```bash
flutter test                       # run the whole suite
flutter test --coverage            # with coverage (coverage/lcov.info)
```

- **Domain** — use cases delegate to the repository.
- **Data** — model parsing (`fromApi`/`fromDb`), remote datasource (mocked
  `ApiClient`), local datasource + generic `Dao` (real **in-memory sqflite** via
  `sqflite_common_ffi`), and the repository's network-first / offline-fallback /
  partial-upsert behavior.
- **Presentation** — all cubits via `bloc_test` (loading/loaded/error/empty,
  pagination, optimistic favorite toggle with revert, search stale-query guard).
- **Core** — `BaseCubit`, paginated cubit concurrency guards, error mapping,
  local storage, theme/locale managers, and formatting extensions.

Mocks use `mocktail`; no code generation is required to run the tests.

---

## Continuous Integration

Planned: a GitHub Actions workflow (`.github/workflows/ci.yml`) that runs
`flutter analyze` and `flutter test` on every push and pull request.

---

## Known trade-offs & future work

- **No TTL / stale-while-revalidate.** Because the strategy is network-first,
  the cache is a pure offline fallback; `updated_at` is stored but not yet used
  to expire data or show a "last updated" label.
- **Detail-enriched rows aren't size-capped.** They're tiny and few in practice,
  but an LRU on opened coins would bound them precisely.
- **Search is online-only** by design (CoinGecko `/search` has no offline
  equivalent and returns no price data).
- **Widget tests** are not included — coverage is logic/state-level; rendering
  tests would be a natural next addition.
