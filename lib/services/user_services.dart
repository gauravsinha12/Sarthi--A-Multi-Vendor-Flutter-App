import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:sarthi/modles/user_modles.dart';

class UserServices {
  String collection = 'users';
  FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<void> createUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).set(values);
  }

  Future<void> updateUserData(Map<String, dynamic> values) async {
    String id = values['id'];
    await _firestore.collection(collection).doc(id).update(values);
  }

  Future<void> getUserById(String id) async {
    await _firestore.collection(collection).doc(id).get().then((doc) {
      if (doc.data() == null) {
        return null;
      }
      return UserModle.fromSnapshot(doc);
    });
  }
}
