import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/conversation.dart';

class ConversationRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('conversations');

  Stream<List<Conversation>> streamForBuyer(String buyerId) {
    return _collection
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Conversation.fromDoc(doc))
              .toList(),
        );
  }

  Stream<List<Conversation>> streamForSeller(String sellerId) {
    return _collection
        .where('sellerId', isEqualTo: sellerId)
        .orderBy('updatedAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Conversation.fromDoc(doc))
              .toList(),
        );
  }

  Future<Conversation> getOrCreate({
    required String buyerId,
    required String sellerId,
    required String livestockId,
  }) async {
    final existing = await _collection
        .where('buyerId', isEqualTo: buyerId)
        .where('sellerId', isEqualTo: sellerId)
        .where('livestockId', isEqualTo: livestockId)
        .limit(1)
        .get();

    if (existing.docs.isNotEmpty) {
      return Conversation.fromDoc(existing.docs.first);
    }

    final now = DateTime.now();
    final doc = await _collection.add({
      'buyerId': buyerId,
      'sellerId': sellerId,
      'livestockId': livestockId,
      'lastMessage': '',
      'updatedAt': Timestamp.fromDate(now),
    });

    final snapshot = await doc.get();
    return Conversation.fromDoc(snapshot);
  }

  Future<void> updateSummary({
    required String conversationId,
    required String lastMessage,
  }) async {
    await _collection.doc(conversationId).update({
      'lastMessage': lastMessage,
      'updatedAt': Timestamp.now(),
    });
  }
}
