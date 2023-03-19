import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get_storage/get_storage.dart';
import 'package:http/http.dart' as http;
import 'package:story_app/data/remote/response/base_response.dart';
import 'package:story_app/data/remote/response/list_story_response.dart';
import 'package:story_app/data/remote/response/login_response.dart';
import 'package:story_app/data/remote/response/login_result.dart';
import 'package:story_app/data/remote/response/story_response.dart';
import 'package:story_app/data/remote/response/story_result.dart';

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

    switch (response.statusCode) {
      case 200:
        return BaseResponse.fromJson(jsonDecode(response.body));
      case 400:
      case 404:
      case 500:
        return Future.error(jsonDecode(response.body)['message']);
      default:
        return Future.error('Tidak ada koneksi internet');
    }
  }

  Future<LoginResult> loginUser(String email, String password) async {
    final response = await client.post(
      Uri.parse('$baseUrl/login'),
      body: {
        'email': email,
        'password': password,
      },
    );

    switch (response.statusCode) {
      case 200:
        return LoginResponse.fromJson(jsonDecode(response.body)).loginResult!;
      case 400:
      case 404:
      case 500:
        return Future.error(jsonDecode(response.body)['message']);
      default:
        return Future.error('Tidak ada koneksi internet');
    }
  }

  Future<BaseResponse> addNewStory(
    String description,
    File photo,
    double? lat,
    double? long,
  ) async {
    final token = _getStorage.read('token');
    final fileBytes = await photo.readAsBytes();
    final file = http.MultipartFile.fromBytes('file', fileBytes);

    final response = await client.post(
      Uri.parse('$baseUrl/stories'),
      headers: {
        'Content-Type': 'multipart/form-data',
        'Authorization': 'Bearer $token',
      },
      body: {
        'description': description,
        'photo': file,
        'lat': lat,
        'lon': long,
      },
    );

    debugPrint(response.body);

    switch (response.statusCode) {
      case 200:
        return BaseResponse.fromJson(jsonDecode(response.body));
      case 400:
      case 404:
      case 500:
        return Future.error(jsonDecode(response.body)['message']);
      default:
        return Future.error('Tidak ada koneksi internet');
    }
  }

  Future<List<StoryResult>> getStories() async {
    final token = _getStorage.read('token');
    final response = await client.get(
      Uri.parse('$baseUrl/listStory'),
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

  Future<StoryResult> getStory(String id) async {
    final token = _getStorage.read('token');
    final response = await client.get(
      Uri.parse('$baseUrl/story/$id'),
      headers: {'Authorization': 'Bearer $token'},
    );
    switch (response.statusCode) {
      case 200:
        return StoryResponse.fromJson(jsonDecode(response.body)).story!;
      case 400:
      case 404:
      case 500:
        return Future.error(jsonDecode(response.body)['message']);
      default:
        return Future.error('Tidak ada koneksi internet');
    }
  }
}
