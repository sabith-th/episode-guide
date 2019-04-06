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

Series _$SeriesFromJson(Map<String, dynamic> json) {
  return Series(json['id'] as int, json['seriesName'] as String,
      json['airsTime'] as String, json['network'] as String);
}

Map<String, dynamic> _$SeriesToJson(Series instance) => <String, dynamic>{
      'id': instance.id,
      'seriesName': instance.seriesName,
      'airsTime': instance.airsTime,
      'network': instance.network
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

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(json['fileName'] as String, json['resolution'] as String,
      json['thumbnail'] as String);
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'fileName': instance.fileName,
      'resolution': instance.resolution,
      'thumbnail': instance.thumbnail
    };
