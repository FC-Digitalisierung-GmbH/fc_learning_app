---
tags: [trainee, plan, onboarding]
role: Flutter Developer Mentor
company: FC-Gruppe
duration: 1 week
trainee_age: ~16
trainee_background: Realschule, minimal coding experience
---

# Trainee Plan — 1 Week Praktikum

## Goals

- [ ] Introduce company & products (FC-Gruppe, Prio365, etc.)
- [ ] Show daily life of a developer
- [ ] Assess coding skills, give hands-on intro to software development
- [ ] Send him home motivated, with concrete next steps

---

## Day 0 — Prep (before he arrives)

Quick checklist. Detailed steps in **Preparation** section below.

- [ ] Workspace + laptop ready (see Preparation → Logistics)
- [ ] Quiz app scaffold pushed to Git (see Preparation → Code Scaffold)
- [ ] UI mockups exported (see Preparation → Mockups)
- [ ] Colleague chats blocked in calendar
- [ ] Planted-bug branch ready

---

## Day 1 (Mon) — Welcome & Company

**Morning**
- [ ] Pick up at reception, badge, office tour
- [ ] Coffee/Tea, intro to team
- [ ] Slide deck: FC-Gruppe — structure, products, history (~30 min)
- [ ] Live demo: Prio365 app on phone, walk through features

**Afternoon**
- [ ] Lunch with team
- [ ] Setup workstation together: Wi-Fi, accounts, dev tools
- [ ] Calibration chat: what does he know? (HTML, Scratch, Python, none?)
- [ ] First win: `flutter create hello_app` → run counter app on emulator
- [ ] Send-home: Send him short blogs/videos on "what is a mobile app developer"

**Goal:** he feel welcome, run code on Day 1.

---

## Day 2 (Tue) — Dev Daily Life

**Morning**
- [ ] Sit in daily standup, explain afterwards
- [ ] IDE tour: Android Studio / VS Code, hot reload, debugger
- [ ] Git basics: clone, branch, commit, push (with base repo)
- [ ] Show Jira/Asana board, ticket flow

**Afternoon**
- [ ] Pair-programming: I fix a small real bug, narrate thinking
- [ ] Kick off mini-project: build "FC Quiz App" (Open Trivia DB)
  - clone scaffold
  - run app
  - explore project structure
- [ ] 1:1 with a non-dev (PO or designer) — 30 - 45 min

**Goal:** he see how a dev day actually flows.

---

## Day 3 (Wed) — Build Day 1: Widgets & Layout

**Morning**
- [ ] Recap Day 2: chat about yesterday, low-key
  - Why do developers use Git?
  - What is a widget?
  - What is an IDE good for?
  - What stuck with you from yesterday? What was confusing?
  - Anything you want to try out today?
- [ ] Concept: Flutter widgets, `StatelessWidget` vs `StatefulWidget`
- [ ] Hands-on: add 2nd screen, `Column`, `Row`, `Padding`, image asset

**Afternoon**
- [ ] Lunch with team
- [ ] Continue building, freedom to experiment
- [ ] Mini-checkpoint: review what he built, give 2 small fixes
- [ ] 1:1 with backend dev or QA — 30 - 45 min

**Goal:** he build a multi-screen UI on his own.

---

## Day 4 (Thu) — Build Day 2: State & API

**Morning**
- [ ] Concept: state management (`setState`), lists with `ListView`
- [ ] Concept: REST API call with `http` package (e.g. PokeAPI, jokes API)
- [ ] Add list + API call to mini-app

**Afternoon**
- [ ] Bug-hunt exercise: planted bug branch, he uses debugger to find it
- [ ] Show real PR workflow: open PR, code review, merge


**Goal:** he taste real dev work — debugging + API.

---

## Day 5 (Fri) — Polish & Farewell

**Morning**
- [ ] Polish app: icon, app name, color
- [ ] Career talk (~30 min): Ausbildung vs Studium, IT paths after Realschule
- [ ] Build APK, install on his phone (souvenir!)

**Afternoon**
- [ ] Present mini-app to team (5 min)
- [ ] Feedback round: what he liked, what was hard
- [ ] Hand over: cheat sheet + resource list (Flutter docs, freeCodeCamp, Mimo, YouTube channels)
- [ ] Certificate / thank-you card from team
- [ ] Farewell coffee

**Goal:** he leave proud, with working app + concrete learning path.

---

## Preparation

Most prep done **1–2 weeks before** he arrives. Coding scaffold takes ~1–2 dev days.

### Logistics (HR / Office)

- [ ] Inform HR: visitor registration
- [ ] Request guest badge / building access for the week
- [ ] Reserve **double workspace** (his desk next to mine) — book via room-booking tool or talk to office mgmt
- [ ] Confirm chair available + adjustable
- [ ] Inform team in Teams: trainee schedule, name, what he'll work on
- [ ] Get information from reception: name, arrival time, contact data, skill level
- [ ] Lunch budget / canteen card / guest lunch arranged
- [ ] Parking spot or transit info (depending on how he arrives)

### Laptop Setup

Pre-install + test everything. He should boot up and code on Day 1, no setup pain.

