import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/saved_listing.dart';

class SavedListingRepository {
  final CollectionReference<Map<String, dynamic>> _collection =
      FirebaseFirestore.instance.collection('savedListings');

  Stream<List<SavedListing>> streamForBuyer(String buyerId) {
    return _collection
        .where('buyerId', isEqualTo: buyerId)
        .orderBy('createdAt', descending: true)
        .snapshots()
        .map(
          (snapshot) => snapshot.docs
              .map((doc) => SavedListing.fromDoc(doc))
              .toList(),
        );
  }

  Future<void> saveListing({
    required String buyerId,
    required String livestockId,
  }) async {
    await _collection.add({
      'buyerId': buyerId,
      'livestockId': livestockId,
      'createdAt': Timestamp.now(),
    });
  }

  Future<void> removeListing(String savedListingId) async {
    await _collection.doc(savedListingId).delete();
  }

  Future<SavedListing?> findSaved({
    required String buyerId,
    required String livestockId,
  }) async {
    final snapshot = await _collection
        .where('buyerId', isEqualTo: buyerId)
        .where('livestockId', isEqualTo: livestockId)
        .limit(1)
        .get();

    if (snapshot.docs.isEmpty) {
      return null;
    }

    return SavedListing.fromDoc(snapshot.docs.first);
  }
}
