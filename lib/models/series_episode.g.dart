// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'series_episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

SeriesEpisode _$SeriesEpisodeFromJson(Map<String, dynamic> json) =>
    SeriesEpisode(
      (json['id'] as num).toInt(),
      json['name'] as String,
      json['aired'] as String?,
      (json['seasonNumber'] as num?)?.toInt(),
      (json['number'] as num?)?.toInt(),
      json['overview'] as String?,
      (json['runtime'] as num?)?.toInt(),
      json['image'] as String?,
    );

Map<String, dynamic> _$SeriesEpisodeToJson(SeriesEpisode instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.episodeName,
      'aired': instance.airDate,
      'seasonNumber': instance.seasonNumber,
      'number': instance.number,
      'overview': instance.overview,
      'runtime': instance.runtime,
      'image': instance.image,
    };
