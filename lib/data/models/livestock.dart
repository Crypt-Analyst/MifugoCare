import 'package:cloud_firestore/cloud_firestore.dart';

class Livestock {
  Livestock({
    required this.id,
    required this.ownerId,
    required this.name,
    required this.type,
    required this.breed,
    required this.ageMonths,
    required this.location,
    required this.healthStatus,
    required this.price,
    required this.createdAt,
  });

  final String id;
  final String ownerId;
  final String name;
  final String type;
  final String breed;
  final int ageMonths;
  final String location;
  final String healthStatus;
  final double? price;
  final DateTime createdAt;

  factory Livestock.fromDoc(DocumentSnapshot<Map<String, dynamic>> doc) {
    final data = doc.data()!;
    return Livestock(
      id: doc.id,
      ownerId: data['ownerId'] as String,
      name: data['name'] as String,
      type: data['type'] as String,
      breed: data['breed'] as String,
      ageMonths: data['ageMonths'] as int,
      location: data['location'] as String,
      healthStatus: data['healthStatus'] as String,
      price: (data['price'] as num?)?.toDouble(),
      createdAt: (data['createdAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'ownerId': ownerId,
      'name': name,
      'type': type,
      'breed': breed,
      'ageMonths': ageMonths,
      'location': location,
      'healthStatus': healthStatus,
      'price': price,
      'createdAt': Timestamp.fromDate(createdAt),
    };
  }
}
