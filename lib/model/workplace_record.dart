import 'package:cloud_firestore/cloud_firestore.dart';

class WorkplaceRecord {
  final String title;
  final String description;
  final String thumbnail;
  final String owner;
  final Timestamp availableFrom;
  final Timestamp availableTo;
  final String address;
  final double averageRating;
  final int numberOfRatings;
  final GeoPoint geopoint;
  final List images;
  final List features;
  final List bookings;
  final DocumentReference reference;

  WorkplaceRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        assert(map['thumbnail'] != null),
        assert(map['owner'] != null),
        assert(map['availableFrom'] != null),
        assert(map['availableTo'] != null),
        assert(map['address'] != null),
        assert(map['averageRating'] != null),
        assert(map['numberOfRatings'] != null),
        assert(map['geopoint'] != null),
        assert(map['images'] != null),
        assert(map['features'] != null),
        assert(map['bookings'] != null),
        title = map['title'],
        description = map['description'],
        thumbnail = map['thumbnail'],
        owner = map['owner'],
        availableFrom = map['availableFrom'],
        availableTo = map['availableTo'],
        address = map['address'],
        averageRating = map['averageRating'],
        numberOfRatings = map['numberOfRatings'],
        geopoint = map['geopoint'],
        images = map['images'],
        features = map['features'],
        bookings = map['bookings'];

  WorkplaceRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$averageRating>";
}
