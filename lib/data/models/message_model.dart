import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/message_entity.dart';

part 'message_model.g.dart';

@JsonSerializable()
class MessageModel extends MessageEntity {
  const MessageModel({
    required super.id,
    required super.content,
    super.type,
    super.priority,
    super.status,
    required super.createdAt,
    super.sentAt,
    super.readAt,
    required super.senderId,
    super.senderName,
    super.recipients,
    super.shouldFlash,
    super.shouldHighlight,
    super.displayDuration,
    super.metadata,
  });

  factory MessageModel.fromJson(Map<String, dynamic> json) => _$MessageModelFromJson(json);
  Map<String, dynamic> toJson() => _$MessageModelToJson(this);

  factory MessageModel.fromEntity(MessageEntity entity) {
    return MessageModel(
      id: entity.id,
      content: entity.content,
      type: entity.type,
      priority: entity.priority,
      status: entity.status,
      createdAt: entity.createdAt,
      sentAt: entity.sentAt,
      readAt: entity.readAt,
      senderId: entity.senderId,
      senderName: entity.senderName,
      recipients: entity.recipients,
      shouldFlash: entity.shouldFlash,
      shouldHighlight: entity.shouldHighlight,
      displayDuration: entity.displayDuration,
      metadata: entity.metadata,
    );
  }

  MessageEntity toEntity() {
    return MessageEntity(
      id: id,
      content: content,
      type: type,
      priority: priority,
      status: status,
      createdAt: createdAt,
      sentAt: sentAt,
      readAt: readAt,
      senderId: senderId,
      senderName: senderName,
      recipients: recipients,
      shouldFlash: shouldFlash,
      shouldHighlight: shouldHighlight,
      displayDuration: displayDuration,
      metadata: metadata,
    );
  }
}