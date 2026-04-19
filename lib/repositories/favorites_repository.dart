import 'package:episode_guide/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static Future<List<int>> getFavoriteSeriesList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String>? seriesIds = prefs.getStringList(FAVORITES_KEY);
    if (seriesIds != null) {
      return seriesIds.map((id) => int.parse(id)).toList();
    }
    return <int>[];
  }

  static Future<bool> addFavoriteSeries(int id) async {
    final String idString = id.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> seriesIds =
        prefs.getStringList(FAVORITES_KEY) ?? <String>[];
    if (seriesIds.contains(idString)) {
      return true;
    }
    seriesIds.add(idString);
    return prefs.setStringList(FAVORITES_KEY, seriesIds);
  }

  static Future<bool> removeFavoriteSeries(int id) async {
    final String idString = id.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final List<String> seriesIds =
        prefs.getStringList(FAVORITES_KEY) ?? <String>[];
    seriesIds.remove(idString);
    return prefs.setStringList(FAVORITES_KEY, seriesIds);
  }
}
