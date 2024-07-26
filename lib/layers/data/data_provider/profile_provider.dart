import 'package:careflix/layers/data/model/user_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/enum.dart';
import '../../../core/firebase/firestore_keys.dart';

class ProfileProvider {
  static FirebaseFirestore _firebaseFirestore = FirebaseFirestore.instance;
  static FirebaseAuth _auth = FirebaseAuth.instance;

  User currentUser = _auth.currentUser!;

  Future<void> createUserProfile(
      String fName, lName, birthDate, Gender gender) async {
    UserModel user = UserModel(
        id: currentUser.uid,
        email: currentUser.email,
        firstName: fName,
        lastName: lName,
        birthDate: birthDate,
        gender: gender,
        createdAt: DateTime.now().toString(),
        userListIds: [],
        pushToken: "");

    await _firebaseFirestore
        .collection(FireStoreKeys.users_collections)
        .doc(currentUser.uid)
        .set(user.toMap())
        .then((value) => currentUser.updateDisplayName(fName + " " + lName));
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getUserProfile() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }

  Future<void> changeUserProfile(List<String> ids) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.users_collections)
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .update({"userListsIds": ids});
  }
}
