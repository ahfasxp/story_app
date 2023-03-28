import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/story_result.dart';

part 'list_story_response.g.dart';

@JsonSerializable()
class ListStoryResponse extends Equatable {
  final bool? error;
  final String? message;
  final List<StoryResult>? listStory;

  const ListStoryResponse({this.error, this.message, this.listStory});

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) =>
      _$ListStoryResponseFromJson(json);

  Map<String, dynamic> toJson() => _$ListStoryResponseToJson(this);

  @override
  List<Object?> get props => [error, message, listStory];
}
