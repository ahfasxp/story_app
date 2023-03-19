import 'package:equatable/equatable.dart';
import 'package:story_app/data/remote/response/story_result.dart';

class StoryResponse extends Equatable {
  final bool? error;
  final String? message;
  final StoryResult? story;

  const StoryResponse({this.error, this.message, this.story});

  factory StoryResponse.fromJson(Map<String, dynamic> json) {
    return StoryResponse(
      error: json['error'],
      message: json['message'],
      story: json['story'] != null ? StoryResult.fromJson(json['story']) : null,
    );
  }

  @override
  List<Object?> get props => [error, message, story];
}
