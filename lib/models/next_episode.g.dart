// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'next_episode.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

NextEpisode _$NextEpisodeFromJson(Map<String, dynamic> json) {
  return NextEpisode(
      json['series'] == null
          ? null
          : Series.fromJson(json['series'] as Map<String, dynamic>),
      json['episodesSummary'] == null
          ? null
          : EpisodesSummary.fromJson(
              json['episodesSummary'] as Map<String, dynamic>),
      (json['images'] as List)
          ?.map((e) =>
              e == null ? null : Images.fromJson(e as Map<String, dynamic>))
          ?.toList());
}

Map<String, dynamic> _$NextEpisodeToJson(NextEpisode instance) =>
    <String, dynamic>{
      'series': instance.series,
      'episodesSummary': instance.episodesSummary,
      'images': instance.images
    };

EpisodesSummary _$EpisodesSummaryFromJson(Map<String, dynamic> json) {
  return EpisodesSummary(json['nextEpisode'] == null
      ? null
      : Episode.fromJson(json['nextEpisode'] as Map<String, dynamic>));
}

Map<String, dynamic> _$EpisodesSummaryToJson(EpisodesSummary instance) =>
    <String, dynamic>{'nextEpisode': instance.nextEpisode};

Episode _$EpisodeFromJson(Map<String, dynamic> json) {
  return Episode(json['airedSeason'] as int, json['episodeName'] as String,
      json['firstAired'] as String, json['airedEpisodeNumber'] as int);
}

Map<String, dynamic> _$EpisodeToJson(Episode instance) => <String, dynamic>{
      'airedSeason': instance.airedSeason,
      'episodeName': instance.episodeName,
      'firstAired': instance.firstAired,
      'airedEpisodeNumber': instance.airedEpisodeNumber
    };
