import 'package:json_annotation/json_annotation.dart';

part 'episode_details.g.dart';

@JsonSerializable()
class EpisodeCharacter {
  final int? id;
  final String? name;
  final String? image;
  final String? personName;
  final String? personImgURL;
  final bool? isFeatured;
  final int? peopleId;
  final int? sort;
  final String? peopleType;

  EpisodeCharacter(
    this.id,
    this.name,
    this.image,
    this.personName,
    this.personImgURL,
    this.isFeatured,
    this.peopleId,
    this.sort,
    this.peopleType,
  );

  factory EpisodeCharacter.fromJson(Map<String, dynamic> json) =>
      _$EpisodeCharacterFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeCharacterToJson(this);
}

@JsonSerializable()
class EpisodeCompany {
  final int id;
  final String? name;

  EpisodeCompany(this.id, this.name);

  factory EpisodeCompany.fromJson(Map<String, dynamic> json) =>
      _$EpisodeCompanyFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeCompanyToJson(this);
}

@JsonSerializable()
class EpisodeDetails {
  final int id;
  final String? finaleType;
  final String? seasonName;
  final List<EpisodeCharacter>? characters;
  final List<EpisodeCompany>? networks;
  final List<EpisodeCompany>? studios;

  EpisodeDetails(
    this.id,
    this.finaleType,
    this.seasonName,
    this.characters,
    this.networks,
    this.studios,
  );

  factory EpisodeDetails.fromJson(Map<String, dynamic> json) =>
      _$EpisodeDetailsFromJson(json);

  Map<String, dynamic> toJson() => _$EpisodeDetailsToJson(this);
}
