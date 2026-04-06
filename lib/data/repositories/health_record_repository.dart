import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/health_record.dart';

class HealthRecordRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('healthRecords');

  Stream<List<HealthRecord>> streamForPastoralist(String pastoralistId) {
    return _collection
        .where('pastoralistId', isEqualTo: pastoralistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => HealthRecord.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> createRecord(HealthRecord record) async {
    await _collection.add(record.toJson());
  }
}
