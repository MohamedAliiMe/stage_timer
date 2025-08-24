import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/device_entity.dart';

part 'device_model.g.dart';

@JsonSerializable()
class DeviceModel extends DeviceEntity {
  const DeviceModel({
    required super.id,
    required super.name,
    required super.type,
    super.status,
    required super.role,
    super.userAgent,
    super.ipAddress,
    required super.connectedAt,
    required super.lastSeenAt,
    required super.sessionId,
    super.capabilities,
    super.isControllerDevice,
  });

  factory DeviceModel.fromJson(Map<String, dynamic> json) => _$DeviceModelFromJson(json);
  Map<String, dynamic> toJson() => _$DeviceModelToJson(this);

  factory DeviceModel.fromEntity(DeviceEntity entity) {
    return DeviceModel(
      id: entity.id,
      name: entity.name,
      type: entity.type,
      status: entity.status,
      role: entity.role,
      userAgent: entity.userAgent,
      ipAddress: entity.ipAddress,
      connectedAt: entity.connectedAt,
      lastSeenAt: entity.lastSeenAt,
      sessionId: entity.sessionId,
      capabilities: entity.capabilities,
      isControllerDevice: entity.isControllerDevice,
    );
  }

  DeviceEntity toEntity() {
    return DeviceEntity(
      id: id,
      name: name,
      type: type,
      status: status,
      role: role,
      userAgent: userAgent,
      ipAddress: ipAddress,
      connectedAt: connectedAt,
      lastSeenAt: lastSeenAt,
      sessionId: sessionId,
      capabilities: capabilities,
      isControllerDevice: isControllerDevice,
    );
  }
}