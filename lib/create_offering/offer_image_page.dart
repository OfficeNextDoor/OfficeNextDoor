import 'dart:async';

import 'package:flutter/material.dart';
import 'package:multi_image_picker/multi_image_picker.dart';
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
  String _error;
  final WorkplaceDTO workplaceDTO;



  OfferViewImagePageState({Key key, @required this.workplaceDTO});


  /* TODO enable firebase upload
  Future saveImage(Asset asset) async {
    ByteData byteData = await asset.requestOriginal();
    List<int> imageData = byteData.buffer.asUint8List();
    StorageReference ref = FirebaseStorage.instance.ref().child("some_image_bame.jpg");
    StorageUploadTask uploadTask = ref.putData(imageData);

    return await (await uploadTask.onComplete).ref.getDownloadURL();
  } */

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
    String error;

    try {
      resultList = await MultiImagePicker.pickImages(
        maxImages: 300,
      );
    } on Exception catch (e) {
      error = e.toString();
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      images = resultList;
      if (error == null) _error = 'No Error Dectected';
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
            // TODO do we even need this? Center(child: Text('Error: $_error')),
            RaisedButton(
              child: Text('Upload images'),
              onPressed: loadAssets,
            ),
            Expanded(
              child: buildGridView(),
            ),
            RaisedButton(
              child: Text('Next'),
              onPressed: null, //TODO navigate to next step
            )
          ],
        ),
      ),
    );
  }
}
