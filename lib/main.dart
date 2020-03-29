import 'package:flutter/material.dart';
import 'package:office_next_door/detail_view/detail_view.dart';
import 'package:office_next_door/pages/booking_check_dates.dart';
import 'package:office_next_door/sign_in/authentication.dart';
import 'map.dart';
import 'create_offering/offer_workplace.dart';

void main() {
  runApp(MaterialApp(
    title: 'Named Routes Demo',
    initialRoute: '/',
    routes: {
      '/detail': (context) => DetailView(),
      '/offer': (context) => OfferView(),
      '/checkdates': (context) => BookingCheckDatesPage(),
        // TODO remve? '/offer/2': (context) => OfferViewImagePage(workplaceDTO ? AppState),
      '/': (context) => MapView(auth: new Auth()),
    },
  ));
}
