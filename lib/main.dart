import 'package:bloc/bloc.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:episode_guide/ui/home/widgets.dart';
import 'package:episode_guide/ui/series/series_details.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

class SimpleBlocDelegate extends BlocDelegate {
  @override
  onTransition(Transition transition) {
    super.onTransition(transition);
    print(transition);
  }
}

void main() {
  BlocSupervisor().delegate = SimpleBlocDelegate();

  final HttpLink _httpLink = HttpLink(uri: TVDB_GRAPHQL_API);

  final GraphQLClient _client =
      GraphQLClient(link: _httpLink, cache: InMemoryCache());

  final TvdbRepository tvdbRepository =
      TvdbRepository(tvdbGraphQLClient: TvdbGraphQLClient(client: _client));

  return runApp(MyApp(tvdbRepository: tvdbRepository));
}

class MyApp extends StatelessWidget {
  final TvdbRepository tvdbRepository;

  const MyApp({Key key, @required this.tvdbRepository}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink = HttpLink(uri: TVDB_GRAPHQL_API);

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
          home: HomePage(tvdbRepository: tvdbRepository),
          routes: {
            SeriesDetailsScreen.routeName: (context) => SeriesDetailsScreen(),
          },
        ),
      ),
    );
  }
}
