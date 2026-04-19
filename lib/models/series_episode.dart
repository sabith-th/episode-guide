import 'package:json_annotation/json_annotation.dart';

part 'series_episode.g.dart';

@JsonSerializable()
class SeriesEpisode {
  final int id;
  @JsonKey(name: 'name')
  final String episodeName;
  @JsonKey(name: 'aired')
  final String? airDate;
  final int? seasonNumber;
  final int? number;
  final String? overview;
  final int? runtime;
  final String? image;

  SeriesEpisode(
    this.id,
    this.episodeName,
    this.airDate,
    this.seasonNumber,
    this.number,
    this.overview,
    this.runtime,
    this.image,
  );

  factory SeriesEpisode.fromJson(Map<String, dynamic> json) =>
      _$SeriesEpisodeFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesEpisodeToJson(this);
}
