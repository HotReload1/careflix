import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../../../core/firebase/firestore_keys.dart';
import '../../../core/shared_preferences/shared_preferences_instance.dart';

class RuleProvider {
  Stream<DocumentSnapshot<Map<String, dynamic>>> getStreamRule() {
    var collectionRef = FirebaseFirestore.instance
        .collection(FireStoreKeys.parental_control_collections);
    return collectionRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .snapshots();
  }

  Future<DocumentSnapshot<Map<String, dynamic>>> getRule() async {
    var collectionRef = FirebaseFirestore.instance
        .collection(FireStoreKeys.parental_control_collections);
    return await collectionRef
        .doc(FirebaseAuth.instance.currentUser!.uid)
        .get();
  }
}
