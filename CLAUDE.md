# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Commands

```bash
flutter pub get                              # Install dependencies
flutter run                                 # Run on connected device/emulator
flutter build apk                           # Build Android APK
flutter build ios                           # Build iOS app
flutter analyze                             # Lint / static analysis
flutter pub run build_runner build          # Regenerate .g.dart JSON serialization files
flutter pub run build_runner build --delete-conflicting-outputs  # Regenerate (force overwrite)
```

There is no test suite.

## Architecture

Episode Guide is a Flutter app (Android/iOS) for tracking upcoming TV show episodes. It uses the **BLoC pattern** throughout, with a clear separation into four layers:

### BLoC Layer (`lib/blocs/`)

Five BLoCs manage all app state:

- **FavoritesBloc** — CRUD on favorite series list (backed by `FavoritesRepository`). Events: `FetchFavorites`, `AddFavorite`, `RemoveFavorite`.
- **NextEpisodesBloc** — Fetches next episode data for each favorite series. Listens to `FavoritesBloc` and auto-fetches when favorites change.
- **SearchSeriesBloc** — Handles series search against the TVDB GraphQL API.
- **SeriesDetailsBloc** — Loads full series info + cast for the detail screen.
- **SeriesEpisodesBloc** — Loads all episodes (by season) for the episodes screen.

All BLoCs follow the same event/state naming convention: `[Action][Resource]` for events, `[Resource][Status]` for states (e.g., `FavoritesLoaded`, `NextEpisodeError`).

### Repository Layer (`lib/repositories/`)

- **TvdbRepository** — High-level data access; calls `TvdbGraphQLClient` for network data.
- **TvdbGraphQLClient** — Wraps `graphql_flutter`; executes queries defined in `lib/graphql_operations/queries/`.
- **FavoritesRepository** — Static methods for reading/writing favorites to `SharedPreferences`.

The GraphQL API endpoint is defined in `lib/constants.dart` (`https://tvdb-graphql-api.sabith-th.vercel.app`). Banner images are served from `https://www.thetvdb.com/banners/`.

### Model Layer (`lib/models/`)

Models are annotated with `json_annotation` and code-generated via `json_serializable`. The `.g.dart` files are committed to the repo. Regenerate them with `build_runner build` after changing model annotations.

Key models: `Series` (id, seriesName, overview, image, score, firstAired, status, genres, averageRuntime, year), `NextEpisode`, `Episode`, `SeriesDetails`, `SeriesEpisode`, `SearchSeriesResult`.

### Service Layer (`lib/services/`)

- **NotificationService** — Initialises `flutter_local_notifications`, requests permissions, exposes `showEpisodeNotification`.

### Background Tasks (`lib/tasks/`)

- **episode_check_task.dart** — Top-level `callbackDispatcher` for `workmanager`. Reads favorites from `SharedPreferences`, fetches next episodes via a fresh `GraphQLClient`, and fires a notification for any episode airing today.

Registered in `main.dart` as a periodic task (every 24h, scheduled to fire at 9 PM via `initialDelay`, requires network). Uses `ExistingPeriodicWorkPolicy.replace` so the 9 PM schedule is recalculated on each app launch.

### UI Layer (`lib/ui/`)

Four screens with named routes:
- `/` — Home (`home_page.dart`): shows next episodes for favorites
- `/searchSeries` — Search (`search_page.dart`): TVDB series search
- `/seriesDetails` — Details (`series_details.dart`): cast, schedule, network info, genres, status
- `/episodes` — Episodes (`episodes_screen.dart`): collapsible seasons with episode tiles

All screens use `BlocBuilder`/`BlocProvider` from `flutter_bloc`. The app uses a Material 3 dark theme (`ColorScheme.fromSeed`, seed `0xFF0F6E8C`) with the custom `AlegreyaSans` font (assets in `assets/`).

BLoCs are provided at the top level in `main.dart` using `MultiBlocProvider`.
