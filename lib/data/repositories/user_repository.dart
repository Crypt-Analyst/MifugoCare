import 'package:cloud_firestore/cloud_firestore.dart';

import '../models/user_profile.dart';

class UserRepository {
  final CollectionReference<Map<String, dynamic>> _users =
      FirebaseFirestore.instance.collection('users');

  Future<UserProfile?> getUserProfile(String uid) async {
    final doc = await _users.doc(uid).get();
    if (!doc.exists || doc.data() == null) {
      return null;
    }
    return UserProfile.fromJson(doc.data()!);
  }

  Future<void> createProfile(UserProfile profile) async {
    await _users.doc(profile.uid).set(profile.toJson());
  }

  Stream<List<UserProfile>> streamUsers() {
    return _users.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserProfile.fromJson(doc.data()))
              .toList(),
        );
  }

  Stream<List<UserProfile>> streamVets({bool? isVerified}) {
    Query<Map<String, dynamic>> query =
        _users.where('role', isEqualTo: 'vet');
    if (isVerified != null) {
      query = query.where('isVerified', isEqualTo: isVerified);
    }
    return query.orderBy('createdAt', descending: true).snapshots().map(
          (snapshot) => snapshot.docs
              .map((doc) => UserProfile.fromJson(doc.data()))
              .toList(),
        );
  }

  Future<void> updateVerification({
    required String uid,
    required bool isVerified,
  }) async {
    await _users.doc(uid).update({'isVerified': isVerified});
  }

  Future<void> updateActive({
    required String uid,
    required bool isActive,
  }) async {
    await _users.doc(uid).update({'isActive': isActive});
  }
}
