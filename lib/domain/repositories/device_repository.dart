import '../entities/device_entity.dart';

abstract class DeviceRepository {
  // Device management operations
  Future<List<DeviceEntity>> getAllDevices();
  Future<DeviceEntity?> getDeviceById(String id);
  Future<DeviceEntity> registerDevice(DeviceEntity device);
  Future<DeviceEntity> updateDevice(DeviceEntity device);
  Future<void> removeDevice(String id);
  
  // Device control operations
  Future<void> kickDevice(String id);
  Future<void> forceReloadDevice(String id);
  Future<void> updateDeviceStatus(String id, DeviceStatus status);
  Future<void> updateDeviceRole(String id, DeviceRole role);
  
  // Device queries
  Future<List<DeviceEntity>> getDevicesByRole(DeviceRole role);
  Future<List<DeviceEntity>> getDevicesByStatus(DeviceStatus status);
  Future<List<DeviceEntity>> getConnectedDevices();
  Future<List<DeviceEntity>> getStaleDevices();
  
  // Device limits and validation
  Future<bool> canAddDevice();
  Future<int> getDeviceCount();
  Future<int> getMaxDeviceLimit();
  Future<bool> isDeviceLimitReached();
  
  // Session management
  Future<DeviceEntity?> getDeviceBySessionId(String sessionId);
  Future<void> refreshDeviceSession(String id);
  Future<void> expireDeviceSession(String id);
  
  // Bulk operations
  Future<void> kickAllDevices();
  Future<void> reloadAllDevices();
  Future<void> cleanupStaleDevices();
  
  // Stream operations
  Stream<List<DeviceEntity>> watchDevices();
  Stream<DeviceEntity?> watchDevice(String id);
  Stream<List<DeviceEntity>> watchDevicesByRole(DeviceRole role);
  Stream<int> watchDeviceCount();
}