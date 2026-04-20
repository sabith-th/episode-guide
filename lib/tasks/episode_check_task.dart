import 'package:episode_guide/constants.dart';
import 'package:episode_guide/repositories/favorites_repository.dart';
import 'package:episode_guide/repositories/tvdb_graphql_client.dart';
import 'package:episode_guide/repositories/tvdb_repository.dart';
import 'package:episode_guide/services/notification_service.dart';
import 'package:flutter/widgets.dart';
import 'package:graphql_flutter/graphql_flutter.dart';
import 'package:workmanager/workmanager.dart';

const String episodeCheckTaskName = 'episodeCheckTask';
const String episodeCheckTaskUniqueName = 'com.sabithth.episodeGuide.episodeCheck';

@pragma('vm:entry-point')
void callbackDispatcher() {
  Workmanager().executeTask((taskName, inputData) async {
    WidgetsFlutterBinding.ensureInitialized();

    await NotificationService.init();

    final HttpLink httpLink = HttpLink(TVDB_GRAPHQL_API);
    final GraphQLClient client = GraphQLClient(
      link: httpLink,
      cache: GraphQLCache(store: InMemoryStore()),
    );
    final TvdbRepository tvdbRepository = TvdbRepository(
      tvdbGraphQLClient: TvdbGraphQLClient(client: client),
    );

    final List<int> favoriteIds =
        await FavoritesRepository.getFavoriteSeriesList();
    if (favoriteIds.isEmpty) return true;

    final today = DateTime.now();
    final todayStr =
        '${today.year}-${today.month.toString().padLeft(2, '0')}-${today.day.toString().padLeft(2, '0')}';

    final nextEpisodes = await tvdbRepository.getNextEpisodes(favoriteIds);

    for (final nextEpisode in nextEpisodes) {
      final episode = nextEpisode.nextEpisode;
      if (episode == null) continue;
      if (episode.firstAired == todayStr) {
        final season = episode.seasonNumber;
        final seasonEpisode = season != null ? 'S${season.toString().padLeft(2, '0')}' : '';
        await NotificationService.showEpisodeNotification(
          id: nextEpisode.series.id,
          seriesName: nextEpisode.series.seriesName,
          episodeTitle: episode.episodeName ?? 'New Episode',
          seasonEpisode: seasonEpisode,
        );
      }
    }

    return true;
  });
}
