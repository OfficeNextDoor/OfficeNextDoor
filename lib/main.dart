import 'package:flutter/material.dart';
import 'package:office_next_door/firebase_example.dart';
import 'map.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    // Start the app with the "/" named route. In this case, the app starts
    // on the FirstScreen widget.
    initialRoute: '/',
    routes: {
      // When navigating to the "/" route, build the FirstScreen widget.
      '/': (context) => MapView(),
      // When navigating to the "/second" route, build the SecondScreen widget.
      '/second': (context) => FirebaseExample(),
    },
  ));
}
