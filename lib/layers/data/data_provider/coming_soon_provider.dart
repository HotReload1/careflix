import 'package:careflix/core/enum.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_keys.dart';

class ComingSoonProvider {
  Future<QuerySnapshot<Map<String, dynamic>>> getComingSoonShows(
      ShowLan? showLan) async {
    final ref = FirebaseFirestore.instance
        .collection(FireStoreKeys.coming_soon_collections);
    final res;
    if (showLan != null) {
      res =
          await ref.where("lan", isEqualTo: showLanToStringData(showLan)).get();
      return res;
    }
    return await ref.get();
  }
}
