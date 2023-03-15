import 'package:equatable/equatable.dart';

class StoryResponse extends Equatable {
  final bool? error;
  final String? message;
  final Story? story;

  const StoryResponse({this.error, this.message, this.story});

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      error: json['error'],
      message: json['message'],
      story: json['story'] != null ? Story.fromJson(json['story']) : null,
    );
  }

  @override
  List<Object?> get props => [error, message, story];
}

class Story extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final String? photoUrl;
  final DateTime? createdAt;
  final double? lat;
  final double? lon;

  const Story({
    this.id,
    this.name,
    this.description,
    this.photoUrl,
    this.createdAt,
    this.lat,
    this.lon,
  });

  factory Story.fromJson(Map<String, dynamic> json) {
    return Story(
      id: json['id'],
      name: json['name'],
      description: json['description'],
      photoUrl: json['photoUrl'],
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      lat: json['lat'] != null ? double.parse(json['lat'].toString()) : null,
      lon: json['lon'] != null ? double.parse(json['lon'].toString()) : null,
    );
  }

  @override
  List<Object?> get props =>
      [id, name, description, photoUrl, createdAt, lat, lon];
}
