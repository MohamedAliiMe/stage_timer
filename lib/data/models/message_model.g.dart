// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'message_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MessageModel _$MessageModelFromJson(Map<String, dynamic> json) => MessageModel(
  id: json['id'] as String,
  content: json['content'] as String,
  type:
      $enumDecodeNullable(_$MessageTypeEnumMap, json['type']) ??
      MessageType.general,
  priority:
      $enumDecodeNullable(_$MessagePriorityEnumMap, json['priority']) ??
      MessagePriority.normal,
  status:
      $enumDecodeNullable(_$MessageStatusEnumMap, json['status']) ??
      MessageStatus.pending,
  createdAt: DateTime.parse(json['createdAt'] as String),
  sentAt:
      json['sentAt'] == null ? null : DateTime.parse(json['sentAt'] as String),
  readAt:
      json['readAt'] == null ? null : DateTime.parse(json['readAt'] as String),
  senderId: json['senderId'] as String,
  senderName: json['senderName'] as String?,
  recipients:
      (json['recipients'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList() ??
      const [],
  shouldFlash: json['shouldFlash'] as bool? ?? false,
  shouldHighlight: json['shouldHighlight'] as bool? ?? false,
  displayDuration: (json['displayDuration'] as num?)?.toInt(),
  metadata: json['metadata'] as Map<String, dynamic>?,
);

Map<String, dynamic> _$MessageModelToJson(MessageModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'content': instance.content,
      'type': _$MessageTypeEnumMap[instance.type]!,
      'priority': _$MessagePriorityEnumMap[instance.priority]!,
      'status': _$MessageStatusEnumMap[instance.status]!,
      'createdAt': instance.createdAt.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'readAt': instance.readAt?.toIso8601String(),
      'senderId': instance.senderId,
      'senderName': instance.senderName,
      'recipients': instance.recipients,
      'shouldFlash': instance.shouldFlash,
      'shouldHighlight': instance.shouldHighlight,
      'displayDuration': instance.displayDuration,
      'metadata': instance.metadata,
    };

const _$MessageTypeEnumMap = {
  MessageType.general: 'general',
  MessageType.question: 'question',
  MessageType.announcement: 'announcement',
  MessageType.alert: 'alert',
  MessageType.instruction: 'instruction',
};

const _$MessagePriorityEnumMap = {
  MessagePriority.low: 'low',
  MessagePriority.normal: 'normal',
  MessagePriority.high: 'high',
  MessagePriority.urgent: 'urgent',
};

const _$MessageStatusEnumMap = {
  MessageStatus.pending: 'pending',
  MessageStatus.sent: 'sent',
  MessageStatus.delivered: 'delivered',
  MessageStatus.read: 'read',
  MessageStatus.dismissed: 'dismissed',
};
