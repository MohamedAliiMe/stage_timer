# Stage Timer

A professional cross-platform timer application built with Flutter, designed for managing stage presentations, conferences, workshops, and events. This application provides real-time timer management with a beautiful dark theme interface and comprehensive timer controls.

## 🚀 Features

### Timer Management
- **Multiple Timer Types**:
  - **Countdown Timers**: Count down from a set duration to zero
  - **Count-Up Timers**: Count up from zero to a maximum duration
  - **Live Clock**: Display current time in 12/24-hour format

- **Advanced Timer Controls**:
  - Play, pause, stop, and reset functionality
  - Real-time time adjustments (+/- seconds, minutes)
  - Custom color themes for each timer
  - Wrap-up warnings with visual indicators
  - Audio chime support (framework ready)

### Bulk Operations
- **Start All**: Start all stopped timers simultaneously
- **Stop All**: Stop all running timers
- **Reset All**: Reset all timers to initial state
- **Delete All**: Remove all timers
- **Blackout Mode**: Hide all displays for breaks

### Data Management
- **CSV Import/Export**: Import timer configurations from CSV files
- **JSON Export**: Export complete timer data structures
- **Sample Data**: Pre-loaded with 10 sample timers for conferences
- **Session-based Storage**: Data persists during app session (no permanent storage)

### Multi-Device Support (Simulated)
- **Device Management**: Track connected devices with different roles
- **Role-based Access**: Controller, Viewer, Moderator, Operator, Questioner
- **Message System**: Send announcements and instructions between devices
- **Real-time Synchronization**: Live updates across all connected devices

## 🏗️ Architecture

### Clean Architecture Pattern
```
├── lib/
│   ├── core/                   # Core application configurations
│   │   ├── constants/         # App constants and configurations
│   │   └── theme/            # Application theming
│   ├── data/                  # Data layer implementation
│   │   ├── models/           # JSON serializable data models
│   │   └── repositories/     # Repository implementations
│   ├── domain/               # Business logic layer
│   │   ├── entities/        # Core business entities
│   │   └── repositories/    # Repository interfaces
│   ├── injection/           # Dependency injection setup
│   └── presentation/        # UI layer
│       ├── blocs/          # BLoC state management
│       ├── pages/          # Application screens
│       └── widgets/        # Reusable UI components
```

### State Management
- **BLoC Pattern**: Using flutter_bloc for reactive state management
- **Stream-based Updates**: Real-time timer updates every 100ms
- **Event-driven Architecture**: Clean separation of events and states

### Dependency Injection
- **GetIt**: Service locator for dependency injection
- **Repository Pattern**: Clean abstraction of data sources
- **Static Implementation**: 100% offline functionality with simulated data

## 📱 Pre-loaded Sample Data

### Sample Timers (10 Built-in)
1. **Opening Remarks** (5 min countdown) - Blue theme
2. **Keynote Presentation** (30 min countdown) - Green theme with 5min wrap-up
3. **Panel Discussion** (45 min countdown) - Purple theme with 10min wrap-up
4. **Q&A Session** (15 min count-up) - Orange theme
5. **Coffee Break** (15 min countdown) - Brown theme
6. **Workshop Session** (60 min countdown) - Blue Grey with 15min wrap-up
7. **Closing Remarks** (10 min countdown) - Pink theme
8. **Current Time** (Live clock) - 12-hour format
9. **Speaker Prep** (3 min countdown) - Amber theme
10. **Live Demo** (20 min count-up) - Cyan theme

### Sample Messages (5 Pre-loaded)
- Welcome announcement with highlighting
- Audience volume question
- Urgent fire drill alert with flashing
- Technical question from attendee
- Time warning instruction to speaker

