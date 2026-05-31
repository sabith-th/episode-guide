// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'movie.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

MovieCastMember _$MovieCastMemberFromJson(Map<String, dynamic> json) =>
    MovieCastMember(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['image'] as String?,
      json['personName'] as String?,
      json['personImgURL'] as String?,
      json['isFeatured'] as bool?,
      (json['peopleId'] as num?)?.toInt(),
      (json['sort'] as num?)?.toInt(),
    );

Map<String, dynamic> _$MovieCastMemberToJson(MovieCastMember instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'personName': instance.personName,
      'personImgURL': instance.personImgURL,
      'isFeatured': instance.isFeatured,
      'peopleId': instance.peopleId,
      'sort': instance.sort,
    };

Movie _$MovieFromJson(Map<String, dynamic> json) => Movie(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['image'] as String?,
  json['year'] as String?,
  (json['runtime'] as num?)?.toInt(),
  _statusFromJson(json['status'] as Map<String, dynamic>?),
  _genresFromJson(json['genres'] as List?),
  (json['characters'] as List<dynamic>?)
      ?.map((e) => MovieCastMember.fromJson(e as Map<String, dynamic>))
      .toList(),
  json['overview'] as String?,
);

Map<String, dynamic> _$MovieToJson(Movie instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'year': instance.year,
  'runtime': instance.runtime,
  'status': _statusToJson(instance.status),
  'genres': _genresToJson(instance.genres),
  'characters': instance.characters,
  'overview': instance.overview,
};
