import 'package:json_annotation/json_annotation.dart';

part 'movie.g.dart';

String? _statusFromJson(Map<String, dynamic>? json) =>
    json?['name'] as String?;

Map<String, dynamic>? _statusToJson(String? name) =>
    name != null ? {'name': name} : null;

List<String>? _genresFromJson(List<dynamic>? json) =>
    json?.map((g) => (g as Map<String, dynamic>)['name'] as String).toList();

List<Map<String, dynamic>>? _genresToJson(List<String>? genres) =>
    genres?.map((g) => {'name': g}).toList();

@JsonSerializable()
class MovieCastMember {
  final int? id;
  final String? name;
  final String? image;
  final String? personName;
  final String? personImgURL;
  final bool? isFeatured;
  final int? peopleId;
  final int? sort;

  MovieCastMember(
    this.id,
    this.name,
    this.image,
    this.personName,
    this.personImgURL,
    this.isFeatured,
    this.peopleId,
    this.sort,
  );

  factory MovieCastMember.fromJson(Map<String, dynamic> json) =>
      _$MovieCastMemberFromJson(json);

  Map<String, dynamic> toJson() => _$MovieCastMemberToJson(this);
}

@JsonSerializable()
class Movie {
  final int id;
  final String name;
  final String? image;
  final String? year;
  final int? runtime;
  @JsonKey(fromJson: _statusFromJson, toJson: _statusToJson)
  final String? status;
  @JsonKey(fromJson: _genresFromJson, toJson: _genresToJson)
  final List<String>? genres;
  final List<MovieCastMember>? characters;
  final String? overview;

  Movie(
    this.id,
    this.name,
    this.image,
    this.year,
    this.runtime,
    this.status,
    this.genres,
    this.characters,
    this.overview,
  );

  factory Movie.fromJson(Map<String, dynamic> json) => _$MovieFromJson(json);

  Map<String, dynamic> toJson() => _$MovieToJson(this);
}
