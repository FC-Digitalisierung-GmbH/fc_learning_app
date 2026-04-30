# AGENTS.md

This file provides guidance to any coding agent when working with code in this repository.

## General Guidelines

- **NEVER push any code!
  If there should be a case where it is a necessity need to do a git push, you ask for permission first.**

- **Use the local folder ".ai" for any meta files that are used for agentic development like plans (`.ai/plans`), documentation (`.ai/docs`) or notes (`.ai/notes`).
  Ignore agent specific behavior in that regard. If a feature (e.g. unit testing) requires multiple plans for example, create a subfolder (`.ai/plans/unit_testing`) inside the AI subfolder.**

## Architecture

**Clean Architecture, component-module layout.**

## Code Guidelines

- **When implementing new widgets, always check if there are existing Widgets (mostly prefixed "Prio")
  that can be used here or fit the purpose (normally under `lib/Components/`), and use our theming and style**

- **Check `lib/Utils` when implementing new features if there is existing functionality to solve a problem**

- **Spacing between siblings**: in `Row`, `Column`, and `Wrap`, use the `spacing:` parameter (and `runSpacing:` for `Wrap`) to space children — **never** insert `SizedBox(width: …)` / `SizedBox(height: …)` between siblings. `SizedBox` is reserved for cases where a widget actually needs a fixed dimension (e.g., a sized progress indicator, a min-height placeholder, a `ListView.separated` separator). For dynamically built children lists, pass the list directly to the row/column and let `spacing:` handle gaps — don't append spacer widgets in a loop.

### Key Packages

- **Routing:** `go_router`
- **Networking:** `http`

### Linting

`analysis_options.yaml` enforces:
- Single quotes
- `const` constructors where possible
- Exhaustive switch cases

Generated files and `api/**` are excluded from analysis.
