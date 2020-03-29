import 'package:flutter/material.dart';
import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:office_next_door/detail_view/detail_view.dart';
import 'package:office_next_door/detail_view/footer.dart';
import 'package:office_next_door/model/workplace_record.dart';

class BookingCheckDatesPage extends StatefulWidget {
  final WorkplaceRecord record;
  final List<DateTime> selectedDates;

  BookingCheckDatesPage(
      {Key key, @required this.record, @required this.selectedDates})
      : super(key: key);

  @override
  State<StatefulWidget> createState() {
    return BookingCheckDatesPageState(record, selectedDates);
  }
}

class BookingCheckDatesPageState extends State<BookingCheckDatesPage> {
  Calendarro monthCalendarro;
  List<DateTime> selectedDates;
  WorkplaceRecord record;

  BookingCheckDatesPageState(this.record, this.selectedDates);

  @override
  Widget build(BuildContext context) {
    var startDate = DateUtils.getFirstDayOfCurrentMonth();
    var endDate = DateUtils.getLastDayOfNextMonth();

    monthCalendarro = Calendarro(
        startDate: startDate,
        endDate: endDate,
        displayMode: DisplayMode.MONTHS,
        selectionMode: SelectionMode.MULTI,
        weekdayLabelsRow: CustomWeekdayLabelsRow(),
        onTap: (date) {
          print(record.description);
          print("onTap: $date");
          selectedDates.add(date);
        });

    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Booking"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: monthCalendarro,
        ),
        bottomSheet: Footer(
          buttonLabel: "save",
          leftElement: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Text(
                  "${record.price.toStringAsFixed(2)}",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text("/Day", style: TextStyle(fontSize: 12)),
              ],
            ),
          ),
          buttonAction: () {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => DetailView(
                        record: record, selectedDates: selectedDates)));
          },
        ));
  }
}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("M", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("W", textAlign: TextAlign.center)),
        Expanded(child: Text("T", textAlign: TextAlign.center)),
        Expanded(child: Text("F", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
        Expanded(child: Text("S", textAlign: TextAlign.center)),
      ],
    );
  }
}
