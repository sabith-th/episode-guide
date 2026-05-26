// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'person.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PersonRole _$PersonRoleFromJson(Map<String, dynamic> json) => PersonRole(
  (json['id'] as num).toInt(),
  json['name'] as String?,
  json['image'] as String?,
  json['isFeatured'] as bool?,
  (json['seriesId'] as num?)?.toInt(),
  (json['movieId'] as num?)?.toInt(),
  (json['sort'] as num?)?.toInt(),
);

Map<String, dynamic> _$PersonRoleToJson(PersonRole instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'isFeatured': instance.isFeatured,
      'seriesId': instance.seriesId,
      'movieId': instance.movieId,
      'sort': instance.sort,
    };

PersonAward _$PersonAwardFromJson(Map<String, dynamic> json) =>
    PersonAward((json['id'] as num?)?.toInt(), json['name'] as String?);

Map<String, dynamic> _$PersonAwardToJson(PersonAward instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

Person _$PersonFromJson(Map<String, dynamic> json) => Person(
  (json['id'] as num).toInt(),
  json['name'] as String,
  json['image'] as String?,
  json['birth'] as String?,
  json['birthPlace'] as String?,
  json['death'] as String?,
  (json['characters'] as List<dynamic>?)
      ?.map((e) => PersonRole.fromJson(e as Map<String, dynamic>))
      .toList(),
  (json['awards'] as List<dynamic>?)
      ?.map((e) => PersonAward.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$PersonToJson(Person instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'image': instance.image,
  'birth': instance.birth,
  'birthPlace': instance.birthPlace,
  'death': instance.death,
  'characters': instance.characters,
  'awards': instance.awards,
};
