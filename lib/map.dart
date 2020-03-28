import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:office_next_door/sign_in/authentication.dart';
import 'package:office_next_door/sign_in/login_signup_view.dart';

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
  GlobalKey<ScaffoldState > _scaffoldKey = GlobalKey<ScaffoldState>();
  AuthStatus _authStatus = AuthStatus.NOT_DETERMINED;
  String _userId = "";

  static final CameraPosition _kZurich = CameraPosition(
    target: LatLng(47.36667, 8.54),
    zoom: 14.4746,
  );

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
  }

  Widget buildWaitingScreen() {
    return Scaffold(
      body: Container(
        alignment: Alignment.center,
        child: CircularProgressIndicator(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      key: _scaffoldKey,
      drawer : buildDrawer(context),
      body: Stack(
        children: <Widget> [
          Center(
            child : GoogleMap(
              mapType: MapType.normal,
              initialCameraPosition: _kZurich,
              onMapCreated: (GoogleMapController controller) {
                _controller.complete(controller);
              }
            )
          ),
          Positioned(
            left: 10,
            top: 30,
            child: IconButton(
              icon: Icon(Icons.menu, color: Colors.white),
              onPressed: () => _scaffoldKey.currentState.openDrawer(),
            )
          ),
          Positioned(
            right: 10,
            top: 30,
            child: IconButton(
              icon: Icon(Icons.filter_list, color: Colors.white)
            ),
          ),
          Positioned(
            top: 30,
            left: 60,
            right: 60,
            child: buildSearchField(context)
          ),
          buildDraggableBottomSheet(context)
        ]
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () {
          // Navigate to the second screen using a named route.
          Navigator.pushNamed(context, '/second');
        },
        label: Text('DetailPage!'),
        icon: Icon(Icons.directions_boat),
      ));
  }

  Drawer buildDrawer(BuildContext context) {
    return new Drawer(
        child: ListView(
          // Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              child: Text('Insert Logo Here'),
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
            ),
            ListTile(
              title: Text('Login'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => LoginSignupView(
                    auth: widget.auth,
                    loginCallback: loginCallback,
                  )
                  )
                );
              },
            ),
          ]));
  }

  TextField buildSearchField(BuildContext context) {
    return TextField(
      autofocus: false,
      decoration : InputDecoration(
        suffixIcon: Icon(Icons.search),
        filled: true,
        fillColor: Colors.white,
        hintText : "Search...",
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white),
          borderRadius: BorderRadius.circular(25),
        ),
      )
    );
  }

  DraggableScrollableSheet buildDraggableBottomSheet(BuildContext context) {
    return DraggableScrollableSheet(
        initialChildSize: 0.2,
        minChildSize: 0.2,
        maxChildSize: 0.8,
        builder: (BuildContext context, ScrollController scrollController) {
          return Container(
            decoration: new BoxDecoration(
                color: Colors.white,
                borderRadius: new BorderRadius.only(
                  topLeft: const Radius.circular(20.0),
                  topRight: const Radius.circular(20.0),
                )),
            child: ListView.builder(
              controller: scrollController,
              itemCount: 25,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(title: Text('Item $index'));
              },
            ),
          );
        });
  }
}

