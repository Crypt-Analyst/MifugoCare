import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/chat_message.dart';

class ChatMessageRepository {
  CollectionReference<Map<String, dynamic>> _messages(String conversationId) {
    return FirebaseFirestore.instance
        .collection('conversations')
        .doc(conversationId)
        .collection('messages');
  }

  Stream<List<ChatMessage>> streamMessages(String conversationId) {
    return _messages(conversationId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => ChatMessage.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> sendMessage({
    required String conversationId,
    required String senderId,
    required String body,
  }) async {
    final batch = FirebaseFirestore.instance.batch();
    final messageRef = _messages(conversationId).doc();
    batch.set(messageRef, {
      'senderId': senderId,
      'body': body,
      'createdAt': Timestamp.now(),
    });

    final convoRef =
        FirebaseFirestore.instance.collection('conversations').doc(conversationId);
    batch.update(convoRef, {
      'lastMessage': body,
      'updatedAt': Timestamp.now(),
    });

    await batch.commit();
  }
}
