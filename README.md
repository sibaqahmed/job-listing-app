# Job Listing App (Flutter)

A Flutter application developed as part of the BooksApp interview assignment. The app fetches live job listings from the provided APIs, separates them into **Active** and **Archived** roles, supports local search & filtering, and provides a detailed job view with an Apply/Withdraw workflow.

---

## Features

- Active & Archived job listings
- Local search (Title & Company)
- Filter jobs without additional API calls
- Job details screen
- Apply / Withdraw functionality
- Archived jobs cannot be applied to
- Loading, Empty & Error states
- Light & Dark themes
- Smooth UI with custom gradients and animations
- State management using Riverpod

---

## APIs Used

**Active Roles**
```
https://api.wraeglobal.com/roleRouter/getActiveRoles
```

**Archived Roles**
```
https://api.wraeglobal.com/roleRouter/getArchivedRoles
```

---

## Tech Stack

- Flutter
- Riverpod
- Dio
- SharedPreferences
- Material 3

---

## Project Structure

```
lib/
 ├── data/
 ├── presentation/
 ├── providers/
 ├── theme/
 └── main.dart
```

---

## Getting Started

Clone the repository and run:

```bash
flutter pub get
flutter run
```

No additional configuration is required.

---

## Design Decisions

- Local in-memory search for instant filtering.
- Riverpod for predictable state management.
- SharedPreferences for lightweight persistence.
- Optimized rebuilds and list rendering for smoother scrolling.
- Responsive UI supporting both Light and Dark themes.

---

## Note About API Keys

The API endpoints have intentionally **not been hidden or obfuscated** because this project was developed as an interview assignment using publicly provided APIs. This allows reviewers to clone the repository and run the application immediately without requiring additional configuration.

---

## Future Improvements

- Pagination
- Offline caching (Hive/SQLite)
- Unit & Widget tests
- Server-side search
- CI/CD pipeline

---

## Author

**Sibaq Ahmed**
B.Tech Information Technology
IIIT Bhopal