import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:office_next_door/create_offering/offer_image_page.dart';
import 'package:place_picker/place_picker.dart';

class OfferView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Create new Offering')),
      body: OfferCreationForm(),
    );
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

class OfferCreationFormState extends State<OfferCreationForm> with AutomaticKeepAliveClientMixin {
  LatLng latLng;
  WorkplaceDTO workplaceDTO;
  List<String> features;

  String longitude;
  String latitude;


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
              CustomTextField('Title', 'title', (value) => workplaceDTO.title = value),
              CustomTextField(
                  'Description', 'description', (value) => workplaceDTO.description = value),
              Row(
                children: <Widget>[
                  Expanded(
                      child: CustomTextField(
                          'Address', 'address', (value) => workplaceDTO.address = value)),
                  RaisedButton(onPressed: showPlacePicker, child: Text('Maps')),
                ],
              ),
              CustomTextField('Lng', '47.4', (value) => longitude = value),
              CustomTextField('Lat', '8.5', (value) => latitude = value),
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

              // TODO useless for now CustomTextField('AverageRating', '3.4', (value) => workplaceDTO.averageRating = double.parse(value)),
              // TODO useless for now CustomTextField('Number of ratings', '100', (value) => workplaceDTO.numberOfRatings = int.parse(value)),
              CustomTextField('Price', '30.1', (value) => workplaceDTO.price = double.parse(value)),
              CustomTextField('Available from', '2020-03-01', (value) =>  workplaceDTO.availableFrom = Timestamp.fromDate(DateTime.parse(value))), //2020-03-01
              CustomTextField('Available until', '2020-06-01', (value) =>  workplaceDTO.availableTo = Timestamp.fromDate(DateTime.parse(value))), //2020-06-01
              CustomTextField('Owner', '95816dd3-bffc-4810-b065-cf9ff9714b06', (value) => workplaceDTO.owner = value),

              RaisedButton(
                child: Text('Next'),
                onPressed: () {
                  if (_formKey.currentState.validate()) {
                    _formKey.currentState.save();
                    workplaceDTO.features = _valueMapToFeatureList(values);
                    if (workplaceDTO.geopoint == null) {
                      workplaceDTO.geopoint = GeoPoint(double.parse(latitude), double.parse(longitude));
                    }
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            OfferViewImagePage(workplaceDTO: this.workplaceDTO),
                      ),
                    );
                  }
                },
              ),
            ])));
  }

  @override
  bool get wantKeepAlive => true;
}

class CustomTextField extends StatefulWidget {
  CustomTextField(this.labelText, this.defaultValue, this.onSaved);

  final String labelText;
  final String defaultValue;
  final Function onSaved;

  @override
  State<StatefulWidget> createState() => CustomTextFieldState(labelText, defaultValue, onSaved);
}

class CustomTextFieldState extends State<CustomTextField> with AutomaticKeepAliveClientMixin {
  CustomTextFieldState(this.labelText, this.defaultValue, this.onSaved);

  final String labelText;
  final String defaultValue;
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
        initialValue: defaultValue,
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
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
  ByteData thumbnail;
  String owner;
  Timestamp availableFrom;
  Timestamp availableTo;
  String address;
  double averageRating;
  int numberOfRatings;
  GeoPoint geopoint;
  DocumentReference reference;
  List bookings;
  List images;
  List features;
  double price;
}

