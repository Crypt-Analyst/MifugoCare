import 'package:cloud_firestore/cloud_firestore.dart';

class Message {
  Message({
    required this.id,
    required this.buyerId,
    required this.sellerId,
    required this.livestockId,
    required this.body,
    required this.createdAt,
  });

  final String id;
  final String buyerId;
  final String sellerId;
  final String livestockId;
  final String body;
  final DateTime createdAt;

  factory Message.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Message(
      id: doc.id,
      buyerId: data['buyerId'] as String,
      sellerId: data['sellerId'] as String,
      livestockId: data['livestockId'] as String,
      body: data['body'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyerId': buyerId,
      'sellerId': sellerId,
      'livestockId': livestockId,
      'body': body,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
