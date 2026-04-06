import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/message.dart';

class MessageRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('messages');

  Stream<List<Message>> streamForBuyer(String buyerId) {
    return _collection
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Message.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> sendMessage(Message message) async {
    await _collection.add(message.toJson());
  }
}
