import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

@JsonSerializable()
class Series {
  final int id;
  final String seriesId;
  final String seriesName;
  final String overview;
  final String network;
  final String banner;
  final String airsTime;
  final String airsDayOfWeek;
  final String rating;
  final double siteRating;

  Series(
    this.id,
    this.seriesId,
    this.seriesName,
    this.overview,
    this.network,
    this.banner,
    this.airsTime,
    this.airsDayOfWeek,
    this.rating,
    this.siteRating,
  );

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
