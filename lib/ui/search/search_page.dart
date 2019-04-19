import 'package:flutter/material.dart';

class SearchSeriesScreen extends StatefulWidget {
  static const routeName = '/searchSeries';

  @override
  _SearchSeriesScreenState createState() => _SearchSeriesScreenState();
}

class _SearchSeriesScreenState extends State<SearchSeriesScreen> {
  final TextEditingController _textController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Search Series'),
      ),
      body: Form(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: TextFormField(
                  controller: _textController,
                  decoration: InputDecoration(
                    labelText: 'Series',
                    hintText: 'Type in the title of the series',
                  ),
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search),
              onPressed: () {
                Navigator.pop(context, _textController.text);
              },
            ),
          ],
        ),
      ),
    );
  }
}
