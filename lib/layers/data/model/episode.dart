import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

List<Episode> getShowVideoListFromListMap(List<QueryDocumentSnapshot> list) =>
    List<Episode>.from(list.map((x) => Episode.fromMap(x)));

class Episode extends Equatable {
  final String id;
  final String number;
  final String videoUrl;

  Episode({required this.id, required this.number, required this.videoUrl});

  Map<String, dynamic> toMap() {
    return {
      'number': this.number,
      'videoUrl': this.videoUrl,
    };
  }

  factory Episode.fromMap(QueryDocumentSnapshot map) {
    return Episode(
      id: map.id,
      number: map['number'],
      videoUrl: map['videoUrl'],
    );
  }

  @override
  List<Object?> get props => [this.number, this.videoUrl];
}
