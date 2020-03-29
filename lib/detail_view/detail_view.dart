import 'package:flutter/material.dart';
import 'package:office_next_door/map.dart';
import 'image_carousel.dart';
import 'detail_list.dart';
import 'footer.dart';

class DetailView extends StatefulWidget {
  final WorkplaceRecord record;

  DetailView({Key key, @required this.record}) : super(key: key);

  @override
  State<DetailView> createState() => DetailViewState(record: this.record);
}

class DetailViewState extends State<DetailView> {
  final WorkplaceRecord record;
  DetailViewState({Key key, @required this.record});

  DateTime selectedDate = DateTime.now();
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
          title: Text(record.title),
        ),
        body: Column(
          children: <Widget>[
            CarouselWithIndicator(),
            DetailList(record: record),
          ],
        ),
        bottomNavigationBar: Footer(this._selectDate));
  }
}
