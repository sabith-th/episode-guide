import 'package:episode_guide/ui/home/carousel.dart';
import 'package:episode_guide/ui/home/episode_list.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Episode Guide',
      theme: ThemeData(
        primaryColor: Colors.black,
        accentColor: Colors.white,
        fontFamily: 'AlegreyaSans'
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Container(
        child: Column(
          children: <Widget>[
            Carousel(),
            EpisodeList(),
          ],
        ),
      ),
    );
  }
}
