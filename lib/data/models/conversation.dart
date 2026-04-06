import 'package:cloud_firestore/cloud_firestore.dart';

class Conversation {
  Conversation({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.livestockId,
    required this.lastMessage,
    required this.updatedAt,
  });

  final String id;
  final String buyerId;
  final String sellerId;
  final String livestockId;
  final String lastMessage;
  final DateTime updatedAt;

  factory Conversation.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Conversation(
      id: doc.id,
      buyerId: data['buyerId'] as String,
      sellerId: data['sellerId'] as String,
      livestockId: data['livestockId'] as String,
      lastMessage: data['lastMessage'] as String? ?? '',
      updatedAt: (data['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'livestockId': livestockId,
      'lastMessage': lastMessage,
      'updatedAt': Timestamp.fromDate(updatedAt),
    };
  }
}
