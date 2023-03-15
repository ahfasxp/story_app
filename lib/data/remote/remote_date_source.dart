import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;
import 'package:story_app/data/remote/response/base_response.dart';
import 'package:story_app/data/remote/response/list_story_response.dart';
import 'package:story_app/data/remote/response/login_result_response.dart';
import 'package:story_app/data/remote/response/story_response.dart';
import 'package:story_app/utils/exception.dart';

abstract class RemoteDataSource {
  Future<BaseResponse> register(String name, String email, String password);
  Future<LoginResult> loginUser(String email, String password);
  Future<BaseResponse> addNewStory(String name, String description,
      String photoPath, double lat, double lon);
  Future<List<Story>> getStories();
  Future<Story> getStory(String id);
}

class RemoteDataSourceImpl implements RemoteDataSource {
  static const baseUrl = 'https://story-api.dicoding.dev/v1';

  final http.Client client;

  RemoteDataSourceImpl({required this.client});

  @override
  Future<BaseResponse> register(
      String name, String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/register'),
      body: {
        'name': name,
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<LoginResult> loginUser(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode == 200) {
      return LoginResultResponse.fromJson(jsonDecode(response.body))
          .loginResult!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<BaseResponse> addNewStory(String name, String description,
      String photoPath, double lat, double lon) async {
    final fileBytes = await File(photoPath).readAsBytes();
    final file =
        http.MultipartFile.fromBytes('file', fileBytes, filename: 'file.txt');

    final response = await client.post(
      Uri.parse('$baseUrl/stories'),
      headers: {
        'Content-Type': 'multipart/form-data',
      },
      body: json.encode({
        'name': name,
        'description': description,
        'photo': file,
        'lat': lat,
        'lon': lon,
      }),
    );

    if (response.statusCode == 200) {
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else {
      throw ServerException();
    }
  }

  @override
  Future<List<Story>> getStories() async {
    final response = await client.get(
      Uri.parse('$baseUrl/listStory'),
    );

    if (response.statusCode == 200) {
      return ListStoryResponse.fromJson(jsonDecode(response.body)).listStory!;
    } else {
      throw ServerException();
    }
  }

  @override
  Future<Story> getStory(String id) async {
    final response = await client.get(
      Uri.parse('$baseUrl/story/$id'),
    );

    if (response.statusCode == 200) {
      return StoryResponse.fromJson(jsonDecode(response.body)).story!;
    } else {
      throw ServerException();
    }
  }
}
