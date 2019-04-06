import 'package:episode_guide/ui/home/carousel.dart';
import 'package:episode_guide/ui/home/episode_list.dart';
import 'package:flutter/material.dart';
import 'package:graphql_flutter/graphql_flutter.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HttpLink httpLink =
        HttpLink(uri: 'https://tvdb-graphql-api.sabith-th.now.sh');

    final AuthLink authLink = AuthLink(
      getToken: () async =>
          'eyJhbGciOiJSUzI1NiIsInR5cCI6IkpXVCJ9.eyJleHAiOjE1NTQ1NzM1MTEsImlkIjoiIiwib3JpZ19pYXQiOjE1NTQ0ODcxMTEsInVzZXJpZCI6NTIyMTY1LCJ1c2VybmFtZSI6InNhYml0aC50aC4wN25kaiJ9.KN0_m0nytNyaDoh7d5Qy3KEsqTyiSFicYrau0EX_Zq0VfZnwKB5RwuvQFzi3b7APLQak7G-Lr7CBhYrpsnC33qP81iELa5hRw2wm4qK6NrE2j2qNAreN2PKNXbRmLaljgNlkFHGLtmFExqAv5X-lDO6sy0X1hye8jnZXshWpg73LdHaytOcYlFFVTBBEj9K_sNsLWrKosBVuDzuLSDWibgDWXn05iWMdTA0g4FZ9Vmnpdwh8hvFomsElyQIe1K0vg3AflHUiA0_351rKoElsJS6WrjruaSyYgFGyY6OWH0wiVTG1TWQM8LAT9Nvgxm1kDyi4AsSWdY_sWQpESyMneg',
    );

    final Link link = authLink.concat(httpLink);

    final ValueNotifier<GraphQLClient> client = ValueNotifier(
      GraphQLClient(
        link: link,
        cache: InMemoryCache(),
      ),
    );

    return GraphQLProvider(
      client: client,
      child: CacheProvider(
        child: MaterialApp(
          title: 'Episode Guide',
          theme: ThemeData(
            primaryColor: Colors.black,
            accentColor: Colors.white,
            fontFamily: 'AlegreyaSans',
          ),
          home: HomePage(),
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
