import 'package:cloud_firestore/cloud_firestore.dart';

class Report {
  Report({
    required this.id,
    required this.reporterId,
    required this.targetType,
    required this.targetId,
    required this.reason,
    required this.status,
    required this.createdAt,
  });

  final String id;
  final String reporterId;
  final String targetType;
  final String targetId;
  final String reason;
  final String status;
  final DateTime createdAt;

  factory Report.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Report(
      id: doc.id,
      reporterId: data['reporterId'] as String,
      targetType: data['targetType'] as String,
      targetId: data['targetId'] as String,
      reason: data['reason'] as String,
      status: data['status'] as String,
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'reporterId': reporterId,
      'targetType': targetType,
      'targetId': targetId,
      'reason': reason,
      'status': status,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
