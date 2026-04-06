import 'package:cloud_firestore/cloud_firestore.dart';

enum UserRole { pastoralist, vet, buyer, admin }

class UserProfile {
  UserProfile({
    required this.uid,
    required this.email,
    required this.displayName,
    required this.role,
    required this.isVerified,
    required this.isActive,
    required this.createdAt,
  });

  final String uid;
  final String email;
  final String displayName;
  final UserRole role;
  final bool isVerified;
  final bool isActive;
  final DateTime createdAt;

  factory UserProfile.fromJson(Map<String, dynamic> json) {
    final roleValue = UserRole.values.firstWhere(
      (role) => role.name == json['role'],
      orElse: () => UserRole.pastoralist,
    );
    return UserProfile(
      uid: json['uid'] as String,
      email: json['email'] as String,
      displayName: json['displayName'] as String,
      role: roleValue,
      isVerified:
          json['isVerified'] as bool? ?? (roleValue == UserRole.vet ? false : true),
      isActive: json['isActive'] as bool? ?? true,
      createdAt: (json['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'uid': uid,
      'email': email,
      'displayName': displayName,
      'role': role.name,
      'isVerified': isVerified,
      'isActive': isActive,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
