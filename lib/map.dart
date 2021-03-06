import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:office_next_door/common/data_access.dart';
import 'package:office_next_door/sign_in/authentication.dart';
import 'package:office_next_door/sign_in/login_signup_view.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'dart:convert';
import 'detail_view/detail_view.dart';
import 'create_offering/offer_workplace.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:location/location.dart';
import 'model/workplace_record.dart';

enum AuthStatus {
  NOT_DETERMINED,
  NOT_LOGGED_IN,
  LOGGED_IN,
}

class MapView extends StatefulWidget {
  MapView({this.auth});

  final BaseAuth auth;

  @override
  State<MapView> createState() => MapViewState();
}

class MapViewState extends State<MapView> {
  Completer<GoogleMapController> _controller = Completer();
  GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";
  FirebaseDataAccess _dataAccess = new FirebaseDataAccess();
  Map<MarkerId, Marker> _markers = <MarkerId, Marker>{};
  MarkerId _selectedMarker;
  bool _showUserLocation = false;

  static final CameraPosition _kZurich = CameraPosition(
    target: LatLng(47.36667, 8.54),
    zoom: 14.4746,
  );

  void _createMarkers() async {
    var workplaces = await _dataAccess.getAllWorkplaces();

    for (var workplace in workplaces) {
      final MarkerId markerId = MarkerId(workplace.reference.documentID);
      final Marker marker = Marker(
          markerId: markerId,
          position:
              LatLng(workplace.geopoint.latitude, workplace.geopoint.longitude),
          infoWindow: InfoWindow(
              title: workplace.title,
              onTap: () => _onMarkerWindowTapped(workplace)),
          onTap: () => _onMarkerTapped(markerId));
      setState(() {
        _markers[markerId] = marker;
      });
    }
  }

  void _onMarkerWindowTapped(WorkplaceRecord record) {
    Navigator.push(context,
        MaterialPageRoute(builder: (context) => DetailView(record: record)));
  }

  void _onMarkerTapped(MarkerId markerId) {
    final Marker tappedMarker = _markers[markerId];
    if (tappedMarker != null) {
      setState(() {
        if (_markers.containsKey(_selectedMarker)) {
          final Marker resetOld = _markers[_selectedMarker]
              .copyWith(iconParam: BitmapDescriptor.defaultMarker);
          _markers[_selectedMarker] = resetOld;
        }
        _selectedMarker = markerId;
        final Marker newMarker = tappedMarker.copyWith(
          iconParam: BitmapDescriptor.defaultMarkerWithHue(
            BitmapDescriptor.hueGreen,
          ),
        );
        _markers[markerId] = newMarker;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        if (user != null) {
          _userId = user?.uid;
        }
        _authStatus =
            user?.uid == null ? AuthStatus.NOT_LOGGED_IN : AuthStatus.LOGGED_IN;
      });
    });
    _createMarkers();
  }

  void loginCallback() {
    widget.auth.getCurrentUser().then((user) {
      setState(() {
        _userId = user.uid.toString();
      });
    });
    setState(() {
      _authStatus = AuthStatus.LOGGED_IN;
    });
    Navigator.pop(context);
  }

  void logoutCallback() {
    setState(() {
      _authStatus = AuthStatus.NOT_LOGGED_IN;
      _userId = "";
    });
    Navigator.pop(context);
    _scaffoldKey.currentState
        .showSnackBar(SnackBar(content: Text('Successfully logged out.')));
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        resizeToAvoidBottomInset: false,
        key: _scaffoldKey,
        drawer: buildDrawer(context),
        body: Stack(children: <Widget>[
          Center(
              child: GoogleMap(
            mapType: MapType.normal,
            initialCameraPosition: _kZurich,
            onMapCreated: (GoogleMapController controller) {
              _controller.complete(controller);
            },
            markers: Set<Marker>.of(_markers.values),
            myLocationEnabled: _showUserLocation,
            myLocationButtonEnabled: false,
            compassEnabled: false,
          )),
          Positioned(
              left: 10,
              top: 30,
              child: IconButton(
                icon: Icon(Icons.menu, color: Colors.white),
                onPressed: () => _scaffoldKey.currentState.openDrawer(),
              )),
          Positioned(
            right: 10,
            top: 30,
            child:
                IconButton(icon: Icon(Icons.filter_list, color: Colors.white)),
          ),
          Positioned(
              top: 30, left: 60, right: 60, child: buildSearchField(context)),
          _buildDraggableBottomSheet(context)
        ]),
        floatingActionButton: buildLocateButton(context));
  }

  FloatingActionButton buildLocateButton(BuildContext context) {
    return FloatingActionButton(
        onPressed: () {
          setState(() {
            _showUserLocation = true;
          });
          _goToUserLocation();
        },
        child: Icon(Icons.location_on));
  }

  void _goToUserLocation() async {
    var location = new Location();
    location.changeSettings(
      accuracy: LocationAccuracy.HIGH,
      distanceFilter: 0,
      interval: 100,
    );
    var controller = await _controller.future;
    var currentLocation = await location.getLocation();
    controller.moveCamera(CameraUpdate.newCameraPosition(CameraPosition(
        target: LatLng(currentLocation.latitude, currentLocation.longitude),
        zoom: 16)));
  }

  Drawer buildDrawer(BuildContext context) {
    return new Drawer(
      child: ListView(
          // Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
                child: Image(image: AssetImage('assets/officenextdoor.png'))),
            buildLoginLogoutTile(context),
            buildOfferWorkplaceTile(context)
          ]),
    );
  }

  ListTile buildLoginLogoutTile(BuildContext context) {
    if (_authStatus == AuthStatus.LOGGED_IN) {
      return ListTile(title: Text('Logout'), onTap: logoutCallback);
    } else {
      return ListTile(
          title: Text('Login'),
          onTap: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginSignupView(
                          auth: widget.auth,
                          loginCallback: loginCallback,
                        )));
          });
    }
  }

  ListTile buildOfferWorkplaceTile(BuildContext context) {
    var gotToView = (userId) => Navigator.push(
        context, MaterialPageRoute(builder: (context) => OfferView(userId: userId)));

    return ListTile(
        title: Text('Offer a workplace'),
        onTap: _authStatus == AuthStatus.LOGGED_IN
            ? () => gotToView(_userId)
            : () => Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => LoginSignupView(
                        auth: widget.auth,
                        loginCallback: () async {
                          loginCallback();
                          var user = await widget.auth.getCurrentUser();
                          gotToView(user.uid);
                        }))));
  }

  TextField buildSearchField(BuildContext context) {
    return TextField(
        autofocus: false,
        decoration: InputDecoration(
          suffixIcon: Icon(Icons.search),
          filled: true,
          fillColor: Colors.white,
          hintText: "Search...",
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: Colors.white),
            borderRadius: BorderRadius.circular(25),
          ),
        ));
  }

  Widget _buildList(BuildContext context, ScrollController scrollController,
      List<DocumentSnapshot> snapshot) {
    return Container(
      color: Colors.white,
      child: ListView.builder(
        padding: EdgeInsets.zero,
        controller: scrollController,
        itemCount: snapshot.length,
        itemBuilder: (BuildContext context, int index) {
          return CustomListItem(
            workplaceRecord: WorkplaceRecord.fromSnapshot(snapshot[index]),
          );
        },
      ),
    );
  }

  DraggableScrollableSheet _buildDraggableBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.2,
        maxChildSize: 0.6,
        builder: _buildBody);
  }

  Widget _buildBody(BuildContext context, ScrollController scrollController) {
    return StreamBuilder<QuerySnapshot>(
      stream: Firestore.instance.collection('workplace').snapshots(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) return LinearProgressIndicator();

        return _buildList(context, scrollController, snapshot.data.documents);
      },
    );
  }
}

