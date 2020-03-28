import 'package:flutter/material.dart';
import 'image_carousel.dart';

class DetailView extends StatefulWidget {
  @override
  State<DetailView> createState() => DetailViewState();
}

class DetailViewState extends State<DetailView> {

  DateTime selectedDate = DateTime.now();

  _selectDate() async {
    debugPrint('it works');
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
          title: Text("simply delete App Bar if you want"),
        ),
        body: Column(
          children: <Widget>[
            CarouselWithIndicator(),
            DetailList(),
            // StickyFooterButton()
          ],
        ),
        bottomNavigationBar: Footer(this._selectDate));
  }
}

class Footer extends StatelessWidget {

  Footer(this.buttonAction);

  final Function buttonAction;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.red,
        height: 100.0,
        child: ButtonBar(alignment: MainAxisAlignment.end, children: [
          RaisedButton(
            color: Colors.blue,
            onPressed: buttonAction,
            child: Text('Book NOW!', style: TextStyle(fontSize: 20)),
          )
        ]));
  }
}

class DetailList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
        child: SizedBox(
            height: 200,
            child: ListView(
              padding: const EdgeInsets.all(8),
              children: <Widget>[
                Container(
                  height: 50,
                  color: Colors.amber[600],
                  child: const Center(child: Text('Entry A')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[500],
                  child: const Center(child: Text('Entry B')),
                ),
                Container(
                  height: 50,
                  color: Colors.amber[100],
                  child: const Center(child: Text('Entry C')),
                ),
              ],
            )));
  }
}