- [ ] Borrow guest laptop from IT (or wipe a spare). Min specs: 16 GB RAM, SSD
- [ ] OS up to date (macOS or Windows — match team's stack)
- [ ] Guest user account with admin rights for install
- [ ] **Flutter SDK** installed (`flutter doctor` clean)
- [ ] **Android Studio** + Android SDK + emulator image (Pixel API 34)
- [ ] **IntelliJ** with Flutter + Dart extensions
- [ ] **Git** + configured `user.name` / `user.email` (his name)
- [ ] **Chrome** for Flutter web debug + Open Trivia DB browsing
- [ ] Test: `flutter create test && flutter run` works on emulator
- [ ] Wi-Fi credentials saved
- [ ] Teams installed, guest account if possible
- [ ] Bookmarks: Flutter docs, DartPad, Open Trivia DB, GitHub repo
- [ ] Welcome sheet on desktop: schedule, contacts, Wi-Fi, repo URL

### Code Scaffold (Quiz App)

Goal: he writes **logic and wiring**, not boilerplate. UI looks plain → he restyles to match mockups.

**Repo setup**

- [ ] Create Git repo: `quiz-app-trainee` (private, on company GitLab/GitHub)
- [ ] Branch: `main` (scaffold) + `solution` (full ref impl, hidden)
- [ ] README: project goal, run instructions, list of TODO tasks
- [ ] `.gitignore` for Flutter
- [ ] Add him as collaborator with push rights to feature branches

**Project structure**

```
lib/
  main.dart                  // ✅ done — runs MaterialApp
  models/
    question.dart            // ✅ done — Question class with fields
    quiz_result.dart         // ✅ done — score, total, answers
  services/
    trivia_api.dart          // 🟡 stub — method signatures, TODO body
  screens/
    home_screen.dart         // ✅ basic UI — start button, category dropdown
    quiz_screen.dart         // 🟡 basic UI — shows question, 4 buttons. TODO: state logic
    result_screen.dart       // ✅ basic UI — score display, restart button
  widgets/
    answer_button.dart       // ✅ done — tappable button with callback
    question_card.dart       // ✅ done — wraps question text
```

**TODOs for trainee** (clearly marked `// TODO(trainee): ...`)

- [ ] `trivia_api.dart`: implement `fetchQuestions(category, amount)` using `http` package + Open Trivia DB
- [ ] `question.dart`: implement `Question.fromJson(Map)` factory
- [ ] `quiz_screen.dart`: track current question index, score, handle answer tap, navigate to result
- [ ] `home_screen.dart`: wire start button → call API → push to QuizScreen
- [ ] `result_screen.dart`: wire restart → pop to home
- [ ] **Styling pass**: edit all screens to match mockups (colors, fonts, spacing, icons)

**Bonus (if fast)**

- [ ] Save high score with `shared_preferences`
- [ ] Add difficulty selector
- [ ] Animate transition between questions

**API reference**

- Endpoint: `https://opentdb.com/api.php?amount=10&category=18&difficulty=easy&type=multiple`
- Response: `{ response_code, results: [{ question, correct_answer, incorrect_answers, ... }] }`
- HTML entities in question text → use `html_unescape` package or simple replace
- Categories endpoint: `https://opentdb.com/api_category.php`

### UI Mockups

Provide 3 screens. Tools: Figma, Penpot, or even hand-drawn + photo.

- [ ] **Home screen**: app title, category dropdown, start button, hero image/icon
- [ ] **Quiz screen**: progress indicator (e.g. "3 / 10"), question card, 4 answer buttons, score in top-right
- [ ] **Result screen**: big score number, message ("Great job!"), restart button, share button (optional)

Export as PNG, drop into `mockups/` folder in repo. Reference them from README.

Style guide on 1 page:
- Primary color (FC-Gruppe brand?)
- Secondary / accent
- Font (Roboto / Inter)
- Border radius, spacing scale
- Icon source (Material Icons)

### Mini-Curriculum / Cheat Sheet

- [ ] 1-page Flutter cheat sheet: widget tree, `setState`, `Navigator.push`, `Future`/`async`
- [ ] 1-page Dart cheat sheet: `var`/`final`/`const`, classes, lists, maps, null safety
- [ ] Glossary: API, JSON, widget, state, build, hot reload, repo, branch, PR

### Bug-Hunt Branch (Day 4)

- [ ] Branch `bug/easy` — off-by-one in question counter (shows wrong index)
- [ ] Branch `bug/medium` — score not reset on restart
- [ ] Optional `bug/hard` — async race in API call

### Misc

- [ ] Small gift for last day (FC-Gruppe merch, sticker, candy)
- [ ] Feedback form (1 page) for him
- [ ] Internal feedback to HR / school after week ends

---

## Resources to Hand Over

- [Flutter docs](https://docs.flutter.dev/)
- [Dart Pad](https://dartpad.dev/) — no install, browser-only Dart
- [freeCodeCamp](https://www.freecodecamp.org/) — free curriculum
- Mimo app — gamified coding on phone
- YouTube: "Flutter Mapp", "Reso Coder"
- FC-Gruppe Ausbildung page (if relevant)

---

## Risks & Backup Plans

- **Setup fails on Day 1** → fallback to DartPad in browser, no install needed
- **Overwhelmed** → drop API call (Day 4), keep app local-only
- **Too easy** → bonus task: add second API endpoint or local persistence (`shared_preferences`)
- **Sick day** → buddy dev takes over (pre-arrange)

---

## Notes / Reflection (fill in during week)

- 
