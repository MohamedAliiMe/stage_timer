import '../entities/message_entity.dart';

abstract class MessageRepository {
  // Message CRUD operations
  Future<List<MessageEntity>> getAllMessages();
  Future<MessageEntity?> getMessageById(String id);
  Future<MessageEntity> createMessage(MessageEntity message);
  Future<MessageEntity> updateMessage(MessageEntity message);
  Future<void> deleteMessage(String id);
  
  // Message operations
  Future<MessageEntity> sendMessage(MessageEntity message);
  Future<MessageEntity> markAsRead(String id);
  Future<MessageEntity> markAsDelivered(String id);
  Future<MessageEntity> dismissMessage(String id);
  
  // Question operations
  Future<MessageEntity> submitQuestion(String content, String senderName);
  Future<List<MessageEntity>> getQuestions();
  Future<List<MessageEntity>> getPendingQuestions();
  
  // Filtering and querying
  Future<List<MessageEntity>> getMessagesByType(MessageType type);
  Future<List<MessageEntity>> getMessagesByPriority(MessagePriority priority);
  Future<List<MessageEntity>> getMessagesByStatus(MessageStatus status);
  Future<List<MessageEntity>> getMessagesByRecipient(String deviceId);
  
  // Bulk operations
  Future<void> markAllAsRead();
  Future<void> dismissAllMessages();
  Future<void> deleteAllMessages();
  
  // Stream operations
  Stream<List<MessageEntity>> watchMessages();
  Stream<MessageEntity?> watchMessage(String id);
  Stream<List<MessageEntity>> watchQuestions();
  Stream<List<MessageEntity>> watchPendingMessages();
}