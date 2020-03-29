import 'package:cloud_firestore/cloud_firestore.dart';

class UserRecord {
  final String firstName;
  final String lastName;
  final String email;
  final String uid;
  final DocumentReference reference;

  UserRecord.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['firstName'] != null),
        assert(map['lastName'] != null),
        assert(map['email'] != null),
        assert(map['uid'] != null),
        firstName = map['firstName'],
        lastName = map['lastName'],
        email = map['email'],
        uid = map['uid'];

  UserRecord.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "User<$firstName $lastName, $email, $uid>";
}
