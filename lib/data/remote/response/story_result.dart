import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

part 'story_result.g.dart'; // nama file ini harus sesuai dengan nama kelasnya

@JsonSerializable()
class StoryResult extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  const StoryResult({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory StoryResult.fromJson(Map<String, dynamic> json) =>
      _$StoryResultFromJson(json);

  Map<String, dynamic> toJson() => _$StoryResultToJson(this);

  @override
  List<Object?> get props =>
      [id, name, description, photoUrl, createdAt, lat, lon];
}
