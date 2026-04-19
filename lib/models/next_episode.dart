import 'package:episode_guide/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'next_episode.g.dart';

@JsonSerializable()
class NextEpisode {
  final Series series;
  final Episode? nextEpisode;

  NextEpisode(this.series, this.nextEpisode);

  factory NextEpisode.fromJson(Map<String, dynamic> json) =>
      _$NextEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$NextEpisodeToJson(this);
}

@JsonSerializable()
class Episode {
  final int id;
  @JsonKey(name: 'name')
  final String? episodeName;
  @JsonKey(name: 'aired')
  final String? firstAired;
  final int? seasonNumber;

  Episode(this.id, this.episodeName, this.firstAired, this.seasonNumber);

  factory Episode.fromJson(Map<String, dynamic> json) =>
      _$EpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeToJson(this);
}
