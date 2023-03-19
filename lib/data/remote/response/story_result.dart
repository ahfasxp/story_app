import 'package:equatable/equatable.dart';

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

  factory StoryResult.fromJson(Map<String, dynamic> json) {
    return StoryResult(
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