### Mock Connected Devices (5 Simulated)
- **Main Controller** - MacBook Pro (Desktop, Controller role)
- **Stage Display** - iPad Pro (Tablet, Viewer role)
- **Moderator Phone** - iPhone 15 (Mobile, Moderator role)
- **Backup Controller** - Windows PC (Desktop, Operator role) [Disconnected]
- **Question Kiosk** - Chrome Browser (Web, Questioner role)

## 🛠️ Technology Stack

### Core Framework
- **Flutter**: Cross-platform UI framework
- **Dart**: Programming language

### State Management & Architecture
- **flutter_bloc**: Reactive state management
- **equatable**: Value equality for entities
- **get_it**: Dependency injection

### Data & Serialization
- **json_annotation**: JSON serialization annotations
- **json_serializable**: Code generation for JSON
- **uuid**: Unique identifier generation
- **csv**: CSV file processing

### Storage & Networking
- **shared_preferences**: Local preferences storage
- **path_provider**: File system access
- **http**: HTTP client for future networking
- **url_launcher**: Launch external URLs

### UI & Responsive Design
- **responsive_framework**: Responsive design utilities
- **intl**: Internationalization support
- **cupertino_icons**: iOS-style icons

### Development Tools
- **build_runner**: Code generation runner
- **flutter_lints**: Dart/Flutter linting rules

## 🚦 Getting Started

### Prerequisites
- Flutter SDK (>=3.7.2)
- Dart SDK
- Platform-specific development tools:
  - Android Studio (for Android)
  - Xcode (for iOS/macOS)
  - Visual Studio (for Windows)
  - Linux development tools (for Linux)

### Installation

1. **Clone the repository**:
   ```bash
   git clone <repository-url>
   cd stage_timer
   ```

2. **Install dependencies**:
   ```bash
   flutter pub get
   ```

3. **Generate code** (for JSON serialization):
   ```bash
   flutter packages pub run build_runner build
   ```

4. **Run the application**:
   ```bash
   flutter run
   ```

### Platform-specific Setup

#### Web
```bash
flutter run -d chrome
```

#### Desktop (Windows/macOS/Linux)
```bash
flutter run -d windows    # Windows
flutter run -d macos      # macOS  
flutter run -d linux      # Linux
```

#### Mobile (Android/iOS)
```bash
flutter run -d android    # Android
flutter run -d ios        # iOS
```

## 🎯 Usage Examples

### Running a Conference
1. **Load** pre-configured conference timers
2. **Customize** durations and colors as needed
3. **Start** opening remarks timer
4. **Monitor** progress with visual indicators
5. **Advance** through schedule using individual controls
6. **Use blackout** mode during breaks
7. **Export** final timing data as CSV

### Timer Controls
- **Individual Controls**: Each timer has play/pause/stop/reset buttons
- **Time Adjustments**: Add/subtract time in real-time
- **Bulk Operations**: Control all timers simultaneously
- **Visual Indicators**: Color-coded status and wrap-up warnings

### Data Import/Export
- **CSV Import**: Load timer configurations from `assets/sample_timers.csv`
- **Export Options**: Save timer data as CSV or JSON
- **Sample Format**:
  ```csv
  Name,Type,Duration,Description
  Opening Remarks,countdown,300,Welcome and introduction
  Keynote,countdown,1800,Main presentation
  ```

## 🎨 UI Features

### Modern Dark Theme
- **Dark Mode**: Professional dark interface
- **Color Coding**: Custom colors for different timer types
- **Visual Feedback**: Status indicators and progress bars
- **Responsive Design**: Adapts to different screen sizes

### Timer Display
- **Large Time Display**: Easy-to-read timer values
- **Progress Bars**: Visual progress indication
- **Status Indicators**: Color-coded timer states
- **Wrap-up Warnings**: Visual alerts when time is running low

### Controls Interface
- **Intuitive Icons**: Clear control buttons
- **Bulk Operations**: Menu for controlling multiple timers
- **Blackout Toggle**: Quick hide/show all displays
- **Export Options**: Easy data export functionality

