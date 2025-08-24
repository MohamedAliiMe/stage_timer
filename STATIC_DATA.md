# Stage Timer - Static Data Implementation

## Overview

This Stage Timer app is designed with **100% static data** and requires **no server connections**. All data is stored locally and persists only during the app session.

## Static Data Features

### 🔢 **Pre-loaded Timers (10 Sample Timers)**
- **Opening Remarks** (5 min countdown) - Blue theme
- **Keynote Presentation** (30 min countdown) - Green theme with 5min wrap-up
- **Panel Discussion** (45 min countdown) - Purple theme with 10min wrap-up  
- **Q&A Session** (15 min count-up) - Orange theme
- **Coffee Break** (15 min countdown) - Brown theme
- **Workshop Session** (60 min countdown) - Blue Grey with 15min wrap-up
- **Closing Remarks** (10 min countdown) - Pink theme
- **Current Time** (Live clock) - 12-hour format
- **Speaker Prep** (3 min countdown) - Amber theme
- **Live Demo** (20 min count-up) - Cyan theme

### 💬 **Sample Messages (5 Pre-loaded)**
- Welcome announcement with highlighting
- Audience question about volume
- Urgent fire drill alert with flashing
- Technical question from attendee
- Time warning instruction to speaker

### 📱 **Mock Connected Devices (5 Simulated)**
- **Main Controller** - MacBook Pro (Desktop, Controller role)
- **Stage Display** - iPad Pro (Tablet, Viewer role)  
- **Moderator Phone** - iPhone 15 (Mobile, Moderator role)
- **Backup Controller** - Windows PC (Desktop, Operator role) [Disconnected]
- **Question Kiosk** - Chrome Browser (Web, Questioner role)

## Timer Features

### Timer Types
- **Countdown**: Starts at set duration, counts down to zero
- **Count-up**: Starts at zero, counts up to maximum duration  
- **Clock**: Displays current time (12h/24h format)

### Timer Controls
- ▶️ **Start/Pause/Stop/Reset** - Full transport controls
- ⏱️ **Time Adjustments**: 
  - Add: +10s, +30s, +1min, +5min, +10min
  - Subtract: -1s, -10s, -30s, -1min, -5min
- 🎨 **Custom Colors**: Each timer has unique color themes
- ⚠️ **Wrap-up Warnings**: Visual alerts when time is running low
- 🔔 **Chime Support**: Audio alerts (framework ready)

### Bulk Operations
- **Start All** - Start all stopped timers simultaneously
- **Stop All** - Stop all running timers  
- **Reset All** - Reset all timers to initial state
- **Delete All** - Remove all timers
- **Blackout Mode** - Hide all displays (useful for breaks)

## Data Import/Export

### CSV Import
- Sample CSV file included: `assets/sample_timers.csv`
- Format: `Name,Type,Duration,Description`
- Supports countdown/countup timer types
- Duration in seconds

### Export Options
- **CSV Export**: Timer list with all properties
- **JSON Export**: Complete timer data structure

## No Network Dependencies

### What Works Offline
✅ All timer operations  
✅ Real-time updates (100ms precision)  
✅ Data persistence during session  
✅ Import/Export functionality  
✅ Message system  
✅ Device simulation  
✅ All UI interactions  

### What's Simulated (No Real Network)
- Device connections (static device list)
- Message sending (local state updates)
- Real-time synchronization (local streams)
- User authentication (no login required)

## Data Persistence

### Session-Based Storage
- Data exists only while app is running
- No permanent storage to external files
- No database connections
- No cloud synchronization

### Memory Storage
- All timers stored in memory arrays
- Real-time updates via Dart streams
- State management through BLoC pattern
- Automatic cleanup on app close

## Usage Examples

### Running a Conference
1. **Load** pre-configured conference timers
2. **Customize** durations and colors as needed
3. **Start** opening remarks timer
4. **Monitor** progress with visual indicators
5. **Advance** through schedule using individual controls
6. **Use blackout** mode during breaks
7. **Export** final timing data as CSV

### Testing Different Scenarios
- Use **count-up** timers for open discussions
- Set **wrap-up warnings** for important presentations  
- Practice with **bulk controls** for emergency situations
- Test **time adjustments** for schedule changes
- Verify **export functionality** for record keeping

## Development Features

### Clean Architecture
- Repository pattern with static implementations
- BLoC state management for reactive updates
- Dependency injection with GetIt
- JSON serialization for data models

### Platform Support
- **Web**: Runs in any modern browser
- **Desktop**: Native macOS, Windows, Linux apps
- **Mobile**: iOS and Android applications
- **Responsive**: Adapts to all screen sizes

This implementation provides a full-featured stage timer application without any external dependencies, perfect for offline use and demonstrations.