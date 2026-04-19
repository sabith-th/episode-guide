// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_series_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSeriesResult _$SearchSeriesResultFromJson(Map<String, dynamic> json) =>
    SearchSeriesResult(
      (json['searchSeries'] as List<dynamic>)
          .map((e) => SearchSeries.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$SearchSeriesResultToJson(SearchSeriesResult instance) =>
    <String, dynamic>{'searchSeries': instance.searchSeries};

SearchSeries _$SearchSeriesFromJson(Map<String, dynamic> json) => SearchSeries(
  _tvdbIdToInt(json['tvdb_id'] as String),
  json['name'] as String,
  json['network'] as String?,
  json['first_air_time'] as String?,
  json['status'] as String?,
);

Map<String, dynamic> _$SearchSeriesToJson(SearchSeries instance) =>
    <String, dynamic>{
      'tvdb_id': instance.id,
      'name': instance.seriesName,
      'network': instance.network,
      'first_air_time': instance.firstAired,
      'status': instance.status,
    };
