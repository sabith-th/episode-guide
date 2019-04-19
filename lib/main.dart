import 'package:bloc/bloc.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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

class MyApp extends StatefulWidget {
  final TvdbRepository tvdbRepository;

  const MyApp({Key key, @required this.tvdbRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  NextEpisodesBloc _nextEpisodesBloc;
  SeriesDetailsBloc _seriesDetailsBloc;

  @override
  void initState() {
    super.initState();
    _nextEpisodesBloc = NextEpisodesBloc(tvdbRepository: widget.tvdbRepository);
    _seriesDetailsBloc =
        SeriesDetailsBloc(tvdbRepository: widget.tvdbRepository);
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      bloc: _nextEpisodesBloc,
      child: BlocProviderTree(
        blocProviders: [
          BlocProvider<NextEpisodesBloc>(bloc: _nextEpisodesBloc),
          BlocProvider<SeriesDetailsBloc>(bloc: _seriesDetailsBloc),
        ],
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
          initialRoute: HomePage.routeName,
          routes: {
            HomePage.routeName: (context) {
              return HomePage(
                onInit: () => _nextEpisodesBloc
                    .dispatch(FetchNextEpisode(ids: seriesIds)),
              );
            },
            SeriesDetailsScreen.routeName: (context) => SeriesDetailsScreen(),
            SearchSeriesScreen.routeName: (context) => SearchSeriesScreen(),
          },
        ),
      ),
    );
  }

  @override
  void dispose() {
    _seriesDetailsBloc.dispose();
    _nextEpisodesBloc.dispose();
    super.dispose();
  }
}
