// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'device_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

DeviceModel _$DeviceModelFromJson(Map<String, dynamic> json) => DeviceModel(
  id: json['id'] as String,
  name: json['name'] as String,
  type: $enumDecode(_$DeviceTypeEnumMap, json['type']),
  status:
      $enumDecodeNullable(_$DeviceStatusEnumMap, json['status']) ??
      DeviceStatus.connected,
  role: $enumDecode(_$DeviceRoleEnumMap, json['role']),
  userAgent: json['userAgent'] as String?,
  ipAddress: json['ipAddress'] as String?,
  connectedAt: DateTime.parse(json['connectedAt'] as String),
  lastSeenAt: DateTime.parse(json['lastSeenAt'] as String),
  sessionId: json['sessionId'] as String,
  capabilities: json['capabilities'] as Map<String, dynamic>?,
  isControllerDevice: json['isControllerDevice'] as bool? ?? false,
);

Map<String, dynamic> _$DeviceModelToJson(DeviceModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'type': _$DeviceTypeEnumMap[instance.type]!,
      'status': _$DeviceStatusEnumMap[instance.status]!,
      'role': _$DeviceRoleEnumMap[instance.role]!,
      'userAgent': instance.userAgent,
      'ipAddress': instance.ipAddress,
      'connectedAt': instance.connectedAt.toIso8601String(),
      'lastSeenAt': instance.lastSeenAt.toIso8601String(),
      'sessionId': instance.sessionId,
      'capabilities': instance.capabilities,
      'isControllerDevice': instance.isControllerDevice,
    };

const _$DeviceTypeEnumMap = {
  DeviceType.web: 'web',
  DeviceType.mobile: 'mobile',
  DeviceType.desktop: 'desktop',
  DeviceType.tablet: 'tablet',
};

const _$DeviceStatusEnumMap = {
  DeviceStatus.connected: 'connected',
  DeviceStatus.disconnected: 'disconnected',
  DeviceStatus.reconnecting: 'reconnecting',
};

const _$DeviceRoleEnumMap = {
  DeviceRole.viewer: 'viewer',
  DeviceRole.controller: 'controller',
  DeviceRole.moderator: 'moderator',
  DeviceRole.operator: 'operator',
  DeviceRole.questioner: 'questioner',
};
