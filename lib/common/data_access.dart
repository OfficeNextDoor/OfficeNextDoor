import 'package:office_next_door/model/user.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

abstract class DataAccess {
  Future<User> getUser(String uid);

  Future<User> createUser(
      String uid, String firstName, String lastName, String email);
}

class FirebaseDataAccess implements DataAccess {
  static final _userCollection = 'user';
  static final _userCollectionId = 'uid';
  static final _userCollectionFirstName = 'firstName';
  static final _userCollectionLastName = 'lastName';
  static final _userCollectionEmail = 'email';

  @override
  Future<User> createUser(
      String uid, String firstName, String lastName, String email) async {
    var userMap = {
      _userCollectionId: uid,
      _userCollectionFirstName: firstName,
      _userCollectionLastName: lastName,
      _userCollectionEmail: email
    };
    DocumentReference ref =
        await Firestore.instance.collection(_userCollection).add(userMap);
    return User.fromMap(userMap, reference: ref);
  }

  @override
  Future<User> getUser(String uid) async {
    var result = await Firestore.instance
        .collection(_userCollection)
        .where(_userCollectionId, isEqualTo: uid)
        .snapshots()
        .first;
    if (result.documents.length == 1) {
      return User.fromSnapshot(result.documents.first);
    } else {
      throw FormatException('No user with UID $uid found');
    }
  }
}
