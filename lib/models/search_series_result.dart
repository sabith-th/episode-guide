import 'package:json_annotation/json_annotation.dart';

part 'search_series_result.g.dart';

@JsonSerializable()
class SearchSeriesResult {
  final List<SearchSeries> searchSeries;

  SearchSeriesResult(this.searchSeries);

  factory SearchSeriesResult.fromJson(Map<String, dynamic> json) =>
      _$SearchSeriesResultFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSeriesResultToJson(this);
}

int _tvdbIdToInt(String value) => int.parse(value);

@JsonSerializable()
class SearchSeries {
  @JsonKey(name: 'tvdb_id', fromJson: _tvdbIdToInt)
  final int id;
  @JsonKey(name: 'name')
  final String seriesName;
  final String? network;
  @JsonKey(name: 'first_air_time')
  final String? firstAired;
  final String? status;

  SearchSeries(this.id, this.seriesName, this.network, this.firstAired, this.status);

  factory SearchSeries.fromJson(Map<String, dynamic> json) =>
      _$SearchSeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SearchSeriesToJson(this);
}
