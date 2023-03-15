import 'package:equatable/equatable.dart';
import 'package:story_app/data/remote/response/story_response.dart';

class ListStoryResponse extends Equatable {
  final bool? error;
  final String? message;
  final List<Story>? listStory;

  const ListStoryResponse({this.error, this.message, this.listStory});

  factory ListStoryResponse.fromJson(Map<String, dynamic> json) {
    List<dynamic> listStoryJson = json['listStory'];
    List<Story> listStory =
        listStoryJson.map((e) => Story.fromJson(e)).toList();
    return ListStoryResponse(
      error: json['error'],
      message: json['message'],
      listStory: listStory.isNotEmpty ? listStory : null,
    );
  }

  @override
  List<Object?> get props => [error, message, listStory];
}
