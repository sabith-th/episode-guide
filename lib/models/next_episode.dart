import 'package:episode_guide/models/models.dart';
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