## 📊 Data Architecture

### Entities
- **TimerEntity**: Core timer functionality and properties
- **DeviceEntity**: Connected device information
- **MessageEntity**: Inter-device messaging
- **RundownEntity**: Timer sequence management

### Repository Pattern
- **TimerRepository**: Timer CRUD operations and control
- **DeviceRepository**: Device management and tracking
- **MessageRepository**: Message handling and delivery

### Static Data Implementation
- **No Server Required**: 100% offline functionality
- **Memory Storage**: All data stored in memory during session
- **Mock Services**: Simulated network operations
- **Sample Data**: Rich set of pre-loaded examples

## 🔧 Configuration

### App Constants
```dart
class AppConstants {
  static const String appName = 'Stage Timer';
  static const int timerUpdateInterval = 100; // milliseconds
  static const int maxDevicesFreeTier = 3;
  // ... more configurations
}
```

### Theme Customization
```dart
class AppTheme {
  static const Color primaryColor = Color(0xFF6366F1);
  static const Color timerActiveColor = Color(0xFF10B981);
  static const Color timerWarningColor = Color(0xFFF59E0B);
  // ... more theme colors
}
```

## 🧪 Testing

### Run Tests
```bash
flutter test
```

### Widget Testing
- Basic widget smoke tests included
- Tests verify app initialization and core functionality

## 📦 Build & Deployment

### Debug Build
```bash
flutter build apk --debug           # Android Debug
flutter build ios --debug           # iOS Debug
flutter build web --debug           # Web Debug
```

### Release Build
```bash
flutter build apk --release         # Android Release
flutter build ipa --release         # iOS Release
flutter build web --release         # Web Release
flutter build windows --release     # Windows Release
flutter build macos --release       # macOS Release
flutter build linux --release       # Linux Release
```

## 🎛️ Advanced Features

### Timer Precision
- **100ms Updates**: High-precision timer updates
- **Real-time Sync**: Synchronized across all displays
- **State Persistence**: Maintains state during app lifecycle

### Message System
- **Priority Levels**: Low, Normal, High, Urgent
- **Message Types**: General, Question, Announcement, Alert, Instruction
- **Visual Effects**: Flash and highlight options
- **Auto-dismiss**: Configurable display duration

### Device Management
- **Role-based Access**: Different capabilities per device role
- **Session Management**: Unique session identifiers
- **Connection Tracking**: Monitor device connectivity
- **Bulk Operations**: Manage all devices simultaneously

## 🔮 Future Enhancements

### Potential Features
- **Real Network Support**: Actual multi-device synchronization
- **Audio Chimes**: Sound notifications for timer events
- **Custom Themes**: User-configurable color schemes
- **Advanced Scheduling**: Automated timer sequences
- **Analytics**: Timer usage statistics and reports
- **Cloud Sync**: Backup and restore timer configurations

## 🤝 Contributing

### Development Setup
1. Fork the repository
2. Create a feature branch
3. Follow the existing code structure
4. Add tests for new functionality
5. Submit a pull request

### Code Style
- Follow Dart/Flutter style guidelines
- Use meaningful variable and function names
- Document public APIs
- Maintain clean architecture principles

## 📄 License

This project is available for educational and demonstration purposes. Check the repository for specific license information.

## 🆘 Support

### Common Issues
- **Build Failures**: Run `flutter clean && flutter pub get`
- **Code Generation**: Run `flutter packages pub run build_runner build --delete-conflicting-outputs`
- **Platform Issues**: Check Flutter doctor with `flutter doctor`

### Resources
- [Flutter Documentation](https://docs.flutter.dev/)
- [BLoC Library Documentation](https://bloclibrary.dev/)
- [Dart Language Tour](https://dart.dev/guides/language/language-tour)

---

**Stage Timer** - Professional timer management for events, conferences, and presentations. Built with Flutter for maximum platform compatibility and performance.
