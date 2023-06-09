import 'dart:convert';
import 'dart:io';

import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:{{appName.snakeCase()}}/data/remote/response/base_response.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/list_story_response.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/login_response.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/login_result.dart';
import 'package:{{appName.snakeCase()}}/data/remote/response/story_result.dart';

class RemoteDataSource {
  final GetStorage _getStorage = GetStorage();
  final http.Client client = http.Client();

  static const baseUrl = 'https://story-api.dicoding.dev/v1';

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

    if (response.statusCode <= 300) {
      return BaseResponse.fromJson(jsonDecode(response.body));
    } else if (response.statusCode <= 500) {
      return Future.error(jsonDecode(response.body)['message']);
    } else {
      return Future.error('Tidak ada koneksi internet');
    }
  }

  Future<LoginResult> login(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    if (response.statusCode <= 300) {
      return LoginResponse.fromJson(jsonDecode(response.body)).loginResult!;
    } else if (response.statusCode <= 500) {
      return Future.error(jsonDecode(response.body)['message']);
    } else {
      return Future.error('Tidak ada koneksi internet');
    }
  }

  Future<BaseResponse> addNewStory(
    String description,
    File photo,
    double? lat,
    double? lon,
  ) async {
    final token = _getStorage.read('token');
    final request = http.MultipartRequest(
      'POST',
      Uri.parse('$baseUrl/stories'),
    );
    request.headers.addAll({
      'Authorization': 'Bearer $token',
    });
    if (lat != null && lon != null) {
      request.fields.addAll({
        'description': description,
        'lat': lat.toString(),
        'lon': lon.toString(),
      });
    } else {
      request.fields.addAll({
        'description': description,
      });
    }
    request.files.add(
      http.MultipartFile(
        'photo',
        photo.readAsBytes().asStream(),
        photo.lengthSync(),
        filename: photo.path.split('/').last,
      ),
    );

    try {
      final response = await request.send();

      if (response.statusCode <= 300) {
        final responseString = await response.stream.bytesToString();
        return BaseResponse.fromJson(jsonDecode(responseString));
      } else if (response.statusCode <= 500) {
        final errorString = await response.stream.bytesToString();
        return Future.error(jsonDecode(errorString)['message']);
      } else {
        return Future.error('Terjadi kesalahan pada server');
      }
    } catch (e) {
      return Future.error('Tidak ada koneksi internet');
    }
  }

  Future<List<StoryResult>> getStories(String page, String size) async {
    final token = _getStorage.read('token');
    final response = await client.get(
      Uri.parse('$baseUrl/stories?page=$page&size=$size'),
      headers: {'Authorization': 'Bearer $token'},
    );

    switch (response.statusCode) {
      case 200:
        return ListStoryResponse.fromJson(jsonDecode(response.body)).listStory!;
      case 400:
      case 404:
      case 500:
        return Future.error(jsonDecode(response.body)['message']);
      default:
        return Future.error('Tidak ada koneksi internet');
    }
  }
}
