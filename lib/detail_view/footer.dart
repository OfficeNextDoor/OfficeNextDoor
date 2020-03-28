import 'package:flutter/material.dart';

class Footer extends StatelessWidget {
  Footer(this.buttonAction);

  final Function buttonAction;

  @override
  Widget build(BuildContext context) {
    return Container(
        color: Colors.black12,
        child: ButtonBar(alignment: MainAxisAlignment.end, children: [
          RaisedButton(
            color: Colors.blue,
            onPressed: buttonAction,
            child: Text('Book NOW!', style: TextStyle(fontSize: 32)),
          )
        ]));
  }
}
