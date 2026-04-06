import 'package:cloud_firestore/cloud_firestore.dart';

class HealthRecord {
  HealthRecord({
    required this.id,
    required this.livestockId,
    required this.pastoralistId,
    required this.vetId,
    required this.summary,
    required this.treatment,
    required this.vaccination,
    required this.createdAt,
  });

  final String id;
  final String livestockId;
  final String pastoralistId;
  final String vetId;
  final String summary;
  final String treatment;
  final String vaccination;
  final DateTime createdAt;

  factory HealthRecord.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return HealthRecord(
      id: doc.id,
      livestockId: data['livestockId'] as String,
      pastoralistId: data['pastoralistId'] as String,
      vetId: data['vetId'] as String,
      summary: data['summary'] as String,
      treatment: data['treatment'] as String,
      vaccination: data['vaccination'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'livestockId': livestockId,
      'pastoralistId': pastoralistId,
      'vetId': vetId,
      'summary': summary,
      'treatment': treatment,
      'vaccination': vaccination,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
