import 'package:flutter/material.dart';

final List<ListItem> listItems = [
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value'),
  ListItem('Title', 'Value')
];

class ListItem {
  ListItem(this.title, this.subtitle);

  final String title;
  final String subtitle;

  Widget build(BuildContext context) =>
      ListTile(title: Text(title), subtitle: Text(subtitle));
}

class DetailList extends StatelessWidget {

//  DetailList(this.items);
//  final List<ListItem> items;

  final List<ListItem> items = listItems;

  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
            height: 200,
            child: ListView.separated(
              itemCount: items.length,
              itemBuilder: (context, index) {
                  final item = items[index];
                  return ListTile(title: item.build(context));
                },
                separatorBuilder: (context, index) => Divider(color: Colors.grey),
            )
        )
    );
  }
}
