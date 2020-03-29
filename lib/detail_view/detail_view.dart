import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:office_next_door/map.dart';
import 'package:office_next_door/model/workplace_record.dart';
import 'package:office_next_door/pages/booking_check_dates.dart';
import 'image_carousel.dart';
import 'footer.dart';

class DetailView extends StatefulWidget {
  final WorkplaceRecord record;
  final List<DateTime> selectedDates;

  DetailView({Key key, @required this.record, @required this.selectedDates})
      : super(key: key);

  @override
  State<DetailView> createState() =>
      DetailViewState(this.record, this.selectedDates);
}

class DetailViewState extends State<DetailView> {
  final WorkplaceRecord record;
  final List<DateTime> selectedDates;

  DetailViewState(this.record, this.selectedDates);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(record.title),
      ),
      body: Column(
        children: <Widget>[
          CarouselWithIndicator(
              base64Images:
                  record.images.map((i) => i['base64'].toString()).toList()),
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
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text(
                  'Description',
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Text(
                  record.description,
                  style: const TextStyle(fontSize: 14.0),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 4.0)),
                Text(
                  'Address',
                  style: const TextStyle(
                      fontSize: 14.0, fontWeight: FontWeight.bold),
                ),
                const Padding(padding: EdgeInsets.symmetric(vertical: 2.0)),
                Text(
                  record.address,
                  style: const TextStyle(fontSize: 14.0),
                ),
              ],
            ),
          )
        ],
      ),
      bottomSheet: Footer(
        buttonLabel:
            selectedDates.length > 0 ? "complete booking" : "check dates",
        leftElement: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: <Widget>[
              Row(
                children: <Widget>[
                  Text(
                    "${record.price.toStringAsFixed(2)}",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text("/Day", style: TextStyle(fontSize: 12)),
                ],
              ),
              Text(
                  "${(record.price * selectedDates.length.toDouble()).toStringAsFixed(2)} CHF total",
                  style: TextStyle(fontSize: 10)),
            ],
          ),
        ),
        buttonAction: () {
          Navigator.push(
              context,
              MaterialPageRoute(
                  builder: selectedDates.length > 0
                      ? (context) => BookingCheckDatesPage(
                          record: record, selectedDates: selectedDates)
                      : (context) => MapView()));
        },
      ),
    );
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
