import 'package:equatable/equatable.dart';

enum DeviceType {
  web,
  mobile,
  desktop,
  tablet,
}

enum DeviceStatus {
  connected,
  disconnected,
  reconnecting,
}

enum DeviceRole {
  viewer,
  controller,
  moderator,
  operator,
  questioner,
}

class DeviceEntity extends Equatable {
  final String id;
  final String name;
  final DeviceType type;
  final DeviceStatus status;
  final DeviceRole role;
  final String? userAgent;
  final String? ipAddress;
  final DateTime connectedAt;
  final DateTime lastSeenAt;
  final String sessionId;
  final Map<String, dynamic>? capabilities;
  final bool isControllerDevice;

  const DeviceEntity({
    required this.id,
    required this.name,
    required this.type,
    this.status = DeviceStatus.connected,
    required this.role,
    this.userAgent,
    this.ipAddress,
    required this.connectedAt,
    required this.lastSeenAt,
    required this.sessionId,
    this.capabilities,
    this.isControllerDevice = false,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        type,
        status,
        role,
        userAgent,
        ipAddress,
        connectedAt,
        lastSeenAt,
        sessionId,
        capabilities,
        isControllerDevice,
      ];

  DeviceEntity copyWith({
    String? id,
    String? name,
    DeviceType? type,
    DeviceStatus? status,
    DeviceRole? role,
    String? userAgent,
    String? ipAddress,
    DateTime? connectedAt,
    DateTime? lastSeenAt,
    String? sessionId,
    Map<String, dynamic>? capabilities,
    bool? isControllerDevice,
  }) {
    return DeviceEntity(
      id: id ?? this.id,
      name: name ?? this.name,
      type: type ?? this.type,
      status: status ?? this.status,
      role: role ?? this.role,
      userAgent: userAgent ?? this.userAgent,
      ipAddress: ipAddress ?? this.ipAddress,
      connectedAt: connectedAt ?? this.connectedAt,
      lastSeenAt: lastSeenAt ?? this.lastSeenAt,
      sessionId: sessionId ?? this.sessionId,
      capabilities: capabilities ?? this.capabilities,
      isControllerDevice: isControllerDevice ?? this.isControllerDevice,
    );
  }

  bool get isConnected => status == DeviceStatus.connected;
  bool get isDisconnected => status == DeviceStatus.disconnected;
  bool get isReconnecting => status == DeviceStatus.reconnecting;

  bool get isViewer => role == DeviceRole.viewer;
  bool get isController => role == DeviceRole.controller;
  bool get isModerator => role == DeviceRole.moderator;
  bool get isOperator => role == DeviceRole.operator;
  bool get isQuestioner => role == DeviceRole.questioner;

  String get typeLabel {
    switch (type) {
      case DeviceType.web:
        return 'Web Browser';
      case DeviceType.mobile:
        return 'Mobile';
      case DeviceType.desktop:
        return 'Desktop';
      case DeviceType.tablet:
        return 'Tablet';
    }
  }

  String get roleLabel {
    switch (role) {
      case DeviceRole.viewer:
        return 'Viewer';
      case DeviceRole.controller:
        return 'Controller';
      case DeviceRole.moderator:
        return 'Moderator';
      case DeviceRole.operator:
        return 'Operator';
      case DeviceRole.questioner:
        return 'Question Submitter';
    }
  }

  String get statusLabel {
    switch (status) {
      case DeviceStatus.connected:
        return 'Connected';
      case DeviceStatus.disconnected:
        return 'Disconnected';
      case DeviceStatus.reconnecting:
        return 'Reconnecting';
    }
  }

  Duration get connectionDuration {
    return lastSeenAt.difference(connectedAt);
  }

  bool get isStale {
    final now = DateTime.now();
    final timeSinceLastSeen = now.difference(lastSeenAt);
    return timeSinceLastSeen.inMinutes > 5; // Consider stale after 5 minutes
  }
}