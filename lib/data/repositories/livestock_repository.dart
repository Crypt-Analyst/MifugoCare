import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/livestock.dart';

class LivestockRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('livestock');

  Stream<List<Livestock>> streamByOwner(String ownerId) {
    return _collection
        .where('ownerId', isEqualTo: ownerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => Livestock.fromDoc(doc))
              .toList(),
        );
  }

  Stream<List<Livestock>> streamListings({
    String? type,
    String? location,
    String? healthStatus,
  }) {
    Query<Map<String, dynamic>> query = _collection
        .where('status', isEqualTo: 'active')
        .orderBy('createdAt', descending: true)
        .limit(50);

    if (type != null && type.isNotEmpty) {
      query = query.where('type', isEqualTo: type);
    }
    if (location != null && location.isNotEmpty) {
      query = query.where('location', isEqualTo: location);
    }
    if (healthStatus != null && healthStatus.isNotEmpty) {
      query = query.where('healthStatus', isEqualTo: healthStatus);
    }

    return query.snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => Livestock.fromDoc(doc))
              .toList(),
        );
  }

        Stream<List<Livestock>> streamAllListings() {
          return _collection.orderBy('createdAt', descending: true).snapshots().map(
            (snapshot) => snapshot.docs
            .map((doc) => Livestock.fromDoc(doc))
            .toList(),
          );
        }

  Future<List<Livestock>> fetchByIds(List<String> ids) async {
    if (ids.isEmpty) {
      return [];
    }
    final snapshot = await _collection.where(FieldPath.documentId, whereIn: ids).get();
    return snapshot.docs.map((doc) => Livestock.fromDoc(doc)).toList();
  }

  Future<void> addLivestock(Livestock livestock) async {
    await _collection.add(livestock.toJson());
  }

  Future<void> updateLivestock(Livestock livestock) async {
    await _collection.doc(livestock.id).update(livestock.toJson());
  }

  Future<void> updateStatus({
    required String livestockId,
    required String status,
  }) async {
    await _collection.doc(livestockId).update({'status': status});
  }
}
