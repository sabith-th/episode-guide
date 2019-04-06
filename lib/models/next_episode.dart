import 'package:json_annotation/json_annotation.dart';

part 'next_episode.g.dart';

@JsonSerializable()
class NextEpisode {
  final Series series;
  final EpisodesSummary episodesSummary;
  final List<Images> images;

  NextEpisode(this.series, this.episodesSummary, this.images);

  factory NextEpisode.fromJson(Map<String, dynamic> json) =>
      _$NextEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$NextEpisodeToJson(this);
}

@JsonSerializable()
class Series {
  final int id;
  final String seriesName;
  final String airsTime;
  final String network;

  Series(this.id, this.seriesName, this.airsTime, this.network);

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}

@JsonSerializable()
class EpisodesSummary {
  @JsonKey(name: 'nextEpisode')
  final Episode nextEpisode;

  EpisodesSummary(this.nextEpisode);

  factory EpisodesSummary.fromJson(Map<String, dynamic> json) =>
      _$EpisodesSummaryFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodesSummaryToJson(this);
}

@JsonSerializable()
class Episode {
  final int airedSeason;
  final String episodeName;
  final String firstAired;
  final int airedEpisodeNumber;

  Episode(this.airedSeason, this.episodeName, this.firstAired,
      this.airedEpisodeNumber);

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}

@JsonSerializable()
class Images {
  final String fileName;
  final String resolution;
  final String thumbnail;

  Images(this.fileName, this.resolution, this.thumbnail);

  factory Images.fromJson(Map<String, dynamic> json) => _$ImagesFromJson(json);

  Map<String, dynamic> toJson() => _$ImagesToJson(this);
}
