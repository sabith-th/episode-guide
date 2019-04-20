// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Series _$SeriesFromJson(Map<String, dynamic> json) {
  return Series(
      json['id'] as int,
      json['seriesId'] as String,
      json['seriesName'] as String,
      json['overview'] as String,
      json['network'] as String,
      json['banner'] as String,
      json['airsTime'] as String,
      json['airsDayOfWeek'] as String,
      json['rating'] as String,
      (json['siteRating'] as num)?.toDouble());
}

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'seriesId': instance.seriesId,
      'seriesName': instance.seriesName,
      'overview': instance.overview,
      'network': instance.network,
      'banner': instance.banner,
      'airsTime': instance.airsTime,
      'airsDayOfWeek': instance.airsDayOfWeek,
      'rating': instance.rating,
      'siteRating': instance.siteRating
    };
