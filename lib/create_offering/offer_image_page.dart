import 'dart:async';
import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
import 'package:office_next_door/common/data_access.dart';
import 'package:office_next_door/create_offering/offer_workplace.dart';

class OfferViewImagePage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() =>
      OfferViewImagePageState(workplaceDTO: this.workplaceDTO);

  OfferViewImagePage({Key key, @required this.workplaceDTO}) : super(key: key);
  final WorkplaceDTO workplaceDTO;
}

class OfferViewImagePageState extends State<OfferViewImagePage> {
  List<Asset> images = List<Asset>();
  final WorkplaceDTO workplaceDTO;
  FirebaseDataAccess _dataAccess = FirebaseDataAccess();

  OfferViewImagePageState({Key key, @required this.workplaceDTO});

  @override
  void initState() {
    super.initState();
  }

  Widget buildGridView() {
    if (images != null)
      return GridView.count(
        crossAxisCount: 3,
        children: List.generate(images.length, (index) {
          Asset asset = images[index];
          return AssetThumb(
            asset: asset,
            width: 300,
            height: 300,
          );
        }),
      );
    else
      return Container(color: Colors.white);
  }

  Future<void> loadAssets() async {
    setState(() {
      images = List<Asset>();
    });

    List<Asset> resultList;
    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      debugPrint(e.toString());
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      home: new Scaffold(
        appBar: new AppBar(
          title: const Text('Choose an image'),
        ),
        body: Column(
          children: <Widget>[
            RaisedButton(
              child: Text('Upload images'),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            ),
            RaisedButton(
              child: Text('Upload'),
              onPressed: setImagesAndUpload,
            )
          ],
        ),
      ),
    );
  }

  setImagesAndUpload() async {
    List<String> base64Images = [];

    await Future.forEach(images, (image) async {
      ByteData byteData = await image.getByteData();
      base64Images.add(base64Encode(byteData.buffer.asUint8List()));
    });
    String thumbnail;
    if (base64Images.isNotEmpty){
      thumbnail = base64Images.first;
    }

    _dataAccess.createWorkplace(
      workplaceDTO.title,
      workplaceDTO.description,
      workplaceDTO.address,
      workplaceDTO.geopoint,
      workplaceDTO.availableFrom,
      workplaceDTO.availableTo,
      workplaceDTO.price,
      workplaceDTO.owner,
      workplaceDTO.features,
      base64Images,
      thumbnail,
    );
  }
}
