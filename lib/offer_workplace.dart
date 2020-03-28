import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:place_picker/place_picker.dart';

class OfferView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text('Create new Offering')),
        body: OfferCreationForm());
  }
}

class OfferCreationForm extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => OfferCreationFormState();
}

class OfferCreationFormState extends State<OfferCreationForm> {

  LatLng latLng;
  WorkplaceDTO workplaceRecord;

  OfferCreationFormState(){
    this.workplaceRecord = WorkplaceDTO();
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) =>
            PlacePicker(
              "-------",
              //TODO get this from google-services.json
              displayLocation: LatLng(47.36667, 8.54),
            )));

    // Handle the result in your way
    workplaceRecord.address = result.formattedAddress;
    workplaceRecord.geopoint = GeoPoint(result.latLng.latitude, result.latLng.longitude);
  }

  void toggle(List<String> features, String value, bool checked) {
    if (checked) {
      features.add(value);
    } else
      features.remove(value);
    //
//    if(features.contains(value)) {
//      features.remove(value);
//    } else {
//      features.add(value);
//    }
  }

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(children: <Widget>[
              CustomTextField('Title', (value) => workplaceRecord.title = value),
              CustomTextField('Description', (value) => workplaceRecord.description = value),
              Row(
                children: <Widget>[
                  Expanded(child: CustomTextField(
                      'Address', (value) => workplaceRecord.address = value)),
                  RaisedButton(onPressed: showPlacePicker, child: Text('Maps')),
                ],
              ),

              CustomCheckboxListTile("wifi", (checked) => toggle(workplaceRecord.features, "wifi", checked)),
              CustomCheckboxListTile("Coffee", (checked) => toggle(workplaceRecord.features, "coffee", checked)),
              CustomCheckboxListTile("Power Outlet", (checked) => toggle(workplaceRecord.features, "power_outlet", checked)),
              CustomCheckboxListTile("Display", (checked) => toggle(workplaceRecord.features, "display", checked)),
              CustomCheckboxListTile("Windows", (checked) => toggle(workplaceRecord.features, "windows", checked)),
              CustomCheckboxListTile("Water", (checked) => toggle(workplaceRecord.features, "water", checked)),
              CustomCheckboxListTile("Toilet", (checked) => toggle(workplaceRecord.features, "toilet", checked)),

              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }
                  _formKey.currentState.save();
                },
                child: Text('Next'),
              ),
            ])));
  }
}

class CustomCheckboxListTile extends StatelessWidget {
  CustomCheckboxListTile(this.labelText, this.onChanged);

  final String labelText;
  final Function onChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(8),
      child: CheckboxListTile(
        value: false,
        title: Text(labelText),
        onChanged: onChanged,
      ),
    );
  }
}

class CustomTextField extends StatelessWidget {
  CustomTextField(this.labelText, this.onSaved);

  final String labelText;
  final Function onSaved;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: TextFormField(
        decoration: InputDecoration(
          labelText: this.labelText,
          labelStyle: TextStyle(color: Colors.grey),
          focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: Colors.blueAccent)),
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: onSaved,
      ),
    );
  }
}

class WorkplaceDTO {

  WorkplaceDTO() {
    this.bookings = [];
    this.images = [];
    this.features = [];
  }

  String title;
  String description;
  String thumbnail;
  String owner;
  Timestamp availableFrom;
  Timestamp availableTo;
  String address;
  double averageRating;
  int numberOfRatings;
  GeoPoint geopoint;
  DocumentReference reference;
  List<BookingDTO> bookings;
  List<Image> images;
  List<String> features;

  WorkplaceDTO.fromMap(Map<String, dynamic> map, {this.reference})
      : assert(map['title'] != null),
        assert(map['description'] != null),
        assert(map['thumbnail'] != null),
        assert(map['owner'] != null),
        assert(map['availableFrom'] != null),
        assert(map['availableTo'] != null),
        assert(map['address'] != null),
        assert(map['averageRating'] != null),
        assert(map['numberOfRatings'] != null),
        assert(map['geopoint'] != null),
        title = map['title'],
        description = map['description'],
        thumbnail = map['thumbnail'],
        owner = map['owner'],
        availableFrom = map['availableFrom'],
        availableTo = map['availableTo'],
        address = map['address'],
        averageRating = map['averageRating'],
        numberOfRatings = map['numberOfRatings'],
        geopoint = map['geopoint'];

  WorkplaceDTO.fromSnapshot(DocumentSnapshot snapshot)
      : this.fromMap(snapshot.data, reference: snapshot.reference);

  @override
  String toString() => "Record<$title:$averageRating>";
}

class BookingDTO {
  BookingDTO(this.by, this.date);

  String by;
  DateTime date;
}
