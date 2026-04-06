import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/vet_request.dart';

class VetRequestRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('vetRequests');

  Stream<List<VetRequest>> streamForPastoralist(String pastoralistId) {
    return _collection
        .where('pastoralistId', isEqualTo: pastoralistId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VetRequest.fromDoc(doc))
              .toList(),
        );
  }

  Stream<List<VetRequest>> streamForVet(String vetId) {
    return _collection
        .where('vetId', isEqualTo: vetId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => VetRequest.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> createRequest(VetRequest request) async {
    await _collection.add(request.toJson());
  }

  Future<void> updateStatus({
    required String requestId,
    required String status,
  }) async {
    await _collection.doc(requestId).update({'status': status});
  }
}
