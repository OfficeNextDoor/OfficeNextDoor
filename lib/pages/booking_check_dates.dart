import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:calendarro/calendarro.dart';
import 'package:calendarro/date_utils.dart';
import 'package:office_next_door/detail_view/detail_view.dart';
import 'package:office_next_door/detail_view/footer.dart';
import 'package:office_next_door/model/workplace_record.dart';
import 'package:intl/intl.dart';


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
  DateTime startDate = DateUtils.getFirstDayOfCurrentMonth();
  DateTime endDate = DateUtils.getLastDayOfNextMonth();

  String _currentMonth;

  void _setCurrentMonth(DateTime startOfPage, DateTime endOfPage) {
    var newMonth = formatMonth(startOfPage);
    setState(() {
      _currentMonth = newMonth;
    });
  }


  @override
  void initState() {
    monthCalendarro = Calendarro(
      startDate: startDate,
      endDate: endDate,
      displayMode: DisplayMode.MONTHS,
      selectionMode: SelectionMode.MULTI,
      weekdayLabelsRow: CustomWeekdayLabelsRow(),
      onTap: (date) {
        selectedDates.add(date);
      },
      onPageSelected: _setCurrentMonth,
    );

    _currentMonth = formatMonth(startDate);
  }

  @override
  Widget build(BuildContext context) {


    return new Scaffold(
        appBar: new AppBar(
          title: new Text("Booking"),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            children: <Widget>[
              Text('$_currentMonth', style: TextStyle(color: Colors.black38, fontSize: 18),),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: monthCalendarro,
              ),
            ],
          ),
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

  static String formatMonth(DateTime date){
    var formatter = new DateFormat('MMMM');
    return formatter.format(date);
  }
}

class CustomWeekdayLabelsRow extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Expanded(child: Text("Mo", textAlign: TextAlign.center)),
        Expanded(child: Text("Tu", textAlign: TextAlign.center)),
        Expanded(child: Text("We", textAlign: TextAlign.center)),
        Expanded(child: Text("Th", textAlign: TextAlign.center)),
        Expanded(child: Text("Fr", textAlign: TextAlign.center)),
        Expanded(child: Text("Sa", textAlign: TextAlign.center)),
        Expanded(child: Text("So", textAlign: TextAlign.center)),
      ],
    );
  }
}
