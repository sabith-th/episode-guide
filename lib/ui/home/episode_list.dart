import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';

List<Episode> mockEpisodes = [
  Episode(
    id: '266189',
    seriesName: 'The Blacklist',
    episodeName: 'Olivia Olson',
    airDate: '2019-04-05',
    imageUrl:
        'https://www.thetvdb.com/banners/_cache/seasons/5c3d006d114c1.jpg',
    season: '6',
    episode: '15',
  ),
  Episode(
    id: '95011',
    seriesName: 'Modern Family',
    episodeName: 'Can\'t Elope',
    airDate: '2019-04-10',
    imageUrl:
        'https://www.thetvdb.com/banners/_cache/seasons/5bb461598d281.jpg',
    season: '10',
    episode: '20',
  ),
  Episode(
    id: '269586',
    seriesName: 'Brooklyn Nine-Nine',
    episodeName: 'Casecation',
    airDate: '2019-04-11',
    imageUrl:
        'https://www.thetvdb.com/banners/_cache/seasons/5c3d2ba25a94a.jpg',
    season: '12',
    episode: '12',
  ),
  Episode(
    id: '278518',
    seriesName: 'Last Week Tonight with John Oliver',
    episodeName: 'Episode 156',
    airDate: '2019-04-07',
    imageUrl:
        'https://www.thetvdb.com/banners/_cache/seasons/5c62b4f29266a.jpg',
    season: '6',
    episode: '7',
  ),
];

class Episode {
  final String id;
  final String seriesName;
  final String episodeName;
  final String airDate;
  final String imageUrl;
  final String season;
  final String episode;

  Episode({
    this.id,
    this.season,
    this.episode,
    this.seriesName,
    this.episodeName,
    this.airDate,
    this.imageUrl,
  });
}

Widget _getEpisodeCard(Episode episode) {
  return Card(
    child: Padding(
      padding: const EdgeInsets.all(8.0),
      child: IntrinsicHeight(
        child: Row(
          children: <Widget>[
            SizedBox(
              height: 110,
              width: 75,
              child: CachedNetworkImage(
                imageUrl: episode.imageUrl,
                placeholder: (context, url) => new CircularProgressIndicator(),
                errorWidget: (context, url, error) => new Icon(Icons.error),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      episode.seriesName,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 24,
                      ),
                    ),
                    Text(
                      'S${episode.season} E${episode.episode} - ${episode.episodeName}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                    Text(
                      'Airs: ${episode.airDate}',
                      style: TextStyle(
                        fontSize: 18,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

Widget _getEpisodes(List<Episode> episodes) {
  return CustomScrollView(
    scrollDirection: Axis.vertical,
    shrinkWrap: true,
    slivers: <Widget>[
      SliverPadding(
        padding: const EdgeInsets.symmetric(vertical: 24.0),
        sliver: SliverList(
          delegate: SliverChildBuilderDelegate(
            (context, index) => _getEpisodeCard(episodes[index]),
            childCount: episodes.length,
          ),
        ),
      )
    ],
  );
}

class EpisodeList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        child: _getEpisodes(mockEpisodes),
      ),
    );
  }
}
