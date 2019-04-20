import 'package:episode_guide/models/models.dart';
import 'package:json_annotation/json_annotation.dart';

part 'series_details.g.dart';

@JsonSerializable()
class SeriesDetails {
  final Series series;
  final List<Actor> actors;
  final List<Images> images;

  SeriesDetails(this.series, this.actors, this.images);

  factory SeriesDetails.fromJson(Map<String, dynamic> json) =>
      _$SeriesDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesDetailsToJson(this);
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
