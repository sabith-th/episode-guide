// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextEpisode _$NextEpisodeFromJson(Map<String, dynamic> json) => NextEpisode(
  Series.fromJson(json['series'] as Map<String, dynamic>),
  json['nextEpisode'] == null
      ? null
      : Episode.fromJson(json['nextEpisode'] as Map<String, dynamic>),
);

Map<String, dynamic> _$NextEpisodeToJson(NextEpisode instance) =>
    <String, dynamic>{
      'series': instance.series,
      'nextEpisode': instance.nextEpisode,
    };

Episode _$EpisodeFromJson(Map<String, dynamic> json) => Episode(
  (json['id'] as num).toInt(),
  json['name'] as String?,
  json['aired'] as String?,
  (json['seasonNumber'] as num?)?.toInt(),
);

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.episodeName,
  'aired': instance.firstAired,
  'seasonNumber': instance.seasonNumber,
};
