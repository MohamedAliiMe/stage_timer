class AppConstants {
  static const String appName = 'Stage Timer';
  static const String appVersion = '1.0.0';
  
  static const int defaultTimerDuration = 300; // 5 minutes in seconds
  static const int maxDevicesFreeTier = 3;
  static const int timerUpdateInterval = 100; // milliseconds
  
  static const List<String> supportedFormats = ['csv'];
  static const List<String> exportFormats = ['csv', 'json'];
  
  static const Map<String, String> viewTypes = {
    'viewer': 'Viewer',
    'controller': 'Controller',
    'agenda': 'Agenda',
    'moderator': 'Moderator',
    'operator': 'Operator',
    'questions': 'Submit Questions',
  };
  
  static const Map<String, int> timeAdjustments = {
    'plus_10_min': 600,
    'plus_5_min': 300,
    'plus_1_min': 60,
    'plus_30_sec': 30,
    'plus_10_sec': 10,
    'minus_1_sec': -1,
    'minus_10_sec': -10,
    'minus_30_sec': -30,
    'minus_1_min': -60,
    'minus_5_min': -300,
  };
}