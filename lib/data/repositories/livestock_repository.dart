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

  Future<void> addLivestock(Livestock livestock) async {
    await _collection.add(livestock.toJson());
  }

  Future<void> updateLivestock(Livestock livestock) async {
    await _collection.doc(livestock.id).update(livestock.toJson());
  }
}
