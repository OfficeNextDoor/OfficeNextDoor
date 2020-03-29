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

class CheckboxData {
  CheckboxData(this.title, this.value);

  String title;
  bool value;
}

class OfferCreationFormState extends State<OfferCreationForm> {
  LatLng latLng;
  WorkplaceDTO workplaceDTO;
  List<String> features;

  final _formKey = GlobalKey<FormState>();

  Map<String, CheckboxData> values = {
    'wifi': CheckboxData("WiFi", false),
    'coffee': CheckboxData("Coffee", false),
    'toilet': CheckboxData("Toilet", false),
  };

  OfferCreationFormState() {
    this.workplaceDTO = WorkplaceDTO();
  }

  void showPlacePicker() async {
    LocationResult result = await Navigator.of(context).push(MaterialPageRoute(
        builder: (context) => PlacePicker(
              "-------",
              //TODO get this from google-services.json
              displayLocation: LatLng(47.36667, 8.54),
            )));

    // Handle the result in your way
    workplaceDTO.address = result.formattedAddress;
    workplaceDTO.geopoint =
        GeoPoint(result.latLng.latitude, result.latLng.longitude);
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Padding(
            padding: EdgeInsets.all(20),
            child: ListView(children: <Widget>[
              CustomTextField(
                  'Title', (value) => workplaceDTO.title = value),
              CustomTextField('Description',
                  (value) => workplaceDTO.description = value),
              Row(
                children: <Widget>[
                  Expanded(
                      child: CustomTextField('Address',
                          (value) => workplaceDTO.address = value)),
                  RaisedButton(onPressed: showPlacePicker, child: Text('Maps')),
                ],
              ),
              Column(
                children: values.keys.map((String key) {
                  return new CheckboxListTile(
                    title: Text(key),
                    value: values[key].value,
                    onChanged: (bool value) {
                      setState(() {
                        values[key].value = value;
                      });
                    },
                  );
                }).toList(),
              ),
              RaisedButton(
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('Processing Data')));
                  }
                  _formKey.currentState.save();
                  workplaceDTO.features = _valueMapToFeatureList(values);

                },
                child: Text('Next'),
              ),
            ])));
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

List<String> _valueMapToFeatureList(Map<String, CheckboxData> values) {
  return values.entries.where((e) => e.value.value).map((e) => e.key).toList();
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