class CustomListItem extends StatelessWidget {
  const CustomListItem({
    this.workplaceRecord,
  });

  final WorkplaceRecord workplaceRecord;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DetailView(
              record: workplaceRecord,
              selectedDates: List(),
            ),
          ),
        );
      },
      child: Card(
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Expanded(
              flex: 1,
              child: ClipRRect(
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(5),
                    bottomLeft: Radius.circular(5),
                  ),
                  child: imageFromBase64(workplaceRecord.thumbnail)),
            ),
            Expanded(
              flex: 3,
              child: WorkplaceDescription(
                title: workplaceRecord.title,
                description: workplaceRecord.description,
                averageRating: workplaceRecord.averageRating,
                numberOfRatings: workplaceRecord.numberOfRatings,
                features: workplaceRecord.features,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

imageFromBase64(String thumbnail) {
  return Image.memory(
    base64Decode(thumbnail),
    fit: BoxFit.cover,
    height: 100,
    cacheHeight: 100,
    cacheWidth: 100,
  );
}

class WorkplaceDescription extends StatelessWidget {
  const WorkplaceDescription({
    Key key,
    this.title,
    this.description,
    this.averageRating,
    this.numberOfRatings,
    this.features,
  }) : super(key: key);

  final String title;
  final String description;
  final double averageRating;
  final int numberOfRatings;
  final List features;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 14.0,
            ),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
          Text(
            description,
            style: const TextStyle(fontSize: 12.0),
          ),
          const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  Icon(Icons.star, size: 18),
                  const Padding(padding: EdgeInsets.symmetric(horizontal: 4.0)),
                  Text(
                    '$averageRating ($numberOfRatings)',
                    style: const TextStyle(fontSize: 12.0),
                  )
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: features.map((feature) {
                  return Padding(
                    padding: const EdgeInsets.all(2.0),
                    child: _getIcon(feature),
                  );
                }).toList(),
              )
            ],
          )
        ],
      ),
    );
  }
}

Widget _getIcon(feature) {
  IconData icon;
  switch (feature) {
    case "toilet":
      {
        icon = FontAwesomeIcons.toilet;
      }
      break;
    case "screen":
      {
        icon = FontAwesomeIcons.desktop;
      }
      break;
    case "fresh_air":
      {
        icon = FontAwesomeIcons.wind;
      }
      break;
    case "coffee":
      {
        icon = FontAwesomeIcons.coffee;
      }
      break;
    case "water":
      {
        icon = FontAwesomeIcons.wineBottle;
      }
      break;
    case "relax":
      {
        icon = FontAwesomeIcons.couch;
      }
      break;
    case "chair":
      {
        icon = FontAwesomeIcons.chair;
      }
      break;
    case "nature":
      {
        icon = FontAwesomeIcons.tree;
      }
      break;
    case "wifi":
      {
        icon = FontAwesomeIcons.wifi;
      }
      break;
    case "power_outlet":
      {
        icon = FontAwesomeIcons.plug;
      }
      break;
    default:
      {
        icon = FontAwesomeIcons.questionCircle;
      }
      break;
  }

  return FaIcon(
    icon,
    size: 18,
  );
}
