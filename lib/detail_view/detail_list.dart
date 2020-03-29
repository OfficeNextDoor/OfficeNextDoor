import 'package:flutter/material.dart';
import 'package:office_next_door/map.dart';
import 'package:office_next_door/model/workplace_record.dart';

class ListItem {
  ListItem(this.title, this.subtitle);

  final String title;
  final String subtitle;

  Widget build(BuildContext context) =>
      ListTile(title: Text(title), subtitle: Text(subtitle));
}

class DetailList extends StatelessWidget {
  final WorkplaceRecord record;

  DetailList({Key key, @required this.record} );

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
            child: ListView.separated(
              itemCount: this.record.features.length,
              itemBuilder: (context, index) {
                  final item = this.record.features[index];
                  return ListTile(title: Text(item));
                },
                separatorBuilder: (context, index) => Divider(color: Colors.grey),
            )
        )
    );
  }
}
