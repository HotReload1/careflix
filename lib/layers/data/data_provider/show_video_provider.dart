import 'package:cloud_firestore/cloud_firestore.dart';
import '../../../core/firebase/firestore_keys.dart';

class ShowVideoProvider {
  Future<QuerySnapshot<Map<String, dynamic>>> getShowVideos(
      String showId) async {
    final ref = FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .doc(showId)
        .collection(FireStoreKeys.episodes_sub_collection);

    return await ref.get();
  }
}
