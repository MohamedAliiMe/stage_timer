import 'dart:async';
import 'package:uuid/uuid.dart';
import '../../domain/entities/message_entity.dart';
import '../../domain/repositories/message_repository.dart';

class MessageRepositoryImpl implements MessageRepository {
  final List<MessageEntity> _messages = [];
  final StreamController<List<MessageEntity>> _messagesController = StreamController.broadcast();
  final Map<String, StreamController<MessageEntity?>> _messageControllers = {};
  final Uuid _uuid = const Uuid();

  MessageRepositoryImpl() {
    _initializeWithSampleData();
  }

  void _initializeWithSampleData() {
    final sampleMessages = [
      MessageEntity(
        id: _uuid.v4(),
        content: 'Welcome to the annual tech conference! Please take your seats.',
        type: MessageType.announcement,
        priority: MessagePriority.normal,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(hours: 1)),
        sentAt: DateTime.now().subtract(const Duration(hours: 1)),
        senderId: 'moderator-1',
        senderName: 'Conference Moderator',
        recipients: ['viewer-all'],
        shouldHighlight: true,
        displayDuration: 10,
      ),
      MessageEntity(
        id: _uuid.v4(),
        content: 'Can you please speak a bit louder? Hard to hear from the back.',
        type: MessageType.question,
        priority: MessagePriority.normal,
        status: MessageStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 30)),
        senderId: 'audience-member-1',
        senderName: 'Anonymous Attendee',
        recipients: ['moderator-1'],
      ),
      MessageEntity(
        id: _uuid.v4(),
        content: 'URGENT: Fire drill in 5 minutes. Please prepare to evacuate.',
        type: MessageType.alert,
        priority: MessagePriority.urgent,
        status: MessageStatus.sent,
        createdAt: DateTime.now().subtract(const Duration(minutes: 15)),
        sentAt: DateTime.now().subtract(const Duration(minutes: 15)),
        senderId: 'security-1',
        senderName: 'Security Team',
        recipients: ['all'],
        shouldFlash: true,
        shouldHighlight: true,
      ),
      MessageEntity(
        id: _uuid.v4(),
        content: 'What tools do you recommend for beginners in this field?',
        type: MessageType.question,
        priority: MessagePriority.normal,
        status: MessageStatus.pending,
        createdAt: DateTime.now().subtract(const Duration(minutes: 10)),
        senderId: 'audience-member-2',
        senderName: 'John D.',
        recipients: ['speaker-1'],
      ),
      MessageEntity(
        id: _uuid.v4(),
        content: 'Please wrap up in the next 5 minutes.',
        type: MessageType.instruction,
        priority: MessagePriority.high,
        status: MessageStatus.delivered,
        createdAt: DateTime.now().subtract(const Duration(minutes: 5)),
        sentAt: DateTime.now().subtract(const Duration(minutes: 5)),
        senderId: 'moderator-1',
        senderName: 'Conference Moderator',
        recipients: ['speaker-1'],
        shouldHighlight: true,
      ),
    ];

    _messages.addAll(sampleMessages);
    _emitUpdates();
  }

  void _emitUpdates() {
    _messagesController.add(List.from(_messages));
  }

  @override
  Future<List<MessageEntity>> getAllMessages() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return List.from(_messages);
  }

  @override
  Future<MessageEntity?> getMessageById(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    try {
      return _messages.firstWhere((message) => message.id == id);
    } catch (_) {
      return null;
    }
  }

  @override
  Future<MessageEntity> createMessage(MessageEntity message) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final newMessage = message.copyWith(id: message.id.isEmpty ? _uuid.v4() : message.id);
    _messages.add(newMessage);
    _emitUpdates();
    return newMessage;
  }

  @override
  Future<MessageEntity> updateMessage(MessageEntity message) async {
    await Future.delayed(const Duration(milliseconds: 50));
    final index = _messages.indexWhere((m) => m.id == message.id);
    if (index != -1) {
      _messages[index] = message;
      _messageControllers[message.id]?.add(message);
      _emitUpdates();
      return message;
    }
    throw Exception('Message not found');
  }

  @override
  Future<void> deleteMessage(String id) async {
    await Future.delayed(const Duration(milliseconds: 50));
    _messages.removeWhere((message) => message.id == id);
    _messageControllers[id]?.add(null);
    _emitUpdates();
  }

  @override
  Future<MessageEntity> sendMessage(MessageEntity message) async {
    final sentMessage = message.copyWith(
      status: MessageStatus.sent,
      sentAt: DateTime.now(),
    );
    return updateMessage(sentMessage);
  }

  @override
  Future<MessageEntity> markAsRead(String id) async {
    final message = await getMessageById(id);
    if (message == null) throw Exception('Message not found');
    
    return updateMessage(message.copyWith(
      status: MessageStatus.read,
      readAt: DateTime.now(),
    ));
  }

  @override
  Future<MessageEntity> markAsDelivered(String id) async {
    final message = await getMessageById(id);
    if (message == null) throw Exception('Message not found');
    
    return updateMessage(message.copyWith(status: MessageStatus.delivered));
  }

  @override
  Future<MessageEntity> dismissMessage(String id) async {
    final message = await getMessageById(id);
    if (message == null) throw Exception('Message not found');
    
    return updateMessage(message.copyWith(status: MessageStatus.dismissed));
  }

  @override
  Future<MessageEntity> submitQuestion(String content, String senderName) async {
    final question = MessageEntity(
      id: _uuid.v4(),
      content: content,
      type: MessageType.question,
      priority: MessagePriority.normal,
      status: MessageStatus.pending,
      createdAt: DateTime.now(),
      senderId: 'audience-${_uuid.v4()}',
      senderName: senderName.isEmpty ? 'Anonymous' : senderName,
      recipients: ['moderator-1'],
    );
    
    return createMessage(question);
  }

  @override
  Future<List<MessageEntity>> getQuestions() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _messages.where((m) => m.type == MessageType.question).toList();
  }

  @override
  Future<List<MessageEntity>> getPendingQuestions() async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _messages.where((m) => 
      m.type == MessageType.question && m.status == MessageStatus.pending
    ).toList();
  }

  @override
  Future<List<MessageEntity>> getMessagesByType(MessageType type) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _messages.where((m) => m.type == type).toList();
  }

  @override
  Future<List<MessageEntity>> getMessagesByPriority(MessagePriority priority) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _messages.where((m) => m.priority == priority).toList();
  }

  @override
  Future<List<MessageEntity>> getMessagesByStatus(MessageStatus status) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _messages.where((m) => m.status == status).toList();
  }

  @override
  Future<List<MessageEntity>> getMessagesByRecipient(String deviceId) async {
    await Future.delayed(const Duration(milliseconds: 50));
    return _messages.where((m) => 
      m.recipients.contains(deviceId) || m.recipients.contains('all')
    ).toList();
  }

  @override
  Future<void> markAllAsRead() async {
    for (final message in _messages) {
      if (message.status != MessageStatus.read) {
        await markAsRead(message.id);
      }
    }
  }

  @override
  Future<void> dismissAllMessages() async {
    for (final message in _messages) {
      if (message.status != MessageStatus.dismissed) {
        await dismissMessage(message.id);
      }
    }
  }

  @override
  Future<void> deleteAllMessages() async {
    _messages.clear();
    _emitUpdates();
  }

  @override
  Stream<List<MessageEntity>> watchMessages() {
    return _messagesController.stream;
  }

  @override
  Stream<MessageEntity?> watchMessage(String id) {
    if (!_messageControllers.containsKey(id)) {
      _messageControllers[id] = StreamController<MessageEntity?>.broadcast();
    }
    return _messageControllers[id]!.stream;
  }

  @override
  Stream<List<MessageEntity>> watchQuestions() {
    return _messagesController.stream.map((messages) =>
        messages.where((m) => m.type == MessageType.question).toList());
  }

  @override
  Stream<List<MessageEntity>> watchPendingMessages() {
    return _messagesController.stream.map((messages) =>
        messages.where((m) => m.status == MessageStatus.pending).toList());
  }

  void dispose() {
    _messagesController.close();
    for (final controller in _messageControllers.values) {
      controller.close();
    }
  }
}