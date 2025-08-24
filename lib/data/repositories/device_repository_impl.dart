import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/device_entity.dart';
import '../../domain/repositories/device_repository.dart';

class DeviceRepositoryImpl implements DeviceRepository {
  final List<DeviceEntity> _devices = [];
  final StreamController<List<DeviceEntity>> _devicesController = StreamController.broadcast();
  final Map<String, StreamController<DeviceEntity?>> _deviceControllers = {};
  final Uuid _uuid = const Uuid();

  static const int _maxDevicesFreeTier = 3;
  static const int _maxDevicesUnlimited = 999;

  DeviceRepositoryImpl() {
    _initializeWithSampleData();
  }

  void _initializeWithSampleData() {
    final sampleDevices = [
      DeviceEntity(
        id: _uuid.v4(),
        name: 'Main Controller - MacBook Pro',
        type: DeviceType.desktop,
        status: DeviceStatus.connected,
        role: DeviceRole.controller,
        userAgent: 'Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_7) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        ipAddress: '192.168.1.100',
        connectedAt: DateTime.now().subtract(const Duration(hours: 2)),
        lastSeenAt: DateTime.now(),
        sessionId: 'session-controller-main',
        isControllerDevice: true,
        capabilities: {
          'canControlTimers': true,
          'canSendMessages': true,
          'canManageDevices': true,
          'canExportData': true,
        },
      ),
      DeviceEntity(
        id: _uuid.v4(),
        name: 'Stage Display - iPad Pro',
        type: DeviceType.tablet,
        status: DeviceStatus.connected,
        role: DeviceRole.viewer,
        userAgent: 'Mozilla/5.0 (iPad; CPU OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        ipAddress: '192.168.1.101',
        connectedAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 30)),
        lastSeenAt: DateTime.now().subtract(const Duration(seconds: 5)),
        sessionId: 'session-viewer-stage',
        capabilities: {
          'canViewTimers': true,
          'canReceiveMessages': true,
          'fullscreenSupport': true,
        },
      ),
      DeviceEntity(
        id: _uuid.v4(),
        name: 'Moderator Phone - iPhone 15',
        type: DeviceType.mobile,
        status: DeviceStatus.connected,
        role: DeviceRole.moderator,
        userAgent: 'Mozilla/5.0 (iPhone; CPU iPhone OS 17_0 like Mac OS X) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/17.0 Mobile/15E148 Safari/604.1',
        ipAddress: '192.168.1.102',
        connectedAt: DateTime.now().subtract(const Duration(minutes: 45)),
        lastSeenAt: DateTime.now().subtract(const Duration(seconds: 10)),
        sessionId: 'session-moderator-mobile',
        capabilities: {
          'canSendMessages': true,
          'canViewMessages': true,
          'canManageQuestions': true,
          'pushNotifications': true,
        },
      ),
      DeviceEntity(
        id: _uuid.v4(),
        name: 'Backup Controller - Windows PC',
        type: DeviceType.desktop,
        status: DeviceStatus.disconnected,
        role: DeviceRole.operator,
        userAgent: 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        ipAddress: '192.168.1.103',
        connectedAt: DateTime.now().subtract(const Duration(hours: 3)),
        lastSeenAt: DateTime.now().subtract(const Duration(minutes: 15)),
        sessionId: 'session-operator-backup',
        capabilities: {
          'canControlTimers': true,
          'canViewTimers': true,
          'basicControls': true,
        },
      ),
      DeviceEntity(
        id: _uuid.v4(),
        name: 'Question Kiosk - Chrome Browser',
        type: DeviceType.web,
        status: DeviceStatus.connected,
        role: DeviceRole.questioner,
        userAgent: 'Mozilla/5.0 (X11; Linux x86_64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
        ipAddress: '192.168.1.104',
        connectedAt: DateTime.now().subtract(const Duration(minutes: 20)),
        lastSeenAt: DateTime.now().subtract(const Duration(seconds: 30)),
        sessionId: 'session-questions-kiosk',
        capabilities: {
          'canSubmitQuestions': true,
          'publicAccess': true,
        },
      ),
    ];

    _devices.addAll(sampleDevices);
    _emitUpdates();
  }

  void _emitUpdates() {
    _devicesController.add(List.from(_devices));
  }

  @override
  Future<List<DeviceEntity>> getAllDevices() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.from(_devices);
  }

  @override
  Future<DeviceEntity?> getDeviceById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _devices.firstWhere((device) => device.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<DeviceEntity> registerDevice(DeviceEntity device) async {
    await Future.delayed(const Duration(milliseconds: 50));
    
    if (!await canAddDevice()) {
      throw Exception('Device limit reached');
    }
    
    final newDevice = device.copyWith(
      id: device.id.isEmpty ? _uuid.v4() : device.id,
      connectedAt: DateTime.now(),
      lastSeenAt: DateTime.now(),
    );
    
    _devices.add(newDevice);
    _emitUpdates();
    return newDevice;
  }

  @override
  Future<DeviceEntity> updateDevice(DeviceEntity device) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _devices.indexWhere((d) => d.id == device.id);
    if (index != -1) {
      _devices[index] = device.copyWith(lastSeenAt: DateTime.now());
      _deviceControllers[device.id]?.add(_devices[index]);
      _emitUpdates();
      return _devices[index];
    }
    throw Exception('Device not found');
  }

  @override
  Future<void> removeDevice(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _devices.removeWhere((device) => device.id == id);
    _deviceControllers[id]?.add(null);
    _emitUpdates();
  }

  @override
  Future<void> kickDevice(String id) async {
    final device = await getDeviceById(id);
    if (device == null) throw Exception('Device not found');
    
    await updateDevice(device.copyWith(status: DeviceStatus.disconnected));
    // In a real app, this would send a disconnect signal to the device
  }

  @override
  Future<void> forceReloadDevice(String id) async {
    final device = await getDeviceById(id);
    if (device == null) throw Exception('Device not found');
    
    // In a real app, this would send a reload signal to the device
    await updateDevice(device.copyWith(lastSeenAt: DateTime.now()));
  }

  @override
  Future<void> updateDeviceStatus(String id, DeviceStatus status) async {
    final device = await getDeviceById(id);
    if (device == null) throw Exception('Device not found');
    
    await updateDevice(device.copyWith(status: status));
  }

  @override
  Future<void> updateDeviceRole(String id, DeviceRole role) async {
    final device = await getDeviceById(id);
    if (device == null) throw Exception('Device not found');
    
    await updateDevice(device.copyWith(role: role));
  }

  @override
  Future<List<DeviceEntity>> getDevicesByRole(DeviceRole role) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _devices.where((d) => d.role == role).toList();
  }

  @override
  Future<List<DeviceEntity>> getDevicesByStatus(DeviceStatus status) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _devices.where((d) => d.status == status).toList();
  }

  @override
  Future<List<DeviceEntity>> getConnectedDevices() async {
    return getDevicesByStatus(DeviceStatus.connected);
  }

  @override
  Future<List<DeviceEntity>> getStaleDevices() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _devices.where((d) => d.isStale).toList();
  }

  @override
  Future<bool> canAddDevice() async {
    final connectedCount = await getDeviceCount();
    final maxDevices = await getMaxDeviceLimit();
    return connectedCount < maxDevices;
  }

  @override
  Future<int> getDeviceCount() async {
    return _devices.length;
  }

  @override
  Future<int> getMaxDeviceLimit() async {
    // In a real app, this would check the user's subscription level
    // For static data, we'll simulate different tiers
    return _maxDevicesUnlimited; // Simulate unlimited plan
  }

  @override
  Future<bool> isDeviceLimitReached() async {
    return !(await canAddDevice());
  }

  @override
  Future<DeviceEntity?> getDeviceBySessionId(String sessionId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _devices.firstWhere((device) => device.sessionId == sessionId);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<void> refreshDeviceSession(String id) async {
    final device = await getDeviceById(id);
    if (device == null) throw Exception('Device not found');
    
    await updateDevice(device.copyWith(
      sessionId: 'session-${device.role.name}-${_uuid.v4().substring(0, 8)}',
      lastSeenAt: DateTime.now(),
    ));
  }

  @override
  Future<void> expireDeviceSession(String id) async {
    await kickDevice(id);
  }

  @override
  Future<void> kickAllDevices() async {
    for (final device in _devices) {
      if (device.isConnected && !device.isControllerDevice) {
        await kickDevice(device.id);
      }
    }
  }

  @override
  Future<void> reloadAllDevices() async {
    for (final device in _devices) {
      if (device.isConnected) {
        await forceReloadDevice(device.id);
      }
    }
  }

  @override
  Future<void> cleanupStaleDevices() async {
    final staleDevices = await getStaleDevices();
    for (final device in staleDevices) {
      await kickDevice(device.id);
    }
  }

  @override
  Stream<List<DeviceEntity>> watchDevices() {
    return _devicesController.stream;
  }

  @override
  Stream<DeviceEntity?> watchDevice(String id) {
    if (!_deviceControllers.containsKey(id)) {
      _deviceControllers[id] = StreamController<DeviceEntity?>.broadcast();
    }
    return _deviceControllers[id]!.stream;
  }

  @override
  Stream<List<DeviceEntity>> watchDevicesByRole(DeviceRole role) {
    return _devicesController.stream.map((devices) =>
        devices.where((d) => d.role == role).toList());
  }

  @override
  Stream<int> watchDeviceCount() {
    return _devicesController.stream.map((devices) => devices.length);
  }

  void dispose() {
    _devicesController.close();
    for (final controller in _deviceControllers.values) {
      controller.close();
    }
  }
}