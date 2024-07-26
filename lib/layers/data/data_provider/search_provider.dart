import 'package:careflix/core/enum.dart';
import 'package:careflix/layers/data/params/search_params.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

import '../../../core/firebase/firestore_keys.dart';

class SearchProvider {
  Future<QuerySnapshot<Map<String, dynamic>>> searchShow(
      SearchParams searchParams) async {
    return await FirebaseFirestore.instance
        .collection(FireStoreKeys.shows_collections)
        .get();
  }
}

// return await FirebaseFirestore.instance
//     .collection(FireStoreKeys.shows_collections)
//     .where("title", isGreaterThanOrEqualTo: searchParams.title)
//     .where("title", isLessThanOrEqualTo: "${searchParams.title}\uf7ff")
//     .where("release_year", isEqualTo: searchParams.year)
//     .where("category", isEqualTo: searchParams.category)
//     .where("lan",
//         isEqualTo: searchParams.showLan != null
//             ? showLanToString(searchParams.showLan!)
//             : "")
//     .limit(10)
//     .get();
