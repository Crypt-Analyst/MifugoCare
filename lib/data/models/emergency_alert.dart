import 'package:cloud_firestore/cloud_firestore.dart';

class EmergencyAlert {
  EmergencyAlert({
    required this.id,
    required this.pastoralistId,
    required this.message,
    required this.location,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String pastoralistId;
  final String message;
  final String location;
  final String status;
  final DateTime createdAt;

  factory EmergencyAlert.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return EmergencyAlert(
      id: doc.id,
      pastoralistId: data['pastoralistId'] as String,
      message: data['message'] as String,
      location: data['location'] as String,
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'pastoralistId': pastoralistId,
      'message': message,
      'location': location,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
