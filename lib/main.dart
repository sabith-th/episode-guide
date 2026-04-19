import 'package:episode_guide/blocs/blocs.dart';
import 'package:episode_guide/constants.dart';
import 'package:episode_guide/repositories/repositories.dart';
import 'package:episode_guide/ui/widgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() {
  Bloc.observer = SimpleBlocObserver();

  final HttpLink httpLink = HttpLink(TVDB_GRAPHQL_API);

  final GraphQLClient client = GraphQLClient(
    link: httpLink,
    cache: GraphQLCache(store: InMemoryStore()),
  );

  final TvdbRepository tvdbRepository =
      TvdbRepository(tvdbGraphQLClient: TvdbGraphQLClient(client: client));

  runApp(
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

  const MyApp({super.key, required this.tvdbRepository});

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
        BlocProvider<SeriesEpisodesBloc>(
          create: (context) =>
              SeriesEpisodesBloc(tvdbRepository: widget.tvdbRepository),
        ),
      ],
      child: MaterialApp(
        title: 'Episode Guide',
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
          colorScheme: ColorScheme.fromSeed(
            seedColor: const Color(0xFF0F6E8C),
            brightness: Brightness.dark,
            surface: const Color(0xFF141414),
          ),
          scaffoldBackgroundColor: const Color(0xFF0D0D0D),
          fontFamily: 'AlegreyaSans',
          textTheme: const TextTheme(
            headlineLarge: TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            headlineMedium: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            titleMedium: TextStyle(
              fontSize: 18,
              color: Colors.white70,
            ),
            bodyMedium: TextStyle(
              fontSize: 16,
              color: Colors.white60,
            ),
          ),
          cardTheme: CardThemeData(
            color: const Color(0xFF1C1C1C),
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
          appBarTheme: const AppBarTheme(
            backgroundColor: Color(0xFF0D0D0D),
            elevation: 0,
            centerTitle: false,
            iconTheme: IconThemeData(color: Colors.white),
            titleTextStyle: TextStyle(
              fontFamily: 'AlegreyaSans',
              fontSize: 26,
              fontWeight: FontWeight.bold,
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
          EpisodesScreen.routeName: (context) => EpisodesScreen(),
        },
      ),
    );
  }
}
