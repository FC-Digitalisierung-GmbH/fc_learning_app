# AGENTS.md

This file provides guidance to any coding agent when working with code in this repository.

## General Guidelines

- **NEVER push any code!
  If there should be a case where it is a necessity need to do a git push, you ask for permission first.**

- **Use the local folder ".ai" for any meta files that are used for agentic development like plans (`.ai/plans`), documentation (`.ai/docs`) or notes (`.ai/notes`).
  Ignore agent specific behavior in that regard. If a feature (e.g. unit testing) requires multiple plans for example, create a subfolder (`.ai/plans/unit_testing`) inside the AI subfolder.**

## Architecture

**Clean Architecture, feature-module layout.**

## Code Guidelines

- **When implementing new widgets, always check if there are existing Widgets (mostly prefixed "Prio")
  that can be used here or fit the purpose (normally under `lib/Components/`), and use our theming and style**

- **Check `lib/Utils` when implementing new features if there is existing functionality to solve a problem**

### Layers

| Layer          | Location                                       | Role                                      |
|----------------|------------------------------------------------|-------------------------------------------|
| Presentation   | `lib/<Feature>/*_page.dart`, `lib/Components/` | UI, shared widgets                        |
| Business Logic | `lib/<Feature>/*_service.dart/`                | API calls, logic methods called by the ui |
| Data           | `lib/<Feature>/models/*_model.dart`            | DTOs                                      |
| API            | `lib/api_client.dart/`                         | HTTP client                               |

### Key Packages

- **Routing:** `go_router`
- **Networking:** `http`

### Linting

`analysis_options.yaml` enforces:
- Single quotes
- `const` constructors where possible
- Exhaustive switch cases

Generated files and `api/**` are excluded from analysis.
