import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';

class FirebaseFireService extends ChangeNotifier {
  final FirebaseFirestore db = FirebaseFirestore.instance;
  Future<void> addUser(String userName, String phoneNumber, String userId,
      String userImageUrl) async {
    await db.collection('users').doc(userId).set({
      'userName': userName,
      'phoneNumber': phoneNumber,
      'userImageUrl': userImageUrl,
      'userId': userId,
      'createdAt': Timestamp.now(),
      'countMessage': 0,
    });
  }
}
