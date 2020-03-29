import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:office_next_door/model/workplace_record.dart';
import 'image_carousel.dart';
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
            Padding(
              padding: const EdgeInsets.all(5.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Icon(Icons.star, size: 18),
                          const Padding(
                              padding: EdgeInsets.symmetric(horizontal: 2.0)),
                          Text(
                            '${record.averageRating.toStringAsFixed(1)} (${record.numberOfRatings})',
                            style: const TextStyle(fontSize: 14.0),
                          )
                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: record.features.map((feature) {
                          return Padding(
                            padding: const EdgeInsets.all(2.0),
                            child: _getIcon(feature),
                          );
                        }).toList(),
                      )
                    ],
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text("CHF ${record.price.toStringAsFixed(2)} per day",
                        style: const TextStyle(fontSize: 14.0),
                      )
                    ]
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                  Text(
                    'Description',
                    style: const TextStyle(fontSize: 14.0, fontWeight: FontWeight.bold),
                  ),
                  const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                  Text(
                    record.description,
                    style: const TextStyle(fontSize: 14.0),
                  ),
                ],
              ),
            )
          ],
        ),
        bottomNavigationBar: Footer(this._selectDate));
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
}
