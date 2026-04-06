import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/emergency_alert.dart';

class EmergencyAlertRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('emergencyAlerts');

  Stream<List<EmergencyAlert>> streamForPastoralist(String pastoralistId) {
    return _collection
        .where('pastoralistId', isEqualTo: pastoralistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EmergencyAlert.fromDoc(doc))
              .toList(),
        );
  }

  Stream<List<EmergencyAlert>> streamOpenAlerts() {
    return _collection
        .where('status', isEqualTo: 'open')
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => EmergencyAlert.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> createAlert(EmergencyAlert alert) async {
    await _collection.add(alert.toJson());
  }

  Future<void> updateStatus({
    required String alertId,
    required String status,
  }) async {
    await _collection.doc(alertId).update({'status': status});
  }
}
