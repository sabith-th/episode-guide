// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesDetails _$SeriesDetailsFromJson(Map<String, dynamic> json) =>
    SeriesDetails(
      Series.fromJson(json['series'] as Map<String, dynamic>),
      json['nextEpisode'] == null
          ? null
          : Episode.fromJson(json['nextEpisode'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$SeriesDetailsToJson(SeriesDetails instance) =>
    <String, dynamic>{
      'series': instance.series,
      'nextEpisode': instance.nextEpisode,
    };
