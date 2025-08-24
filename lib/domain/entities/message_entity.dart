import 'package:equatable/equatable.dart';

enum MessageType {
  general,
  question,
  announcement,
  alert,
  instruction,
}

enum MessagePriority {
  low,
  normal,
  high,
  urgent,
}

enum MessageStatus {
  pending,
  sent,
  delivered,
  read,
  dismissed,
}

class MessageEntity extends Equatable {
  final String id;
  final String content;
  final MessageType type;
  final MessagePriority priority;
  final MessageStatus status;
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? readAt;
  final String senderId;
  final String? senderName;
  final List<String> recipients;
  final bool shouldFlash;
  final bool shouldHighlight;
  final int? displayDuration; // in seconds, null for manual dismiss
  final Map<String, dynamic>? metadata;

  const MessageEntity({
    required this.id,
    required this.content,
    this.type = MessageType.general,
    this.priority = MessagePriority.normal,
    this.status = MessageStatus.pending,
    required this.createdAt,
    this.sentAt,
    this.readAt,
    required this.senderId,
    this.senderName,
    this.recipients = const [],
    this.shouldFlash = false,
    this.shouldHighlight = false,
    this.displayDuration,
    this.metadata,
  });

  @override
  List<Object?> get props => [
        id,
        content,
        type,
        priority,
        status,
        createdAt,
        sentAt,
        readAt,
        senderId,
        senderName,
        recipients,
        shouldFlash,
        shouldHighlight,
        displayDuration,
        metadata,
      ];

  MessageEntity copyWith({
    String? id,
    String? content,
    MessageType? type,
    MessagePriority? priority,
    MessageStatus? status,
    DateTime? createdAt,
    DateTime? sentAt,
    DateTime? readAt,
    String? senderId,
    String? senderName,
    List<String>? recipients,
    bool? shouldFlash,
    bool? shouldHighlight,
    int? displayDuration,
    Map<String, dynamic>? metadata,
  }) {
    return MessageEntity(
      id: id ?? this.id,
      content: content ?? this.content,
      type: type ?? this.type,
      priority: priority ?? this.priority,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
      sentAt: sentAt ?? this.sentAt,
      readAt: readAt ?? this.readAt,
      senderId: senderId ?? this.senderId,
      senderName: senderName ?? this.senderName,
      recipients: recipients ?? this.recipients,
      shouldFlash: shouldFlash ?? this.shouldFlash,
      shouldHighlight: shouldHighlight ?? this.shouldHighlight,
      displayDuration: displayDuration ?? this.displayDuration,
      metadata: metadata ?? this.metadata,
    );
  }

  bool get isSent => status == MessageStatus.sent || 
                     status == MessageStatus.delivered || 
                     status == MessageStatus.read;
  bool get isRead => status == MessageStatus.read;
  bool get isPending => status == MessageStatus.pending;
  bool get isDismissed => status == MessageStatus.dismissed;

  bool get isQuestion => type == MessageType.question;
  bool get isAlert => type == MessageType.alert;
  bool get isUrgent => priority == MessagePriority.urgent;
  bool get isHigh => priority == MessagePriority.high;

  bool get shouldAutoDismiss => displayDuration != null;

  String get priorityLabel {
    switch (priority) {
      case MessagePriority.low:
        return 'Low';
      case MessagePriority.normal:
        return 'Normal';
      case MessagePriority.high:
        return 'High';
      case MessagePriority.urgent:
        return 'Urgent';
    }
  }

  String get typeLabel {
    switch (type) {
      case MessageType.general:
        return 'General';
      case MessageType.question:
        return 'Question';
      case MessageType.announcement:
        return 'Announcement';
      case MessageType.alert:
        return 'Alert';
      case MessageType.instruction:
        return 'Instruction';
    }
  }
}