import 'package:flutter/material.dart';
import 'image_carousel.dart';
import 'detail_list.dart';
import 'footer.dart';

class DetailView extends StatefulWidget {
  @override
  State<DetailView> createState() => DetailViewState();
}

class DetailViewState extends State<DetailView> {

  DateTime selectedDate = DateTime.now();

  //TODO load state from Firebase
  final String locationName = 'Location Name';

  _selectDate() async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: selectedDate,
        firstDate: DateTime(2015, 8),
        lastDate: DateTime(2101));
    if (picked != null && picked != selectedDate)
      setState(() {
        selectedDate = picked;
      });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(locationName),
        ),
        body: Column(
          children: <Widget>[
            CarouselWithIndicator(),
            DetailList(),
          ],
        ),
        bottomNavigationBar: Footer(this._selectDate));
  }
}
