import 'package:episode_guide/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FavoritesRepository {
  static Future<List<int>> getFavoriteSeriesList() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> seriesIds = prefs.getStringList(FAVORITES_KEY);
    return seriesIds.map((id) => int.parse(id)).toList();
  }

  static Future<bool> addFavoriteSeries(int id) async {
    String idString = id.toString();
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> seriesIds = prefs.getStringList(FAVORITES_KEY);
    if (seriesIds.contains(idString)) {
      return true;
    }
    seriesIds.add(idString);
    return prefs.setStringList(FAVORITES_KEY, seriesIds);
  }
}
