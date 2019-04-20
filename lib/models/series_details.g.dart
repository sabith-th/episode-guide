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
          ?.toList(),
      (json['images'] as List)
          ?.map((e) =>
              e == null ? null : Images.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$SeriesDetailsToJson(SeriesDetails instance) =>
    <String, dynamic>{
      'series': instance.series,
      'actors': instance.actors,
      'images': instance.images
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
