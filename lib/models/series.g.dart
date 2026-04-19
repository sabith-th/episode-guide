// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Character _$CharacterFromJson(Map<String, dynamic> json) => Character(
  json['personName'] as String,
  json['name'] as String?,
  json['peopleType'] as String?,
  json['personImgURL'] as String?,
  json['isFeatured'] as bool?,
);

Map<String, dynamic> _$CharacterToJson(Character instance) => <String, dynamic>{
  'personName': instance.personName,
  'name': instance.name,
  'peopleType': instance.peopleType,
  'personImgURL': instance.personImgURL,
  'isFeatured': instance.isFeatured,
};

Series _$SeriesFromJson(Map<String, dynamic> json) => Series(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['overview'] as String?,
  json['image'] as String?,
  (json['score'] as num?)?.toDouble(),
  json['firstAired'] as String?,
  (json['characters'] as List<dynamic>?)
      ?.map((e) => Character.fromJson(e as Map<String, dynamic>))
      .toList(),
  _statusFromJson(json['status'] as Map<String, dynamic>?),
  _genresFromJson(json['genres'] as List?),
  (json['averageRuntime'] as num?)?.toInt(),
  json['year'] as String?,
);

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.seriesName,
  'overview': instance.overview,
  'image': instance.image,
  'score': instance.score,
  'firstAired': instance.firstAired,
  'characters': instance.characters,
  'status': _statusToJson(instance.status),
  'genres': _genresToJson(instance.genres),
  'averageRuntime': instance.averageRuntime,
  'year': instance.year,
};
