import 'package:bloc/bloc.dart';
import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  BlocSupervisor.delegate = SimpleBlocDelegate();

  final HttpLink _httpLink = HttpLink(uri: TVDB_GRAPHQL_API);

  final GraphQLClient _client =
      GraphQLClient(link: _httpLink, cache: InMemoryCache());

  final TvdbRepository tvdbRepository =
      TvdbRepository(tvdbGraphQLClient: TvdbGraphQLClient(client: _client));

  return runApp(
    BlocProvider(
      create: (context) {
        return FavoritesBloc()..add(FetchFavorites());
      },
      child: MyApp(tvdbRepository: tvdbRepository),
    ),
  );
}

class MyApp extends StatefulWidget {
  final TvdbRepository tvdbRepository;

  const MyApp({Key key, @required this.tvdbRepository}) : super(key: key);

  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NextEpisodesBloc>(
          create: (context) => NextEpisodesBloc(
              favoritesBloc: BlocProvider.of<FavoritesBloc>(context),
              tvdbRepository: widget.tvdbRepository),
        ),
        BlocProvider<SeriesDetailsBloc>(
          create: (context) =>
              SeriesDetailsBloc(tvdbRepository: widget.tvdbRepository),
        ),
        BlocProvider<SearchSeriesBloc>(
          create: (context) =>
              SearchSeriesBloc(tvdbRepository: widget.tvdbRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Episode Guide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColorDark: Colors.grey[900],
          primaryColorLight: Colors.grey[500],
          primaryColor: Colors.black,
          accentColor: Colors.white,
          primarySwatch: Colors.blue,
          fontFamily: 'AlegreyaSans',
          textTheme: TextTheme(
            headline5: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            subtitle1: TextStyle(
              fontSize: 18,
              color: Colors.white,
            ),
          ),
        ),
        initialRoute: HomePage.routeName,
        routes: {
          HomePage.routeName: (context) => HomePage(
                onInit: () {},
              ),
          SeriesDetailsScreen.routeName: (context) => SeriesDetailsScreen(),
          SearchSeriesScreen.routeName: (context) => SearchSeriesScreen(),
        },
      ),
    );
  }
}
