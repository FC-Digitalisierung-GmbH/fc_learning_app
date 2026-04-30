# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project

Flutter trainee learning project. Stock `flutter create` counter-app scaffold, intended as a starting point for FC trainees learning Flutter — not a production app. All app code currently lives in `lib/main.dart` (`MyApp` → `MyHomePage`/`_MyHomePageState`).

Dart SDK: `^3.11.0`. Flutter dependencies: only `cupertino_icons` (runtime) and `flutter_lints` (dev).

## Commands

```bash
flutter pub get              # install dependencies
flutter run                  # run on attached device/emulator (hot reload via `r`)
flutter analyze              # lint / static analysis (uses analysis_options.yaml)
flutter test                 # run all tests
flutter test test/widget_test.dart   # run a single test file
flutter test --name "<substring>"    # run tests matching a name
flutter build apk            # Android release build
flutter build ios            # iOS build (mac only)
```

Targets configured: `android/`, `ios/`. No web/desktop folders.

## Linting

`analysis_options.yaml` includes `package:flutter_lints/flutter.yaml`. No custom rule overrides — default Flutter lint set applies.

## Notes for editing

- `lib/main.dart` currently contains two minor syntax issues from the source: line 31 (`.fromSeed(...)` missing `ColorScheme` prefix) and line 105 (`.center` missing `MainAxisAlignment` prefix). Run `flutter analyze` before claiming changes compile.
- No state management, routing, networking, or persistence in place yet — add structure (e.g. split files under `lib/`) when introducing features beyond the counter.