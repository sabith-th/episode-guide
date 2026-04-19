import 'package:json_annotation/json_annotation.dart';

part 'series.g.dart';

@JsonSerializable()
class Character {
  final String personName;
  final String? name;
  final String? peopleType;
  final String? personImgURL;
  final bool? isFeatured;

  Character(
    this.personName,
    this.name,
    this.peopleType,
    this.personImgURL,
    this.isFeatured,
  );

  factory Character.fromJson(Map<String, dynamic> json) =>
      _$CharacterFromJson(json);

  Map<String, dynamic> toJson() => _$CharacterToJson(this);
}

String? _statusFromJson(Map<String, dynamic>? json) =>
    json?['name'] as String?;

Map<String, dynamic>? _statusToJson(String? name) =>
    name != null ? {'name': name} : null;

List<String>? _genresFromJson(List<dynamic>? json) =>
    json?.map((g) => (g as Map<String, dynamic>)['name'] as String).toList();

List<Map<String, dynamic>>? _genresToJson(List<String>? genres) =>
    genres?.map((g) => {'name': g}).toList();

@JsonSerializable()
class Series {
  final int id;
  @JsonKey(name: 'name')
  final String seriesName;
  final String? overview;
  final String? image;
  final double? score;
  final String? firstAired;
  final List<Character>? characters;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final String? status;
  @JsonKey(fromJson: _genresFromJson, toJson: _genresToJson)
  final List<String>? genres;
  final int? averageRuntime;
  final String? year;

  Series(
    this.id,
    this.seriesName,
    this.overview,
    this.image,
    this.score,
    this.firstAired,
    this.characters,
    this.status,
    this.genres,
    this.averageRuntime,
    this.year,
  );

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
