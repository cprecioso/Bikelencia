# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bikelencia is an iOS app that shows bike parking locations in Valencia, Spain. This is a monorepo with three workspaces:

- **app/** — iOS app (SwiftUI)
- **web/** — Marketing site and JSON API (TanStack Start, deployed to GitHub Pages)
- **data/** — Bike parking data fetched from Valencia's open data portal

## Tool Versions

Managed via `mise.toml`: Node LTS, Yarn (via `package.json` `packageManager`).

Package manager: **Yarn 4.18.1** (installed by mise). Do not use npm.

## Commands

### Monorepo (root)

```bash
yarn install            # Install all JS dependencies
yarn prettier --check . # Check formatting
yarn prettier --write . # Fix formatting
yarn lint               # Lint all workspaces (oxlint)
yarn lint:fix           # Lint and apply auto-fixes
```

### Data (`data/`)

```bash
yarn workspace @bikelencia/data refresh # Fetch the latest data into data/out/data.json
```

The refresh fetches GeoJSON from Valencia's geoportal. `@bikelencia/data/data` exports it with `updatedAt` taken from the last commit touching the file, so it needs git history. The `Build site` GitHub Actions workflow (`build.yaml`, on push to `main` or manually) runs the web `build:static` and deploys it to GitHub Pages. The `Refresh data` workflow (`refresh.yaml`, daily at midnight UTC or manually) refreshes and commits the data, then calls `Build site`.

### Web (`web/`)

```bash
cd web
yarn dev          # Dev server (Vite)
yarn build        # Production build into dist/ (prerenders pages) + type check
yarn build:static # Same, but `/` redirects on the client, for static hosts
yarn preview      # Serve the production build
```

Linting is repo-wide, not per-workspace — run `yarn lint` from the root.

### iOS App (`app/`)

Open `app/Bikelencia.xcodeproj` in Xcode to build and run. No test targets exist.

## Architecture

### iOS App

The Xcode project is checked in at `app/Bikelencia.xcodeproj`, defined in Xcode's JSON project format (`project.xcproj`). Each target has its own `*-Info.plist` and, where needed, `*.entitlements` in its folder.

#### Targets

- **Bikelencia** (app target) — SwiftUI app with MapKit and ClusterMap for annotation clustering. On launch, promotes any pending background downloads to foreground via `BADownloadManager`.
- **BikelenciaCore** (framework target) — `SpotsController` (data fetch/cache with 30-day TTL), `StoredJSON` (actor-based file persistence), `BikelenciaConfig` (shared constants like the app group identifier).
- **BikelenciaDownloader** (BackgroundAssets extension) — Extension Kit extension that uses the `BADownloaderExtension` protocol to download bike parking data in the background. See [BackgroundAssets Extension](#backgroundassets-extension) below.
- **ValenciaKit** (local Swift package) — API client, data models, and shared utilities. Depends on [MetaCodable](https://github.com/SwiftyLab/MetaCodable) for the `@Codable` macro.

#### Key libraries

- **ValenciaKit targets**:
  - `ValenciaKit` — API client (`BikelenciaAPI`, `BikeParkingsFetcher`), data models (`BikeParkings`, `Manifest`), and helpers (`LenientISO8601DateCoder`).
  - `CoreLocationCodable` — Adds `Codable`, `Equatable`, and `Hashable` conformance to `CLLocationCoordinate2D`.
- **MetaCodable** — Provides `@Codable` macro and `HelperCoder` protocol used by `LenientISO8601DateCoder` for lenient ISO 8601 date parsing (with and without fractional seconds).

#### Data models

- **`BikeParkings`** — Top-level response model with `fetchedAt` (client-set), `updatedAt` (server timestamp), and `spots` array. Each `Spot` has `id`, `coordinate` (`CLLocationCoordinate2D`), `capacity`, and optional `spotType`.
- **`Manifest`** — Metadata served at `/api/manifest` with `bikeParkings.updatedAt` and `bikeParkings.size`, used by the background downloader to decide whether to fetch new data.

#### State management

`@Observable` objects passed via SwiftUI `@Environment`. No third-party state management.

#### Localization

Localized in English, Spanish, and Catalan via `.xcstrings` string catalogs.

#### Code style

2-space indentation.

### BackgroundAssets Extension

The `BikelenciaDownloader` target (`app/BikelenciaDownloader/`) is an Extension Kit extension using Apple's BackgroundAssets framework. It allows the system to download updated bike parking data without the app running.

**How it works:**

1. The system periodically calls the extension with the manifest URL configured in the app's Info.plist (`BAManifestURL`: `https://bikelencia.precioso.design/api/manifest`).
2. The extension fetches the manifest and compares `manifest.bikeParkings.updatedAt` against a cached `lastKnownUpdatedAt` timestamp stored in shared `UserDefaults` (app group: `group.design.precioso.Bikelencia`).
3. If the server has newer data, it creates a `BAURLDownload` for the bike parkings endpoint.
4. On successful download, the extension decodes the JSON as `BikeParkings`, sets `fetchedAt` to the current time, and writes it atomically to `cached-bike-parkings.json` in the shared app group container.
5. When the app launches, `promotePendingDownloads()` in `App.swift` moves any pending background downloads to foreground priority.

**Key files:**

- `app/BikelenciaDownloader/BikelenciaDownloader.swift` — Extension entry point conforming to `BADownloaderExtension`
- `app/BikelenciaCore/BikelenciaConfig.swift` — Shared app group identifier (`group.design.precioso.Bikelencia`)
- `app/Bikelencia/Bikelencia-Info.plist` — `BAManifestURL`, download size limits, and domain allowlist

**Data sharing:** The extension and main app share data through:

- App group `UserDefaults` for the `lastKnownUpdatedAt` timestamp
- App group container filesystem for the cached `cached-bike-parkings.json` file

### API

Served by the marketing site at `/api/bike-parkings` and `/api/manifest` (the URLs the app uses), from server routes in `web/src/routes/api/`. `web/src/api.ts` imports `@bikelencia/data/data`, which reads `updatedAt` from git, so the routes only work at build time. Both are prerendered (listed in `pages` in `vite.config.ts`, since nothing links to them) into extensionless files, so static hosts like GitHub Pages (which has no rewrites) serve them as `application/octet-stream`; a server serves them as `application/json`. The site is deployed to GitHub Pages at `bikelencia.precioso.design`.

### Marketing Site

[TanStack Start](https://tanstack.com/start) on Vite, with file-based routes in `src/routes/` (`routeTree.gen.ts` is generated, do not edit). Locale-based routing via a `$locale` segment (en/es/ca) whose `params.parse` rejects unknown locales, so they 404. Uses Vanilla Extract (`*.css.ts` files) for styling. `/` (`src/routes/index.tsx`) redirects to a locale: its server handler negotiates `Accept-Language`, and its component does the same from `navigator.languages` on the client. Start's prerenderer crawls from `/` and writes every page into `dist/client` at build time (configured in `vite.config.ts`); the server entry goes to `dist/server`. In `build:static` (`--mode static`), the `/` server handler falls through to the component, so its prerendered page does the client redirect. The `Build site` workflow deploys `dist/client`.

Path alias: `@/*` maps to `web/src/*`.

## Formatting

Prettier is configured at the repo root with plugins for import sorting (`prettier-plugin-organize-imports`), `package.json` formatting (`prettier-plugin-pkg`), and shell scripts (`prettier-plugin-sh`).

## Linting

[oxlint](https://oxc.rs/docs/guide/usage/linter) is configured at the repo root in `.oxlintrc.json` and covers every workspace in one pass. The base config enables the `import`, `oxc`, `promise`, `typescript`, and `unicorn` plugins; a `web/**` override adds `jsx-a11y` and `react`. oxlint has no formatting rules, so it does not overlap with Prettier and needs no `eslint-config-prettier` equivalent.
