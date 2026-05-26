import 'package:json_annotation/json_annotation.dart';

part 'person.g.dart';

@JsonSerializable()
class PersonRole {
  final int id;
  final String? name;
  final String? image;
  final bool? isFeatured;
  final int? seriesId;
  final int? movieId;
  final int? sort;

  PersonRole(
    this.id,
    this.name,
    this.image,
    this.isFeatured,
    this.seriesId,
    this.movieId,
    this.sort,
  );

  factory PersonRole.fromJson(Map<String, dynamic> json) =>
      _$PersonRoleFromJson(json);

  Map<String, dynamic> toJson() => _$PersonRoleToJson(this);
}

@JsonSerializable()
class PersonAward {
  final int? id;
  final String? name;

  PersonAward(this.id, this.name);

  factory PersonAward.fromJson(Map<String, dynamic> json) =>
      _$PersonAwardFromJson(json);

  Map<String, dynamic> toJson() => _$PersonAwardToJson(this);
}

@JsonSerializable()
class Person {
  final int id;
  final String name;
  final String? image;
  final String? birth;
  final String? birthPlace;
  final String? death;
  final List<PersonRole>? characters;
  final List<PersonAward>? awards;

  Person(
    this.id,
    this.name,
    this.image,
    this.birth,
    this.birthPlace,
    this.death,
    this.characters,
    this.awards,
  );

  factory Person.fromJson(Map<String, dynamic> json) => _$PersonFromJson(json);

  Map<String, dynamic> toJson() => _$PersonToJson(this);
}
