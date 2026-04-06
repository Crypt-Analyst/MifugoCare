import 'package:cloud_firestore/cloud_firestore.dart';

class VetRequest {
  VetRequest({
    required this.id,
    required this.pastoralistId,
    required this.vetId,
    required this.notes,
    required this.preferredDate,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String pastoralistId;
  final String vetId;
  final String notes;
  final DateTime preferredDate;
  final String status;
  final DateTime createdAt;

  factory VetRequest.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return VetRequest(
      id: doc.id,
      pastoralistId: data['pastoralistId'] as String,
      vetId: data['vetId'] as String,
      notes: data['notes'] as String,
      preferredDate: (data['preferredDate'] as Timestamp).toDate(),
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pastoralistId': pastoralistId,
      'vetId': vetId,
      'notes': notes,
      'preferredDate': Timestamp.fromDate(preferredDate),
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
