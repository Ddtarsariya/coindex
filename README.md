# Coindex 📈

A modern Flutter cryptocurrency portfolio tracking application that allows users to manage their crypto investments with real-time price updates and intuitive portfolio management.

## 🚀 App Setup Steps

### Prerequisites
- Flutter SDK (^3.9.0)
- Dart SDK
- Android Studio / VS Code
- Git

### Installation
1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd coindex
   ```

2. **Install dependencies**
   ```bash
   flutter pub get
   ```

3. **Run the application**
   ```bash
   flutter run
   ```

## 📱 How to Run the Application

### Development Mode
```bash
# Run on connected device/emulator
flutter run

# Run on platform
flutter run -d android
```

### Release Mode
```bash
# Build APK for Android
flutter build apk --release
```

### Platform Support
- Android

## Architectural Choices

### Clean Architecture
The app follows **Clean Architecture** principles with clear separation of concerns:

```
lib/
├── core/           # Shared utilities, constants, services
├── data/           # Data models and repositories
├── features/       # Feature-based modules
│   ├── home/       # Portfolio management feature
│   └── splash/     # Splash screen feature
└── main.dart       # App entry point
```

### Feature Structure
Each feature contains:
```
features/home/
├── bloc/           # State management (Events, States, BLoCs)
├── models/         # Feature-specific data models
├── screens/        # UI screens
├── widgets/        # Reusable UI components
└── helper/         # Business logic helpers
```

### Key Design Patterns
- **Repository Pattern**: Data abstraction layer
- **Singleton Pattern**: SharedPreferencesManager
- **Factory Pattern**: Model creation from JSON
- **Observer Pattern**: BLoC state management

## Third-Party Libraries Used

### Core Dependencies
```yaml
dependencies:
  # State Management
  flutter_bloc: ^8.1.6    # BLoC pattern implementation
  
  # Networking
  dio: ^5.4.3+1           # HTTP client for API calls
  
  # Local Storage
  shared_preferences: ^2.2.3  # Persistent local storage
```
