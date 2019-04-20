// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'images.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Images _$ImagesFromJson(Map<String, dynamic> json) {
  return Images(json['fileName'] as String, json['resolution'] as String,
      json['thumbnail'] as String);
}

Map<String, dynamic> _$ImagesToJson(Images instance) => <String, dynamic>{
      'fileName': instance.fileName,
      'resolution': instance.resolution,
      'thumbnail': instance.thumbnail
    };
