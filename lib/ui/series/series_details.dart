import 'package:flutter/material.dart';

class SeriesDetailsArgs {
  final int id;
  final String name;

  SeriesDetailsArgs(this.id, this.name);
}

class SeriesDetails extends StatelessWidget {
  static const routeName = '/seriesDetails';

  @override
  Widget build(BuildContext context) {
    final SeriesDetailsArgs args = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        title: Text(args.name),
      ),
      body: Center(
        child: Text('${args.id} ${args.name}'),
      ),
    );
  }
}
