import 'package:careflix/core/firebase/firestore_keys.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ListsProvider {
  Future<QuerySnapshot<Map<String, dynamic>>> getTopShows() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .orderBy("rating", descending: true)
        .limit(5)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getTrendingShows() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .where("trending", isEqualTo: true)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getEnglishShows() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .where("lan", isEqualTo: 'en')
        .limit(5)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getArabicShows() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .where("lan", isEqualTo: 'ar')
        .limit(5)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getAnimeShows() async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .where("lan", isEqualTo: 'anime')
        .limit(5)
        .get();
  }

  Future<QuerySnapshot<Map<String, dynamic>>> getUserLists(
      List<String> ids) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .where(FieldPath.documentId, whereIn: ids)
        .get();
  }
}
