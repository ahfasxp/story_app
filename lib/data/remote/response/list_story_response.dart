import 'package:equatable/equatable.dart';
import 'package:story_app/data/remote/response/story_result.dart';

class ListStoryResponse extends Equatable {
  final bool? error;
  final String? message;
  final List<StoryResult>? listStory;

  const ListStoryResponse({this.error, this.message, this.listStory});

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> listStoryJson = json['listStory'];
    List<StoryResult> listStory =
        listStoryJson.map((e) => StoryResult.fromJson(e)).toList();
    return ListStoryResponse(
      error: json['error'],
      message: json['message'],
      listStory: listStory.isNotEmpty ? listStory : null,
    );
  }

  @override
  List<Object?> get props => [error, message, listStory];
}
