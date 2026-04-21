import 'dart:convert';
import 'dart:io';

import 'package:episode_guide/models/next_episode.dart';
import 'package:path_provider/path_provider.dart';

class EpisodesCacheRepository {
  static Future<File> _cacheFile() async {
    final dir = await getApplicationCacheDirectory();
    return File('${dir.path}/episodes_cache.json');
  }

  static Future<void> save(List<NextEpisode> episodes) async {
    final file = await _cacheFile();
    await file.writeAsString(jsonEncode(episodes.map((e) => e.toJson()).toList()));
  }

  static Future<List<NextEpisode>?> load() async {
    try {
      final file = await _cacheFile();
      if (!await file.exists()) return null;
      final contents = await file.readAsString();
      final List<dynamic> json = jsonDecode(contents);
      return json.map((e) => NextEpisode.fromJson(e as Map<String, dynamic>)).toList();
    } catch (_) {
      return null;
    }
  }
}
