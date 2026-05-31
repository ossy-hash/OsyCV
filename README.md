# OsyCV

A Flutter-based CV/Resume maker app with 8 professional templates, PDF generation, and full customization.

## Features

- **8 Professional Templates**: Classic, Modern, Minimal, Creative, Executive, Material, Sidebar Bold, Timeline
- **PDF Generation**: Export any CV as a PDF document
- **Photo Import**: Add your profile photo from the gallery
- **Full Customization**: Change accent colors, rearrange sections, toggle visibility
- **Sections**: Personal info, summary, experience, education, projects, certifications, skills, languages
- **Persistence**: All data saved locally via Hive
- **State Management**: Riverpod (Notifier API)
- **Navigation**: GoRouter with named routes

## Screenshots

*(add screenshots here)*

## Getting Started

### Prerequisites

- Flutter SDK ^3.12.0
- Dart SDK ^3.12.0

### Installation

```bash
git clone https://github.com/ossy-hash/OsyCV.git
cd OsyCV
flutter pub get
flutter run
```

### Build APK

```bash
flutter build apk --release
```

## Project Structure

```
lib/
├── core/
│   ├── constants/
│   ├── router/
│   ├── theme/
│   └── utils/
├── data/
│   ├── models/          # Data models with ==/hashCode
│   └── repositories/     # Repository pattern (Hive impl)
├── providers/            # Riverpod providers
├── screens/
│   ├── dashboard/
│   ├── editor/
│   ├── preview/
│   └── template_picker/
├── services/             # PDF generation service
└── widgets/
    ├── forms/            # Section form widgets
    ├── templates/        # 8 template implementations
    │   ├── mixins/       # Shared renderer mixins
    │   ├── classic/
    │   ├── modern/
    │   ├── minimal/
    │   ├── creative/
    │   ├── executive/
    │   ├── material/
    │   ├── sidebar_bold/
    │   └── timeline/
    └── logo_widget.dart
```

## Tech Stack

- **Framework**: Flutter
- **State Management**: Riverpod 2.x (Notifier API)
- **Navigation**: GoRouter 14.x
- **PDF**: pdf & printing packages
- **Persistence**: Hive
- **Icons**: flutter_svg
- **Fonts**: Google Fonts

## License

MIT
