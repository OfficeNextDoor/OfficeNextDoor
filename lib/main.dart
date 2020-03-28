import 'package:flutter/material.dart';
import 'package:office_next_door/detail_view/detail_view.dart';
import 'package:office_next_door/sign_in/authentication.dart';
import 'map.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    initialRoute: '/',
    routes: {
      '/': (context) => MapView(auth: new Auth()),
      '/detail': (context) => DetailView(),
    },
  ));
}
