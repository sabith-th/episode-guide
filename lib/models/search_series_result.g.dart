// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'search_series_result.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SearchSeriesResult _$SearchSeriesResultFromJson(Map<String, dynamic> json) {
  return SearchSeriesResult((json['searchSeries'] as List)
      ?.map((e) =>
          e == null ? null : SearchSeries.fromJson(e as Map<String, dynamic>))
      ?.toList());
}

Map<String, dynamic> _$SearchSeriesResultToJson(SearchSeriesResult instance) =>
    <String, dynamic>{'searchSeries': instance.searchSeries};

SearchSeries _$SearchSeriesFromJson(Map<String, dynamic> json) {
  return SearchSeries(
      json['id'] as int,
      json['seriesName'] as String,
      json['network'] as String,
      json['firstAired'] as String,
      json['status'] as String);
}

Map<String, dynamic> _$SearchSeriesToJson(SearchSeries instance) =>
    <String, dynamic>{
      'id': instance.id,
      'seriesName': instance.seriesName,
      'network': instance.network,
      'firstAired': instance.firstAired,
      'status': instance.status
    };
