# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

Bikelencia is an iOS app that shows bike parking locations in Valencia, Spain. Monorepo with three workspaces:

- **app/**: iOS app (SwiftUI)
- **web/**: Marketing site and JSON API (TanStack Start, deployed to GitHub Pages at `bikelencia.precioso.design`)
- **data/**: Bike parking data fetched from Valencia's open data portal

Tools are managed via `mise.toml`. Use Yarn, not npm.

## Commands

```bash
yarn install                            # Install all JS dependencies
yarn prettier --write .                 # Format
yarn lint                               # Lint all workspaces (oxlint, repo-wide only)
yarn workspace @bikelencia/data refresh # Fetch the latest data
```

Web scripts (`dev`, `build`, `build:static`, `preview`) live in `web/package.json`. The iOS app is built from `app/Bikelencia.xcodeproj` in Xcode. There are no tests.

## Architecture

### Data and API

`@bikelencia/data/data` takes `updatedAt` from the last git commit touching the data file, so it needs git history and only works at build time. The API (`/api/bike-parkings`, `/api/manifest`) is served by the marketing site and prerendered at build, so GitHub Pages serves it as `application/octet-stream`. GitHub Actions refresh the data daily and rebuild the site on push to `main`.

### Marketing Site

`routeTree.gen.ts` is generated, do not edit. Routes are under a `$locale` segment (en/es/ca). `/` negotiates the locale on the server, or on the client in `build:static` mode.

### iOS App

The Xcode project is checked in, in Xcode's JSON project format. The `BikelenciaDownloader` BackgroundAssets extension fetches new data when the manifest's `updatedAt` changes, and shares it with the app through the app group container and `UserDefaults`. Localized in English, Spanish, and Catalan via `.xcstrings`. 2-space indentation.
