import 'package:episode_guide/ui/home/carousel.dart';
import 'package:episode_guide/ui/home/episode_list.dart';
import 'package:episode_guide/ui/series/series_details.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: 'https://tvdb-graphql-api.sabith-th.now.sh');

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: httpLink,
        cache: InMemoryCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Episode Guide',
          theme: ThemeData(
            primaryColorDark: Colors.grey[900],
            primaryColorLight: Colors.grey[500],
            primaryColor: Colors.black,
            accentColor: Colors.white,
            primarySwatch: Colors.blue,
            fontFamily: 'AlegreyaSans',
            textTheme: TextTheme(
              headline: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              subhead: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
          ),
          home: HomePage(),
          routes: {
            SeriesDetailsScreen.routeName: (context) => SeriesDetailsScreen(),
          },
        ),
      ),
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
