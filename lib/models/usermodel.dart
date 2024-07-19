import 'package:cloud_firestore/cloud_firestore.dart';

class UserModel {
  final String email;
  final String uid;
  final String username;
  final int age;
  final String photoUrl;
  final double weight; // Added field for weight
  final double height; // Added field for height
  final String gender; // Added field for gender

  UserModel({
    required this.email,
    required this.uid,
    required this.username,
    required this.age,
    required this.photoUrl,
    required this.weight, // Constructor parameter for weight
    required this.height, // Constructor parameter for height
    required this.gender, // Constructor parameter for gender
  });

  Map<String, dynamic> toJson() => {
    'email': email,
    'username': username,
    'age': age,
    'photoUrl': photoUrl,
    'uid': uid,
    'weight': weight, // Include weight in JSON
    'height': height, // Include height in JSON
    'gender': gender, // Include gender in JSON
  };

  static UserModel SnapData(DocumentSnapshot snap) {
    var snapshot = snap.data() as Map<String, dynamic>;

    return UserModel(
      username: snapshot['username'],
      uid: snapshot['uid'],
      email: snapshot['email'],
      age: snapshot['age'],
      photoUrl: snapshot['photoUrl'],
      weight: snapshot['weight']?.toDouble() ?? 0.0, // Extract weight, default to 0.0 if not found
      height: snapshot['height']?.toDouble() ?? 0.0, // Extract height, default to 0.0 if not found
      gender: snapshot['gender'] ?? '', // Extract gender, default to empty string if not found
    );
  }
}