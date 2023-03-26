import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:story_app/data/remote/remote_date_source.dart';
import 'package:story_app/data/remote/response/story_result.dart';

class HomeController extends GetxController {
  final RemoteDataSource _remoteDataSource = RemoteDataSource();
  final GetStorage _getStorage = GetStorage();

  var isLoading = false.obs;
  var hasData = false.obs;
  var isError = false.obs;
  var errorMessage = ''.obs;
  var stories = <StoryResult>[].obs;

  Future<void> getStories() async {
    try {
      isLoading.value = true;
      update();
      final result = await _remoteDataSource.getStories();
      stories.value = result;
      hasData.value = true;
      update();
    } catch (e) {
      errorMessage.value = e.toString();
      isError.value = true;
      update();
    } finally {
      isLoading.value = false;
      update();
    }
  }

  Future<bool> logout() async {
    try {
      await _getStorage.erase();
      return true;
    } catch (e) {
      debugPrint(e.toString());
      return false;
    }
  }
}
