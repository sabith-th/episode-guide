import 'package:json_annotation/json_annotation.dart';

part 'series_details.g.dart';

@JsonSerializable()
class SeriesDetails {
  final Series series;
  final List<Actor> actors;

  SeriesDetails(this.series, this.actors);

  factory SeriesDetails.fromJson(Map<String, dynamic> json) =>
      _$SeriesDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesDetailsToJson(this);
}

@JsonSerializable()
class Series {
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

@JsonSerializable()
class Actor {
  final String name;
  final String role;
  final String image;
  final int sortOrder;

  Actor(this.name, this.role, this.image, this.sortOrder);

  factory Actor.fromJson(Map<String, dynamic> json) => _$ActorFromJson(json);

  Map<String, dynamic> toJson() => _$ActorToJson(this);
}
