import 'package:flutter/material.dart';

class Carousel extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomLeft,
      children: <Widget>[
        Image.asset("assets/images/tbl.jpg"),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            'The Blacklist',
            style: TextStyle(
              fontSize: 16.0,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}
