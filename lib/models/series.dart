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

  Series(
    this.id,
    this.seriesName,
    this.overview,
    this.image,
    this.score,
    this.firstAired,
    this.characters,
  );

  factory Series.fromJson(Map<String, dynamic> json) => _$SeriesFromJson(json);

  Map<String, dynamic> toJson() => _$SeriesToJson(this);
}
