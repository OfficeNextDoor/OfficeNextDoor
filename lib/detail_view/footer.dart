import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  Footer(
      {Key key,
      @required this.buttonAction,
      @required this.buttonLabel,
      @required this.leftElement})
      : super(key: key);

  final Function buttonAction;
  final String buttonLabel;
  final Widget leftElement;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 45,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          leftElement,
          RaisedButton(
            color: Colors.blue,
            onPressed: buttonAction,
            child: Text(
              buttonLabel,
              style: TextStyle(color: Colors.white),
            ),
          )
        ],
      ),
    );
  }
}
