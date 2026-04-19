import 'package:episode_guide/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'series_details.g.dart';

@JsonSerializable()
class SeriesDetails {
  final Series series;
  final Episode? nextEpisode;

  SeriesDetails(this.series, this.nextEpisode);

  factory SeriesDetails.fromJson(Map<String, dynamic> json) =>
      _$SeriesDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesDetailsToJson(this);
}
