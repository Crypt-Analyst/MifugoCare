import 'package:cloud_firestore/cloud_firestore.dart';

class SavedListing {
  SavedListing({
    required this.id,
    required this.buyerId,
    required this.livestockId,
    required this.createdAt,
  });

  final String id;
  final String buyerId;
  final String livestockId;
  final DateTime createdAt;

  factory SavedListing.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return SavedListing(
      id: doc.id,
      buyerId: data['buyerId'] as String,
      livestockId: data['livestockId'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'buyerId': buyerId,
      'livestockId': livestockId,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
