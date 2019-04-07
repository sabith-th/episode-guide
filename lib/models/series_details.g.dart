// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesDetails _$SeriesDetailsFromJson(Map<String, dynamic> json) {
  return SeriesDetails(
      json['series'] == null
          ? null
          : Series.fromJson(json['series'] as Map<String, dynamic>),
      (json['actors'] as List)
          ?.map((e) =>
              e == null ? null : Actor.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SeriesDetailsToJson(SeriesDetails instance) =>
    <String, dynamic>{'series': instance.series, 'actors': instance.actors};

Series _$SeriesFromJson(Map<String, dynamic> json) {
  return Series(
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

Actor _$ActorFromJson(Map<String, dynamic> json) {
  return Actor(json['name'] as String, json['role'] as String,
      json['image'] as String, json['sortOrder'] as int);
}

Map<String, dynamic> _$ActorToJson(Actor instance) => <String, dynamic>{
      'name': instance.name,
      'role': instance.role,
      'image': instance.image,
      'sortOrder': instance.sortOrder
    };
