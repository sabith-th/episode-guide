// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'episode_details.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EpisodeCharacter _$EpisodeCharacterFromJson(Map<String, dynamic> json) =>
    EpisodeCharacter(
      (json['id'] as num?)?.toInt(),
      json['name'] as String?,
      json['image'] as String?,
      json['personName'] as String?,
      json['personImgURL'] as String?,
      json['isFeatured'] as bool?,
      (json['peopleId'] as num?)?.toInt(),
      (json['sort'] as num?)?.toInt(),
      json['peopleType'] as String?,
    );

Map<String, dynamic> _$EpisodeCharacterToJson(EpisodeCharacter instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'image': instance.image,
      'personName': instance.personName,
      'personImgURL': instance.personImgURL,
      'isFeatured': instance.isFeatured,
      'peopleId': instance.peopleId,
      'sort': instance.sort,
      'peopleType': instance.peopleType,
    };

EpisodeCompany _$EpisodeCompanyFromJson(Map<String, dynamic> json) =>
    EpisodeCompany((json['id'] as num).toInt(), json['name'] as String?);

Map<String, dynamic> _$EpisodeCompanyToJson(EpisodeCompany instance) =>
    <String, dynamic>{'id': instance.id, 'name': instance.name};

EpisodeDetails _$EpisodeDetailsFromJson(Map<String, dynamic> json) =>
    EpisodeDetails(
      (json['id'] as num).toInt(),
      json['finaleType'] as String?,
      json['seasonName'] as String?,
      (json['characters'] as List<dynamic>?)
          ?.map((e) => EpisodeCharacter.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['networks'] as List<dynamic>?)
          ?.map((e) => EpisodeCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
      (json['studios'] as List<dynamic>?)
          ?.map((e) => EpisodeCompany.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$EpisodeDetailsToJson(EpisodeDetails instance) =>
    <String, dynamic>{
      'id': instance.id,
      'finaleType': instance.finaleType,
      'seasonName': instance.seasonName,
      'characters': instance.characters,
      'networks': instance.networks,
      'studios': instance.studios,
    };
