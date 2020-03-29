import 'package:office_next_door/model/user_record.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:office_next_door/model/workplace_record.dart';

abstract class DataAccess {
  Future<UserRecord> getUser(String uid);

  Future<UserRecord> createUser(String uid, String firstName, String lastName,
      String email);

  Future<List<WorkplaceRecord>> getAllWorkplaces();

  Future<WorkplaceRecord> getWorkplace(String uid);

  Future<WorkplaceRecord> createWorkplace(String title,
      String description,
      String address,
      String geopoint,
      DateTime availableFrom,
      DateTime availableTo,
      double price,
      String owner,
      List<String> features,
      List<String> images,);

  Future<WorkplaceRecord> createBooking(WorkplaceRecord record, String bookedBy,
      DateTime date);
}

class FirebaseDataAccess implements DataAccess {
  static final _userCollection = 'user';
  static final _userCollectionId = 'uid';
  static final _userCollectionFirstName = 'firstName';
  static final _userCollectionLastName = 'lastName';
  static final _userCollectionEmail = 'email';

  static final _workplaceCollection = 'workplace';
  static final _workplaceCollectionTitle = 'title';
  static final _workplaceCollectionDescription = 'description';
  static final _workplaceCollectionAddress = 'address';
  static final _workplaceCollectionGeopoint = 'geopoint';
  static final _workplaceCollectionAvailableFrom = 'availableFrom';
  static final _workplaceCollectionAvailableTo = 'availableTo';
  static final _workplaceCollectionAverageRating = 'averageRating';
  static final _workplaceCollectionNumberOfRatings = 'numberOfRatings';
  static final _workplaceCollectionPrice = 'price';
  static final _workplaceCollectionOwner = 'owner';

  static final _workplaceCollectionFeatures = 'features';

  static final _workplaceCollectionThumbnail = 'thumbnail';
  static final _workplaceCollectionImages = 'images';

  static final _workplaceCollectionBookings = 'bookings';
  static final _workplaceCollectionBookingsBy = 'by';
  static final _workplaceCollectionBookingsDate = 'date';

  @override
  Future<UserRecord> createUser(String uid, String firstName, String lastName,
      String email) async {
    var userMap = {
      _userCollectionId: uid,
      _userCollectionFirstName: firstName,
      _userCollectionLastName: lastName,
      _userCollectionEmail: email
    };
    DocumentReference ref =
    await Firestore.instance.collection(_userCollection).add(userMap);
    return UserRecord.fromMap(userMap, reference: ref);
  }

  @override
  Future<UserRecord> getUser(String uid) async {
    var result = await Firestore.instance
        .collection(_userCollection)
        .where(_userCollectionId, isEqualTo: uid)
        .snapshots()
        .first;
    if (result.documents.length == 1) {
      return UserRecord.fromSnapshot(result.documents.first);
    } else {
      throw FormatException('No user with UID $uid found');
    }
  }

  @override
  Future<WorkplaceRecord> createWorkplace(String title,
      String description,
      String address,
      String geopoint,
      DateTime availableFrom,
      DateTime availableTo,
      double price,
      String owner,
      List<String> features,
      List<String> images,) async {
    var workplaceMap = {
      _workplaceCollectionTitle: title,
      _workplaceCollectionDescription: description,
      _workplaceCollectionAddress: address,
      _workplaceCollectionGeopoint: geopoint,
      _workplaceCollectionAvailableFrom: availableFrom,
      _workplaceCollectionAvailableTo: availableTo,
      _workplaceCollectionAverageRating: 0,
      _workplaceCollectionNumberOfRatings: 0,
      _workplaceCollectionPrice: price,
      _workplaceCollectionOwner: owner,
      _workplaceCollectionFeatures: features,
      _workplaceCollectionThumbnail: images,
      _workplaceCollectionImages: images,
      _workplaceCollectionBookings: List<String>()
    };
    DocumentReference ref =
    await Firestore.instance.collection(_workplaceCollection).add(workplaceMap);
    return WorkplaceRecord.fromMap(workplaceMap, reference: ref);
  }

  @override
  Future<List<WorkplaceRecord>> getAllWorkplaces() async {
    var result = await Firestore.instance
        .collection(_workplaceCollection)
        .getDocuments();

    return result.documents
        .map((document) => WorkplaceRecord.fromSnapshot(document))
        .toList();
  }

  @override
  Future<WorkplaceRecord> getWorkplace(String uid) async {
    var result = await Firestore.instance
        .collection(_workplaceCollection)
        .document(uid)
        .get();
    if (result != null) {
      return WorkplaceRecord.fromSnapshot(result);
    } else {
      throw FormatException('No workplace with UID $uid found');
    }
  }

  @override
  Future<WorkplaceRecord> createBooking(WorkplaceRecord record, String bookedBy,
      DateTime date) async {
    record.bookings.add({
      _workplaceCollectionBookingsBy: bookedBy,
      _workplaceCollectionBookingsDate: date
    });

    record.reference.updateData({
      _workplaceCollectionBookings : record.bookings
    });

    return record;
  }
}
