import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/report.dart';

class ReportRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('reports');

  Stream<List<Report>> streamOpenReports() {
    return _collection
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Report.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> updateStatus({
    required String reportId,
    required String status,
  }) async {
    await _collection.doc(reportId).update({'status': status});
  }
}
